import mysql.connector
from mysql.connector import Error

class DatabaseConnection:
    def __init__(self):
        # In a real app, these should come from environment variables!
        self.host = 'localhost'
        self.database = 'trackbudget_db'
        self.user = 'devuser'
        self.password = 'password123'
        self.connection = None

    def __enter__(self):
        """This runs automatically when you use a 'with' block."""
        try:
            self.connection = mysql.connector.connect(
                host=self.host,
                database=self.database,
                user=self.user,
                password=self.password
            )
            return self.connection
        except Error as e:
            print(f"Database connection failed: {e}")
            return None

    def __exit__(self, exc_type, exc_val, traceback):
        """This runs automatically when the 'with' block ends, ensuring cleanup."""
        if self.connection and self.connection.is_connected():
            self.connection.close()
