'''
Generates Fernet private key for submitter
Saves key byte to submitter_key.txt
'''
from cryptography.fernet import Fernet

with open('submitter_key.bytes', 'wb+') as fp:
    key = Fernet.generate_key()
    fp.write(key)
