// SPDX-License-Identifier: GPLv3
pragma solidity ^0.8.24;

import "./Uint512.sol";
import "./UintTypes.sol";

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
     * @return res boolean. True if x > y
     */
    function gt512(uint256 x0, uint256 x1, uint256 y0, uint256 y1) internal pure returns (bool res) {
        //return x1 > y1 || (x1 == y1 && x0 > y0);
        assembly{
            res := or(gt(x1, y1), and(eq(x1, y1), gt(x0, y0)))
        }
    }

    /**
     * @notice x > y
     * @dev tells if x is greater than y where x and y are 512 bit numbers
     * @param x A uint512 representing the value to compare against y
     * @param y A uint512 representing the value to compare against x
     * @return res boolean. True if x > y
     */
    function gt512(uint512 memory x, uint512 memory y) internal pure returns (bool) {
        return gt512(x._0, x._1, y._0, y._1);
    }

    /**
     * @notice x == y
     * @dev tells if x is equal to y where x and y are 512 bit numbers
     * @param x0 lower bits of x
     * @param x1 higher bits of x
     * @param y0 lower bits of y
     * @param y1 higher bits of y
     * @return res boolean. True if x == y
     */
    function eq512(uint256 x0, uint256 x1, uint256 y0, uint256 y1) internal pure returns (bool res) {
        //return x1 == y1 && x0 == y0;
        assembly{
            res := and(eq(x1, y1), eq(x0, y0))
        }
    }

    /**
     * @notice x > y
     * @dev tells if x is greater than y where x and y are 512 bit numbers
     * @param x A uint512 representing the value to compare against y
     * @param y A uint512 representing the value to compare against x
     * @return res boolean. True if x == y
     */
    function eq512(uint512 memory x, uint512 memory y) internal pure returns (bool) {
        return eq512(x._0, x._1, y._0, y._1);
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
     * @notice x >= y
     * @dev tells if x is greater or equal than y where x and y are 512 bit numbers
     * @param x A uint512 representing the value to compare against y
     * @param y A uint512 representing the value to compare against x
     * @return boolean. True if x >= y
     */
    function ge512(uint512 memory x, uint512 memory y) internal pure returns (bool) {
        return ge512(x._0, x._1, y._0, y._1);
    }

    /**
     * @notice x < y
     * @dev tells if x is less than y where x and y are 512 bit numbers
     * @param x0 lower bits of x
     * @param x1 higher bits of x
     * @param y0 lower bits of y
     * @param y1 higher bits of y
     * @return res boolean. True if x < y
     */
    function lt512(uint256 x0, uint256 x1, uint256 y0, uint256 y1) internal pure returns (bool res) {
        //return x1 < y1 || (x1 == y1 && x0 < y0);
        assembly{
            res := or(lt(x1, y1), and(eq(x1, y1), lt(x0, y0)))
        }
    }

    /**
     * @notice x < y
     * @dev tells if x is less than y where x and y are 512 bit numbers
     * @param x A uint512 representing the value to compare against y
     * @param y A uint512 representing the value to compare against x
     * @return res boolean. True if x < y
     */
    function lt512(uint512 memory x, uint512 memory y) internal pure returns (bool) {
        return lt512(x._0, x._1, y._0, y._1);
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
        assembly{
            if eq(n, 0){
                let ptr := mload(0x40) // Get free memory pointer
                mstore(ptr, 0x08c379a000000000000000000000000000000000000000000000000000000000) // Selector for method Error(string)
                mstore(add(ptr, 0x04), 0x20) // String offset
                mstore(add(ptr, 0x24), 26) // Revert reason length
                mstore(add(ptr, 0x44), "Uint512: div512 n is 0")
                revert(ptr, 0x64) // Revert data length is 4 bytes for selector and 3 slots of 0x20 bytes
            }
        }
        uint _2ToTheNth = 2 ** n;
        uint shiftedBits = a1 & (_2ToTheNth - 1);
        remainder = a0 & (_2ToTheNth - 1);
        r1 = a1 >> n;
        r0 = (shiftedBits << (256 - n)) | (a0 >> n);
    }

    /**
     * @dev Calculates the division of a 512-bit unsigned integer by a denominator which is
     * a power of 2. It doesn't require the result to be a uint256.
     * @notice very useful if a division of a 512 is expected to be also a 512.
     * @param a A uint512 representing the numerator
     * @param n the power of 2 that the division will be carried out by (demominator = 2**n).
     * @return r A uint512 representing the result of the division
     * @return rem The remainder of the division
     */
    function div512ByPowerOf2(uint512 memory a, uint8 n) internal pure returns (uint512 memory r, uint256 rem) {
        (r._0, r._1, rem) = div512ByPowerOf2(a._0, a._1, n);
    }

    /**
     * @dev Calculates the division of a 512-bit unsigned integer by a 512-bit. The result will be a uint256.
     * @param a0 A uint256 representing the low bits of the numerator
     * @param a1 A uint256 representing the high bits of the numerator
     * @param b0 A uint256 representing the low bits of the denominator
     * @param b1 A uint256 representing the high bits of the denominator
     * @return result The result of the division of a and b
     */
    function div512x512(uint256 a0, uint256 a1, uint256 b0, uint256 b1) internal pure returns (uint256 result) {
        if (b1 == 0) revert("Uint512Extended: div512x512 b1 can't be zero");
        if (lt512(a0, a1, b0, b1)) return 0;
        /// we find the amount of bits we need to shift in the higher bits of the denominator for it to be 0
        uint n = log2(b1) + 1;
        /// d = 2**n;
        /// if b = c * d + e, where e = k * (c * d) then b = c * d * ( 1 + e / (c * d))
        (uint c, , ) = div512ByPowerOf2(b0, b1, uint8(n));
        /// if b = c * d * ( 1 + e / (c * d)) then a / b = (( a / d) / c) / (1 + e / (c * d)) where e / (c * d) is neglegibly small
        /// making the whole term close to 1 and therefore an unnecessary step which yields a final computation of a / b = (a / d) / c
        (uint resultLo, uint resultHi, ) = div512ByPowerOf2(a0, a1, uint8(n));
        /// (a / d) / c
        result = resultLo.div512x256(resultHi, c);
        (uint eLo, uint eHi) = Uint512.mul512x256(b0, b1, result);
        //bool add = lt512(proofLo, proofHi, eLo, eHi);
        if (lt512(a0, a1, eLo, eHi)){
            --result;
        }
    }

    /**
     * @dev Calculates the division of a 512-bit unsigned integer by a 512-bit. The result will be a uint256.
     * @param a A uint512 representing the numerator
     * @param b A uint512 representing the denominator
     * @return result The result of the division of a and b
     */
    function div512x512(uint512 memory a, uint512 memory b) internal pure returns (uint256 result) {
        (uint256 a0, uint256 a1, uint256 b0, uint256 b1) = (a._0, a._1, b._0, b._1);
        if (b1 == 0) revert("Uint512Extended: div512x512 b1 can't be zero");
        if (lt512(a0, a1, b0, b1)) return 0;
        /// we find the amount of bits we need to shift in the higher bits of the denominator for it to be 0
        uint n = log2(b1) + 1;
        /// d = 2**n;
        /// if b = c * d + e, where e = k * (c * d) then b = c * d * ( 1 + e / (c * d))
        (uint c, , ) = div512ByPowerOf2(b0, b1, uint8(n));
        /// if b = c * d * ( 1 + e / (c * d)) then a / b = (( a / d) / c) / (1 + e / (c * d)) where e / (c * d) is neglegibly small
        /// making the whole term close to 1 and therefore an unnecessary step which yields a final computation of a / b = (a / d) / c
        (uint resultLo, uint resultHi, ) = div512ByPowerOf2(a0, a1, uint8(n));
        /// (a / d) / c
        result = resultLo.div512x256(resultHi, c);
        (uint eLo, uint eHi) = Uint512.mul512x256(b0, b1, result);
        //bool add = lt512(proofLo, proofHi, eLo, eHi);
        if (lt512(a0, a1, eLo, eHi)){
            --result;
        }
    }

    /**
     * @notice Calculates the product of two uint512 and uint256 safely
     * @dev Used the chinese remainder theorem
     * @param a0 A uint256 representing lower bits of the first factor
     * @param a1 A uint256 representing higher bits of the first factor
     * @param b A uint256 representing the second factor
     * @return r0 The result as a uint512. r0 contains the lower bits
     * @return r1 The higher bits of the result
     */
    function safeMul512x256(uint256 a0, uint256 a1, uint256 b) internal pure returns (uint256 r0, uint256 r1) {
        // Get the low and high bits of r0
        (uint r0Lo, uint r0Hi) = Uint512.mul256x256(a0, b);
        // Get the low and high bits of r1
        (uint r1Lo, uint r1Hi) = Uint512.mul256x256(a1, b);
        // r0 is equal to the lowest bits of a0 * b
        r0 = r0Lo;
        assembly {
            // r1 is equal to the sum of the higher bits of a0 * b and the lower bits of a1 * b
            r1 := add(r0Hi, r1Lo)
            // If r1 < r0Hi or r1Hi > 0, it indicates a phantom overflow has happened. Revert in this case.
            if or(lt(r1, r0Hi), gt(r1Hi, 0)) {
                let ptr := mload(0x40) // Get free memory pointer
                mstore(ptr, 0x08c379a000000000000000000000000000000000000000000000000000000000) // Selector for method Error(string)
                mstore(add(ptr, 0x04), 0x20) // String offset
                mstore(add(ptr, 0x24), 28) // Revert reason length
                mstore(add(ptr, 0x44), "Uint512: mul512x256 overflow")
                revert(ptr, 0x64) // Revert data length is 4 bytes for selector and 3 slots of 0x20 bytes
            }
        }
    }

    /**
     * @notice Calculates the product of two uint512 and uint256 safely
     * @dev Used the chinese remainder theorem
     * @param a A uint512 representing the first factor
     * @param b A uint256 representing the second factor
     * @return r A uint512 representing the result of the multiplication of a and b
     */
    function safeMul512x256(uint512 memory a, uint256 b) internal pure returns (uint512 memory r) {
        (r._0, r._1) = safeMul512x256(a._0, a._1, b);
    }

    /**
     * @notice Calculates the sum of two uint512 safely
     * @param a0 A uint256 representing the lower bits of the first addend
     * @param a1 A uint256 representing the higher bits of the first addend
     * @param b0 A uint256 representing the lower bits of the second addend
     * @param b1 A uint256 representing the higher bits of the second addend
     * @return r0 The result as a uint512. r0 contains the lower bits
     * @return r1 The higher bits of the result
     */
    function safeAdd512x512(uint256 a0, uint256 a1, uint256 b0, uint256 b1) internal pure returns (uint256 r0, uint256 r1) {
        // Initialize the carryover check here so we can check outside of the assembly block
        uint carryoverB;
        assembly {
            // Add the lowest bits together
            r0 := add(a0, b0)
            // Check if the lower bits have a carryover
            let carryoverA := lt(r0, b0)
            // Add the highest bits together
            r1 := add(a1, b1)
            // Check if the higher bits have a carryover
            carryoverB := lt(r1, b1)
            // Add the potental carryover to the higher bits of the result
            r1 := add(r1, carryoverA)
            // Check for carryover from the recalc of r1, taking into account previous carryoverB value
            carryoverB := or(carryoverB, lt(r1, carryoverA))
            // If carryoverB has some value, it indicates an overflow for some or all of the results bits
            if gt(carryoverB, 0){
                let ptr := mload(0x40) // Get free memory pointer
                mstore(ptr, 0x08c379a000000000000000000000000000000000000000000000000000000000) // Selector for method Error(string)
                mstore(add(ptr, 0x04), 0x20) // String offset
                mstore(add(ptr, 0x24), 28) // Revert reason length
                mstore(add(ptr, 0x44), "Uint512: safeAdd512 overflow")
                revert(ptr, 0x64) // Revert data length is 4 bytes for selector and 3 slots of 0x20 bytes
            }
        }
    }

    /**
     * @notice Calculates the sum of two uint512 safely
     * @param a A uint512 representing the first addend
     * @param b A uint512 representing the second addend
     * @return r A uint512 representing the result of the addition of a and b
     */
    function safeAdd512x512(uint512 memory a, uint512 memory b) internal pure returns (uint512 memory r) {
        (r._0, r._1) = safeAdd512x512(a._0, a._1, b._0, b._1);
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
            // r0 is the difference of a0 and b0
            r0 := sub(a0, b0)
            // r1 is the difference of a1 and b1. If a0 < b0, subtract 1
            r1 := sub(sub(a1, b1), lt(a0, b0))
        }
    }

    /**
     * @notice Calculates the difference of two uint512 safely
     * @param a A uint512 representing the minuend
     * @param b A uint512 representing the subtrahend
     * @return r A uint512 representing the result of the subtraction of a and b
     */
    function safeSub512x512(uint512 memory a, uint512 memory b) internal pure returns (uint512 memory r) {
        (r._0, r._1) = safeSub512x512(a._0, a._1, b._0, b._1);
    }

    /**
     * @notice Calculates the division of a 512 bit unsigned integer by a 256 bit integer safely. It
     * requires the result to fit in a 256 bit integer
     * @dev For a detailed explaination see:
     * https://www.researchgate.net/publication/235765881_Efficient_long_division_via_Montgomery_multiply
     * @param a0 A uint256 representing the low bits of the nominator
     * @param a1 A uint256 representing the high bits of the nominator
     * @param b A uint256 representing the denominator
     * @return r The result as an uint256. Result must have at most 256 bits
     */
    function safeDiv512x256(uint256 a0, uint256 a1, uint256 b) internal pure returns (uint256 r) {
        if (a1 >= b) revert("Uint512: a1 >= b div512x256");
        uint256 rem = Uint512.mod512x256(a0, a1, b);
        r = Uint512.divRem512x256(a0, a1, b, rem);
    }

    /**
     * @notice Calculates the division of a 512 bit unsigned integer by a 256 bit integer safely. It
     * requires the result to fit in a 256 bit integer
     * @dev For a detailed explaination see:
     * https://www.researchgate.net/publication/235765881_Efficient_long_division_via_Montgomery_multiply
     * @param a A uint512 representing the nominator
     * @param b A uint256 representing the denominator
     * @return r The result as an uint256. Result must have at most 256 bits
     */
    function safeDiv512x256(uint512 memory a, uint256 b) internal pure returns (uint256 r) {
        r = safeDiv512x256(a._0, a._1, b);
    }

    /**
     * @dev calculates the logarithm base 2 of x
     * @param x the number to calculate the logarithm base 2 of
     * @return n the result of log2(x)
     */
    function log2(uint x) internal pure returns (uint n) {
        assembly {
            // 2 ** 128
            if or(gt(x, 340282366920938463463374607431768211456), eq(x, 340282366920938463463374607431768211456)){
                x := shr(128, x)
                n := add(n, 128)
            }
            // 2 ** 64
            if or(gt(x, 18446744073709551616), eq(x, 18446744073709551616)){
                x := shr(64, x)
                n := add(n, 64)
            }
            // 2 ** 32
            if or(gt(x, 4294967296), eq(x, 4294967296)){
                x := shr(32, x)
                n := add(n, 32)
            }
            // 2 ** 16
            if or(gt(x, 65536), eq(x, 65536)){
                x := shr(16, x)
                n := add(n, 16)
            }
            // 2 ** 8
            if or(gt(x, 256), eq(x, 256)){
                x := shr(8, x)
                n := add(n, 8)
            }
            // 2 ** 4
            if or(gt(x, 16), eq(x, 16)){
                x := shr(4, x)
                n := add(n, 4)
            }
            // 2 ** 2
            if or(gt(x, 4), eq(x, 4)){
                x := shr(2, x)
                n := add(n, 2)
            }
            // 2 ** 1
            if or(gt(x, 2), eq(x, 2)){
                n := add(n, 1)
            }
        }
    }
}
