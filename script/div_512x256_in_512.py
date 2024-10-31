import argparse
from eth_abi import encode

def calculate_division(args):
    a0 = int(args.a0) 
    a1 = int(args.a1) 
    b = int(args.b) 

    word = int(2) ** int(256)
    numerator = (a1 * word) + a0
    result = int(numerator) // b
    r0 = int(result) % int(word)
    r1 = int(result) // int(word)
    enc = encode(["(uint256,uint256)"], [(r0,r1)])
    print("0x" + enc.hex(), end="")

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("a0", type=int)
    parser.add_argument("a1", type=int)
    parser.add_argument("b", type=int)
    return parser.parse_args()

def main():
    args = parse_args()
    calculate_division(args)


if __name__ == "__main__":
    main()