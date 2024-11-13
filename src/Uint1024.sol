// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "src/Uint512.sol";
import "src/Uint512Extended.sol";
import "forge-std/console2.sol";

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
     * @notice Calculates the product of a uint512 and uint256. The result is a uint768.
     * @dev Used the chinese remainder theoreme
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
     * @notice Calculates the product of two uint512. The result is a uint1024.
     * @dev Used the chinese remainder theoreme
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
     * @dev Calculates the product of two uint512 modulo 512. The result is a uint512.
     * @notice Used the chinese remainder theoreme
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
        uint a2,
        uint8 n
    ) internal pure returns (uint256 r0, uint256 r1, uint r2, uint256 remainder) {
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
     * @dev Calculates *a* modulo *b* where *a* is a 768-bit unsigned integer and *b* is a uint256.
     * @param a0 A uint256 representing the low bits of *a*
     * @param a1 A uint256 representing the middle bits of *a*
     * @param a2 A uint256 representing the high bits of *a*
     * @param b A uint256 representing the base of the modulo
     * @return rem the modulo of a%b
     */
    function mod768x256(uint a0, uint a1, uint a2, uint b) internal pure returns (uint rem) {
        uint rem_a2x256;
        uint rem_a2x512;
        assembly {
            // (a2*2**512)%b
            rem_a2x256 := mulmod(a2, not(0), b) // (a2*(2**256 - 1))%b
            rem_a2x256 := addmod(rem, a2, b) // (a2*(2**256 - 1) + a2)%b = (a2*(2**256))%b
            rem_a2x512 := mulmod(rem_a2x256, not(0), b) // (a2*(2**256)*(2**256 - 1))%b = (a2*2**512 - a2*2**256)%b
            rem_a2x512 := addmod(rem_a2x512, sub(0, rem_a2x256), b) // (a2*2**512 - a2*2**256 - a2*(2**256))%b
        }
        // (a1*2**256 + a0)%b
        rem = a0.mod512x256(a1, b);
        // (a2*2**512 + a1*2**256 + a0)%b
        assembly {
            rem := addmod(rem, rem_a2x512, b)
        }
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
     * @notice Checks the minuend(a0-a2) is greater than the right operand(b0-b2)
     * @dev Used as an underflow/negative result indicator for subtraction methods
     * @param a0 A uint256 representing the lower bits of the minuend
     * @param a1 A uint256 representing the high bits of the minuend
     * @param a2 A uint256 representing the higher bits of the minuend
     * @param b0 A uint256 representing the lower bits of the subtrahend
     * @param b1 A uint256 representing the high bits of the subtrahend
     * @param b2 A uint256 representing the higher bits of the subtrahend
     * @return Returns true if there would be an underflow/negative result
     */
    function lt768(uint256 a0, uint256 a1, uint256 a2, uint256 b0, uint256 b1, uint256 b2) internal pure returns (bool) {
        return a2 < b2 || (a2 == b2 && (a1 < b1 || (a1 == b1 && a0 < b0)));
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
}
