'''
Convert bytes file to list of hex strings for Remix input
Usage: python bytes_to_hex.py filename.bytes
'''
import sys

with open(sys.argv[1], 'rb') as fp:
    hex_str = fp.read().hex()
    print(hex_str)
