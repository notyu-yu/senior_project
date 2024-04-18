'''
Convert file to string literal
Usage: python file_to_string.py filename.txt
'''
import sys

with open(sys.argv[1],'r',encoding='utf-8') as fp:
    text = fp.read()
    print(repr(text))