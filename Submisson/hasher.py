import hashlib

def hash_string(string):
    encoded_string = string.encode('utf-8')
    
    hash_object = hashlib.sha256(encoded_string)
    hash_hex = hash_object.hexdigest()

    return hash_hex

