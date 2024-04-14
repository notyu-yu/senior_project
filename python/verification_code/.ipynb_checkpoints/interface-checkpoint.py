'''
Defines interaction interface of database
'''
import random
from hashlib import sha256

rand_data = []
data_hashes = []


def database_init():
    '''
    Generate random string data
    '''
    for _ in range(100):
        item = ''.join(random.choices(("G", "A", "T", "C"), k=1000))
        rand_data.append(item)
        data_hashes.append(sha256(item.encode('utf-8')).hexdigest())


def database_interface(command):
    '''
    Simulate interaction interface, URL request, etc.
    '''
    if command == 'leak':
        return rand_data[0]
    return ""


def genome_hashes():
    '''
    Return list of genome hashes for current database
    '''
    return data_hashes
