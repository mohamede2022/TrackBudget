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
            return render_template('success.html')
        return redirect(url_for('home'))

    username = request.form.get('username')
    password = request.form.get('password')
    hash_password = hash_string(password)

    user = user_dao.get_user_by_username(username)

    if user and user['password'] == hash_password:
        session['user_id'] = user['user_id']
        session['username'] = user['user_name']
        session['first_name'] = user['first_name']
        
        return render_template('success.html')
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

    return render_template('settings.html')

if __name__ == '__main__':
    app.run(debug=True)
