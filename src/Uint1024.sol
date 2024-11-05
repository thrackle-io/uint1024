// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "src/Uint512.sol";
import "src/Uint512Extended.sol";

library Uint1024 {
    using Uint512 for uint256;
    using Uint512Extended for uint256;

    /**
     * @notice Calculates the sum of two uint768. The result is a uint768.
     * @param a0 A uint256 representing the lower bits of the first addend
     * @param a1 A uint256 representing the higher bits of the first addend
     * @param a2 A uint256 representing the highest bits of the first addend
     * @param b0 A uint256 representing the lower bits of the seccond addend
     * @param b1 A uint256 representing the higher bits of the seccond addend
     * @param b2 A uint256 representing the highest bits of the seccond addend
     * @return r0 The lower bits of the result
     * @return r1 The higher bits of the result
     * @return r2 The highest bits of the result
     */
    function add768x768(uint a0, uint a1, uint a2, uint b0, uint b1, uint b2) internal pure returns (uint r0, uint r1, uint r2) {
        assembly {
            r0 := add(a0, b0)
            let carryoverA := lt(r0, b0)
            r1 := add(a1, b1)
            let carryoverB := lt(r1, b1)
            r1 := add(r1, carryoverA)
            carryoverB := or(carryoverB, lt(r1, carryoverA))
            r2 := add(a2, b2)
            carryoverA := lt(r2, b2)
            r2 := add(r2, carryoverB)
            if carryoverA {
                let ptr := mload(0x40) // Get free memory pointer
                mstore(ptr, 0x08c379a000000000000000000000000000000000000000000000000000000000) // Selector for method Error(string)
                mstore(add(ptr, 0x04), 0x20) // String offset
                mstore(add(ptr, 0x24), 15) // Revert reason length
                mstore(add(ptr, 0x44), "add768 overflow")
                revert(ptr, 0x64) // Revert data length is 4 bytes for selector and 3 slots of 0x20 bytes
            }
        }
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
    function sub768x768(uint a0, uint a1, uint a2, uint b0, uint b1, uint b2) internal pure returns (uint r0, uint r1, uint r2) {
        if (lt768(a0, a1, a2, b0, b1, b2)) revert("Uint768: negative result sub768x768");
        
        assembly {
            if or(lt(b0, a0), eq(b0, a0)) {
                r0 := sub(a0, b0)
            }
            if gt(b0, a0) {
                r0 := add(a0, sub(0, b0))
                if iszero(a1) {
                    a2 := sub(a2, 1)
                }
                a1 := sub(a1, 1)
            }
            let condition := or(lt(b1, a1), eq(b1, a1))
            switch condition
            case 0 {
                r1 := add(a1, sub(0, b1))
                a2 := sub(a2, 1)
            }
            case 1 {
                r1 := sub(a1, b1)
            }
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
    function mul512x256In768(uint a0, uint a1, uint b) internal pure returns (uint r0, uint r1, uint r2) {
        (uint r0Lo, uint r0Hi) = a0.mul256x256(b);
        (uint r1Lo, uint r1Hi) = a1.mul256x256(b);
        r0 = r0Lo;
        assembly {
            r1 := add(r0Hi, r1Lo)
            if lt(r1, r0Hi) {
                r2 := 1
            }
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
    function mul512x512In1024(uint a0, uint a1, uint b0, uint b1) internal pure returns (uint r0, uint r1, uint r2, uint r3) {
        uint r0Hi;
        (r0, r0Hi) = a0.mul256x256(b0);
        (uint r1Lo, uint r1Hi) = a1.mul256x256(b0);
        (uint r2Lo, uint r2Hi) = a0.mul256x256(b1);
        (uint r3Lo, uint r3Hi) = a1.mul256x256(b1);
        assembly {
            /// r1
            let sumA := add(r0Hi, r1Lo)
            r1 := add(sumA, r2Lo)
            let overflowA := lt(sumA, r0Hi)
            let overflowB := lt(r1, sumA)
            /// r2
            sumA := add(r1Hi, r2Hi)
            r2 := add(add(add(sumA, r3Lo), overflowA), overflowB)
            overflowA := lt(sumA, r1Hi)
            overflowB := lt(r2, sumA)
            /// r3
            r3 := add(add(r3Hi, overflowA), overflowB)
        }
    }

    function mul512x512Mod512(uint a0, uint a1, uint b0, uint b1) internal pure returns (uint r0, uint r1) {
        uint r0Hi;
        (r0, r0Hi) = a0.mul256x256(b0);
        (uint r1Lo, ) = a1.mul256x256(b0);
        (uint r2Lo, ) = a0.mul256x256(b1);
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
    function div512x256In512(uint256 a0, uint256 a1, uint256 b) internal pure returns (uint256 r0, uint r1) {
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
        uint inv = b.mulInverseMod256();

        assembly {
            r0 := mul(a0, inv)
        }
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
        uint two = 2;
        uint interimLo;
        uint interimHi;

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
    function lt768(uint a0, uint a1, uint a2, uint b0, uint b1, uint b2) internal pure returns (bool) {
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
    function lt1024(uint a0, uint a1, uint a2, uint256 a3, uint b0, uint b1, uint b2, uint256 b3) internal pure returns (bool) {
        return a3 < b3 || (a3 == b3 && (a2 < b2 || (a1 == b1 && a0 < b0)));
    }

    /**
     * @notice Calculates the sum of two uint1024. The result is a uint1024.
     * @param a0 A uint256 representing the lower bits of the first addend
     * @param a1 A uint256 representing the high bits of the first addend
     * @param a2 A uint256 representing the higher bits of the first addend
     * @param a3 A uint256 representing the highest bits of the first addend
     * @param b0 A uint256 representing the lower bits of the seccond addend
     * @param b1 A uint256 representing the high bits of the seccond addend
     * @param b2 A uint256 representing the higher bits of the seccond addend
     * @param b3 A uint256 representing the highest bits of the seccond addend
     * @return r0 The lower bits of the result
     * @return r1 The high bits of the result
     * @return r2 The higher bits of the result
     * @return r3 The highest bits of the result
     */
    function add1024x1024(uint256 a0, uint256 a1, uint256 a2, uint256 a3, uint256 b0, uint256 b1, uint256 b2, uint256 b3) internal pure returns (uint256 r0, uint256 r1, uint256 r2, uint256 r3) {
        assembly {
            r0 := add(a0, b0)
            let carryoverA := lt(r0, b0)
            r1 := add(a1, b1)
            let carryoverB := lt(r1, b1)
            r1 := add(r1, carryoverA)
            carryoverB := or(carryoverB, lt(r1, carryoverA))
            r2 := add(a2, b2)
            carryoverA := lt(r2, b2)
            r2 := add(r2, carryoverB)
            carryoverA := or(carryoverA, lt(r2, carryoverB))
            r3 := add(a3, b3)
            carryoverB := lt(r3, b3)
            r3 := add(r3, carryoverA)
            carryoverB := or(carryoverB, lt(r3, carryoverA))
            if carryoverB {
                let ptr := mload(0x40) // Get free memory pointer
                mstore(ptr, 0x08c379a000000000000000000000000000000000000000000000000000000000) // Selector for method Error(string)
                mstore(add(ptr, 0x04), 0x20) // String offset
                mstore(add(ptr, 0x24), 16) // Revert reason length
                mstore(add(ptr, 0x44), "add1024 overflow")
                revert(ptr, 0x64) // Revert data length is 4 bytes for selector and 3 slots of 0x20 bytes
            }
        }
    }
    

    /**
     * @notice Calculates the difference of two uint1024. The result is a uint1024.
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
    function sub1024x1024(uint a0, uint a1, uint a2, uint256 a3, uint b0, uint b1, uint b2, uint256 b3) internal pure returns (uint r0, uint r1, uint r2, uint256 r3) {
        if (lt1024(a0, a1, a2, a3, b0, b1, b2, b3)) revert("Uint1024: negative result sub1024x1024");
        assembly {
            if or(lt(b0, a0), eq(b0, a0)) {
                r0 := sub(a0, b0)
            }
            if gt(b0, a0) {
                r0 := add(a0, sub(0, b0))
                if iszero(a1) {
                    if iszero(a2) {
                        a3 := sub(a3, 1)
                    }
                    a2 := sub(a2, 1)
                }
                a1 := sub(a1, 1)
            }
            let condition := or(lt(b1, a1), eq(b1, a1))
            switch condition
            case 0 {
                r1 := add(a1, sub(0, b1))
                if iszero(a2) {
                    a3 := sub(a3, 1)
                }
                a2 := sub(a2, 1)
            }
            case 1 {
                r1 := sub(a1, b1)
            }
            condition := or(lt(b2, a2), eq(b2, a2))
            switch condition
            case 0 {
                r2 := add(a2, sub(0, b2))
                a3 := sub(a3, 1)
            }
            case 1 {
                r2 := sub(a2, b2)
            }
            r3 := sub(a3, b3)
        }
    }
}
