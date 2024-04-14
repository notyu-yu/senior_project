'''
Generates private and public rsa keys as strings
Saves output to public_key.txt and private_key.txt
'''
import rsa

with open('public_key.txt', 'w+', encoding='utf-8') as public_key_fp, \
        open('private_key.txt', 'w+', encoding='utf-8') as private_key_fp:
    public_key, private_key = rsa.newkeys(2048)

    public_key_string = public_key.save_pkcs1().decode('utf-8')
    private_key_string = private_key.save_pkcs1().decode('utf-8')

    public_key_fp.write(public_key_string)
    private_key_fp.write(private_key_string)
