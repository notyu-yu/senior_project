'''
Convert a hex string to bytes, and writes it to a file
Usage: python hex_to_bytes.py output_file.txt hexstring
'''
import sys

with open(sys.argv[1], 'wb+') as fp:
    fp.write(bytes.fromhex(sys.argv[2]))
