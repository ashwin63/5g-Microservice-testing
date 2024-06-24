import typing
import random
import time
import string
import itertools
import subprocess
random_seed=time.time()
#print(f"Value generator random seed: {random_seed}")
random.seed(random_seed)

EXAMPLE_ARG = "examples"

def get_next_val(filename):
    #return subprocess.run('echo "ashwin"',capture_output= True)
    #return subprocess.run(['"ashwin" |radamsa'], capture_output=True)
    while True:
    	command = 'echo "12345" | radamsa'  # Using a simple base number for mutations
    	result = subprocess.run(command, shell=True, capture_output=True, text=True)
    	mutated_output = result
		# Filter the output to ensure it's a positive number
		with open('/RESTler/json/output.txt', 'a') as file:
			file.write(mutated_output)
			file.write('\n')
		if re.match(r'^[0-9]+$', mutated_output):
			return mutated_output
def get_next_val_char(filename):
    command = 'echo "a" | radamsa --mutations num'
    result = subprocess.run(command, shell=True, capture_output=True, text=True) 
    return result.stdout
def placeholder_value_generator():
    while True:
        #raise Exception("Testing")
        yield get_next_val("sample_file_name")
        #yield int(random.randint(222,225 ))
        #yield ''.join(random.choices(string.ascii_letters + string.digits, k=1))

def gen_restler_fuzzable_int(**kwargs):
    return placeholder_value_generator() 


value_generators = {
	"restler_fuzzable_int": gen_restler_fuzzable_int
}
#print(get_next_val("sample_file_name_not_used"))

