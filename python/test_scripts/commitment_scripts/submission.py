def exploit_entry(interface_function):
    # Takes in function pointer as argument, return list of genome sequences
    return [interface_function('leak')] * 10