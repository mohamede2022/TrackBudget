import os
import datetime
from flask import Flask, render_template, request, redirect, url_for, session
from db_operations import UserDAO
from hasher import hash_string
from koin import KoinAssistant
from itsdangerous import URLSafeTimedSerializer, SignatureExpired, BadTimeSignature
import smtplib
from email.mime.text import MIMEText

app = Flask(__name__)

app.secret_key = os.urandom(24) 

user_dao = UserDAO()
koin = KoinAssistant()

@app.route('/')
def home():
    session.clear()
    return render_template('index.html', error=None)

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'GET':
        if 'user_id' in session:
            return redirect(url_for('dashboard'))
        return redirect(url_for('home'))

    username = request.form.get('username')
    password = request.form.get('password')
    hash_password = hash_string(password)

    user = user_dao.get_user_by_username(username)

    if user and user['password'] == hash_password:
        session['user_id'] = user['user_id']
        session['username'] = user['user_name']
        session['first_name'] = user['first_name']
        
        return redirect(url_for('dashboard'))
    else:
        return render_template('index.html', error="Invalid username and/or password")

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'GET':
        return render_template('register.html')
    
    if request.method == 'POST':
        first_name = request.form.get('first_name')
        last_name = request.form.get('last_name')
        email = request.form.get('email')
        username = request.form.get('username')
        password = request.form.get('password')
        
        user_type = request.form.get('user_type')

        existing_user = user_dao.get_user_by_email(email)
        if existing_user:
            return render_template('register.html', error="Email is already in use, try forgot password.")

        success = user_dao.add_user(first_name, last_name, email, username, password, user_type)
        
        if success:
            return render_template('index.html', success="Account created successfully! Please log in.")
        else:
            return render_template('register.html', error="An error occurred while creating your account. Please try again.")

@app.route('/settings')
def settings():
    if 'user_id' not in session:
        return redirect(url_for('home'))

    user = user_dao.get_user_by_id(session['user_id'])

    return render_template('settings.html', user=user)

@app.route('/update_settings', methods=['POST'])
def update_settings():
    if 'user_id' not in session:
        return redirect(url_for('home'))

    user_id = session['user_id']

    first_name = request.form.get('first_name')
    last_name = request.form.get('last_name')
    email = request.form.get('email')
    username = request.form.get('username')

    current_password = request.form.get('current_password')
    new_password = request.form.get('new_password')

    success = user_dao.update_user_profile(user_id, first_name, last_name, email, username)

    if success:
        session['username'] = username
        session['first_name'] = first_name

    if current_password and new_password:
        user = user_dao.get_user_by_id(user_id)
        if user and user['password'] == hash_string(current_password):
            hashed_new_password = hash_string(new_password)
            user_dao.update_user_password(user_id, hashed_new_password)

    return redirect(url_for('settings'))

@app.route('/dashboard')
def dashboard():
    if 'user_id' not in session:
        return redirect(url_for('home'))

    user_id = session['user_id']
    
    transactions = user_dao.get_user_transactions(user_id)
    
    now = datetime.datetime.now()
    monthly_spending = sum(
        float(t['money_spent']) 
        for t in transactions 
        if t['money_spent'] 
        and t['date_of_transaction'].month == now.month 
        and t['date_of_transaction'].year == now.year
    )
    
    total_balance = 1000.00 - monthly_spending 

    account_type = user_dao.get_user_account_type(user_id)

    return render_template(
        'dashboard.html', 
        first_name=session.get('first_name'),
        transactions=transactions,
        total_balance=total_balance,
        monthly_spending=monthly_spending,
        account_type=account_type
    )

@app.route('/send_message', methods=['POST'])
def send_message():
    if 'user_id' not in session:
        return redirect(url_for('home'))

    user_id = session['user_id']
    user_query = request.form.get('user_query')
    
    if not user_query:
        return redirect(url_for('chat'))

    transactions = user_dao.get_user_transactions(user_id)
    now = datetime.datetime.now()
    monthly_spending = sum(
        float(t['money_spent']) for t in transactions 
        if t['money_spent'] and t['date_of_transaction'].month == now.month and t['date_of_transaction'].year == now.year
    )
    total_balance = 1000.00 - monthly_spending 
    first_name = session.get('first_name', 'User')

    ai_response = koin.get_financial_advice(user_query, first_name, monthly_spending, total_balance, transactions)

    user_dao.add_chat_message(user_id, user_query, ai_response)

    return redirect(url_for('chat'))

@app.route('/upload_statement', methods=['POST'])
def upload_statement():
    if 'user_id' not in session:
        return redirect(url_for('home'))
        
    if 'statement_file' not in request.files:
        return redirect(url_for('chat'))
        
    file = request.files['statement_file']
    if file.filename == '':
        return redirect(url_for('chat'))
        
    file_path = os.path.join("/tmp", file.filename)
    file.save(file_path)
    _, ext = os.path.splitext(file.filename)
    
    new_transactions = koin.parse_bank_statement(file_path, ext)
    
    if isinstance(new_transactions, dict):
        for key, val in new_transactions.items():
            if isinstance(val, list):
                new_transactions = val
                break
        else:
            new_transactions = []
            
    if isinstance(new_transactions, list):
        for t in new_transactions:
            if isinstance(t, dict):
                user_dao.add_transaction(
                    session['user_id'], 
                    t.get('vendor_name', 'Unknown'), 
                    t.get('money_spent', 0.0), 
                    t.get('date_of_transaction'), 
                    t.get('transaction_type', 'Uncategorized')
                )
                
    if os.path.exists(file_path):
        os.remove(file_path)

    return redirect(url_for('dashboard'))

@app.route('/chat')
def chat():
    if 'user_id' not in session:
        return redirect(url_for('home'))
        
    user_id = session['user_id']
    
    chat_history = user_dao.get_user_chat_history(user_id)
    
    return render_template('chat.html', chat_history=chat_history)

s = URLSafeTimedSerializer(app.secret_key)

def send_reset_email(user_email, token):
    """Helper function to send the email via SMTP"""
    reset_url = url_for('reset_password_with_token', token=token, _external=True)
    msg = MIMEText(f"Click the link to reset your password: {reset_url}\n\nThis link will expire in 1 hour.")
    msg['Subject'] = 'TrackBudget Password Reset'
    msg['From'] = 'trackbudget.support@gmail.com'
    msg['To'] = user_email

    try:
        with smtplib.SMTP('localhost') as server:
            server.send_message(msg)
    except Exception as e:
        print(f"Failed to send email: {e}")

@app.route('/forgot_password', methods=['GET', 'POST'])
def forgot_password():
    if request.method == 'GET':
        return render_template('forgot_password.html')

    email = request.form.get('email')
    user = user_dao.get_user_by_email(email)

    if user:
        token = s.dumps(email, salt='password-reset-salt')
        send_reset_email(email, token)
        
        print(f"Debug Reset URL: {url_for('reset_password_with_token', token=token, _external=True)}")

    return render_template('forgot_password.html', success="If an account exists with that email, a reset link has been sent.")

@app.route('/reset_password/<token>', methods=['GET', 'POST'])
def reset_password_with_token(token):
    try:
        email = s.loads(token, salt='password-reset-salt', max_age=3600)
    except (SignatureExpired, BadTimeSignature):
        return render_template('index.html', error="The password reset link is invalid or has expired.")

    if request.method == 'GET':
        return render_template('reset_password.html', token=token)

    new_password = request.form.get('new_password')
    user = user_dao.get_user_by_email(email)
    
    if user:
        hashed_new_password = hash_string(new_password)
        user_dao.update_user_password(user['user_id'], hashed_new_password)
        return render_template('index.html', success="Your password has been updated! Please log in.")
    
    return render_template('index.html', error="Error resetting password.")

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)
