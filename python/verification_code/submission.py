'''
Contains the exploit_entry function of submission
'''
import numpy as np


def random_error(array, n):
    '''
    Set n random bits in array to 0 
    '''
    indices = np.random.choice(np.arange(array.size), replace=False, size=n)
    array[indices] = 0
    return array


def exploit_entry(interface_function):
    '''
    Takes in function pointer as argument, return list of genome sequences
    '''
    result = np.array([random_error(interface_function('leak'),100)
                      for _ in range(100)])
    return result
