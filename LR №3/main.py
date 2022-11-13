import collections
from pathlib import Path

with open('./folder/text.txt', 'r') as f:
    message = f.read()

c = {}
def create_list(message):
    list = dict(collections.Counter(message))
    list_sorted = sorted(iter(list.items()), key=lambda k_v: (k_v[1], k_v[0]), reverse=True)
    final_list = []
    for key, value in list_sorted:
        final_list.append([key, value, ''])
    return final_list

def divide_list(list):
    if len(list) == 2:
        return [list[0]], [list[1]]
    else:
        n = 0
        for i in list:
            n += i[1]
        x = 0
        distance = abs(2*x - n)
        j = 0
        for i in range(len(list)):
            x += list[i][1]
            if distance < abs(2*x - n):
                j = i
    return list[0:j+1], list[j+1:]


def label_list(list):
    list1, list2 = divide_list(list)
    for i in list1:
        i[2] += '0'
        c[i[0]] = i[2]
    for i in list2:
        i[2] += '1'
        c[i[0]] = i[2]
    if len(list1) == 1 and len(list2) == 1:
        return
    label_list(list2)
    return c

code = label_list(create_list(message))
output = open("compressed.txt", "w+")
letter_binary = []
for key, value in code.items():
    letter_binary.append([key,value])


for a in message:
    for key, value in code.items():
        if key in a:
            output.write(value)


output = open("compressed.txt", "r")  #decode
text = output.readlines()
bitstring = ""
for digit in text:
    bitstring = bitstring + digit
uncompressed_string = ""
code = ""
for digit in bitstring:
    code = code+digit
    pos=0
    for letter in letter_binary:
        if code == letter[1]:
            uncompressed_string = uncompressed_string+letter_binary[pos][0]
            code = ""
        pos += 1

print("Количество информации до кодироки: ")
print(Path('./folder/text.txt').stat().st_size)
print("Количество информации после кодировки Шеннона кодироки: ")
print(Path('./compressed.txt').stat().st_size)
