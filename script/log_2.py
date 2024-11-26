import argparse
from math import log2
from decimal import *
from eth_abi import encode

def calculate_ln(args):
    result = log2(Decimal(args.x))
    enc = encode(["int256"], [round(result)])
    print("0x" + enc.hex(), end="")

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("x", type=int)
    return parser.parse_args()

def main():
    args = parse_args()
    calculate_ln(args)


if __name__ == "__main__":
    main()