// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./Uint512.sol";
import "./Uint512Extended.sol";
import "./UintTypes.sol";

library Uint1024 {
    using Uint512 for uint256;
    using Uint512Extended for uint256;

    /**
     * @notice Calculates the sum of two uint768. The result is a uint768.
     * @param a0 A uint256 representing the lower bits of the first addend
     * @param a1 A uint256 representing the higher bits of the first addend
     * @param a2 A uint256 representing the highest bits of the first addend
     * @param b0 A uint256 representing the lower bits of the second addend
     * @param b1 A uint256 representing the higher bits of the second addend
     * @param b2 A uint256 representing the highest bits of the second addend
     * @return r0 The lower bits of the result
     * @return r1 The higher bits of the result
     * @return r2 The highest bits of the result
     */
    function add768x768(
        uint256 a0,
        uint256 a1,
        uint256 a2,
        uint256 b0,
        uint256 b1,
        uint256 b2
    ) internal pure returns (uint256 r0, uint256 r1, uint256 r2) {
        // Initialize the carryover check here so we can check outside of the assembly block
        uint256 carryoverA;
        assembly {
            // Add the lowest bits together
            r0 := add(a0, b0)
            // Check if the lower bits have a carryover
            carryoverA := lt(r0, b0)
            // Add the higher bits together
            r1 := add(a1, b1)
            // Check if the higher bits have a carryover
            let carryoverB := lt(r1, b1)
            // Add the potental carryover to the higher bits of the result
            r1 := add(r1, carryoverA)
            // Check for carryover from the recalc of r1, taking into account previous carryoverB value
            carryoverB := or(carryoverB, lt(r1, carryoverA))
            // Add the highest bits together
            r2 := add(a2, b2)
            // Check if the highest bits have a carryover
            carryoverA := lt(r2, b2)
            // Add the potential carryover to the highest bits of the result
            r2 := add(r2, carryoverB)
            // Check for carryover from the recalc of r2, taking into account previous carryoverA value
            carryoverA := or(carryoverA, lt(r2, carryoverB))
        }
        // If carryoverA has some value, it indicates an overflow for some or all of the results bits
        if (carryoverA > 0) revert("Uint1024: add768 overflow");
    }

    /**
     * @notice Calculates the sum of two uint768. The result is a uint768.
     * @param a A uint768 representing the first addend
     * @param b A uint768 representing the second addend
     * @return r The result of the addition
     */
    function add768x768(uint768 memory a, uint768 memory b) internal pure returns (uint768 memory r) {
        (r._0, r._1, r._2) = add768x768(a._0, a._1, a._2, b._0, b._1, b._2);
    }

    /**
     * @notice Calculates the difference of two uint768. The result is a uint768.
     * @param a0 A uint256 representing the lower bits of the minuend
     * @param a1 A uint256 representing the higher bits of the minuend
     * @param a2 A uint256 representing the highest bits of the minuend
     * @param b0 A uint256 representing the lower bits of the subtrahend
     * @param b1 A uint256 representing the higher bits of the subtrahend
     * @param b2 A uint256 representing the highest bits of the subtrahend
     * @return r0 The lower bits of the result
     * @return r1 The higher bits of the result
     * @return r2 The highest bits of the result
     */
    function sub768x768(
        uint256 a0,
        uint256 a1,
        uint256 a2,
        uint256 b0,
        uint256 b1,
        uint256 b2
    ) internal pure returns (uint256 r0, uint256 r1, uint256 r2) {
        if (lt768(a0, a1, a2, b0, b1, b2)) revert("Uint1024: negative result sub768x768");

        assembly {
            // If b0 <= a0, find the difference of the lowest set of bits
            if or(lt(b0, a0), eq(b0, a0)) {
                r0 := sub(a0, b0)
            }
            // When b0 > a0, we'll have to borrow from a higher set of bits
            if gt(b0, a0) {
                // r0 is the sum of a0 and negative b0
                r0 := add(a0, sub(0, b0))
                // If a1 == 0, we "borrow" a bit from a2 for the next step
                if iszero(a1) {
                    a2 := sub(a2, 1)
                }
                // Subtract the extra bit from a1
                a1 := sub(a1, 1)
            }
            // set a switch condition to 1 if b1 <= a1, else set the condition to 0
            let condition := or(lt(b1, a1), eq(b1, a1))
            switch condition
            // case 0, where b1 > a1
            case 0 {
                // r1 is the sum of a1 and negative b1
                r1 := add(a1, sub(0, b1))
                a2 := sub(a2, 1)
            }
            // case 1, where b1 <= a1
            case 1 {
                // r1 is simply the difference of a1 and b1
                r1 := sub(a1, b1)
            }
            // r2 is the difference of a2 and b2
            r2 := sub(a2, b2)
        }
    }

    /**
     * @notice Calculates the difference of two Uint768. The result is a Uint768.
     * @param a A uint768 representing the minuend
     * @param b A uint768 representing the subtrahend
     * @return r The 768 result of the subtraction
     */
    function sub768x768(uint768 memory a, uint768 memory b) internal pure returns (uint768 memory r) {
        (r._0, r._1, r._2) = sub768x768(a._0, a._1, a._2, b._0, b._1, b._2);
    }

    /**
     * @notice Calculates the product of a uint512 and uint256. The result is a uint768.
     * @dev Used the chinese remainder theorem
     * @param a0 A uint256 representing the lower bits of the first factor
     * @param a1 A uint256 representing the higher bits of the first factor
     * @param b A uint256 representing the second factor
     * @return r0 The lower bits of the result
     * @return r1 The higher bits of the result
     * @return r2 The highest bits of the result
     */
    function mul512x256In768(uint256 a0, uint256 a1, uint256 b) internal pure returns (uint256 r0, uint256 r1, uint256 r2) {
        // Get the low and high bits of r0
        (uint256 r0Lo, uint256 r0Hi) = a0.mul256x256(b);
        // Get the low and high bits of r1
        (uint256 r1Lo, uint256 r1Hi) = a1.mul256x256(b);
        // r0 is equal to the lowest bits of a0 * b
        r0 = r0Lo;
        assembly {
            // r1 is equal to the sum of the higher bits of a0 * b and the lower bits of a1 * b
            r1 := add(r0Hi, r1Lo)
            // If r1 < r0Hi, there was a phantom overflow
            if lt(r1, r0Hi) {
                // Account for the overflow
                r2 := 1
            }
            // r2 is equal to the higher bits of a1 * b
            r2 := add(r2, r1Hi)
        }
    }

    /**
     * @notice Calculates the product of a uint512 and uint256. The result is a uint768.
     * @dev Used the chinese remainder theorem
     * @param a A uint512 representing the first factor
     * @param b A uint256 representing the second factor
     * @return r The result of the multiplication
     */
    function mul512x256In768(uint512 memory a, uint256 b) internal pure returns (uint768 memory r) {
        (r._0, r._1, r._2) = mul512x256In768(a._0, a._1, b);
    }

    /**
     * @notice Calculates the product of a uint768 and uint256. The result is a uint1024.
     * @dev Used the chinese remainder theorem
     * @param a0 A uint256 representing the lower bits of the first factor
     * @param a1 A uint256 representing the middle bits of the first factor
     * @param a2 A uint256 representing the higher bits of the first factor
     * @param b A uint256 representing the second factor
     * @return r0 The lowest bits of the result
     * @return r1 The middle-lower bits of the result
     * @return r2 The middle-higher bits of the result
     * @return r3 The highest bits of the result
     */
    function mul768x256In1024(
        uint256 a0,
        uint256 a1,
        uint256 a2,
        uint256 b
    ) internal pure returns (uint256 r0, uint256 r1, uint256 r2, uint r3) {
        // Get the low and high bits of r0
        (uint256 r0Lo, uint256 r0Hi) = a0.mul256x256(b);
        // Get the low and high bits of r1
        (uint256 r1Lo, uint256 r1Hi) = a1.mul256x256(b);
        // Get the low and high bits of r2
        (uint256 r2Lo, uint256 r2Hi) = a2.mul256x256(b);
        // r0 is equal to the lowest bits of a0 * b
        r0 = r0Lo;
        assembly {
            // r1 is equal to the sum of the higher bits of a0 * b and the lower bits of a1 * b
            r1 := add(r0Hi, r1Lo)
            // If r1 < r0Hi, there was a phantom overflow
            if lt(r1, r0Hi) {
                // Account for the overflow
                r2 := 1
            }
            // we first add the higher bits of a1 * b plus the overflow to get initial r2
            r2 := add(r2, r1Hi)
            if lt(r2, r1Hi) {
                // Account for the overflow
                r3 := 1
            }
            // now, r2 would be equal to higher bits of a1 * b plus the overflow and the lower bits of a2 * b
            r2 := add(r2, r2Lo)
            if lt(r2, r2Lo) {
                // Account for the overflow
                r3 := 1
            }
            // r3 is equal to the higher bits of a2 * b plus the overflow
            r3 := add(r3, r2Hi)
        }
    }

    /**
     * @notice Calculates the product of a uint768 and uint256. The result is a uint1024.
     * @dev Used the chinese remainder theorem
     * @param a A uint768 representing the first factor
     * @param b A uint256 representing the second factor
     * @return r The result of the multiplication
     */
    function mul768x256In1024(uint768 memory a, uint256 b) internal pure returns (uint1024 memory r) {
        (r._0, r._1, r._2, r._3) = mul768x256In1024(a._0, a._1, a._2, b);
    }

    /**
     * @notice Calculates the product of two uint512. The result is a uint1024.
     * @dev Used the chinese remainder theorem
     * @param a0 A uint256 representing the lower bits of the first factor
     * @param a1 A uint256 representing the higher bits of the first factor
     * @param b0 A uint256 representing the lower bits of the second factor
     * @param b1 A uint256 representing the higher bits of the second factor
     * @return r0 The lower bits of the result
     * @return r1 The high bits of the result
     * @return r2 The higher bits of the result
     * @return r3 The highest bits of the result
     */
    function mul512x512In1024(
        uint256 a0,
        uint256 a1,
        uint256 b0,
        uint256 b1
    ) internal pure returns (uint256 r0, uint256 r1, uint256 r2, uint256 r3) {
        uint256 r0Hi;
        // Get the low and high bits of r0
        (r0, r0Hi) = a0.mul256x256(b0);
        // Get the low and high bits of r1
        (uint256 r1Lo, uint256 r1Hi) = a1.mul256x256(b0);
        // Get the low and high bits of r2
        (uint256 r2Lo, uint256 r2Hi) = a0.mul256x256(b1);
        // Get the low and high bits of r3
        (uint256 r3Lo, uint256 r3Hi) = a1.mul256x256(b1);
        assembly {
            /// r1
            let sumA := add(r0Hi, r1Lo)
            r1 := add(sumA, r2Lo)
            let overflowA := lt(sumA, r0Hi)
            let overflowB := lt(r1, sumA)
            /// r2
            sumA := add(r1Hi, r2Hi)
            let sumB := add(sumA, r3Lo)
            let overflowC := lt(sumB, sumA)
            r2 := add(add(sumB, overflowA), overflowB)
            overflowA := lt(sumA, r1Hi)
            overflowB := lt(r2, sumB)
            /// r3
            r3 := add(add(add(r3Hi, overflowA), overflowB), overflowC)
        }
    }

    /**
     * @notice Calculates the product of two uint512. The result is a uint1024.
     * @dev Used the chinese remainder theorem
     * @param a A uint512 representing the first factor
     * @param b A uint512 representing the second factor
     * @return r The result of the multiplication
     */
    function mul512x512In1024(uint512 memory a, uint512 memory b) internal pure returns (uint1024 memory r) {
        (r._0, r._1, r._2, r._3) = mul512x512In1024(a._0, a._1, b._0, b._1);
    }

    /**
     * @dev Calculates the product of two uint512 modulo 512. The result is a uint512.
     * @notice Used the chinese remainder theorem
     * @param a0 A uint256 representing the lower bits of the first factor
     * @param a1 A uint256 representing the higher bits of the first factor
     * @param b0 A uint256 representing the lower bits of the second factor
     * @param b1 A uint256 representing the higher bits of the second factor
     * @return r0 The lower bits of the result
     * @return r1 The high bits of the result
     */
    function mul512x512Mod512(uint a0, uint a1, uint b0, uint b1) internal pure returns (uint r0, uint r1) {
        uint r0Hi;
        (r0, r0Hi) = a0.mul256x256(b0);
        // slither-disable-start unused-return --> the modulo 512 doesn't care of the upper bits because they are not part of the result
        (uint256 r1Lo, ) = a1.mul256x256(b0);
        (uint256 r2Lo, ) = a0.mul256x256(b1);
        // slither-disable-end unused-return
        assembly {
            /// r1
            let sumA := add(r0Hi, r1Lo)
            r1 := add(sumA, r2Lo)
            let overflowA := lt(sumA, r0Hi)
            let overflowB := lt(r1, sumA)
        }
    }

    /**
     * @dev Calculates the product of two uint512 modulo 512. The result is a uint512.
     * @notice Used the chinese remainder theorem
     * @param a A uint512 representing the first factor
     * @param b A uint512 representing the second factor
     * @return r The result of the multiplication mod512
     */
    function mul512x512Mod512(uint512 memory a, uint512 memory b) internal pure returns (uint512 memory r) {
        (r._0, r._1) = mul512x512Mod512(a._0, a._1, b._0, b._1);
    }   

    /**
     * @notice Calculates the division of a uint512 by a uint256.
     * The result will be a uint512.
     * @dev For a detailed explaination see:
     * https://www.researchgate.net/publication/235765881_Efficient_long_division_via_Montgomery_multiply
     * @param a0 A uint256 representing the low bits of the nominator
     * @param a1 A uint256 representing the high bits of the nominator
     * @param b A uint256 representing the denominator
     * @return r0 The lower bits of the result
     * @return r1 The higher bits of the result
     */
    function div512x256In512(uint256 a0, uint256 a1, uint256 b) internal pure returns (uint256 r0, uint256 r1) {
        assembly {
            let remHi := mod(a1, b)
            r1 := div(sub(a1, remHi), b)
            a1 := remHi

            // calculate the remainder
            let rem := mulmod(a1, not(0), b)
            rem := addmod(rem, a1, b)
            rem := addmod(rem, a0, b)

            // subtract the remainder
            a1 := sub(a1, lt(a0, rem))
            a0 := sub(a0, rem)

            // The integer space mod 2**256 is not an abilian group on the multiplication operation. In fact the
            // multiplicative inserve only exists for odd numbers. The denominator gets shifted right until the
            // least significant bit is 1. To do this we find the biggest power of 2 that devides the denominator.
            let pow := and(sub(0, b), b)
            // slither-disable-start divide-before-multiply
            b := div(b, pow)

            // Also shift the nominator. We only shift a0 and the lower bits of a1 which are transfered into a0
            // by the shift operation. a1 no longer required for the calculation. This might sound odd, but in
            // fact under the conditions that r < 2**255 and a / b = (r * a) + rem with rem = 0 the value of a1
            // is uniquely identified. Thus the value is not needed for the calculation.
            a0 := div(a0, pow)
            pow := add(div(sub(0, pow), pow), 1)
            a0 := or(a0, mul(a1, pow))
        }
        uint256 inv = b.mulInverseMod256();

        assembly {
            r0 := mul(a0, inv)
        }
        // slither-disable-end divide-before-multiply
    }

    /**
     * @notice Calculates the division of a uint512 by a uint256.
     * The result will be a uint512.
     * @param a A uint512 representing the nominator
     * @param b A uint256 representing the denominator
     * @return r The result of the division
     */
    function div512x256In512(uint512 memory a, uint256 b) internal pure returns (uint512 memory r) {
        (r._0, r._1) = div512x256In512(a._0, a._1, b);
    } 

    /**
     * @dev Calculates the division of a uint768 by a uint256. The result is a uint768.
     * @notice Used long division
     * @param a0 A uint256 representing the lower bits of the first factor
     * @param a1 A uint256 representing the middle bits of the first factor
     * @param a2 A uint256 representing the higher bits of the first factor
     * @param b A uint256 representing the divisor
     * @return r0 The lower bits of the result
     * @return r1 The middle bits of the result
     * @return r2 The higher bits of the result
     */
    function div768x256(uint256 a0, uint256 a1, uint256 a2, uint256 b) internal pure returns (uint256 r0, uint r1, uint r2) {
        assembly {
            let remHi := mod(a2, b)
            r2 := div(sub(a2, remHi), b)
            a2 := remHi
        }
        uint rem = a1.mod512x256(a2, b);
        r1 = a1.divRem512x256(a2, b, rem);
        r0 = a0.safeDiv512x256(rem, b);
    }

    /**
     * @dev Calculates the division of a uint768 by a uint256. The result is a uint768.
     * @notice Used long division
     * @param a A uint768 representing the first factor
     * @param b A uint256 representing the divisor
     * @return r The result of the division
     */
    function div768x256(uint768 memory a, uint256 b) internal pure returns (uint768 memory r) {
        (r._0, r._1, r._2) = div768x256(a._0, a._1, a._2, b);
    }

    /**
     * @dev Calculates the division of a 768-bit dividend by a 512-bit divisor. The result will be a uint512.
     * @param a A uint768 representing the numerator
     * @param b A uint512 representing the denominator
     * @return result uint512 value
     */
    function div768x512(uint768 memory a, uint512 memory b) internal pure returns (uint512 memory result) {
        uint bMod2N;
        (result, bMod2N) = _aproxDiv768x512(a, b);
        (uint condition0, uint condition1, uint condition2, uint condition3) = mul512x512In1024(result._0, result._1, b._0, b._1);
        if (condition3 > 0 || gt768(condition0, condition1, condition2, a._0, a._1, a._2)) {
            // slither-disable-next-line uninitialized-local // aNew1024 is initialized in the next line
            uint1024 memory aNew1024;
            (aNew1024._0, aNew1024._1, aNew1024._2, aNew1024._3) = mul512x512In1024(result._0, result._1, b._0, b._1);
            aNew1024 = sub1024x1024(aNew1024, uint1024(a._0, a._1, a._2, 0));
            uint768 memory aNew = uint768(aNew1024._0, aNew1024._1, aNew1024._2);
            uint512 memory rec = div768x512(aNew, b);
            (result._0, result._1) = result._0.sub512x512(result._1, rec._0, rec._1);
            (result._0, result._1) = result._0.sub512x512(result._1, 1, 0);
        }
    }

    /**
     * @dev Calculates the aproximation of the division of a 768-bit dividend by a 512-bit divisor. The result will be a uint512.
     * @notice this is a private helper function. It also returns some helper values to make the division exact.
     * @param a A uint768 representing the numerator
     * @param b A uint512 representing the denominator
     * @return aproxResult the approximation of a/b
     * @return bMod2N the remainder of b/2^n where n is the number of bits of the most significant b's word
     */
    function _aproxDiv768x512(uint768 memory a, uint512 memory b) private pure returns (uint512 memory aproxResult, uint bMod2N) {
        if (b._1 == 0) revert("Uint512Extended: div768x512 b1 can't be zero");
        if (a._2 == 0 && a._0.lt512(a._1, b._0, b._1)) return (uint512(0, 0), 0);
        uint bShifted;
        uint _bMod2N;
        uint768 memory aShifted;
        if (b._1 >> 255 == 1) (bShifted, _bMod2N,  aShifted) = (b._1, b._0, uint768(a._1, a._2, 0));
        else (bShifted, _bMod2N,  aShifted) = getShiftedBitsDiv768x512(a, b);
        uint rem = aShifted._1.mod512x256(aShifted._2, bShifted);
        aproxResult._1 = aShifted._1.divRem512x256(aShifted._2, bShifted, rem);
        aproxResult._0 = aShifted._0.safeDiv512x256(rem, bShifted);
        bMod2N = _bMod2N;
    }

    /**
     * @dev returns a and b shifted to the right by the amount of bits necessary to make b a uint256 value
     * @notice this is a private helper function.
     * @param a A uint768 representing the numerator
     * @param b A uint512 representing the denominator
     * @return bShifted the denominator shifted to the right by n bits
     * @return bMod2N the remainder of b / 2**n
     * @return aShifted the numerator shifted to the right by n bits
     */
    function getShiftedBitsDiv768x512(
        uint768 memory a,
        uint512 memory b
    ) private pure returns (uint bShifted, uint bMod2N, uint768 memory aShifted) {
        /// we find the amount of bits we need to shift in the higher bits of the denominator for it to be 0
        uint n = b._1.log2() + 1;
        /// d = 2**n;
        /// if b = c * d + e, where e = k * (c * d) then b = c * d * ( 1 + e / (c * d))
        uint overflowVal;
        (bShifted, overflowVal, bMod2N) = b._0.div512ByPowerOf2(b._1, uint8(n));
        if (overflowVal > 0) revert("div512x512: unsuccessful division by 2**n");
        /// if b = c * d * ( 1 + e / (c * d)) then a / b = (( a / d) / c) / (1 + e / (c * d)) where e / (c * d) is neglegibly small
        /// making the whole term close to 1 and therefore an unnecessary step which yields a final computation of a / b = (a / d) / c
        /// a / d
        (aShifted._0, aShifted._1, aShifted._2, ) = div768ByPowerOf2(a._0, a._1, a._2, uint8(n));
    }

    /**
     * @dev Calculates the division of a uint1024 by a uint256. The result is a uint1024.
     * @notice Used long division
     * @param a0 A uint256 representing the lowest bits of the first factor
     * @param a1 A uint256 representing the middle-lower bits of the first factor
     * @param a2 A uint256 representing the middle-higher bits of the first factor
     * @param a3 A uint256 representing the highest bits of the first factor
     * @param b A uint256 representing the divisor
     * @return r0 The lowest bits of the result
     * @return r1 The middle-lower bits of the result
     * @return r2 The middle-higher bits of the result
     * @return r3 The highest bits of the result
     */
    function div1024x256(
        uint256 a0,
        uint256 a1,
        uint256 a2,
        uint256 a3,
        uint256 b
    ) internal pure returns (uint256 r0, uint r1, uint r2, uint r3) {
        uint rem3;
        assembly {
            rem3 := mod(a3, b)
            r3 := div(sub(a3, rem3), b)
        }
        uint rem2 = a2.mod512x256(rem3, b);
        r2 = a2.divRem512x256(rem3, b, rem2);
        uint rem1 = a1.mod512x256(rem2, b);
        r1 = a1.divRem512x256(rem2, b, rem1);
        r0 = a0.safeDiv512x256(rem1, b);
    }

    /**
     * @dev Calculates the division of a uint1024 by a uint256. The result is a uint1024.
     * @notice Used long division
     * @param a A uint1024 representing the first factor
     * @param b A uint256 representing the divisor
     * @return r The result of the division
     */
    function div1024x256(uint1024 memory a, uint256 b) internal pure returns (uint1024 memory r) {
        (r._0, r._1, r._2, r._3) = div1024x256(a._0, a._1, a._2, a._3, b);
    }

    /**
     * @dev Calculates the division of a 768-bit unsigned integer by a denominator which is
     * a power of 2 less than 256.
     * @param a0 A uint256 representing the low bits of the numerator
     * @param a1 A uint256 representing the middle bits of the numerator
     * @param a2 A uint256 representing the high bits of the numerator
     * @param n the power of 2 that the division will be carried out by (demominator = 2**n).
     * @return r0 The lower bits of the result
     * @return r1 The middle bits of the result
     * @return r2 The higher bits of the result
     * @return remainder of the division
     */
    function div768ByPowerOf2(
        uint256 a0,
        uint256 a1,
        uint256 a2,
        uint8 n
    ) internal pure returns (uint256 r0, uint256 r1, uint256 r2, uint256 remainder) {
        if (n == 0) revert("n must be greater than 0");
        uint _2ToTheNth = 2 ** n;
        uint mask = _2ToTheNth - 1;
        uint shiftedBitsA2 = a2 & mask;
        uint shiftedBitsA1 = a1 & mask;
        remainder = a0 & mask;
        r2 = a2 >> n;
        r1 = (shiftedBitsA2 << (256 - n)) | (a1 >> n);
        r0 = (shiftedBitsA1 << (256 - n)) | (a0 >> n);
    }

    /**
     * @dev Calculates the division of a 768-bit unsigned integer by a denominator which is
     * a power of 2 less than 256.
     * @param a A uint768 representing the low bits of the numerator
     * @param n the power of 2 that the division will be carried out by (demominator = 2**n).
     * @return r The result of the division
     * @return rem The remainder of the division
     */
    function div768ByPowerOf2(uint768 memory a, uint8 n) internal pure returns (uint768 memory r, uint256 rem) {
        (r._0, r._1, r._2, rem) = div768ByPowerOf2(a._0, a._1, a._2, n);
    }

    /**
     * @dev Calculates *a* modulo *b* where *a* is a 768-bit unsigned integer and *b* is a uint256.
     * @param a0 A uint256 representing the low bits of *a*
     * @param a1 A uint256 representing the middle bits of *a*
     * @param a2 A uint256 representing the high bits of *a*
     * @param b A uint256 representing the base of the modulo
     * @return rem the modulo of a%b
     */
    function mod768x256(uint a0, uint a1, uint a2, uint b) internal pure returns (uint rem) {
        if (b == 0) revert("Uint1024: mod 0 undefined");
        uint rem_a2x256;
        uint rem_a2x512;
        assembly {
            // (a2*2**256)%b
            rem_a2x256 := mulmod(a2, not(0), b) // (a2*(2**256 - 1))%b
            rem_a2x256 := addmod(rem_a2x256, a2, b) // (a2*(2**256 - 1) + a2)%b = (a2*(2**256))%b
            // (a2*2**512)%b
            rem_a2x512 := mulmod(rem_a2x256, not(0), b) // (a2*(2**256)*(2**256 - 1))%b = (a2*2**512 - a2*2**256)%b
            rem_a2x512 := addmod(rem_a2x512, rem_a2x256, b) // (a2*2**512 - a2*2**256 + a2*(2**256))%b = (a2*2**512)%b
        }
        // (a1*2**256 + a0)%b
        rem = a0.mod512x256(a1, b);
        // (a2*2**512 + a1*2**256 + a0)%b
        assembly {
            rem := addmod(rem, rem_a2x512, b)
        }
    }

    /**
     * @dev Calculates *a* modulo *b* where *a* is a 768-bit unsigned integer and *b* is a uint256.
     * @param a A uint768 representing *a*
     * @param b A uint256 representing the base of the modulo
     * @return rem the modulo of a%b
     */
    function mod768x256(uint768 memory a, uint256 b) internal pure returns (uint256 rem) {
        rem = mod768x256(a._0, a._1, a._2, b);
    }

    /**
     * @dev Calculates *a* modulo *b* where *a* is a 1024-bit unsigned integer and *b* is a uint256.
     * @param a0 A uint256 representing the low bits of *a*
     * @param a1 A uint256 representing the middle bits of *a*
     * @param a2 A uint256 representing the high bits of *a*
     * @param a3 A uint256 representing the high bits of *a*
     * @param b A uint256 representing the base of the modulo
     * @return rem the modulo of a%b
     */
    function mod1024x256(uint a0, uint a1, uint a2, uint256 a3, uint b) internal pure returns (uint rem) {
        if (b == 0) revert("Uint1024: mod 0 undefined");
        uint rem_a3x256;
        uint rem_a3x512;
        uint rem_a3x768;
        assembly {
            // (a2*2**256)%b
            rem_a3x256 := mulmod(a3, not(0), b) // (a3*(2**256 - 1))%b
            rem_a3x256 := addmod(rem_a3x256, a3, b) // (a3*(2**256 - 1) + a3)%b = (a3*(2**256))%b
            // (a2*2**512)%b
            rem_a3x512 := mulmod(rem_a3x256, not(0), b) // (a3*(2**256)*(2**256 - 1))%b = (a3*2**512 - a3*2**256)%b
            rem_a3x512 := addmod(rem_a3x512, rem_a3x256, b) // (a3*2**512 - a3*2**256 + a3*(2**256))%b = (a3*2**512)%b
            // (a2*2**768)%b
            rem_a3x768 := mulmod(rem_a3x512, not(0), b) // (a3*(2**512)*(2**256 - 1))%b = (a3*2**768 - a3*2**512)%b
            rem_a3x768 := addmod(rem_a3x768, rem_a3x512, b) // (a3*2**768 - a3*2**512 + a3*(2**512))%b = (a3*2**768)%b
        }
        // (a2*2**512 + a1*2**256 + a0)%b
        rem = mod768x256(a0, a1, a2, b);

        assembly {
            rem := addmod(rem, rem_a3x768, b)
        }
    }

    /**
     * @dev Calculates *a* modulo *b* where *a* is a 1024-bit unsigned integer and *b* is a uint256.
     * @param a A uint1024 representing *a*
     * @param b A uint256 representing the base of the modulo
     * @return rem the modulo of a%b
     */
    function mod1024x256(uint1024 memory a, uint256 b) internal pure returns (uint256 rem) {
        rem = mod1024x256(a._0, a._1, a._2, a._3, b);
    }

    /**
     * @dev Calculates the division *a* / *b* where *a* is a 1024-bit unsigned integer and *b* is
     * a uint512.
     * @notice it requires to previously know the remainder of the division
     * @param a0 A uint256 representing the lowest bits of *a*
     * @param a1 A uint256 representing the mid-lower bits of *a*
     * @param a2 A uint256 representing the mid-higher bits of *a*
     * @param a3 A uint256 representing the highest bits of *a*
     * @param b0 A uint256 representing the lower bits of *b*
     * @param b1 A uint256 representing the higher bits of *b*
     * @param rem0 A uint256 representing the lower bits of the remainder of the division
     * @param rem1 A uint256 representing the higher bits of the remainder of the division
     * @return r0 The lower bits of the result
     * @return r1 The high bits of the result
     */
    function divRem1024x512In512(
        uint256 a0,
        uint256 a1,
        uint256 a2,
        uint256 a3,
        uint256 b0,
        uint256 b1,
        uint256 rem0,
        uint256 rem1
    ) internal pure returns (uint256 r0, uint r1) {
        if (b0 == 0 && b1 == 0) revert("Uint1024: division by zero");
        (a0, a1, a2, a3) = sub1024x1024(a0, a1, a2, a3, rem0, rem1, 0, 0);
        assembly {
            // The integer space mod 2**256 is not an abilian group on the multiplication operation. In fact the
            // multiplicative inserve only exists for odd numbers. The denominator gets shifted right until the
            // least significant bit is 1. To do this we find the biggest power of 2 that devides the denominator.

            // if all the lower bits of b are zero, then we simply shift the whole numbers a full word to the right,
            // and we continue with the regular shifting after this
            if iszero(b0) {
                b0 := b1
                b1 := 0
                a0 := a1
                a1 := a2
                a2 := a3
                a3 := 0
            }

            let shiftR := and(sub(0, b0), b0)
            // slither-disable-start divide-before-multiply
            b0 := div(b0, shiftR)
            let shiftL := add(div(sub(0, shiftR), shiftR), 1)
            b0 := or(b0, mul(b1, shiftL))
            b1 := div(b1, shiftR)

            // Also shift the nominator. We only shift a0 and the lower bits of a1 which are transfered into a0
            // by the shift operation. a1 no longer required for the calculation. This might sound odd, but in
            // fact under the conditions that r < 2**255 and a / b = (r * a) + rem with rem = 0 the value of a1
            // is uniquely identified. Thus the value is not needed for the calculation.
            a0 := div(a0, shiftR)
            a0 := or(a0, mul(a1, shiftL))
            a1 := div(a1, shiftR)
            a1 := or(a1, mul(a2, shiftL))
            a2 := div(a2, shiftR)
            a2 := or(a2, mul(a3, shiftL))
        }
        (uint inv0, uint inv1) = mulInverseMod512(b0, b1);

        (r0, r1) = mul512x512Mod512(a0, a1, inv0, inv1);
        // slither-disable-end divide-before-multiply
    }

    /**
     * @dev Calculates the division *a* / *b* where *a* is a 1024-bit unsigned integer and *b* is
     * a uint512.
     * @notice it requires to previously know the remainder of the division
     * @param a A uint1024 representing *a*
     * @param b A uint512 representing *b*
     * @param rem A uint512 representing the remainder of the division
     * @return r The result of the division
     */
    function divRem1024x512In512(uint1024 memory a, uint512 memory b, uint512 memory rem) internal pure returns (uint512 memory r) {
        (r._0, r._1) = divRem1024x512In512(a._0, a._1, a._2, a._3, b._0, b._1, rem._0, rem._1);
    }

    /**
     * @dev Calculates the multiplicative inverse of *b* modulo 2**512 where *b* is a uint512.
     * @notice this is a 512 implementation of the Helsen's lemma and Montgomery reduction.
     * @param b0 A uint256 representing the lower bits of *b*
     * @param b1 A uint256 representing the higher bits of *b*
     * @return inv0 The lower bits of the inverse
     * @return inv1 The higher bits of the inverse
     */
    function mulInverseMod512(uint b0, uint b1) internal pure returns (uint inv0, uint inv1) {
        if (b0 % 2 == 0) revert("Uint1024: denominator must be odd");
        (uint bx3Lo, uint bx3Hi) = b0.mul512x256(b1, 3);
        inv1 = bx3Hi;
        assembly {
            // Calculate the multiplicative inverse mod 2**256 of b. See Montgomery reduction for more details.
            //slither-disable-next-line incorrect-exp
            inv0 := xor(bx3Lo, 2) // 4
        }
        uint256 two = 2;
        uint256 interimLo;
        uint256 interimHi;

        /// expansion of the inverse with Hensel's lemma
        (interimLo, interimHi) = mul512x512Mod512(b0, b1, inv0, inv1);
        (interimLo, interimHi) = two.sub512x512(0, interimLo, interimHi);
        (inv0, inv1) = mul512x512Mod512(inv0, inv1, interimLo, interimHi); // 8

        (interimLo, interimHi) = mul512x512Mod512(b0, b1, inv0, inv1);
        (interimLo, interimHi) = two.sub512x512(0, interimLo, interimHi);
        (inv0, inv1) = mul512x512Mod512(inv0, inv1, interimLo, interimHi); // 16

        (interimLo, interimHi) = mul512x512Mod512(b0, b1, inv0, inv1);
        (interimLo, interimHi) = two.sub512x512(0, interimLo, interimHi);
        (inv0, inv1) = mul512x512Mod512(inv0, inv1, interimLo, interimHi); // 32

        (interimLo, interimHi) = mul512x512Mod512(b0, b1, inv0, inv1);
        (interimLo, interimHi) = two.sub512x512(0, interimLo, interimHi);
        (inv0, inv1) = mul512x512Mod512(inv0, inv1, interimLo, interimHi); // 64

        (interimLo, interimHi) = mul512x512Mod512(b0, b1, inv0, inv1);
        (interimLo, interimHi) = two.sub512x512(0, interimLo, interimHi);
        (inv0, inv1) = mul512x512Mod512(inv0, inv1, interimLo, interimHi); // 128

        (interimLo, interimHi) = mul512x512Mod512(b0, b1, inv0, inv1);
        (interimLo, interimHi) = two.sub512x512(0, interimLo, interimHi);
        (inv0, inv1) = mul512x512Mod512(inv0, inv1, interimLo, interimHi); // 256

        (interimLo, interimHi) = mul512x512Mod512(b0, b1, inv0, inv1);
        (interimLo, interimHi) = two.sub512x512(0, interimLo, interimHi);
        (inv0, inv1) = mul512x512Mod512(inv0, inv1, interimLo, interimHi); // 512
    }

    /**
     * @dev Calculates the multiplicative inverse of *b* modulo 2**512 where *b* is a uint512.
     * @notice this is a 512 implementation of the Helsen's lemma and Montgomery reduction.
     * @param b A uint512 representing *b*
     * @return r A uint512 representing the inverse
     */
    function mulInverseMod512(uint512 memory b) internal pure returns (uint512 memory r) {
        (r._0, r._1) = mulInverseMod512(b._0, b._1);
    }

    /**
     * @dev Checks if a < b where a and b are uint768
     * @param a0 A uint256 representing the lower bits of a
     * @param a1 A uint256 representing the high bits of a
     * @param a2 A uint256 representing the higher bits of a
     * @param b0 A uint256 representing the lower bits of b
     * @param b1 A uint256 representing the high bits of b
     * @param b2 A uint256 representing the higher bits of b
     * @return Returns true if a < b
     */
    function lt768(uint256 a0, uint256 a1, uint256 a2, uint256 b0, uint256 b1, uint256 b2) internal pure returns (bool) {
        return a2 < b2 || (a2 == b2 && (a1 < b1 || (a1 == b1 && a0 < b0)));
    }

    /**
     * @notice Checks if the left opperand is less than the right opperand
     * @param a A uint768 representing the left operand
     * @param b A uint768 representing the right operand 
     * @return Returns true if there would be an underflow/negative result
     */
    function lt768(uint768 memory a, uint768 memory b) internal pure returns (bool) {
        return lt768(a._0, a._1, a._2, b._0, b._1, b._2);
    }

    /**
     * @dev Checks if a > b where a and b are uint768
     * @param a0 A uint256 representing the lower bits of a
     * @param a1 A uint256 representing the high bits of a
     * @param a2 A uint256 representing the higher bits of a
     * @param b0 A uint256 representing the lower bits of b
     * @param b1 A uint256 representing the high bits of b
     * @param b2 A uint256 representing the higher bits of b
     * @return Returns true if a > b
     */
    function gt768(uint256 a0, uint256 a1, uint256 a2, uint256 b0, uint256 b1, uint256 b2) internal pure returns (bool) {
        return a2 > b2 || (a2 == b2 && (a1 > b1 || (a1 == b1 && a0 > b0)));
    }

    /**
     * @notice Checks if the left opperand is greater than the right opperand
     * @param a A uint768 representing the left operand
     * @param b A uint768 representing the right operand 
     * @return Returns true if there would be an overflow result
     */
    function gt768(uint768 memory a, uint768 memory b) internal pure returns (bool) {
        return gt768(a._0, a._1, a._2, b._0, b._1, b._2);
    }

    /**
     * @notice Checks the minuend(a0-a3) is greater than the right operand(b0-b3)
     * @dev Used as an underflow/negative result indicator for subtraction methods
     * @param a0 A uint256 representing the lower bits of the minuend
     * @param a1 A uint256 representing the high bits of the minuend
     * @param a2 A uint256 representing the higher bits of the minuend
     * @param a3 A uint256 representing the highest bits of the minuend
     * @param b0 A uint256 representing the lower bits of the subtrahend
     * @param b1 A uint256 representing the high bits of the subtrahend
     * @param b2 A uint256 representing the higher bits of the subtrahend
     * @param b3 A uint256 representing the highest bits of the subtrahend
     * @return Returns true if there would be an underflow/negative result
     */
    function lt1024(
        uint256 a0,
        uint256 a1,
        uint256 a2,
        uint256 a3,
        uint256 b0,
        uint256 b1,
        uint256 b2,
        uint256 b3
    ) internal pure returns (bool) {
        return a3 < b3 || (a3 == b3 && (a2 < b2 || (a2 == b2 && (a1 < b1 || (a1 == b1 && a0 < b0)))));
    }

    /**
     * @notice Checks if the left opperand is less than the right opperand
     * @param a A uint1024 representing the left operand
     * @param b A uint1024 representing the right operand 
     * @return Returns true if there would be an underflow/negative result
     */
    function lt1024(uint1024 memory a, uint1024 memory b) internal pure returns (bool) {
        return lt1024(a._0, a._1, a._2, a._3, b._0, b._1, b._2, b._3);
    }

    /**
     * @notice Calculates the sum of two Uint1024. The result is a Uint1024.
     * @param a0 A uint256 representing the lower bits of the first addend
     * @param a1 A uint256 representing the high bits of the first addend
     * @param a2 A uint256 representing the higher bits of the first addend
     * @param a3 A uint256 representing the highest bits of the first addend
     * @param b0 A uint256 representing the lower bits of the second addend
     * @param b1 A uint256 representing the high bits of the second addend
     * @param b2 A uint256 representing the higher bits of the second addend
     * @param b3 A uint256 representing the highest bits of the second addend
     * @return r0 The lower bits of the result
     * @return r1 The high bits of the result
     * @return r2 The higher bits of the result
     * @return r3 The highest bits of the result
     */
    function add1024x1024(
        uint256 a0,
        uint256 a1,
        uint256 a2,
        uint256 a3,
        uint256 b0,
        uint256 b1,
        uint256 b2,
        uint256 b3
    ) internal pure returns (uint256 r0, uint256 r1, uint256 r2, uint256 r3) {
        // Initialize the carryover check here so we can check outside of the assembly block
        uint256 carryoverB;
        assembly {
            // Add the lowest bits together
            r0 := add(a0, b0)
            // Check if the lower bits have a carryover
            let carryoverA := lt(r0, b0)
            // Add the high bits together
            r1 := add(a1, b1)
            // Check if the high bits have a carryover
            carryoverB := lt(r1, b1)
            // Add the potental carryover to the high bits of the result
            r1 := add(r1, carryoverA)
            // Check for carryover from the recalc of r1, taking into account previous carryoverB value
            carryoverB := or(carryoverB, lt(r1, carryoverA))
            // Add the higher bits together
            r2 := add(a2, b2)
            // Check if the higher bits have a carryover
            carryoverA := lt(r2, b2)
            // Add the potential carryover to the higher bits of the result
            r2 := add(r2, carryoverB)
            // Check for carryover from the recalc of r2, taking into account previous carryoverA value
            carryoverA := or(carryoverA, lt(r2, carryoverB))
            // Add the highest bits together
            r3 := add(a3, b3)
            // Check if the highest bits have a carryover
            carryoverB := lt(r3, b3)
            // Add the potential carryover to the highest bits of the result
            r3 := add(r3, carryoverA)
            // Check for carryover from the recalc of r3, taking into account previous carryoverB value
            carryoverB := or(carryoverB, lt(r3, carryoverA))
        }
        // If carryoverB has some value, it indicates an overflow for some or all of the results bits
        if (carryoverB > 0) revert("Uint1024: add1024 overflow");
    }

    /**
     * @notice Calculates the sum of two Uint1024. The result is a Uint1024.
     * @param a A uint1024 representing the one addend
     * @param b A uint1024 representing the other addend
     * @return r The 1024 result
     */
    function add1024x1024(uint1024 memory a, uint1024 memory b) internal pure returns (uint1024 memory r) {
        (r._0, r._1, r._2, r._3) = add1024x1024(a._0, a._1, a._2, a._3, b._0, b._1, b._2, b._3);
    }

    /**
     * @notice Calculates the difference of two Uint1024. The result is a Uint1024.
     * @param a0 A uint256 representing the lower bits of the minuend
     * @param a1 A uint256 representing the high bits of the minuend
     * @param a2 A uint256 representing the higher bits of the minuend
     * @param a3 A uint256 representing the highest bits of the minuend
     * @param b0 A uint256 representing the lower bits of the subtrahend
     * @param b1 A uint256 representing the high bits of the subtrahend
     * @param b2 A uint256 representing the higher bits of the subtrahend
     * @param b3 A uint256 representing the highest bits of the subtrahend
     * @return r0 The lower bits of the result
     * @return r1 The high bits of the result
     * @return r2 The higher bits of the result
     * @return r3 The highest bits of the result
     */
    function sub1024x1024(
        uint256 a0,
        uint256 a1,
        uint256 a2,
        uint256 a3,
        uint256 b0,
        uint256 b1,
        uint256 b2,
        uint256 b3
    ) internal pure returns (uint256 r0, uint256 r1, uint256 r2, uint256 r3) {
        if (lt1024(a0, a1, a2, a3, b0, b1, b2, b3)) revert("Uint1024: negative result sub1024x1024");

        assembly {
            // If b0 <= a0, find the difference of the lowest set of bits
            if or(lt(b0, a0), eq(b0, a0)) {
                r0 := sub(a0, b0)
            }
            // When b0 > a0, we'll have to borrow from a higher set of bits
            if gt(b0, a0) {
                // r0 is the difference of a0 and negative b0
                r0 := add(a0, sub(0, b0))
                // If a1 == 0, we "borrow" a bit from a2 for the next step
                if iszero(a1) {
                    if iszero(a2) {
                        a3 := sub(a3, 1)
                    }
                    a2 := sub(a2, 1)
                }
                // Subtract the extra bit from a1
                a1 := sub(a1, 1)
            }
            // set a switch condition to 1 if b1 <= a1, else set the condition to 0
            let condition := or(lt(b1, a1), eq(b1, a1))
            switch condition
            // case 0, where b1 > a1
            case 0 {
                // r1 is the sum of a1 and negative b1
                r1 := add(a1, sub(0, b1))
                // If a2 == 0, we "borrow" a bit from a3 for the next step
                if iszero(a2) {
                    a3 := sub(a3, 1)
                }
                // Subtract the extra bit from a2
                a2 := sub(a2, 1)
            }
            // case 1, where b1 <= a1
            case 1 {
                // r1 is simply the difference of a1 and b1
                r1 := sub(a1, b1)
            }
            // set a switch condition to 1 if b2 <= a2, else set the condition to 0
            condition := or(lt(b2, a2), eq(b2, a2))
            switch condition
            // case 0, where b2 > a2
            case 0 {
                // r2 is the sum of a2 and negative b2
                r2 := add(a2, sub(0, b2))
                a3 := sub(a3, 1)
            }
            // case 1, where b2 <= a2
            case 1 {
                // r2 is simply the difference of a2 and b2
                r2 := sub(a2, b2)
            }
            // r3 is the difference of a3 and b3
            r3 := sub(a3, b3)
        }
    }

    /**
     * @notice Calculates the difference of two Uint1024. The result is a Uint1024.
     * @param a A uint1024 representing the minuend
     * @param b A uint1024 representing the subtrahend
     * @return r The 1024 result
     */
    function sub1024x1024(uint1024 memory a, uint1024 memory b) internal pure returns (uint1024 memory r) {
        (r._0, r._1, r._2, r._3) = sub1024x1024(a._0, a._1, a._2, a._3, b._0, b._1, b._2, b._3);
    }
}
