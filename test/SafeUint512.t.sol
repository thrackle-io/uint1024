/// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/console2.sol";
import "forge-std/Test.sol";
import {Uint512Extended} from "src/Uint512Extended.sol";
import {PythonUtils} from "test/PythonUtils.sol";

/**
 * @title Test Math For safe Uint512 library
 * @dev fuzz test that compares Solidity results against the same math in Python
 * @author @oscarsernarosero @Palmerg4
 */
contract SafeUint512FuzzTests is Test, PythonUtils {
    using Uint512Extended for uint256;

    function testSafeDiv512x256(uint256 a0, uint256 a1, uint256 b) public {
        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, 0, 0, b, 0, 0, 0, "div");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (uint256 pyValLo, uint256 pyValHi, , ) = abi.decode(res, (uint256, uint256, uint256, uint256));
        console2.log("pyRes: ", pyValLo, pyValHi);

        if (pyValHi >= 1 || b == 0) vm.expectRevert("Uint512: a1 >= b div512x256");
        uint256 solR0 = a0.safeDiv512x256(a1, b);
        console2.log("solRes: ", solR0);

        if (solR0 != pyValLo) revert("lower bits different");
    }

    function testSafeMul512x256(uint256 a0, uint256 a1, uint256 b) public {
        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, 0, 0, b, 0, 0, 0, "mul");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (uint256 pyValLo, uint256 pyValHi, uint256 r2, ) = abi.decode(res, (uint256, uint256, uint256, uint256));
        console2.log("pyRes: ", pyValLo, pyValHi, r2);

        if (r2 > 0) vm.expectRevert("Uint512: mul512x256 overflow");
        (uint256 solR0, uint256 solR1) = a0.safeMul512x256(a1, b);
        console2.log("solRes:", solR0, solR1);

        if (solR0 != pyValLo) revert("lower bits different");
        if (solR1 != pyValHi) revert("higher bits different");
    }

    function testSafeAdd512x512(uint256 a0, uint256 a1, uint256 b0, uint256 b1) public {
        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, 0, 0, b0, b1, 0, 0, "add");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (uint256 pyValLo, uint256 pyValHi, uint256 r2, ) = abi.decode(res, (uint256, uint256, uint256, uint256));
        console2.log("pyRes: ", pyValLo, pyValHi, r2);

        if (r2 > 0) vm.expectRevert("Uint512: safeAdd512 overflow");
        (uint256 solR0, uint256 solR1) = a0.safeAdd512x512(a1, b0, b1);
        console2.log("solRes:", solR0, solR1);

        if (solR0 != pyValLo) revert("lower bits different");
        if (solR1 != pyValHi) revert("higher bits different");
    }

    function testSafeSub512x512(uint256 a0, uint256 a1, uint256 b0, uint256 b1) public {
        if (Uint512Extended.lt512(a0, a1, b0, b1)) vm.expectRevert("Uint512: negative result sub512x512");
        (uint256 solR0, uint256 solR1) = a0.safeSub512x512(a1, b0, b1);
        console2.log("solRes:", solR0, solR1);

        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, 0, 0, b0, b1, 0, 0, "sub");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (uint256 pyValLo, uint256 pyValHi, , ) = abi.decode(res, (uint256, uint256, uint256, uint256));
        console2.log("pyRes: ", pyValLo, pyValHi);

        if (solR0 != pyValLo) revert("lower bits different");
        if (solR1 != pyValHi) revert("higher bits different");
    }

    function testDiv512x512(uint a0, uint a1, uint b0, uint b1) public {
        b1 = bound(b1, 1, type(uint256).max / 2);
        a1 = bound(a1, b1 * 2, type(uint256).max);
        console2.log(a0, a1, b0, b1);
        uint solVal = a0.div512x512(a1, b0, b1);
        console2.log("solVal:", solVal);

        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, 0, 0, b0, b1, 0, 0, "div");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (uint pyR0, , , ) = abi.decode(res, (uint, uint, uint, uint));
        console2.log("pythonRes:", pyR0);

        if (solVal - pyR0 > 1) revert(string.concat("absolute difference is greater than 1 and the number is greater than "));
    }
}
