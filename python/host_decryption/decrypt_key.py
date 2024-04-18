'''
Decrypt submitter key in encrypted_key.bytes
Using private key in private_key.txt
Output to submitter_key.txt
'''
import rsa

with open('private_key.txt', 'r', encoding='utf-8') as fp:
    private_key = rsa.PrivateKey.load_pkcs1(fp.read().encode('utf-8'))
with open('encrypted_key.bytes', 'rb') as fp:
    encrypted_key = fp.read()

decrypted_key = rsa.decrypt(encrypted_key, private_key)

with open('submitter_key.bytes', 'wb+') as fp:
    key = decrypted_key
    fp.write(key)
