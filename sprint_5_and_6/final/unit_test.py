import pytest
from unittest.mock import patch, MagicMock
from flask import session
import io
from unittest.mock import mock_open
import json

# Import your application modules
from app import app
from hasher import hash_string
from koin import KoinAssistant
from db_operations import UserDAO

# -------------------------------------------------------------------
# 1. Testing Pure Functions (hasher.py)
# -------------------------------------------------------------------
def test_hash_string():
    """Test that the SHA256 hashing works consistently."""
    password = "my_secure_password"
    # The actual known SHA256 hash for "my_secure_password"
    expected_hash = "2c9a8d02fc17ae77e926d38fe83c3529d6638d1d636379503f0c6400e063445f"
    assert hash_string(password) == expected_hash

# -------------------------------------------------------------------
# 2. Testing External APIs / LLM (koin.py)
# -------------------------------------------------------------------
@patch('koin.requests.post')
def test_koin_get_financial_advice_success(mock_post):
    """Test Koin Assistant when the Ollama API returns a 200 OK."""
    # Setup the fake response from the LLM
    mock_response = MagicMock()
    mock_response.status_code = 200
    mock_response.json.return_value = {'response': 'Save 20% of your income.'}
    mock_post.return_value = mock_response

    koin = KoinAssistant()
    advice = koin.get_financial_advice(
        user_query="How do I budget?", 
        first_name="Alice", 
        monthly_spending=500.0, 
        total_balance=1500.0
    )

    assert advice == 'Save 20% of your income.'
    mock_post.assert_called_once()

@patch('koin.requests.post')
def test_koin_get_financial_advice_failure(mock_post):
    """Test Koin Assistant when the API is down."""
    mock_response = MagicMock()
    mock_response.status_code = 500
    mock_post.return_value = mock_response

    koin = KoinAssistant()
    advice = koin.get_financial_advice("Help", "Bob", 100, 100)

    assert "API Error: Received status code 500" in advice

# -------------------------------------------------------------------
# 3. Testing Database Operations (db_operations.py)
# -------------------------------------------------------------------
@patch('db_operations.DatabaseConnection')
def test_get_user_by_username(mock_db_class):
    """Test fetching a user by mocking the database context manager."""
    # Setup the mock cursor and its return value
    mock_cursor = MagicMock()
    mock_cursor.fetchone.return_value = {'user_id': 1, 'user_name': 'testuser123', 'password': 'hashed_password'}
    
    # Setup the mock connection to return the mock cursor
    mock_conn = MagicMock()
    mock_conn.cursor.return_value = mock_cursor
    
    # Setup the context manager (__enter__) to return our mock connection
    mock_db_instance = MagicMock()
    mock_db_instance.__enter__.return_value = mock_conn
    mock_db_class.return_value = mock_db_instance

    # Execute the actual code
    dao = UserDAO()
    user = dao.get_user_by_username('testuser123')

    # Assertions
    assert user is not None
    assert user['user_name'] == 'testuser123'
    # Ensure the query was actually executed
    mock_cursor.execute.assert_called_once()

# -------------------------------------------------------------------
# 4. Testing Flask Routes (app.py)
# -------------------------------------------------------------------
@pytest.fixture
def client():
    """A pytest fixture to set up the Flask test client."""
    app.config['TESTING'] = True
    # We don't want CSRF or other protections getting in the way of simple tests
    app.config['WTF_CSRF_ENABLED'] = False 
    with app.test_client() as client:
        yield client

def test_home_route(client):
    """Test that the index page loads successfully."""
    response = client.get('/')
    assert response.status_code == 200
    # Assuming 'index.html' has a login form or welcome text
    assert b'login' in response.data.lower() or b'html' in response.data.lower()

@patch('app.user_dao')
def test_login_success(mock_user_dao, client):
    """Test the login route with valid credentials."""
    # Mock the database returning a valid user
    mock_user_dao.get_user_by_username.return_value = {
        'user_id': 1, 
        'user_name': 'alice', 
        'first_name': 'Alice',
        'password': hash_string('password123') # Match the hashed password
    }

    # Post data to the login route
    response = client.post('/login', data={
        'username': 'alice',
        'password': 'password123'
    })

    # Successful login should redirect (302) to the dashboard
    assert response.status_code == 302
    assert '/dashboard' in response.headers['Location']

@patch('app.user_dao')
def test_dashboard_redirects_if_not_logged_in(mock_user_dao, client):
    """Test that unauthenticated users are kicked out of the dashboard."""
    response = client.get('/dashboard')
    
    # Should redirect back to home ('/')
    assert response.status_code == 302
    assert response.headers['Location'] == '/'

# -------------------------------------------------------------------
# 5. Advanced Flask Route Testing (app.py)
# -------------------------------------------------------------------

@patch('app.user_dao')
def test_register_success(mock_user_dao, client):
    """Test successful user registration."""
    # Ensure the email doesn't already exist
    mock_user_dao.get_user_by_email.return_value = None
    # Mock the database successfully adding the user
    mock_user_dao.add_user.return_value = True

    response = client.post('/register', data={
        'first_name': 'John',
        'last_name': 'Doe',
        'email': 'john@example.com',
        'username': 'johndoe',
        'password': 'securepassword',
        'user_type': 'Student'
    })

    assert response.status_code == 200
    assert b'Account created successfully' in response.data

@patch('app.user_dao')
def test_register_duplicate_email(mock_user_dao, client):
    """Test registration failure when email already exists."""
    # Mock the database finding an existing user
    mock_user_dao.get_user_by_email.return_value = {'user_id': 2, 'email': 'john@example.com'}

    response = client.post('/register', data={
        'first_name': 'John',
        'last_name': 'Doe',
        'email': 'john@example.com',
        'username': 'johndoe',
        'password': 'securepassword',
        'user_type': 'Student'
    })

    assert response.status_code == 200
    assert b'Email is already in use' in response.data

@patch('app.user_dao')
def test_dashboard_authenticated(mock_user_dao, client):
    """Test the dashboard loads correctly for a logged-in user."""
    # 1. Inject a fake user session
    with client.session_transaction() as sess:
        sess['user_id'] = 1
        sess['first_name'] = 'Alice'

    # 2. Mock the required database calls for the dashboard
    mock_user_dao.get_user_transactions.return_value = []
    mock_user_dao.get_user_account_type.return_value = 'Student'

    # 3. Request the dashboard
    response = client.get('/dashboard')

    assert response.status_code == 200
    mock_user_dao.get_user_transactions.assert_called_once_with(1)
    mock_user_dao.get_user_account_type.assert_called_once_with(1)

@patch('app.koin')
@patch('app.user_dao')
def test_send_message(mock_user_dao, mock_koin, client):
    """Test that submitting a chat query queries the LLM and saves to the DB."""
    with client.session_transaction() as sess:
        sess['user_id'] = 1
        sess['first_name'] = 'Alice'

    mock_user_dao.get_user_transactions.return_value = []
    mock_koin.get_financial_advice.return_value = "Spend less on coffee."

    response = client.post('/send_message', data={
        'user_query': 'How can I save money?'
    })

    # Should redirect back to chat
    assert response.status_code == 302
    assert '/chat' in response.headers['Location']

    # Verify the advice was requested and saved
    mock_koin.get_financial_advice.assert_called_once()
    mock_user_dao.add_chat_message.assert_called_once_with(1, 'How can I save money?', 'Spend less on coffee.')

@patch('app.koin')
@patch('app.user_dao')
def test_upload_statement_success(mock_user_dao, mock_koin, client):
    """Test the document upload route with a simulated PDF."""
    with client.session_transaction() as sess:
        sess['user_id'] = 1

    # Mock Koin successfully parsing a transaction from the PDF
    mock_koin.parse_bank_statement.return_value = [
        {
            'date_of_transaction': '2023-10-01',
            'vendor_name': 'Target',
            'money_spent': 50.0,
            'transaction_type': 'Groceries'
        }
    ]

    # Simulate a file upload using io.BytesIO
    data = {
        'statement_file': (io.BytesIO(b"fake pdf binary data"), 'statement.pdf')
    }

    response = client.post('/upload_statement', data=data, content_type='multipart/form-data')

    # Should redirect to the dashboard after processing
    assert response.status_code == 302
    assert '/dashboard' in response.headers['Location']

    # Verify the transaction was saved to the database
    mock_user_dao.add_transaction.assert_called_once_with(
        1, 'Target', 50.0, '2023-10-01', 'Groceries'
    )

# -------------------------------------------------------------------
# 6. Database Exception Handling (db_operations.py)
# -------------------------------------------------------------------

@patch('db_operations.DatabaseConnection')
def test_add_user_exception(mock_db_class):
    """Test that adding a user gracefully handles DB exceptions."""
    # Setup mock connection and cursor
    mock_cursor = MagicMock()
    # Force the execute method to raise an Exception
    mock_cursor.execute.side_effect = Exception("Mocked DB Insert Error")

    mock_conn = MagicMock()
    mock_conn.cursor.return_value = mock_cursor
    mock_db_instance = MagicMock()
    mock_db_instance.__enter__.return_value = mock_conn
    mock_db_class.return_value = mock_db_instance

    dao = UserDAO()
    # Attempt to add a user
    result = dao.add_user("John", "Doe", "j@d.com", "jdoe", "pass", "Student")

    # Assert the exception was caught and False was returned
    assert result is False

@patch('db_operations.DatabaseConnection')
def test_get_user_account_type_exception(mock_db_class):
    """Test that failing to fetch an account type defaults to 'Default'."""
    mock_cursor = MagicMock()
    mock_cursor.execute.side_effect = Exception("Mocked DB Query Error")

    mock_conn = MagicMock()
    mock_conn.cursor.return_value = mock_cursor
    mock_db_instance = MagicMock()
    mock_db_instance.__enter__.return_value = mock_conn
    mock_db_class.return_value = mock_db_instance

    dao = UserDAO()
    result = dao.get_user_account_type(1)

    # Assert the exception was caught and "Default" was returned
    assert result == "Default"

@patch('db_operations.DatabaseConnection')
def test_update_user_password_exception(mock_db_class):
    """Test that failing to update a password returns False."""
    mock_cursor = MagicMock()
    mock_cursor.execute.side_effect = Exception("Mocked DB Update Error")

    mock_conn = MagicMock()
    mock_conn.cursor.return_value = mock_cursor
    mock_db_instance = MagicMock()
    mock_db_instance.__enter__.return_value = mock_conn
    mock_db_class.return_value = mock_db_instance

    dao = UserDAO()
    result = dao.update_user_password(1, "new_hashed_pass")

    assert result is False

@patch('db_operations.DatabaseConnection')
def test_get_user_transactions_exception(mock_db_class):
    """Test that failing to fetch transactions returns an empty list."""
    mock_cursor = MagicMock()
    mock_cursor.execute.side_effect = Exception("Mocked DB Fetch Error")

    mock_conn = MagicMock()
    mock_conn.cursor.return_value = mock_cursor
    mock_db_instance = MagicMock()
    mock_db_instance.__enter__.return_value = mock_conn
    mock_db_class.return_value = mock_db_instance

    dao = UserDAO()
    result = dao.get_user_transactions(1)

    # Assert the exception was caught and an empty list was returned
    assert result == []

@patch('db_operations.DatabaseConnection')
def test_db_connection_returns_none(mock_db_class):
    """Test that DAO methods handle a failed connection (None) correctly."""
    # Simulate the DatabaseConnection context manager returning None (connection failure)
    mock_db_instance = MagicMock()
    mock_db_instance.__enter__.return_value = None
    mock_db_class.return_value = mock_db_instance

    dao = UserDAO()

    # Test a few methods to ensure the 'if not connection:' block works
    assert dao.get_all_users() is None
    assert dao.add_user("J", "D", "j@d.com", "jd", "p", "S") is False
    assert dao.get_user_chat_history(1) == []
    assert dao.get_user_account_type(1) == "Default"

# -------------------------------------------------------------------
# 7. File Parsing & Extraction (koin.py)
# -------------------------------------------------------------------

@patch('koin.requests.post')
@patch('koin.pdfplumber.open')
def test_parse_bank_statement_pdf_success(mock_pdf_open, mock_post):
    """Test extracting text from a PDF and successfully parsing it via LLM."""
    # 1. Mock the PDF file and its pages
    mock_page = MagicMock()
    mock_page.extract_text.return_value = "10/01/2023 Target $50.00 Groceries"

    mock_pdf = MagicMock()
    mock_pdf.pages = [mock_page]

    # Setup context manager (the 'with pdfplumber.open(...) as pdf:' block)
    mock_pdf_open.return_value.__enter__.return_value = mock_pdf

    # 2. Mock the LLM's JSON response
    mock_response = MagicMock()
    mock_response.status_code = 200
    mock_response.json.return_value = {
        'response': '[{"date_of_transaction": "2023-10-01", "vendor_name": "Target", "money_spent": 50.0, "transaction_type": "Groceries"}]'
    }
    mock_post.return_value = mock_response

    # 3. Execute
    koin_assistant = KoinAssistant()
    result = koin_assistant.parse_bank_statement("fake_statement.pdf", ".pdf")

    # 4. Assert
    assert isinstance(result, list)
    assert len(result) == 1
    assert result[0]['vendor_name'] == 'Target'
    assert result[0]['money_spent'] == 50.0

@patch('koin.requests.post')
@patch('builtins.open', new_callable=mock_open, read_data="Date,Vendor,Amount\n2023-10-02,Walmart,30.00")
def test_parse_bank_statement_csv_success(mock_file, mock_post):
    """Test reading a CSV and successfully parsing it via LLM."""
    # Mock the LLM's JSON response
    mock_response = MagicMock()
    mock_response.status_code = 200
    mock_response.json.return_value = {
        'response': '[{"date_of_transaction": "2023-10-02", "vendor_name": "Walmart", "money_spent": 30.0, "transaction_type": "Groceries"}]'
    }
    mock_post.return_value = mock_response

    koin_assistant = KoinAssistant()
    result = koin_assistant.parse_bank_statement("fake_statement.csv", ".csv")

    assert isinstance(result, list)
    assert len(result) == 1
    assert result[0]['vendor_name'] == 'Walmart'
    mock_file.assert_called_once_with("fake_statement.csv", mode='r', encoding='utf-8-sig')

@patch('koin.pdfplumber.open')
def test_parse_bank_statement_pdf_read_error(mock_pdf_open):
    """Test that PDF read errors are caught and return an empty list."""
    mock_pdf_open.side_effect = Exception("PDF corrupted or unreadable")

    koin_assistant = KoinAssistant()
    result = koin_assistant.parse_bank_statement("corrupt.pdf", ".pdf")

    assert result == []

@patch('builtins.open', new_callable=mock_open)
def test_parse_bank_statement_csv_read_error(mock_file):
    """Test that CSV read errors (like file not found) are caught."""
    mock_file.side_effect = Exception("File not found")

    koin_assistant = KoinAssistant()
    result = koin_assistant.parse_bank_statement("missing.csv", ".csv")

    assert result == []

@patch('koin.requests.post')
@patch('builtins.open', new_callable=mock_open, read_data="dummy data")
def test_parse_bank_statement_llm_api_error(mock_file, mock_post):
    """Test that if the LLM API fails (e.g., 500 server error), it returns an empty list."""
    mock_response = MagicMock()
    mock_response.status_code = 500
    mock_post.return_value = mock_response

    koin_assistant = KoinAssistant()
    result = koin_assistant.parse_bank_statement("fake_statement.csv", ".csv")

    # Because the status code is not 200, it shouldn't attempt to parse JSON
    assert result == []
