import requests
import json
import pdfplumber
from typing import List, Dict, Optional

class KoinAssistant:
    def __init__(self, ollama_url: str = "http://localhost:11434"):
        self.ollama_endpoint = f"{ollama_url}/api/generate"
        self.model = "llama3.1"
        self.base_system_prompt = (
            "You are Koin, a helpful financial AI assistant for TrackBudget. "
            "You are talking to {name}. "
            "Their current monthly spending is ${spending:.2f} and their remaining balance is ${balance:.2f}. "
            "Keep your answers concise, friendly, and under 3 sentences."
        )

    def get_financial_advice(self, user_query: str, first_name: str, monthly_spending: float, total_balance: float, transactions: Optional[List[Dict]] = None) -> str:
        transaction_context = "No recent transactions found."
        if transactions:
            transaction_context = "Recent Transactions:\n"
            for t in transactions[:10]: 
                date = t.get('date_of_transaction', 'Unknown date')
                vendor = t.get('vendor_name', 'Unknown vendor')
                amount = t.get('money_spent', 0.0)
                transaction_context += f"- {date}: ${amount} at {vendor}\n"

        system_prompt = (
            "You are Koin, a helpful financial AI assistant for TrackBudget. "
            f"You are talking to {first_name}. "
            f"Their current monthly spending is ${monthly_spending:.2f} and their remaining balance is ${total_balance:.2f}.\n\n"
            f"{transaction_context}\n\n"
            "Keep your answers concise, friendly, and under 3 sentences."
        )
        
        full_prompt = f"{system_prompt}\nUser: {user_query}\nKoin:"

        try:
            response = requests.post(self.ollama_endpoint, json={
                "model": self.model,
                "prompt": full_prompt,
                "stream": False 
            }, timeout=15)

            if response.status_code == 200:
                return response.json()['response'].strip()
            else:
                return f"API Error: Received status code {response.status_code}"
                
        except requests.exceptions.RequestException as e:
            return f"Error connecting to LLM. Ensure Ollama is running. Details: {e}"

    def parse_bank_statement(self, file_path: str, file_extension: str) -> List[Dict]:
        parsed_transactions = []
        
        if file_extension == '.pdf':
            extracted_text = ""
            try:
                with pdfplumber.open(file_path) as pdf:
                    for page in pdf.pages:
                        text = page.extract_text()
                        if text:
                            extracted_text += text + "\n"
            except Exception as e:
                print(f"Error reading PDF: {e}")
                return []

            system_prompt = (
                "You are a data extraction assistant. Extract all financial transactions from the provided bank statement text. "
                "You MUST respond with a valid JSON array containing objects with these exact keys: "
                "'date_of_transaction' (format YYYY-MM-DD), 'vendor_name' (string), 'money_spent' (positive float), "
                "and 'transaction_type' (string category like 'Groceries', 'Utilities', 'Entertainment', etc.). "
                "Do not include any markdown formatting, explanations, or text outside the JSON array."
            )
            
            full_prompt = f"{system_prompt}\n\nBank Statement Text:\n{extracted_text}"

            try:
                response = requests.post(self.ollama_endpoint, json={
                    "model": self.model,
                    "prompt": full_prompt,
                    "stream": False,
                    "format": "json"
                }, timeout=60)  

                if response.status_code == 200:
                    response_text = response.json()['response'].strip()
                    parsed_transactions = json.loads(response_text)
                else:
                    print(f"API Error: Received status code {response.status_code}")
                    
            except Exception as e:
                print(f"Error parsing text with LLM: {e}")

        elif file_extension == '.csv':
            extracted_text = ""
            try:
                with open(file_path, mode='r', encoding='utf-8-sig') as file:
                    extracted_text = file.read()
            except Exception as e:
                print(f"Error reading CSV: {e}")
                return []

            system_prompt = (
                "You are a data extraction assistant. Extract all financial transactions from the provided bank statement text. "
                "You MUST respond with a valid JSON array containing objects with these exact keys: "
                "'date_of_transaction' (format YYYY-MM-DD), 'vendor_name' (string), 'money_spent' (positive float), "
                "and 'transaction_type' (string category like 'Groceries', 'Utilities', 'Entertainment', etc.). "
                "Do not include any markdown formatting, explanations, or text outside the JSON array."
            )
            
            full_prompt = f"{system_prompt}\n\nCSV Bank Statement Data:\n{extracted_text}"

            try:
                response = requests.post(self.ollama_endpoint, json={
                    "model": self.model,
                    "prompt": full_prompt,
                    "stream": False,
                    "format": "json"
                }, timeout=60)

                if response.status_code == 200:
                    response_text = response.json()['response'].strip()
                    parsed_transactions = json.loads(response_text)
                else:
                    print(f"API Error: Received status code {response.status_code}")
                    
            except Exception as e:
                print(f"Error parsing CSV text with LLM: {e}")
            
        return parsed_transactions
