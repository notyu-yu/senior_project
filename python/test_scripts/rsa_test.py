'''
Testing RSA encryption
'''
import rsa
from cryptography.fernet import Fernet
from hashlib import sha256

# Encryption:
# Import encryption keys
with open('public_key.txt', 'r', encoding='utf-8') as fp:
    public_key = rsa.PublicKey.load_pkcs1(fp.read().encode('utf-8'))
with open('submitter_key.bytes', 'rb') as fp:
    submitter_key = fp.read()
fernet = Fernet(submitter_key)

# Generate encrypted_key.txt
with open('encrypted_key.bytes', 'wb+') as fp:
    public_encrypted_key = rsa.encrypt(
        submitter_key, public_key)
    fp.write(public_encrypted_key)

# Generate encrypted_code.txt
with open('submission.py', 'r', encoding='utf-8') as code_fp, \
        open('encrypted_code.bytes', 'wb') as encrypted_fp:
    code_str = code_fp.read().encode('utf-8')
    code_public_encrypted = b''.join([rsa.encrypt(
        code_str[i:i+245], public_key) for i in range(0, len(code_str), 245)])
    code_fernet_encrypted = fernet.encrypt(code_public_encrypted)
    encrypted_fp.write(code_fernet_encrypted)

# Decrypt
# Read keys and code
with open('private_key.txt', 'r', encoding='utf-8') as fp:
    private_key = rsa.PrivateKey.load_pkcs1(fp.read().encode('utf-8'))
with open('encrypted_key.bytes', 'rb') as fp:
    encrypted_key = fp.read()
decrypted_key = rsa.decrypt(encrypted_key, private_key)

assert decrypted_key == submitter_key

fernet = Fernet(decrypted_key)

with open('encrypted_code.bytes', 'rb') as fp:
    encrypted_code = fp.read()

# Decrypt
with open('output.py', 'w+', encoding='utf-8') as fp:
    code_encrypted = fernet.decrypt(encrypted_code)
    pieces = [rsa.decrypt(code_encrypted[i:i+256], private_key).decode('utf-8')
              for i in range(0, len(code_encrypted), 256)]
    rsa_decrypted = ''.join(pieces)
    fp.write(rsa_decrypted)

print("done")
