import os
from flask import Flask, render_template, request, redirect, url_for, session
from db_operations import UserDAO
from hasher import hash_string

app = Flask(__name__)

app.secret_key = os.urandom(24) 

user_dao = UserDAO()

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

        success = user_dao.add_user(first_name, last_name, email, username, password)
        
        if success:
            return render_template('index.html', error="Account created successfully! Please log in.")
        else:
            return render_template('register.html') 

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
    # Make sure the user is actually logged in
    if 'user_id' not in session:
        return redirect(url_for('home'))

    user_id = session['user_id']
    
    # Fetch user's transactions
    transactions = user_dao.get_user_transactions(user_id)
    
    # Calculate some basic financial stats to pass to the template
    monthly_spending = sum(float(t['money_spent']) for t in transactions if t['money_spent'])
    
    total_balance = 1000.00 - monthly_spending 

    # Pass everything to success.html
    return render_template(
        'success.html', 
        first_name=session.get('first_name'),
        transactions=transactions,
        total_balance=total_balance,
        monthly_spending=monthly_spending
    )

if __name__ == '__main__':
    app.run(debug=True)
