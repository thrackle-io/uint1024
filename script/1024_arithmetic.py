from util_1024 import utils

def calculate_in_1024(args):

    a, b, operator = utils.reconstruct_a_b_1024(args)

    if(operator == "div"):
        # This step is needed to ensure correct reversion on the solidity implementation
        if(b == 0): b = 1 
        result = int(a) // int(b)
    elif(operator == "mul"):
        result = int(a) * int(b)
    elif(operator == "add"):
        result = int(a) + int(b)
    elif(operator == "sub"):
        if(a < b):
            # Setting result to int(word)**4 instead of negative result to ensure correct reversion on the solidity implementation
            result = int(utils.word)**4 
        else: result = int(a) - int(b)
    elif(operator == "lt"):
        result = int(a) < int(b)
    elif(operator == "gt"):
        result = int(a) > int(b)
    elif(operator == "mod"):
        result = int(a) % int(b)
    elif(operator == "eq"):
        result = int(a) == int(b)
    elif(operator == "ge"):
        result = int(a) == int(b) or int(a) > int(b)
    else: raise ValueError("Incorrect operator passed as argument")

    r0, r1, r2, r3, r4 = utils.deconstruct_1024(result)

    utils.return_encoded_1024(r0, r1, r2, r3, r4)

def main():
    args = utils.parse_args_a_b_1024()
    calculate_in_1024(args)

if __name__ == "__main__":
    main()
