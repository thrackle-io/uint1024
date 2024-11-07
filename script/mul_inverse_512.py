from util_1024 import utils

def calculate_mul_inv(args):

    b = utils.reconstruct_b_512(args)

    result = pow(b, -1, utils.word**2)

    r0, r1, r2, r3, r4 = utils.deconstruct_1024(result)

    utils.return_encoded_1024(r0, r1, r2, r3, r4)

def main():
    args = utils.parse_args_b_512()
    calculate_mul_inv(args)

if __name__ == "__main__":
    main()
