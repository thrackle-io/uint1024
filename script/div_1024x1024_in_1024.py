import argparse
from eth_abi import encode

def calculate_division_in_1024(args):
    a0 = int(args.a0)
    a1 = int(args.a1)
    a2 = int(args.a2)
    a3 = int(args.a3)
    b0 = int(args.b0)
    b1 = int(args.b1)
    b2 = int(args.b2)
    b3 = int(args.b3)

    word = int(2) ** int(256)

    numerator = (a3 * int(word)**3) + (a2 * int(word)**2) + (a1 * int(word)) + a0
    denominator = (b3 * int(word)**3) + (b2 * int(word)**2) + (b1 * int(word)) + b0
    
    result = int(numerator) // int(denominator)

    r3 = int(result) // int(word)**3
    r2 = int(result - (r3 * int(word)**3)) // int(word)**2
    r1 = int(result - (r3 * int(word)**3) - (r2 * int(word)**2)) // int(word)
    r0 = int(result - (r3 * int(word)**3) - (r2 * int(word)**2)) % int(word)

    enc = encode(["(uint256,uint256,uint256,uint256)"], [(r0,r1,r2,r3)])
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
    return parser.parse_args()

def main():
    args = parse_args()
    calculate_division_in_1024(args)


if __name__ == "__main__":
    main()