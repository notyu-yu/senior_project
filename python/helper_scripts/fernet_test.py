'''
Test fernet encryption
'''
from cryptography.fernet import Fernet

with open('submitter_key.txt', 'r', encoding='utf-8') as fp:
    submitter_key = fp.read().encode('utf-8')

message = "Test message."

fernet = Fernet(submitter_key)

encrypted = fernet.encrypt(message.encode())
decrypted = fernet.decrypt(encrypted).decode()

assert message == decrypted

print(message)
print(decrypted)
