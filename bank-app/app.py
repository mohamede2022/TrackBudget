from flask import Flask, render_template, request

app = Flask(__name__)

# Route for the homepage
@app.route('/')
def home():
    return render_template('index.html', error=None)

# Route to handle the form submission
@app.route('/login', methods=['POST'])
def login():
    # We are catching the username and password here, 
    # but for this test, we just send them to the success page.
    username = request.form.get('username')
    password = request.form.get('password')

    if username == "admin" and password == "pass":
        return render_template('success.html')
    else:
        return render_template('index.html', error="Invalid username and/or password")

if __name__ == '__main__':
    app.run(debug=True)
