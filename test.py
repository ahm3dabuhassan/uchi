import re
user = { 'Id': 112, 'Name': 'Mac_Boy'}

print(user["Name"])

data = ['Hamburg','Berlin','San Francisco']

for index in data: 
	print(index)

w = lambda a, b : a * b
print(w(3, 7))

txt_1 = "The rain in Spain"
result = re.findall("a",txt_1)
print(result)

counter = int(0)

while counter <= 23:
	print(counter)
	if counter == 11:
		print('Hello elf')
		break
	counter += 1 
