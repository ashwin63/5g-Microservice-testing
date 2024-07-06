import json 
filename = "d5b0a8e753f5fade074a3a97e0bd7cd4bb49a6f2"
with open(filename, 'r') as file:
    data = json.load(file)
print(data[0]['0'])