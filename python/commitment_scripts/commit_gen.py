'''
Generates all commitment files needed for submission.py
All files beside this script can be copied to verifier directory
'''
from hashlib import sha256
import rsa
from cryptography.fernet import Fernet

# Import encryption keys
with open('public_key.txt', 'r', encoding='utf-8') as fp:
    public_key = rsa.PublicKey.load_pkcs1(fp.read().encode('utf-8'))
with open('submitter_key.txt', 'r', encoding='utf-8') as fp:
    submitter_key = fp.read()
fernet = Fernet(submitter_key.encode('utf-8'))

# Generate encrypted_key.txt
with open('encrypted_key.bytes', 'wb+') as fp:
    public_encrypted_key = rsa.encrypt(
        submitter_key.encode('utf-8'), public_key)
    new = rsa.encrypt(
        submitter_key.encode('utf-8'), public_key)
    assert public_encrypted_key == new
    fp.write(public_encrypted_key)

with open('encrypted_key.bytes', 'rb') as fp:
    written = fp.read()
    print(new)
    print(written)
    assert new == written

# Generate key_hash.txt
with open('key_hash.txt', 'w+', encoding='utf-8') as fp:
    fp.write(sha256(public_encrypted_key).hexdigest())

# Generate ecrypted_code.txt
with open('submission.py', 'r', encoding='utf-8') as code_fp, \
        open('encrypted_code.txt', 'w+', encoding='utf-8') as encrypted_fp:
    code_str = code_fp.read()
    code_public_encrypted = rsa.encrypt(code_str.encode('utf-8'), public_key)
    code_fernet_encrypted = fernet.encrypt(code_public_encrypted)
    encrypted_fp.write(code_fernet_encrypted.decode('utf-8'))
