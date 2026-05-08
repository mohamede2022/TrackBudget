import mysql.connector
from mysql.connector import Error

class DatabaseConnection:
    def __init__(self):
        self.host = 'localhost'
        self.database = 'trackbudget_db'
        self.user = 'devuser'
        self.password = 'password123'
        self.connection = None

    def __enter__(self):
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
        if self.connection and self.connection.is_connected():
            self.connection.close()
