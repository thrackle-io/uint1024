/// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/console2.sol";
import "forge-std/Test.sol";
import {Uint512Extended} from "../src/Uint512Extended.sol";
import {Uint512} from "../src/Uint512.sol";
import {PythonUtils} from "./PythonUtils.sol";
import "./UintUtils.sol";

/**
 * @title Test Math For safe Uint512 library
 * @dev fuzz test that compares Solidity results against the same math in Python
 * @author @oscarsernarosero @Palmerg4
 */
contract SafeUint512FuzzTests is Test, PythonUtils, UintUtils {
    using Uint512Extended for uint256;
    using Uint512 for uint256;

    function testSafeDiv512x256(uint256 a0, uint256 a1, uint256 b) public {
        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, 0, 0, b, 0, 0, 0, "div");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, pyR1, , ) = abi.decode(res, (uint256, uint256, uint256, uint256));
        console2.log("pyRes: ", pyR0, pyR1);

        solStA512 = uint512(a0, a1);

        if (pyR1 >= 1 || b == 0) vm.expectRevert("Uint512: a1 >= b div512x256");
        solR0 = Uint512Extended.safeDiv512x256(a0, a1, b);
        console2.log("solRes: ", solR0);

        if (solR0 != pyR0) revert("lower bits different");

        solR0 = Uint512Extended.safeDiv512x256(solStA512, b);
        if (solR0 != pyR0) revert("lower bits different");
    }

    function testSafeMul512x256(uint256 a0, uint256 a1, uint256 b) public {
        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, 0, 0, b, 0, 0, 0, "mul");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, pyR1, pyR2, ) = abi.decode(res, (uint256, uint256, uint256, uint256));
        console2.log("pyRes: ", pyR0, pyR1, pyR2);

        solStA512 = uint512(a0, a1);

        if (pyR2 > 0) vm.expectRevert("Uint512: mul512x256 overflow");
        (solR0, solR1) = Uint512Extended.safeMul512x256(a0, a1, b);
        solR512 = Uint512Extended.safeMul512x256(solStA512, b);
        console2.log("solRes:", solR0, solR1);

        if (solR0 != pyR0) revert("lower bits different");
        if (solR1 != pyR1) revert("higher bits different");
        if (solR512._0 != pyR0) revert("lower bits different");
        if (solR512._1 != pyR1) revert("higher bits different");
    }

    function testSafeAdd512x512(uint256 a0, uint256 a1, uint256 b0, uint256 b1) public {
        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, 0, 0, b0, b1, 0, 0, "add");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, pyR1, pyR2, ) = abi.decode(res, (uint256, uint256, uint256, uint256));
        console2.log("pyRes: ", pyR0, pyR1, pyR2);

        solStA512 = uint512(a0, a1);
        solStB512 = uint512(b0, b1);

        if (pyR2 > 0) vm.expectRevert("Uint512: safeAdd512 overflow");
        (solR0, solR1) = Uint512Extended.safeAdd512x512(a0, a1, b0, b1);
        solR512 = Uint512Extended.safeAdd512x512(solStA512, solStB512);
        console2.log("solRes:", solR0, solR1);

        if (solR0 != pyR0) revert("lower bits different");
        if (solR1 != pyR1) revert("higher bits different");
        if (solR512._0 != pyR0) revert("lower bits different");
        if (solR512._1 != pyR1) revert("higher bits different");
    }

    function testSafeSub512x512(uint256 a0, uint256 a1, uint256 b0, uint256 b1) public {
        solStA512 = uint512(a0, a1);
        solStB512 = uint512(b0, b1);

        if (Uint512Extended.lt512(a0, a1, b0, b1)) vm.expectRevert("Uint512: negative result sub512x512");
        (solR0, solR1) = Uint512Extended.safeSub512x512(a0, a1, b0, b1);
        solR512 = Uint512Extended.safeSub512x512(solStA512, solStB512);
        console2.log("solRes:", solR0, solR1);

        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, 0, 0, b0, b1, 0, 0, "sub");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, pyR1, , ) = abi.decode(res, (uint256, uint256, uint256, uint256));
        console2.log("pyRes: ", pyR0, pyR1);

        if (solR0 != pyR0) revert("lower bits different");
        if (solR1 != pyR1) revert("higher bits different");
        if (solR512._0 != pyR0) revert("lower bits different");
        if (solR512._1 != pyR1) revert("higher bits different");
    }

    function testDiv512x512(uint a0, uint a1, uint b0, uint b1) public {
        b1 = bound(b1, 1, type(uint256).max / 2);

        solStA512 = uint512(a0, a1);
        solStB512 = uint512(b0, b1);

        solR0 = Uint512Extended.div512x512(a0, a1, b0, b1);

        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, 0, 0, b0, b1, 0, 0, "div");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, , , ) = abi.decode(res, (uint, uint, uint, uint));

        if (solR0 != pyR0) revert ("different results");

        solR0 = Uint512Extended.div512x512(solStA512, solStB512);
        if (solR0 != pyR0) revert ("different results");
    }

    function testLog2(uint x) public {
        solR0 = x.log2();
        if (solR0 == 0) return;
        string[] memory inputs = _buildFFILog2(x);
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        console2.log(solR0);
        pyR0 = abi.decode(res, (uint));
        console2.log("pythonRes:", pyR0); 

        pyR0 > solR0 ? assertEq(pyR0 - 1, solR0) : 
        solR0 > pyR0 ? assertEq(pyR0, solR0 - 1) : 
        assertEq(pyR0, solR0);
    }

    function testDiv512ByPowerOf2(uint a0, uint a1, uint8 n) public {
        a1 = a1 % (2 ** 254);
        n = (n % 254) + 1;

        solStA512 = uint512(a0, a1);

        (solR0, solR1, ) = Uint512Extended.div512ByPowerOf2(a0, a1, n);
        (solR512, ) = Uint512Extended.div512ByPowerOf2(solStA512, n);

        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, 0, 0, 2 ** n, 0, 0, 0, "div");
        bytes memory res = vm.ffi(inputs);
        (pyR0, pyR1) = abi.decode(res, (uint, uint));

        if (pyR0 != solR0) revert("R0 bits different");
        if (pyR1 != solR1) revert("R1 bits different");
        if (pyR0 != solR512._0) revert("R0 bits different");
        if (pyR1 != solR512._1) revert("R1 bits different");
    }

    function testMod512x256(uint a0, uint a1, uint b) public {
        if (b == 0) vm.expectRevert("Uint512: mod 0 undefined");
        solR0 = Uint512.mod512x256(a0, a1, b);

        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, 0, 0, b, 0, 0, 0, "mod");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        pyR0 = abi.decode(res, (uint256));
        console2.log("pyRes: ", pyR0);

        if (solR0 != pyR0) revert("different results");
    }

    function testEq512(uint256 a0, uint256 a1, uint256 b0, uint256 b1) public {
        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, 0, 0, b0, b1, 0, 0, "eq");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, , , ) = abi.decode(res, (uint256, uint256, uint256, uint256));
        console2.log("pyRes: ", pyR0);

        solStA512 = uint512(a0, a1);
        solStB512 = uint512(b0, b1);

        bool solR = Uint512Extended.eq512(a0, a1, b0, b1);
        bool solRSt = Uint512Extended.eq512(solStA512, solStB512);

        if (pyR0 == 0) {
            assertFalse(solR, "Python said Nay, Solidity said Aye");
            assertFalse(solRSt, "Python said Nay, Solidity said Aye");
        } 
        else {
            assertTrue(solR, "Python said Aye, Solidity said Nay");
            assertTrue(solRSt, "Python said Aye, Solidity said Nay");
        }
    }

    function testGe512(uint256 a0, uint256 a1, uint256 b0, uint256 b1) public {
        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, 0, 0, b0, b1, 0, 0, "ge");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, , , ) = abi.decode(res, (uint256, uint256, uint256, uint256));
        console2.log("pyRes: ", pyR0);

        solStA512 = uint512(a0, a1);
        solStB512 = uint512(b0, b1);

        bool solR = Uint512Extended.ge512(a0, a1, b0, b1);
        bool solRSt = Uint512Extended.ge512(solStA512, solStB512);

        if (pyR0 == 0) {
            assertFalse(solR, "Python said Nay, Solidity said Aye");
            assertFalse(solRSt, "Python said Nay, Solidity said Aye");
        } 
        else {
            assertTrue(solR, "Python said Aye, Solidity said Nay");
            assertTrue(solRSt, "Python said Aye, Solidity said Nay");
        }
    }

    function testGt512(uint a0, uint a1, uint b0, uint b1) public {
        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, 0, 0, b0, b1, 0, 0, "gt");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, , , ) = abi.decode(res, (uint256, uint256, uint256, uint256));
        console2.log("pyRes: ", pyR0);

        solStA512 = uint512(a0, a1);
        solStB512 = uint512(b0, b1);

        bool solR = Uint512Extended.gt512(a0, a1, b0, b1);
        bool solRSt = Uint512Extended.gt512(solStA512, solStB512);

        if (pyR0 == 0) {
            assertFalse(solR, "Python said Nay, Solidity said Aye");
            assertFalse(solRSt, "Python said Nay, Solidity said Aye");
        } 
        else {
            assertTrue(solR, "Python said Aye, Solidity said Nay");
            assertTrue(solRSt, "Python said Aye, Solidity said Nay");
        }
    }

    function testLt512(uint a0, uint a1, uint b0, uint b1) public {
        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, 0, 0, b0, b1, 0, 0, "lt");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, , , ) = abi.decode(res, (uint256, uint256, uint256, uint256));
        console2.log("pyRes: ", pyR0);

        solStA512 = uint512(a0, a1);
        solStB512 = uint512(b0, b1);

        bool solR = Uint512Extended.lt512(a0, a1, b0, b1);
        bool solRSt = Uint512Extended.lt512(solStA512, solStB512);

        if (pyR0 == 0) {
            assertFalse(solR, "Python said Nay, Solidity said Aye");
            assertFalse(solRSt, "Python said Nay, Solidity said Aye");
        } 
        else {
            assertTrue(solR, "Python said Aye, Solidity said Nay");
            assertTrue(solRSt, "Python said Aye, Solidity said Nay");
        }
    }
}
