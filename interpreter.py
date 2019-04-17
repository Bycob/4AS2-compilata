import sys

if len(sys.argv) < 2:
    print("Usage: python", __file__, "[asm file]")

filename = sys.argv[1]
reg = [0] * 4
mem = [0] * 65536

with open(filename, "r") as file:
    instructions = file.readlines()
    iptr = 0

    while iptr < len(instructions):
        instruction = instructions[iptr]
        parts = instruction.split(" ")
        command = parts[0]
        args = [int(x) for x in parts[1:4]]

        if command == "ADD":
            reg[args[0]] = reg[args[1]] + reg[args[2]]
        elif command == "SUB":
            reg[args[0]] = reg[args[1]] - reg[args[2]]
        elif command == "MUL":
            reg[args[0]] = reg[args[1]] * reg[args[2]]
        elif command == "DIV":
            reg[args[0]] = reg[args[1]] / reg[args[2]]
        elif command == "COP":
            reg[args[0]] = reg[args[1]]
        elif command == "AFC":
            reg[args[0]] = args[1];
        elif command == "LOAD":
            reg[args[0]] = mem[args[1] // 4]
        elif command == "STORE":
            mem[args[0] // 4] = reg[args[1]]
        elif command == "EQU":
            reg[args[0]] = reg[args[1]] == reg[args[2]]
        elif command == "LSS":
            reg[args[0]] = reg[args[1]] < reg[args[2]]
        elif command == "LEQ":
            reg[args[0]] = reg[args[1]] <= reg[args[2]]
        elif command == "GTR":
            reg[args[0]] = reg[args[1]] > reg[args[2]]
        elif command == "GEQ":
            reg[args[0]] = reg[args[1]] >= reg[args[2]]
        elif command == "JMP":
            iptr = args[0] - 1
        elif command == "JMPC":
            if reg[args[1]] == 0:
                iptr = args[0] - 1
        else:
            raise "Unknown command"

        iptr += 1

print("Etat des registres: ", reg[1:])
print("Etat de la memoire: ", mem[:10])
