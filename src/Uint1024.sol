// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "src/Uint512.sol";

library Uint1024 {
  using Uint512 for uint256;

  function add768x768(
    uint a0,
    uint a1,
    uint a2,
    uint b0,
    uint b1,
    uint b2
  ) internal pure returns (uint r0, uint r1, uint r2) {
    assembly {
      r0 := add(a0, b0)
      r1 := add(add(a1, b1), lt(r0, b0))
      r2 := add(add(a2, b2), lt(r1, b1))
      if lt(r2, b2) {
        let ptr := mload(0x40) // Get free memory pointer
        mstore(
          ptr,
          0x08c379a000000000000000000000000000000000000000000000000000000000
        ) // Selector for method Error(string)
        mstore(add(ptr, 0x04), 0x20) // String offset
        mstore(add(ptr, 0x24), 30) // Revert reason length
        mstore(add(ptr, 0x44), "add768 overflow")
        revert(ptr, 0x64) // Revert data length is 4 bytes for selector and 3 slots of 0x20 bytes
      }
    }
  }

  function sub768x768(
    uint a0,
    uint a1,
    uint a2,
    uint b0,
    uint b1,
    uint b2
  ) internal pure returns (uint r0, uint r1, uint r2) {
    if (lt768(a0, a1, a2, b0, b1, b2))
      revert("Uint768: negative result sub768x768");
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

  function mul512x256In768(
    uint a0,
    uint a1,
    uint b
  ) internal pure returns (uint r0, uint r1, uint r2) {
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

  function mul512x512In1024(
    uint a0,
    uint a1,
    uint b0,
    uint b1
  ) internal pure returns (uint r0, uint r1, uint r2, uint r3) {
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

  function div512x256In512(
    uint256 a0,
    uint256 a1,
    uint256 b
  ) internal pure returns (uint256 r0, uint r1) {
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
    uint inv = mulInverseMod256(b);

    assembly {
      r0 := mul(a0, inv)
    }
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

  function mulInverseMod512(
    uint b0,
    uint b1
  ) internal pure returns (uint inv0, uint inv1) {
    (uint bx3Lo, uint bx3Hi) = b0.mul512x256(b1, 3);
    inv1 = bx3Hi;
    assembly {
      // Calculate the multiplicative inverse mod 2**256 of b. See the paper for details.
      //slither-disable-next-line incorrect-exp
      inv0 := xor(bx3Lo, 2) // 4
      // slither-disable-end divide-before-multiply
    }
    uint two = 2;
    uint iterimLo;
    uint iterimHi;
    (iterimLo, iterimHi, , ) = mul512x512In1024(b0, b1, inv0, inv1);
    (iterimLo, iterimHi) = two.sub512x512(0, iterimLo, iterimHi);
    (inv0, inv1, , ) = mul512x512In1024(inv0, inv1, iterimLo, iterimHi); // 8
    (iterimLo, iterimHi, , ) = mul512x512In1024(b0, b1, inv0, inv1);
    (iterimLo, iterimHi) = two.sub512x512(0, iterimLo, iterimHi);
    (inv0, inv1, , ) = mul512x512In1024(inv0, inv1, iterimLo, iterimHi); // 16
    (iterimLo, iterimHi, , ) = mul512x512In1024(b0, b1, inv0, inv1);
    (iterimLo, iterimHi) = two.sub512x512(0, iterimLo, iterimHi);
    (inv0, inv1, , ) = mul512x512In1024(inv0, inv1, iterimLo, iterimHi); // 32
    (iterimLo, iterimHi, , ) = mul512x512In1024(b0, b1, inv0, inv1);
    (iterimLo, iterimHi) = two.sub512x512(0, iterimLo, iterimHi);
    (inv0, inv1, , ) = mul512x512In1024(inv0, inv1, iterimLo, iterimHi); // 64
    (iterimLo, iterimHi, , ) = mul512x512In1024(b0, b1, inv0, inv1);
    (iterimLo, iterimHi) = two.sub512x512(0, iterimLo, iterimHi);
    (inv0, inv1, , ) = mul512x512In1024(inv0, inv1, iterimLo, iterimHi); // 128
    (iterimLo, iterimHi, , ) = mul512x512In1024(b0, b1, inv0, inv1);
    (iterimLo, iterimHi) = two.sub512x512(0, iterimLo, iterimHi);
    (inv0, inv1, , ) = mul512x512In1024(inv0, inv1, iterimLo, iterimHi); // 256
    (iterimLo, iterimHi, , ) = mul512x512In1024(b0, b1, inv0, inv1);
    (iterimLo, iterimHi) = two.sub512x512(0, iterimLo, iterimHi);
    (inv0, inv1, , ) = mul512x512In1024(inv0, inv1, iterimLo, iterimHi); // 512
  }

  function lt768(
    uint a0,
    uint a1,
    uint a2,
    uint b0,
    uint b1,
    uint b2
  ) internal pure returns (bool) {
    return
      a2 < b2 || (a2 == b2 && a1 < b1) || (a2 == b2 && a1 == b1 && a0 < b0);
  }
}
