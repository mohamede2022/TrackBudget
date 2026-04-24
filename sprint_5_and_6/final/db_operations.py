from db_connector import DatabaseConnection
from hasher import hash_string

class UserDAO:
    def __init__(self):
        self.db = DatabaseConnection()

    def get_all_users(self):
        with self.db as connection:
            if not connection:
                return None
                
            cursor = connection.cursor(dictionary=True)
            cursor.execute("SELECT * FROM users;")
            return cursor.fetchall()

    def get_user_by_id(self, user_id):
        with self.db as connection:
            if not connection:
                return None
                
            cursor = connection.cursor(dictionary=True)
            query = "SELECT * FROM users WHERE user_id = %s;"
            cursor.execute(query, (user_id,))
            return cursor.fetchone()

    def get_user_by_username(self, username):
        """Fetches a single user by their username for login verification."""
        with self.db as connection:
            if not connection:
                return None
                
            cursor = connection.cursor(dictionary=True)
            query = "SELECT * FROM users WHERE user_name = %s;"
            cursor.execute(query, (username,))
            return cursor.fetchone()
            
    def add_user(self, first_name, last_name, email, username, password, user_type):
        """Inserts a new user and their selected account type."""
        with self.db as connection:
            if not connection:
                return False
                
            try:
                cursor = connection.cursor()
                
                # Insert the user into the users table
                query = """
                    INSERT INTO users (first_name, last_name, email, user_name, password) 
                    VALUES (%s, %s, %s, %s, %s);
                """
                cursor.execute(query, (first_name, last_name, email, username, hash_string(password)))
                
                new_user_id = cursor.lastrowid
                
                # Insert into the user_types table using the form input
                type_query = """
                    INSERT INTO user_types (user_id, account_type) VALUES (%s, %s);
                """
                cursor.execute(type_query, (new_user_id, user_type))
                
                connection.commit() 
                return True
            except Exception as e:
                print(f"Failed to add user: {e}")
                return False

    def get_user_account_type(self, user_id):
        """Fetches the account type (Student, Business, Default) for a user."""
        with self.db as connection:
            if not connection:
                return "Default"
            
            try:
                cursor = connection.cursor(dictionary=True)
                query = "SELECT account_type FROM user_types WHERE user_id = %s;"
                cursor.execute(query, (user_id,))
                result = cursor.fetchone()
                
                if result and result['account_type']:
                    return result['account_type']
                return "Default"
            except Exception as e:
                print(f"Failed to fetch account type: {e}")
                return "Default"

    def update_user_password(self, user_id, new_password):
        """Updates the user by id"""
        with self.db as connection:
            if not connection:
                return False

            try:
                cursor = connection.cursor()
                query = """
                    UPDATE users
                    SET password = %s
                    WHERE user_id = %s
                """

                cursor.execute(query, (new_password, user_id))

                connection.commit()
                return True
            except Exception as e:
                print(f"Failed to update user password: {e}")
                return False

    def update_user_profile(self, user_id, first_name, last_name, email, username):
        """Updates the user's basic profile information."""
        with self.db as connection:
            if not connection:
                return False

            try:
                cursor = connection.cursor()
                query = """
                    UPDATE users
                    SET first_name = %s, last_name = %s, email = %s, user_name = %s
                    WHERE user_id = %s
                """
                cursor.execute(query, (first_name, last_name, email, username, user_id))
                connection.commit()
                return True
            except Exception as e:
                print(f"Failed to update user profile: {e}")
                return False

    def get_user_transactions(self, user_id):
        """Fetches all transactions for a specific user."""
        with self.db as connection:
            if not connection:
                return []

            try:
                cursor = connection.cursor(dictionary=True)
                # Fetching transactions ordered by most recent
                query = """
                    SELECT * FROM transactions
                    WHERE user_id = %s
                    ORDER BY date_of_transaction DESC;
                """
                cursor.execute(query, (user_id,))
                return cursor.fetchall()
            except Exception as e:
                print(f"Failed to fetch transactions: {e}")
                return []
    
    def get_user_chat_history(self, user_id):
        """Fetches the chat history for a specific user."""
        with self.db as connection:
            if not connection:
                return []
            try:
                cursor = connection.cursor(dictionary=True)
                query = """
                    SELECT user_query, ai_response, timestamp
                    FROM chat_history
                    WHERE user_id = %s
                    ORDER BY timestamp ASC;
                """
                cursor.execute(query, (user_id,))
                return cursor.fetchall()
            except Exception as e:
                print(f"Failed to fetch chat history: {e}")
                return []

    def add_chat_message(self, user_id, user_query, ai_response):
        """Saves a new chat interaction to the database."""
        with self.db as connection:
            if not connection:
                return False
            try:
                cursor = connection.cursor()
                query = """
                    INSERT INTO chat_history (user_id, user_query, ai_response)
                    VALUES (%s, %s, %s);
                """
                cursor.execute(query, (user_id, user_query, ai_response))
                connection.commit()
                return True
            except Exception as e:
                print(f"Failed to save chat message: {e}")
                return False

    def get_user_by_email(self, email):
        """Fetches a single user by their email for password recovery."""
        with self.db as connection:
            if not connection:
                return None
                
            cursor = connection.cursor(dictionary=True)
            query = "SELECT * FROM users WHERE email = %s;"
            cursor.execute(query, (email,))
            return cursor.fetchone()

    def add_transaction(self, user_id, vendor_name, money_spent, date_of_transaction, transaction_type):
        """Inserts a new parsed transaction into the database."""
        with self.db as connection:
            if not connection:
                return False

            try:
                cursor = connection.cursor()
                query = """
                    INSERT INTO transactions (user_id, vendor_name, money_spent, date_of_transaction, transaction_type)
                    VALUES (%s, %s, %s, %s, %s);
                """
                cursor.execute(query, (user_id, vendor_name, money_spent, date_of_transaction, transaction_type))
                connection.commit()
                return True
            except Exception as e:
                print(f"Failed to add transaction: {e}")
                return False
