from db_connector import DatabaseConnection

class UserDAO:
    def __init__(self):
        # We instantiate the connector class so we can use it in our methods
        self.db = DatabaseConnection()

    def get_all_users(self):
        # The 'with' statement triggers __enter__ to connect, and __exit__ to close!
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
            query = "SELECT * FROM users WHERE id = %s;"
            cursor.execute(query, (user_id,))
            return cursor.fetchone()
            
    def add_user(self, name, email):
        """Example of an INSERT operation using OOP"""
        with self.db as connection:
            if not connection:
                return False
                
            try:
                cursor = connection.cursor()
                query = "INSERT INTO users (name, email) VALUES (%s, %s);"
                cursor.execute(query, (name, email))
                
                # We MUST commit when changing data!
                connection.commit() 
                return True
            except Exception as e:
                print(f"Failed to add user: {e}")
                return False
