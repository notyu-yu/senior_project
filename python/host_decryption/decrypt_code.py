'''
Decrypt encrypted sourcecode in encrypted_code.txt
Using private key in private_key.txt and submitter key in submitter_key.txt
Output to submission.py
'''
import rsa
from cryptography.fernet import Fernet

with open('private_key.txt', 'r', encoding='utf-8') as fp:
    private_key = rsa.PrivateKey.load_pkcs1(fp.read().encode('utf-8'))
with open('submitter_key.bytes', 'rb') as fp:
    submitter_key = fp.read()
with open('encrypted_code.bytes', 'rb') as fp:
    encrypted_code = fp.read()

fernet = Fernet(submitter_key)

with open('submission.py', 'w+', encoding='utf-8') as fp:
    encrypted_code = fernet.decrypt(encrypted_code)
    code_pieces = [rsa.decrypt(encrypted_code[i:i+256], private_key).decode('utf-8')
              for i in range(0, len(encrypted_code), 256)]
    code_decrypted = ''.join(code_pieces)
    fp.write(code_decrypted)
