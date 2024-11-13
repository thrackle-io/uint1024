import argparse
from math import log2
from decimal import *
from eth_abi import encode

def calculate_ln(args):

    result = int(log2(args.x))
    if (result == 256): result = 255 # this is a fix for a rounding error from Python
    enc = encode(["int256"], [result])
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