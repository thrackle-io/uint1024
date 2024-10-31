// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "src/Uint512.sol";

/**
 * @title Uint512 Extended Math Library
 * @author  @oscarsernarosero @mpetersoCode55 @cirsteve @Palmerg4
 */
library Uint512Extended {
    using Uint512 for uint256;
    /**
     * @notice x > y
     * @dev tells if x is greater than y where x and y are 512 bit numbers
     * @param x0 lower bits of x
     * @param x1 higher bits of x
     * @param y0 lower bits of y
     * @param y1 higher bits of y
     * @return boolean. True if x > y
     */
    function gt512(uint256 x0, uint256 x1, uint256 y0, uint256 y1) internal pure returns (bool) {
        return x1 > y1 || (x1 == y1 && x0 > y0);
    }

    /**
     * @notice x == y
     * @dev tells if x is equal to y where x and y are 512 bit numbers
     * @param x0 lower bits of x
     * @param x1 higher bits of x
     * @param y0 lower bits of y
     * @param y1 higher bits of y
     * @return boolean. True if x = y
     */
    function eq512(uint256 x0, uint256 x1, uint256 y0, uint256 y1) internal pure returns (bool) {
        return x1 == y1 && x0 == y0;
    }

    /**
     * @notice x >= y
     * @dev tells if x is greater or equal than y where x and y are 512 bit numbers
     * @param x0 lower bits of x
     * @param x1 higher bits of x
     * @param y0 lower bits of y
     * @param y1 higher bits of y
     * @return boolean. True if x >= y
     */
    function ge512(uint256 x0, uint256 x1, uint256 y0, uint256 y1) internal pure returns (bool) {
        return eq512(x0, x1, y0, y1) || gt512(x0, x1, y0, y1);
    }

    /**
     * @notice x < y
     * @dev tells if x is less than y where x and y are 512 bit numbers
     * @param x0 lower bits of x
     * @param x1 higher bits of x
     * @param y0 lower bits of y
     * @param y1 higher bits of y
     * @return boolean. True if x < y
     */
    function lt512(uint256 x0, uint256 x1, uint256 y0, uint256 y1) internal pure returns (bool) {
        return !ge512(x0, x1, y0, y1);
    }

    /**
     * @dev Calculates the division of a 512-bit unsigned integer by a denominator which is
     * a power of 2. It doesn't require the result to be a uint256.
     * @notice very useful if a division of a 512 is expected to be also a 512.
     * @param a0 A uint256 representing the low bits of the numerator
     * @param a1 A uint256 representing the high bits of the numerator
     * @param n the power of 2 that the division will be carried out by (demominator = 2**n).
     * @return r0 The lower bits of the result
     * @return r1 The higher bits of the result
     * @return remainder of the division
     */
    function div512ByPowerOf2(uint256 a0, uint256 a1, uint8 n) internal pure returns (uint256 r0, uint256 r1, uint256 remainder) {
        if (n == 0) revert("n must be greater than 0");
        uint _2ToTheNth = 2 ** n;
        uint shiftedBits = a1 & (_2ToTheNth - 1);
        remainder = a0 & (_2ToTheNth - 1);
        r1 = a1 >> n;
        r0 = (shiftedBits << (256 - n)) | (a0 >> n);
    }

    /**
     * @notice Calculates the product of two uint512 and uint256 safely
     * @dev Used the chinese remainder theoreme
     * @param a0 A uint256 representing lower bits of the first factor
     * @param a1 A uint256 representing higher bits of the first factor
     * @param b A uint256 representing the second factor
     * @return r0 The result as a uint512. r0 contains the lower bits
     * @return r1 The higher bits of the result
     */
    function safeMul512x256(uint256 a0, uint256 a1, uint256 b) internal pure returns (uint256 r0, uint256 r1) {
        assembly {
            let mm := mulmod(a0, b, not(0))
            r0 := mul(a0, b)
            r1 := sub(sub(mm, r0), lt(mm, r0))
            r1 := add(r1, mul(a1, b))

            // overflow check
            if lt(r1, a1) {
                let ptr := mload(0x40) // Get free memory pointer
                mstore(ptr, 0x08c379a000000000000000000000000000000000000000000000000000000000) // Selector for method Error(string)
                mstore(add(ptr, 0x04), 0x20) // String offset
                mstore(add(ptr, 0x24), 19) // Revert reason length
                mstore(add(ptr, 0x44), "mul512x256 overflow")
                revert(ptr, 0x64) // Revert data length is 4 bytes for selector and 3 slots of 0x20 bytes
            }
        }
    }

    /**
     * @notice Calculates the sum of two uint512 safely
     * @param a0 A uint256 representing the lower bits of the first addend
     * @param a1 A uint256 representing the higher bits of the first addend
     * @param b0 A uint256 representing the lower bits of the seccond addend
     * @param b1 A uint256 representing the higher bits of the seccond addend
     * @return r0 The result as a uint512. r0 contains the lower bits
     * @return r1 The higher bits of the result
     */
    function safeAdd512x512(uint256 a0, uint256 a1, uint256 b0, uint256 b1) internal pure returns (uint256 r0, uint256 r1) {
        assembly {
            r0 := add(a0, b0)
            r1 := add(add(a1, b1), lt(r0, a0))

            //overflow check
            if lt(r1, b1) {
                let ptr := mload(0x40) // Get free memory pointer
                mstore(ptr, 0x08c379a000000000000000000000000000000000000000000000000000000000) // Selector for method Error(string)
                mstore(add(ptr, 0x04), 0x20) // String offset
                mstore(add(ptr, 0x24), 19) // Revert reason length
                mstore(add(ptr, 0x44), "add512x512 overflow")
                revert(ptr, 0x64) // Revert data length is 4 bytes for selector and 3 slots of 0x20 bytes
            }
        }
    }

    /**
     * @notice Calculates the difference of two uint512 safely
     * @param a0 A uint256 representing the lower bits of the minuend
     * @param a1 A uint256 representing the higher bits of the minuend
     * @param b0 A uint256 representing the lower bits of the subtrahend
     * @param b1 A uint256 representing the higher bits of the subtrahend
     * @return r0 The result as a uint512. r0 contains the lower bits
     * @return r1 The higher bits of the result
     */
    function safeSub512x512(uint256 a0, uint256 a1, uint256 b0, uint256 b1) internal pure returns (uint256 r0, uint256 r1) {
        if (lt512(a0, a1, b0, b1)) revert("Uint512: negative result sub512x512");
        assembly {
            r0 := sub(a0, b0)
            r1 := sub(sub(a1, b1), lt(a0, b0))
        }
    }

    /**
     * @notice Calculates the division of a 512 bit unsigned integer by a 256 bit integer safely. It
     * requires the result to fit in a 256 bit integer
     * @dev For a detailed explaination see:
     * https://www.researchgate.net/publication/235765881_Efficient_long_division_via_Montgomery_multiply
     * @param a0 A uint256 representing the low bits of the nominator
     * @param a1 A uint256 representing the high bits of the nominator
     * @param b A uint256 representing the denominator
     * @return r The result as an uint256. Result must have at most 256 bit
     */
    function safeDiv512x256(uint256 a0, uint256 a1, uint256 b) internal pure returns (uint256 r) {
        if (a1 >= b) revert("Uint512: a1 >= b div512x256");
        uint256 rem;
        assembly {
            // calculate the remainder
            rem := mulmod(a1, not(0), b)
            rem := addmod(rem, a1, b)
            rem := addmod(rem, a0, b)
        }
            r = a0.divRem512x256(a1, b, rem);
    }

    function mulInverseMod256(uint b) internal pure returns (uint inv) {
        assembly {
            // Calculate the multiplicative inverse mod 2**256 of b. See the paper for details.
            //slither-disable-next-line incorrect-exp
            inv := xor(mul(3, b), 2) // 4
            inv := mul(inv, sub(2, mul(b, inv))) // 8
            inv := mul(inv, sub(2, mul(b, inv))) // 16
            inv := mul(inv, sub(2, mul(b, inv))) // 32
            inv := mul(inv, sub(2, mul(b, inv))) // 64
            inv := mul(inv, sub(2, mul(b, inv))) // 128
            inv := mul(inv, sub(2, mul(b, inv))) // 256
            // slither-disable-end divide-before-multiply
        }
    }
}
