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
            
    def add_user(self, first_name, last_name, email, username, password):
        """Inserts a new user into the database upon registration."""
        with self.db as connection:
            if not connection:
                return False
                
            try:
                cursor = connection.cursor()
                query = """
                    INSERT INTO users (first_name, last_name, email, user_name, password) 
                    VALUES (%s, %s, %s, %s, %s);
                """
                cursor.execute(query, (first_name, last_name, email, username, hash_string(password)))
                
                connection.commit() 
                return True
            except Exception as e:
                print(f"Failed to add user: {e}")
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
