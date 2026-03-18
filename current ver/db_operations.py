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
        """Inserts a new user and their account type."""
        with self.db as connection:
            if not connection:
                return False
                
            try:
                cursor = connection.cursor()
                
                # 1. Insert into the main users table
                query1 = """
                    INSERT INTO users (first_name, last_name, email, user_name, password) 
                    VALUES (%s, %s, %s, %s, %s);
                """
                cursor.execute(query1, (first_name, last_name, email, username, hash_string(password)))
                
                # 2. Get the brand new user_id that MySQL just created
                new_user_id = cursor.lastrowid
                
                # 3. Insert the type into the user_types table
                query2 = """
                    INSERT INTO user_types (user_id, account_type)
                    VALUES (%s, %s);
                """
                # If they bypassed the dropdown somehow, default to 'Default'
                safe_type = user_type if user_type in ['Student', 'Business'] else 'Default'
                cursor.execute(query2, (new_user_id, safe_type))
                
                connection.commit() 
                return True
            except Exception as e:
                print(f"Failed to add user: {e}")
                connection.rollback() # Undoes the creation if something fails
                return False

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
                print(f"Failded to update user password: {e}")
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

    def get_user_type(self, user_id):
        """Fetches the account type for a specific user."""
        with self.db as connection:
            if not connection:
                return "Default"
            try:
                cursor = connection.cursor(dictionary=True)
                query = "SELECT account_type FROM user_types WHERE user_id = %s;"
                cursor.execute(query, (user_id,))
                result = cursor.fetchone()
                
                if result:
                    return result['account_type']
                return "Default"
            except Exception as e:
                print(f"Failed to fetch user type: {e}")
                return "Default"
