import typing
import random
import time
import string
import itertools
import subprocess
import re
random_seed=time.time()
#print(f"Value generator random seed: {random_seed}")
random.seed(random_seed)
EXAMPLE_ARG = "examples"

def get_next_val(filename):
    #return subprocess.run('echo "ashwin"',capture_output= True)
    #return subprocess.run(['"ashwin" |radamsa'], capture_output=True)
    while True:
        command = 'echo "12345" | radamsa --mutations num'  # Using a simple base number for mutations
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        mutated_output = result.stdout.strip()
        # Filter the output to ensure it's a positive number
        if re.match(r'^\-?\d+$', mutated_output):  # Match integers (possibly negative)
            try:
                val = int(mutated_output)
                if -2**31 <= val <= 2**31 - 1:  # Ensure it's within int32 range
                    with open('/RESTler/json/output.txt', 'a') as file:
                        file.write(str(val))
                        file.write('\n')
                    return val
            except ValueError:
                pass  # Handle conversion to int errors
def get_next_val_char(filename):
    command = 'echo "a" | radamsa --mutations num'
    result = subprocess.run(command, shell=True, capture_output=True, text=True) 
    return result.stdout
def get_next_number(filename):
    while True:
        command = 'echo "12345" | radamsa --mutations num'  # Using a simple base number for mutations
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        mutated_output = result.stdout.strip()
        # Filter the output to ensure it's a positive number
        if re.match(r'^\-?\d+$', mutated_output):  # Match integers (possibly negative)
            return mutated_output
def placeholder_value_generator():
    while True:
        #raise Exception("Testing")
        yield get_next_val("sample_file_name")
        #yield int(random.randint(222,225 ))
        #yield ''.join(random.choices(string.ascii_letters + string.digits, k=1))

def gen_restler_fuzzable_int(**kwargs):
    return placeholder_value_generator() 
def gen_restler_fuzzable_number(**kwargs):
    while True:
        yield get_next_number("sample_file_name")
    

value_generators = {
    "restler_fuzzable_int": gen_restler_fuzzable_int,
    "restler_fuzzable_number": gen_restler_fuzzable_number
}
#print(get_next_val("sample_file_name_not_used"))
