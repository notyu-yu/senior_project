'''
Verifies validity of encrypted code, keys, key_hash, and exploit code
'''
from hashlib import sha256
import rsa
from submission import exploit_entry
from interface import database_init
from cryptography.fernet import Fernet


def generate_commitments():
    '''
    Generate encrypted files and hashes for commitment
    Print encrypted key hash and hash of encrypted code
    '''
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

    # Print key hash
    print(sha256(public_encrypted_key).hexdigest())

    # Generate ecrypted_code.txt
    with open('submission.py', 'r', encoding='utf-8') as code_fp, \
            open('encrypted_code.bytes', 'wb') as encrypted_fp:
        code_str = code_fp.read().encode('utf-8')
        code_public_encrypted = b''.join([rsa.encrypt(
            code_str[i:i+245], public_key) for i in range(0, len(code_str), 245)])
        code_fernet_encrypted = fernet.encrypt(code_public_encrypted)
        encrypted_fp.write(code_fernet_encrypted)
        print(sha256(code_fernet_encrypted).hexdigest())


if __name__ == "__main__":
    # Generate commitments for submission
    generate_commitments()

    # Initialize database
    database_interface, verify_results = database_init()

    # Run exploit
    results = exploit_entry(database_interface)

    # Check submission hash
    print(verify_results(results))
