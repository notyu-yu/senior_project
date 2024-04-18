'''
Defines interaction interface of database
'''
import random
import numpy as np
import faiss

LENGTH = 1000  # Length of sequences
DATA_SIZE = 1000  # Number of datapoints generated
RESULT_SIZE = 100  # Max number of result sequences accepted
MAX_DISTANCE = LENGTH/100  # Maximum hamming distance variation allowed for results


def database_init():
    '''
    Generate random numpy arrays for dataset
    Returns database_interface and verify_results functions
    '''
    rand_data = None
    index = None

    rand_data = np.random.randint(0, high=4, size=(DATA_SIZE, LENGTH))

    # Create LSH neighbor search object
    index = faiss.IndexLSH(LENGTH, 40)
    index.add(rand_data)

    def database_interface(command):
        '''
        Simulate interaction interface, URL request, etc.
        '''
        if command == 'leak':
            return random.choice(rand_data)
        return ""

    def verify_results(results_list):
        '''
        Check if any entry in results_list is close to a database entry
        Returns boolean as result
        '''
        assert len(
            results_list) <= RESULT_SIZE, f'Result size {RESULT_SIZE} exceeded'
        _, reference_matches = index.search(results_list, 1)
        for reference, exploit in zip(reference_matches, results_list):
            if np.sum(rand_data[reference] != exploit) <= MAX_DISTANCE:
                return True
        return False

    return database_interface, verify_results
