/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/console2.sol";
import "forge-std/Test.sol";
import {Uint1024} from "src/Uint1024.sol";
import {Uint512} from "src/Uint512.sol";
import {Uint512Extended} from "src/Uint512Extended.sol";


/**
 * @title Utils for interacting with Python
 */
contract PythonUtils is Test {
    using Uint1024 for uint256;
    using Uint512 for uint256;
    using Uint512Extended for uint256;

    function _buildFFIDiv512x256In512(uint a0, uint a1, uint b) internal pure returns (string[] memory) {
        string[] memory inputs = new string[](5);
        inputs[0] = "python3";
        inputs[1] = "script/div_512x256_in_512.py";
        inputs[2] = vm.toString(a0);
        inputs[3] = vm.toString(a1);
        inputs[4] = vm.toString(b);
        return inputs;
    }

    /**
     * compares if 2 uints are similar enough.
     * @param x value to compare against *y*
     * @param y value to compare against *x*
     * @param maxTolerance the maximum allowed difference tolerance based on the precision
     * @param toleranceDenom the denom of the tolerance value. For instance, 10 ** 11.
     * @return withinTolerance true if the difference expressed as a normalized value is less or equal than the tolerance.
     */
    function areWithinTolerance(uint x, uint y, uint8 maxTolerance, uint256 toleranceDenom) internal pure returns (bool withinTolerance) {
        /// we calculate the absolute difference to avoid overflow/underflow
        uint diff = absoluteDiff(x, y);
        /// we calculate difference percentage as diff/(smaller number unless 0) to get the bigger difference "percentage".
        withinTolerance = true;
        if (diff != 0) {
            (uint scaledLo, uint scaledHi) = diff.mul256x256(toleranceDenom);
            (uint relativeDiff, ) = scaledLo.div512x256In512(
                scaledHi,
                x > y
                    ? y == 0
                        ? x
                        : y
                    : x == 0
                        ? y
                        : x
            );
            if (relativeDiff > maxTolerance) withinTolerance = false;
        }
    }

    /**
     * compares if 2 uints are similar enough.
     * @param x0 lower bits of x. Value to compare against *y*
     * @param x1 higher bits of x. Value to compare against *y*
     * @param y0 lower bits of y. Value to compare against *x*
     * @param y1 higher bits of y. Value to compare against *x*
     * @param maxTolerance the maximum allowed difference tolerance based on the precision
     * @param toleranceDenom the denom of the tolerance value. For instance, 10 ** 11.
     * @return true if the difference expressed as a normalized value is less or equal than the tolerance.
     */
    function areWithinTolerance512(
        uint256 x0,
        uint256 x1,
        uint256 y0,
        uint256 y1,
        uint8 maxTolerance,
        uint256 toleranceDenom
    ) internal pure returns (bool) {
        /// we calculate the absolute difference to avoid overflow/underflow
        uint diff = absoluteDiff512(x0, x1, y0, y1);
        console2.log("from absoluteDiff512");
        console2.log(diff);
        /// we calculate difference percentage as diff/(smaller number unless 0) to get the bigger difference "percentage".
        if (diff == 0) return true;
        (uint diffXTolDenomL, uint diffXTolDenomH) = diff.mul256x256(toleranceDenom);
        (uint greaterXTolNumerL, uint greaterXTolNumerH) = _getSmallerXToleranceNumerator(x0, x1, y0, y1, maxTolerance);
        console2.log("from areWithinTolerance512");
        console2.log(diffXTolDenomL, diffXTolDenomH);
        console2.log(greaterXTolNumerL, greaterXTolNumerH);
        return !(diffXTolDenomL.gt512(diffXTolDenomH, greaterXTolNumerL, greaterXTolNumerH));
    }

    /**
     * helper function for areWithinTolerance512. It gets the result for the greater between x and y multiplied by the tolerance numerator
     * @param x0 lower bits of x.
     * @param x1 higher bits of x.
     * @param y0 lower bits of y.
     * @param y1 higher bits of y.
     * @param maxTolerance the maximum allowed difference tolerance based on the precision. The numerator side
     * @return greaterXTolNumerL lower bits of the result of the greater between x and y multiplied by the tolerance numerator
     * @return greaterXTolNumerH higher bits of the result of the greater between x and y multiplied by the tolerance numerator
     */
    function _getSmallerXToleranceNumerator(
        uint256 x0,
        uint256 x1,
        uint256 y0,
        uint256 y1,
        uint8 maxTolerance
    ) internal pure returns (uint greaterXTolNumerL, uint greaterXTolNumerH) {
        bool isXgtY = x0.gt512(x1, y0, y1);
        bool dividingByX = !(isXgtY || x0.eq512(x1, 0, 0));
        (greaterXTolNumerL, greaterXTolNumerH) = dividingByX
            ? x0.mul512x256(x1, uint(maxTolerance))
            : y0.mul512x256(y1, uint(maxTolerance));
    }



    /**
     * @dev calculates the difference between 2 512 uints without risk of overflow/underflow
     * @param x0 uint lower bits of x
     * @param x1 uint higher bits of x
     * @param y0 uint lower bits of y
     * @param y1 uint higher bits of y
     * @return diff the absolute difference between *x* and *y*
     */
    function absoluteDiff512(uint x0, uint x1, uint y0, uint y1) public pure returns (uint diff) {
        uint diffH;
        if (x0.gt512(x1, y0, y1)) (diff, diffH) = x0.sub512x512(x1, y0, y1);
        else (diff, diffH) = y0.sub512x512(y1, x0, x1);
        if (diffH > 0) revert("diffGreaterThanUint256");
    }

     /**
     * @dev calculates the difference between 2 uints without risk of overflow/underflow
     * @param x uint
     * @param y uint
     * @return diff the absolute difference between *x* and *y*
     */
    function absoluteDiff(uint x, uint y) public pure returns (uint diff) {
        diff = x > y ? x - y : y - x;
    }
}