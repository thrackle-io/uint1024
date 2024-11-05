from util_1024 import utils

def calculate_in_1024(args):

    leftOperand, rightOperand,  operator = utils.reconstruct_a_b_1024(args)

    if(operator == "div"):
        # This step is needed to ensure correct reversion on the solidity implementation
        if(rightOperand == 0): rightOperand = 1 
        result = int(leftOperand) // int(rightOperand)
    elif(operator == "mul"):
        result = int(leftOperand) * int(rightOperand)
    elif(operator == "add"):
        result = int(leftOperand) + int(rightOperand)
    elif(operator == "sub"):
        result = int(leftOperand) - int(rightOperand)
    else: raise ValueError("Incorrect operator passed as argument")

    r0, r1, r2, r3 = utils.deconstruct_1024(result)

    utils.return_encoded_1024(r0, r1, r2, r3)

def main():
    args = utils.parse_args_a_b_1024()
    calculate_in_1024(args)

if __name__ == "__main__":
    main()
