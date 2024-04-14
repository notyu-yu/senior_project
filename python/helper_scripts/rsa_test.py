'''
Testing RSA encryption
'''
import rsa

message = "Test message."

with open('private_key.txt', 'r', encoding='utf-8') as fp:
    private_key = rsa.PrivateKey.load_pkcs1(fp.read().encode('utf-8'))
with open('public_key.txt', 'r', encoding='utf-8') as fp:
    public_key = rsa.PublicKey.load_pkcs1(fp.read().encode('utf-8'))

encrypted = rsa.encrypt(message.encode(), public_key)
decrypted = rsa.decrypt(encrypted, private_key).decode()

assert message == decrypted

print(decrypted)
print(message)
