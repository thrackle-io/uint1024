/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/console2.sol";
import "forge-std/Test.sol";
import {Uint1024} from "src/Uint1024.sol";
import {PythonUtils} from "test/PythonUtils.sol";
import {TesterContract} from "test/TesterContract.sol";

/**
 * @title Test Math For library Uint1024
 * @dev fuzz test that compares Solidity results against the same math in Python
 * @author @oscarsernarosero @Palmerg4
 */
contract Uint1024FuzzTests is Test, PythonUtils {
    using Uint1024 for uint256;

    function testDiv512x256In512(uint a0, uint a1, uint b) public {
        b = bound(b, 1, type(uint256).max);
        a1 = bound(a1, 1, type(uint256).max);

        (uint solR0, uint solR1) = a0.div512x256In512(a1, b);
        console2.log("solRes:", solR0, solR1);

        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, 0, 0, b, 0, 0, 0, "div");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (uint pyValLo, uint pyValHi) = abi.decode(res, (uint, uint));
        console2.log("pythonRes:", pyValLo, pyValHi);

        if (solR0 != pyValLo) revert("lower bits different");
        if (solR1 != pyValHi) revert("higher bits different");
    }

    function testDivMulInverse512(uint b0, uint b1) public {
        TesterContract testerContract = new TesterContract();
        b1 = bound(b1, 1, type(uint256).max);

        if (b0 % 2 == 0) vm.expectRevert("Uint1024: denominator must be odd");
        (uint solR0, uint solR1) = testerContract.mulInverseMod512(b0, b1);
        console2.log("solRes:", solR0, solR1);

        if (b0 % 2 == 0) return; // python code will fail because inverse of an even number is not defined
        string[] memory inputs = _buildFFIMulInv512(b0, b1);
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (uint pyValLo, uint pyValHi) = abi.decode(res, (uint, uint));
        console2.log("pythonRes:", pyValLo, pyValHi);
        if (solR0 != pyValLo) revert("lower bits different");
        if (solR1 != pyValHi) revert("higher bits different");
    }

    function testMul512x512Mod512(uint256 a0, uint256 a1, uint256 b0, uint256 b1) public {
        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, 0, 0, b0, b1, 0, 0, "mul");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (uint256 pyValLo, uint256 pyValHi, , ) = abi.decode(res, (uint256, uint256, uint256, uint256));
        console2.log("pyRes: ", pyValLo, pyValHi);

        (uint256 solR0, uint256 solR1) = a0.mul512x512Mod512(a1, b0, b1);
        console2.log("solRes:", solR0, solR1);

        if (solR0 != pyValLo) revert("lower bits different");
        if (solR1 != pyValHi) revert("higher bits different");
    }
}
