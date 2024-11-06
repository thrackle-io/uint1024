import argparse
from eth_abi import encode

def calculate_in_1024(args):
    a0 = int(args.a0)
    a1 = int(args.a1)
    a2 = int(args.a2)
    a3 = int(args.a3)
    b0 = int(args.b0)
    b1 = int(args.b1)
    b2 = int(args.b2)
    b3 = int(args.b3)
    operator = str(args.operator)
    
    word = int(2) ** int(256)

    leftOperand = (a3 * int(word)**3) + (a2 * int(word)**2) + (a1 * int(word)) + a0
    rightOperand = (b3 * int(word)**3) + (b2 * int(word)**2) + (b1 * int(word)) + b0

    if(operator == "div"):
        # This step is needed to ensure correct reversion on the solidity implementation
        if(rightOperand == 0): rightOperand = 1 
        result = int(leftOperand) // int(rightOperand)
    elif(operator == "mul"):
        result = int(leftOperand) * int(rightOperand)
    elif(operator == "add"):
        result = int(leftOperand) + int(rightOperand)
    elif(operator == "sub"):
        if(leftOperand < rightOperand):
            # Setting result to int(word)**4 instead of negative result to ensure correct reversion on the solidity implementation
            result = int(word)**4 
        else: result = int(leftOperand) - int(rightOperand)
    else: raise ValueError("Incorrect operator passed as argument")

    r4 = int(result) // int(word)**4
    r3 = int(result - (r4 * int(word)**4)) // int(word)**3
    r2 = int(result - (r4 * int(word)**4) - (r3 * int(word)**3)) // int(word)**2
    r1 = int(result - (r4 * int(word)**4) - (r3 * int(word)**3) - (r2 * int(word)**2)) // int(word)
    r0 = int(result - (r4 * int(word)**4) - (r3 * int(word)**3) - (r2 * int(word)**2)) % int(word)

    enc = encode(["(uint256,uint256,uint256,uint256,uint256)"], [(r0,r1,r2,r3,r4)])
    print("0x" + enc.hex(), end="")

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("a0", type=int)
    parser.add_argument("a1", type=int)
    parser.add_argument("a2", type=int)
    parser.add_argument("a3", type=int)
    parser.add_argument("b0", type=int)
    parser.add_argument("b1", type=int)
    parser.add_argument("b2", type=int)
    parser.add_argument("b3", type=int)
    parser.add_argument("operator", type=str)
    return parser.parse_args()

def main():
    args = parse_args()
    calculate_in_1024(args)

if __name__ == "__main__":
    main()
