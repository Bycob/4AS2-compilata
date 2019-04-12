import sys

if len(sys.argv) < 2:
    print("Usage: python", __file__, "[asm file]")

filename = sys.argv[1]
reg = [0] * 4
mem = [0] * 65536

with open(filename, "r") as file:
    for str in file.readlines():
        parts = str.split(" ")
        command = parts[0]
        args = [int(x) for x in parts[1:4]]

        if command == "ADD":
            reg[args[0]] = reg[args[1]] + reg[args[2]]
        elif command == "LOAD":
            reg[args[0]] = mem[args[1]/4]
        elif command == "STORE":
            mem[args[0]/4] = reg[args[1]]
        elif command == "AFC":
            reg[args[0]] = args[1];
        else:
            raise "Unknown command"

print("Etat des registres: ", reg[1:])
print("Etat de la memoire: ", mem[:10])
