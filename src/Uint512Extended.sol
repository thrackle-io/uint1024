// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "src/Uint512.sol";

/**
 * @title Uint512 Extended Math Library
 * @author  @oscarsernarosero @mpetersoCode55 @cirsteve
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
        return x1 > y1 || x1 == y1 && x0 > y0;
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
    function div512ByPowerOf2(uint256 a0, uint256 a1, uint8 n) internal pure returns(uint256 r0, uint256 r1, uint256 remainder){
        if(n == 0) revert("n must be greater than 0");
        uint _2ToTheNth = 2**n;
        uint shiftedBits = a1 & (_2ToTheNth - 1);
        remainder = a0 & (_2ToTheNth - 1);
        r1 = a1 >> n;
        r0 = (shiftedBits << (256 - n)) | a0 >> n;
    }
}