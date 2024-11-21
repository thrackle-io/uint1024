/// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/console2.sol";
import "forge-std/Test.sol";
import {Uint1024} from "../src/Uint1024.sol";
import {Uint512} from "../src/Uint512.sol";
import {Uint512Extended} from "src/Uint512Extended.sol";

/**
 * @title Utils for interacting with Python
 */
contract PythonUtils is Test {
    using Uint1024 for uint256;
    using Uint512 for uint256;
    using Uint512Extended for uint256;
    /**
     * @notice Builds the input arguments for the python implementation of 1024 arithmetic operations
     * @param a0 A uint256 representing the lower bits of the first operand
     * @param a1 A uint256 representing the high bits of the first operand
     * @param a2 A uint256 representing the higher bits of the first operand
     * @param a3 A uint256 representing the highest bits of the first operand
     * @param b0 A uint256 representing the lower bits of the second operand
     * @param b1 A uint256 representing the high bits of the second operand
     * @param b2 A uint256 representing the higher bits of the second operand
     * @param b3 A uint256 representing the highest bits of the second operand
     * @return The input argument array to pass to the 1024_arithmetic python script
     */
    function _buildFFI1024Arithmetic(
        uint256 a0,
        uint256 a1,
        uint256 a2,
        uint256 a3,
        uint256 b0,
        uint256 b1,
        uint256 b2,
        uint256 b3,
        string memory operator
    ) internal pure returns (string[] memory) {
        string[] memory inputs = new string[](11);
        inputs[0] = "python3";
        inputs[1] = "script/1024_arithmetic.py";
        inputs[2] = vm.toString(a0);
        inputs[3] = vm.toString(a1);
        inputs[4] = vm.toString(a2);
        inputs[5] = vm.toString(a3);
        inputs[6] = vm.toString(b0);
        inputs[7] = vm.toString(b1);
        inputs[8] = vm.toString(b2);
        inputs[9] = vm.toString(b3);
        inputs[10] = operator;
        return inputs;
    }

    /**
     * @notice Builds the input arguments for the python implementation of the multiplicative inverse operation
     * @param b0 A uint256 representing the lower bits of the operand
     * @param b1 A uint256 representing the high bits of the operand
     * @return The input argument array to pass to the mul_inverse_512 python script
     */
    function _buildFFIMulInv512(uint256 b0, uint256 b1) internal pure returns (string[] memory) {
        string[] memory inputs = new string[](4);
        inputs[0] = "python3";
        inputs[1] = "script/mul_inverse_512.py";
        inputs[2] = vm.toString(b0);
        inputs[3] = vm.toString(b1);
        return inputs;
    }

    /**
     * @notice Builds the input arguments for the python implementation of the logarithm base 2
     * @param x A uint256 which will be applied log2
     * @return The input argument array to pass to the log_2 python script
     */
   /*function _buildFFILog2(uint256 x) internal pure returns (string[] memory) {
        string[] memory inputs = new string[](3);
        inputs[0] = "python3";
        inputs[1] = "script/log_2.py";
        inputs[2] = vm.toString(x);
        return inputs;
    }*/
}
