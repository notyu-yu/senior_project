'''
Generates Fernet private key for submitter
Saves key byte to submitter_key.txt
'''
from cryptography.fernet import Fernet

with open('submitter_key.txt', 'w+', encoding='utf-8') as fp:
    key = Fernet.generate_key().decode('utf-8')
    fp.write(key)
