/// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "forge-std/console2.sol";
import "forge-std/Test.sol";
import {Uint1024} from "src/Uint1024.sol";
import {Uint512} from "../src/Uint512.sol";
import {PythonUtils} from "test/PythonUtils.sol";
import {TesterContract} from "test/TesterContract.sol";
import "./UintUtils.sol";

/**
 * @title Test Math For library Uint1024
 * @dev fuzz test that compares Solidity results against the same math in Python
 * @author @oscarsernarosero @Palmerg4
 */
contract Uint1024FuzzTests is Test, PythonUtils, UintUtils {
    using Uint1024 for uint256;

    function testLt768(uint a0, uint a1, uint a2, uint b0, uint b1, uint b2) public {
        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, a2, 0, b0, b1, b2, 0, "lt");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, , , ) = abi.decode(res, (uint256, uint256, uint256, uint256));
        console2.log("pyRes: ", pyR0);

        solStA768 = uint768(a0, a1, a2);
        solStB768 = uint768(b0, b1, b2);

        bool solR = Uint1024.lt768(a0, a1, a2, b0, b1, b2);
        bool solRSt = Uint1024.lt768(solStA768, solStB768);

        if (pyR0 == 0) {
            assertFalse(solR, "Python said Nay, Solidity said Aye");
            assertFalse(solRSt, "Python said Nay, Solidity said Aye");
        } else {
            assertTrue(solR, "Python said Aye, Solidity said Nay");
            assertTrue(solRSt, "Python said Aye, Solidity said Nay");
        }
    }

    function testLt1024(uint a0, uint a1, uint a2, uint a3, uint b0, uint b1, uint b2, uint b3) public {
        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, a2, a3, b0, b1, b2, b3, "lt");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, , , ) = abi.decode(res, (uint256, uint256, uint256, uint256));
        console2.log("pyRes: ", pyR0);

        solStA1024 = uint1024(a0, a1, a2, a3);
        solStB1024 = uint1024(b0, b1, b2, b3);

        bool solR = Uint1024.lt1024(a0, a1, a2, a3, b0, b1, b2, b3);
        console2.log("solRes:", solR);

        bool solRSt = Uint1024.lt1024(solStA1024, solStB1024);

        if (pyR0 == 0) {
            assertFalse(solR, "Python said No, Solidity said Aye");
            assertFalse(solRSt, "Python said No, Solidity said Aye");
        } else {
            assertTrue(solR, "Python said Aye, Solidity said Nay");
            assertTrue(solRSt, "Python said Aye, Solidity said Nay");
        }
    }

    function testGt1024(uint a0, uint a1, uint a2, uint a3, uint b0, uint b1, uint b2, uint b3) public {
        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, a2, a3, b0, b1, b2, b3, "gt");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, , , ) = abi.decode(res, (uint256, uint256, uint256, uint256));
        console2.log("pyRes: ", pyR0);

        solStA1024 = uint1024(a0, a1, a2, a3);
        solStB1024 = uint1024(b0, b1, b2, b3);

        bool solR = Uint1024.gt1024(a0, a1, a2, a3, b0, b1, b2, b3);
        console2.log("solRes:", solR);

        bool solRSt = Uint1024.gt1024(solStA1024, solStB1024);

        if (pyR0 == 0) {
            assertFalse(solR, "Python said No, Solidity said Aye");
            assertFalse(solRSt, "Python said No, Solidity said Aye");
        } else {
            assertTrue(solR, "Python said Aye, Solidity said Nay");
            assertTrue(solRSt, "Python said Aye, Solidity said Nay");
        }
    }

    function testGt768(uint a0, uint a1, uint a2, uint b0, uint b1, uint b2) public {
        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, a2, 0, b0, b1, b2, 0, "gt");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, , , ) = abi.decode(res, (uint256, uint256, uint256, uint256));
        console2.log("pyRes: ", pyR0);

        solStA768 = uint768(a0, a1, a2);
        solStB768 = uint768(b0, b1, b2);

        bool solR = Uint1024.gt768(a0, a1, a2, b0, b1, b2);
        console2.log("solRes:", solR0, solR1);

        bool solRSt = Uint1024.gt768(solStA768, solStB768);

        if (pyR0 == 0) {
            assertFalse(solR, "Python said Nay, Solidity said Aye");
            assertFalse(solRSt, "Python said Nay, Solidity said Aye");
        } else {
            assertTrue(solR, "Python said Aye, Solidity said Nay");
            assertTrue(solRSt, "Python said Aye, Solidity said Nay");
        }
    }

    function testDiv512x256In512(uint a0, uint a1, uint b) public {
        b = bound(b, 1, type(uint256).max);
        a1 = bound(a1, 1, type(uint256).max);

        solStA512 = uint512(a0, a1);

        (solR0, solR1) = Uint1024.div512x256In512(a0, a1, b);
        console2.log("solRes:", solR0, solR1);

        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, 0, 0, b, 0, 0, 0, "div");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, pyR1) = abi.decode(res, (uint, uint));
        console2.log("pythonRes:", pyR0, pyR1);

        if (solR0 != pyR0) revert("R0 bits different");
        if (solR1 != pyR1) revert("R1 bits different");

        solR512 = Uint1024.div512x256In512(solStA512, b);
        if (solR512._0 != pyR0) revert("R0 bits different");
        if (solR512._1 != pyR1) revert("R1 bits different");
    }

    function testDiv768x256(uint a0, uint a1, uint a2, uint b) public {
        b = bound(b, 1, type(uint256).max);

        solStA768 = uint768(a0, a1, a2);

        (solR0, solR1, solR2) = Uint1024.div768x256(a0, a1, a2, b);
        console2.log("solRes:", solR0, solR1, solR2);

        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, a2, 0, b, 0, 0, 0, "div");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, pyR1, pyR2) = abi.decode(res, (uint, uint, uint));
        console2.log("pythonRes:", pyR0, pyR1, pyR2);

        if (solR0 != pyR0) revert("R0 bits different");
        if (solR1 != pyR1) revert("R1 bits different");
        if (solR2 != pyR2) revert("R2 bits different");

        solR768 = Uint1024.div768x256(solStA768, b);
        if (solR768._0 != pyR0) revert("R0 bits different");
        if (solR768._1 != pyR1) revert("R1 bits different");
        if (solR768._2 != pyR2) revert("R2 bits different");
    }

    function testDiv768x512(uint a0, uint a1, uint a2, uint b0, uint b1) public {
        b1 = bound(b1, 1, type(uint256).max);
        uint768 memory a = uint768(a0, a1, a2);
        uint512 memory b = uint512(b0, b1);
        uint512 memory solR;
        solR = Uint1024.div768x512(a, b);

        string[] memory inputs = _buildFFI1024Arithmetic(a._0, a._1, a._2, 0, b._0, b._1, 0, 0, "div");
        bytes memory res = vm.ffi(inputs);
        (pyR0, pyR1, pyR2) = abi.decode(res, (uint, uint, uint));

        if (solR._1 != pyR1) revert("R1 bits different");
        if (solR._0 != pyR0) revert("R0 bits different");
    }

    function testDiv1024x256(uint a0, uint a1, uint a2, uint a3, uint b) public {
        b = bound(b, 1, type(uint256).max);

        solStA1024 = uint1024(a0, a1, a2, a3);

        (solR0, solR1, solR2, solR3) = Uint1024.div1024x256(a0, a1, a2, a3, b);
        console2.log("solRes:", solR0, solR1, solR2);
        console2.log("highest bits solRes:", solR3);

        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, a2, a3, b, 0, 0, 0, "div");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, pyR1, pyR2, pyR3) = abi.decode(res, (uint, uint, uint, uint));
        console2.log("pythonRes:", pyR0, pyR1, pyR2);
        console2.log("highest bits pythonRes:", pyR3);

        if (solR0 != pyR0) revert("R0 bits different");
        if (solR1 != pyR1) revert("R1 bits different");
        if (solR2 != pyR2) revert("R2 bits different");
        if (solR3 != pyR3) revert("R3 bits different");

        solR1024 = Uint1024.div1024x256(solStA1024, b);
        if (solR1024._0 != pyR0) revert("R0 bits different");
        if (solR1024._1 != pyR1) revert("R1 bits different");
        if (solR1024._2 != pyR2) revert("R2 bits different");
        if (solR1024._3 != pyR3) revert("R3 bits different");
    }

    function testDiv1024x512(uint a0, uint a1, uint a2, uint a3, uint b0, uint b1) public {
        // a3 = a3 % (b1 >> 1);
        b1 = bound(b1, 1, type(uint256).max);
        uint1024 memory a = uint1024(a0, a1, a2, a3);
        uint512 memory b = uint512(b0, b1);
        uint768 memory solR;
        solR = Uint1024.div1024x512(a, b);

        string[] memory inputs = _buildFFI1024Arithmetic(a._0, a._1, a._2, a._3, b._0, b._1, 0, 0, "div");
        bytes memory res = vm.ffi(inputs);
        (pyR0, pyR1, pyR2, pyR4) = abi.decode(res, (uint, uint, uint, uint));
        console2.log("solR", solR._0, solR._1, solR._2);
        console2.log("pyR", pyR0, pyR1, pyR2);

        if (solR._2 != pyR2) revert("R2 bits different");
        if (solR._1 != pyR1) revert("R1 bits different");
        if (solR._0 != pyR0) revert("R0 bits different");
    }

    function testAdd768x768(uint a0, uint a1, uint a2, uint b0, uint b1, uint b2) public {
        solStA768 = uint768(a0, a1, a2);
        solStB768 = uint768(b0, b1, b2);

        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, a2, 0, b0, b1, b2, 0, "add");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, pyR1, pyR2, pyR3, pyR4) = abi.decode(res, (uint256, uint256, uint256, uint256, uint256));
        console2.log("pythonRes:", pyR0, pyR1, pyR2);
        console2.log("pythonRes cont:", pyR3, pyR4);

        if (pyR3 > 0) vm.expectRevert("Uint1024: add768 overflow");
        (solR0, solR1, solR2) = Uint1024.add768x768(a0, a1, a2, b0, b1, b2);
        console2.log("solRes:", solR0, solR1, solR2);

        if (solR0 != pyR0) revert("R0 bits different");
        if (solR1 != pyR1) revert("R1 bits different");
        if (solR2 != pyR2) revert("R2 bits different");

        solR768 = Uint1024.add768x768(solStA768, solStB768);
        if (solR768._0 != pyR0) revert("R0 bits different");
        if (solR768._1 != pyR1) revert("R1 bits different");
        if (solR768._2 != pyR2) revert("R2 bits different");
    }

    function testAdd1024x1024(uint a0, uint a1, uint a2, uint256 a3, uint b0, uint b1, uint b2, uint256 b3) public {
        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, a2, a3, b0, b1, b2, b3, "add");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, pyR1, pyR2, pyR3, pyR4) = abi.decode(res, (uint256, uint256, uint256, uint256, uint256));
        console2.log("pythonRes:", pyR0, pyR1, pyR2);
        console2.log("pythonRes cont:", pyR3, pyR4);

        solStA1024 = uint1024(a0, a1, a2, a3);
        solStB1024 = uint1024(b0, b1, b2, b3);

        if (pyR4 > 0) vm.expectRevert("Uint1024: add1024 overflow");
        (solR0, solR1, solR2, solR3) = Uint1024.add1024x1024(a0, a1, a2, a3, b0, b1, b2, b3);
        console2.log("solRes:", solR0, solR1, solR2);
        console2.log("solRes cont:", solR3);

        if (solR0 != pyR0) revert("R0 bits different");
        if (solR1 != pyR1) revert("R1 bits different");
        if (solR2 != pyR2) revert("R2 bits different");
        if (solR3 != pyR3) revert("R3 bits different");

        solR1024 = Uint1024.add1024x1024(solStA1024, solStB1024);
        if (solR1024._0 != pyR0) revert("R0 bits different");
        if (solR1024._1 != pyR1) revert("R1 bits different");
        if (solR1024._2 != pyR2) revert("R2 bits different");
        if (solR1024._3 != pyR3) revert("R3 bits different");
    }

    function testSub768x768(uint a0, uint a1, uint a2, uint b0, uint b1, uint b2) public {
        if (b0 == 0 && b1 == 0 && b2 == 0) b0 = 1;

        solStA768 = uint768(a0, a1, a2);
        solStB768 = uint768(b0, b1, b2);

        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, a2, 0, b0, b1, b2, 0, "sub");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, pyR1, pyR2, pyR3, pyR4) = abi.decode(res, (uint256, uint256, uint256, uint256, uint256));
        console2.log("pythonRes:", pyR0, pyR1, pyR2);
        console2.log("Python highest Bits: ", pyR4);
        if (pyR4 > 0) vm.expectRevert("Uint1024: negative result sub768x768");
        (solR0, solR1, solR2) = Uint1024.sub768x768(a0, a1, a2, b0, b1, b2);
        console2.log("solRes:", solR0, solR1, solR2);

        if (solR0 != pyR0) revert("R0 bits different");
        if (solR1 != pyR1) revert("R1 bits different");
        if (solR2 != pyR2) revert("R2 bits different");

        solR768 = Uint1024.sub768x768(solStA768, solStB768);
        if (solR768._0 != pyR0) revert("R0 bits different");
        if (solR768._1 != pyR1) revert("R1 bits different");
        if (solR768._2 != pyR2) revert("R2 bits different");
    }

    function testSub1024x1024(uint a0, uint a1, uint a2, uint256 a3, uint b0, uint b1, uint b2, uint256 b3) public {
        if (b0 == 0 && b1 == 0 && b2 == 0) b0 = 1;

        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, a2, a3, b0, b1, b2, b3, "sub");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, pyR1, pyR2, pyR3, pyR4) = abi.decode(res, (uint256, uint256, uint256, uint256, uint256));
        console2.log("pythonRes:", pyR0, pyR1, pyR2);
        console2.log("Python highest Bits: ", pyR3, pyR4);

        solStA1024 = uint1024(a0, a1, a2, a3);
        solStB1024 = uint1024(b0, b1, b2, b3);

        if (pyR4 > 0) vm.expectRevert("Uint1024: sub1024 underflow");
        (solR0, solR1, solR2, solR3) = Uint1024.sub1024x1024(a0, a1, a2, a3, b0, b1, b2, b3);
        console2.log("solRes:", solR0, solR1, solR2);
        console2.log("solRes cont:", solR3);

        if (solR0 != pyR0) revert("R0 bits different");
        if (solR1 != pyR1) revert("R1 bits different");
        if (solR2 != pyR2) revert("R2 bits different");
        if (solR3 != pyR3) revert("R3 bits different");

        solR1024 = Uint1024.sub1024x1024(solStA1024, solStB1024);
        if (solR1024._0 != pyR0) revert("R0 bits different");
        if (solR1024._1 != pyR1) revert("R1 bits different");
        if (solR1024._2 != pyR2) revert("R2 bits different");
        if (solR1024._3 != pyR3) revert("R3 bits different");
    }

    function testMul512x256In768(uint a0, uint a1, uint b) public {
        solStA512 = uint512(a0, a1);

        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, 0, 0, b, 0, 0, 0, "mul");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, pyR1, pyR2, pyR3) = abi.decode(res, (uint256, uint256, uint256, uint256));
        console2.log("pyRes: ", pyR0, pyR1, pyR2);
        console2.log("Python highest Bits: ", pyR3);

        if (pyR3 > 0) revert("MUL512x256In768 - Overflow");
        (solR0, solR1, solR2) = Uint1024.mul512x256In768(a0, a1, b);
        console2.log("solRes:", solR0, solR1, solR2);

        if (solR0 != pyR0) revert("R0 bits different");
        if (solR1 != pyR1) revert("R1 bits different");
        if (solR2 != pyR2) revert("R2 bits different");

        solR768 = Uint1024.mul512x256In768(solStA512, b);
        if (solR768._0 != pyR0) revert("R0 bits different");
        if (solR768._1 != pyR1) revert("R1 bits different");
        if (solR768._2 != pyR2) revert("R2 bits different");
    }

    function testMul768x256In1024(uint a0, uint a1, uint a2, uint b) public {
        solStA768 = uint768(a0, a1, a2);

        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, a2, 0, b, 0, 0, 0, "mul");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, pyR1, pyR2, pyR3) = abi.decode(res, (uint256, uint256, uint256, uint256));
        console2.log("pyRes: ", pyR0, pyR1, pyR2);
        console2.log("Python highest Bits: ", pyR3);

        (solR0, solR1, solR2, solR3) = Uint1024.mul768x256In1024(a0, a1, a2, b);
        console2.log("solRes:", solR0, solR1, solR2);
        console2.log("highest:", solR3);

        if (solR0 != pyR0) revert("R0 bits different");
        if (solR1 != pyR1) revert("R1 bits different");
        if (solR2 != pyR2) revert("R2 bits different");
        if (solR3 != pyR3) revert("R3 bits different");

        solR1024 = Uint1024.mul768x256In1024(solStA768, b);
        if (solR1024._0 != pyR0) revert("R0 bits different");
        if (solR1024._1 != pyR1) revert("R1 bits different");
        if (solR1024._2 != pyR2) revert("R2 bits different");
        if (solR1024._3 != pyR3) revert("R2 bits different");
    }

    function testMul512x512In1024(uint256 a0, uint256 a1, uint256 b0, uint256 b1) public {
        solStA512 = uint512(a0, a1);
        solStB512 = uint512(b0, b1);

        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, 0, 0, b0, b1, 0, 0, "mul");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, pyR1, pyR2, pyR3, pyR4) = abi.decode(res, (uint256, uint256, uint256, uint256, uint256));
        console2.log("pyRes: ", pyR0, pyR1, pyR2);
        console2.log("Python highest Bits: ", pyR3);
        console2.log("Python highest Bits: ", pyR4);

        if (pyR4 > 0) revert("Mul512x512In1024 - Overflow");
        (solR0, solR1, solR2, solR3) = Uint1024.mul512x512In1024(a0, a1, b0, b1);
        console2.log("solRes:", solR0, solR1, solR2);
        console2.log("highest sol bits: ", solR3);

        if (solR0 != pyR0) revert("R0 bits different");
        if (solR1 != pyR1) revert("R1 bits different");
        if (solR2 != pyR2) revert("R2 bits different");
        if (solR3 != pyR3) revert("R3 bits different");

        solR1024 = Uint1024.mul512x512In1024(solStA512, solStB512);
        if (solR1024._0 != pyR0) revert("R0 bits different");
        if (solR1024._1 != pyR1) revert("R1 bits different");
        if (solR1024._2 != pyR2) revert("R2 bits different");
        if (solR1024._3 != pyR3) revert("R2 bits different");
    }

    function testMul728x512In1240(uint256 a0, uint256 a1, uint a2, uint256 b0, uint256 b1) public {
        a2 = a2 % (1 << (256 - (5 + 7 + 8 + 9 + 11)));
        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, a2, 0, b0, b1, 0, 0, "mul");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, pyR1, pyR2, pyR3, pyR4) = abi.decode(res, (uint256, uint256, uint256, uint256, uint256));
        console2.log("pyRes: ", pyR0, pyR1, pyR2);
        console2.log("Python highest Bits: ", pyR3, pyR4);
        console2.log("Python highest Bits: ", pyR4);

        uint768 memory a = uint768(a0, a1, a2);
        uint512 memory b = uint512(b0, b1);
        uint1280 memory solR = Uint1024.mul728x512In1240(a, b);
        console2.log("solRes:", solR._0, solR._1, solR._2);
        console2.log("highest sol bits: ", solR._3, solR._4);

        if (solR._0 != pyR0) revert("R0 bits different");
        if (solR._1 != pyR1) revert("R1 bits different");
        if (solR._2 != pyR2) revert("R2 bits different");
        if (solR._3 != pyR3) revert("R3 bits different");
        if (solR._4 != pyR4) revert("R3 bits different");
    }

    function testDivMulInverse512(uint b0, uint b1) public {
        TesterContract testerContract = new TesterContract();
        b1 = bound(b1, 1, type(uint256).max);
        if (b0 % 2 == 0) vm.expectRevert("Uint1024: MulnvMod512 denom even");
        (solR0, solR1) = testerContract.mulInverseMod512(b0, b1);
        console2.log("solRes:", solR0, solR1);

        solStB512 = uint512(b0, b1);

        if (b0 % 2 == 0) return; // python code will fail because inverse of an even number is not defined
        string[] memory inputs = _buildFFIMulInv512(b0, b1);
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, pyR1) = abi.decode(res, (uint, uint));
        console2.log("pythonRes:", pyR0, pyR1);

        if (solR0 != pyR0) revert("R0 bits different");
        if (solR1 != pyR1) revert("R1 bits different");

        solR512 = Uint1024.mulInverseMod512(solStB512);
        if (solR512._0 != pyR0) revert("R0 bits different");
        if (solR512._1 != pyR1) revert("R1 bits different");
    }

    function testMul512x512Mod512(uint256 a0, uint256 a1, uint256 b0, uint256 b1) public {
        solStA512 = uint512(a0, a1);
        solStB512 = uint512(b0, b1);

        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, 0, 0, b0, b1, 0, 0, "mul");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, pyR1, , ) = abi.decode(res, (uint256, uint256, uint256, uint256));
        console2.log("pyRes: ", pyR0, pyR1);

        (solR0, solR1) = Uint1024.mul512x512Mod512(a0, a1, b0, b1);
        console2.log("solRes:", solR0, solR1);

        if (solR0 != pyR0) revert("R0 bits different");
        if (solR1 != pyR1) revert("R1 bits different");

        solR512 = Uint1024.mul512x512Mod512(solStA512, solStB512);
        if (solR512._0 != pyR0) revert("R0 bits different");
        if (solR512._1 != pyR1) revert("R1 bits different");
    }

    function testdivRem1024x512In512(uint b0, uint b1, uint r0, uint r1) public {
        // we avoid b being zero. We randomize what bits to set to 1
        if (b0 == 0 && b1 == 0) {
            if (r0 % 2 == 0) b1 = 1;
            else b0 = 1;
        }

        uint512 memory rem = uint512(0, 0);
        solStB512 = uint512(b0, b1);

        (uint a0, uint a1, uint a2, uint a3) = b0.mul512x512In1024(b1, r0, r1);
        solStA1024 = uint1024(a0, a1, a2, a3);

        (solR0, solR1) = Uint1024.divRem1024x512In512(a0, a1, a2, a3, b0, b1, 0, 0);
        console2.log("solRes:", solR0, solR1);

        if (solR0 != r0) revert("lower bits different");
        if (solR1 != r1) revert("higher bits different");

        solR512 = Uint1024.divRem1024x512In512(solStA1024, solStB512, rem);
        if (solR512._0 != r0) revert("lower bits different");
        if (solR512._1 != r1) revert("higher bits different");
    }

    function testMod768x256(uint a0, uint a1, uint a2, uint b) public {
        if (b == 0) vm.expectRevert("Uint1024: mod 0 undefined");
        (solR0) = Uint1024.mod768x256(a0, a1, a2, b);

        solStA768 = uint768(a0, a1, a2);

        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, a2, 0, b, 0, 0, 0, "mod");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        pyR0 = abi.decode(res, (uint256));
        console2.log("solR0: ", solR0);
        console2.log("pyRes: ", pyR0);

        if (solR0 != pyR0) revert("different results");

        uint256 rem = Uint1024.mod768x256(solStA768, b);
        if (rem != pyR0) revert("different results");
    }

    function testMod1024x256(uint a0, uint a1, uint a2, uint a3, uint b) public {
        if (b == 0) vm.expectRevert("Uint1024: mod 0 undefined");
        (solR0) = Uint1024.mod1024x256(a0, a1, a2, a3, b);

        solStA1024 = uint1024(a0, a1, a2, a3);

        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, a2, a3, b, 0, 0, 0, "mod");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        pyR0 = abi.decode(res, (uint256));
        console2.log("solR0: ", solR0);
        console2.log("pyRes: ", pyR0);

        if (solR0 != pyR0) revert("different results");

        uint256 rem = Uint1024.mod1024x256(solStA1024, b);

        if (rem != pyR0) revert("different results");
    }

    function testDiv768ByPowerOf2(uint a0, uint a1, uint a2, uint8 n) public {
        a1 = a1 % (2 ** 254);
        n = (n % 254) + 1;

        solStA768 = uint768(a0, a1, a2);

        (solR0, solR1, solR2, ) = Uint1024.div768ByPowerOf2(a0, a1, a2, n);
        console2.log("solRes:", solR0, solR1, solR3);

        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, a2, 0, 2 ** n, 0, 0, 0, "div");
        bytes memory res = vm.ffi(inputs);
        (pyR0, pyR1, pyR2) = abi.decode(res, (uint, uint, uint));
        console2.log("pyRes:", pyR0, pyR1, pyR2);

        if (solR0 != pyR0) revert("R0 bits different");
        if (solR1 != pyR1) revert("R1 bits different");
        if (solR2 != pyR2) revert("R2 bits different");

        (solR768, ) = Uint1024.div768ByPowerOf2(solStA768, n);
        if (solR768._0 != pyR0) revert("R0 bits different");
        if (solR768._1 != pyR1) revert("R1 bits different");
        if (solR768._2 != pyR2) revert("R2 bits different");
    }

    function testSqrt1024(uint a0, uint a1, uint a2, uint a3) public {
        (solR0, solR1) = Uint1024.sqrt1024(a0, a1, a2, a3);
        console2.log("solRes:", solR0, solR1);

        /// NOTE: Python was not precise enough for this test. Instead, it is proven that result r is the correct
        // square root of a by checking that r**2 <= a, and that (r + 1)**2 > a. We also test that
        // (a - (r - 1)**2) > (a - r**2) as a further confirmation that r is indeed our result

        // we make sure that the result square is less or equal to the original value, proving r is in the correct lower range
        {
            // _r**2
            (uint rec0, uint rec1, uint rec2, uint rec3) = Uint1024.mul512x512In1024(solR0, solR1, solR0, solR1);
            // a must not be less than r**2
            if (Uint1024.lt1024(a0, a1, a2, a3, rec0, rec1, rec2, rec3)) revert("result square greater than a");
        }

        // we make sure that the result + 1 square is above original value, proving r + 1 is not the correct result
        if (solR0 < type(uint).max || solR1 < type(uint).max) {
            // _r = r + 1
            (uint _solR0, uint _solR1) = Uint512.add512x512(solR0, solR1, 1, 0);
            // _r**2
            (uint rec0, uint rec1, uint rec2, uint rec3) = Uint1024.mul512x512In1024(_solR0, _solR1, _solR0, _solR1);
            // _r**2 must not be less or equal than a
            if (!Uint1024.lt1024(a0, a1, a2, a3, rec0, rec1, rec2, rec3)) revert("result + 1 square not greater than a");
        }

        // we make sure that the result - 1 square is further away than result square from original value, proving that r - 1 is not a better result than r
        if (solR0 > 0 || solR1 > 0) {
            // _r = r - 1
            (uint _solR0, uint _solR1) = Uint512.sub512x512(solR0, solR1, 1, 0);
            // _r**2
            (uint rec0, uint rec1, uint rec2, uint rec3) = Uint1024.mul512x512In1024(_solR0, _solR1, _solR0, _solR1);
            // a - _r**2
            (rec0, rec1, rec2, rec3) = Uint1024.sub1024x1024(a0, a1, a2, a3, rec0, rec1, rec2, rec3);
            // r**2
            (uint og0, uint og1, uint og2, uint og3) = Uint1024.mul512x512In1024(solR0, solR1, solR0, solR1);
            // a - r**2
            (og0, og1, og2, og3) = Uint1024.sub1024x1024(a0, a1, a2, a3, og0, og1, og2, og3);
            // (a - _r**2) must not be less or equal than (a - r**2)
            if (!Uint1024.lt1024(og0, og1, og2, og3, rec0, rec1, rec2, rec3)) revert("result - 1 square closer to a than result square");
        }
    }

    function testDiv1024ByPowerOf2(uint a0, uint a1, uint a2, uint a3, uint8 n) public {
        n = (n % 255) + 1;

        solStA1024 = uint1024(a0, a1, a2, a3);

        (solR0, solR1, solR2, solR3, ) = Uint1024.div1024ByPowerOf2(a0, a1, a2, a3, n);
        console2.log("solRes:", solR0, solR1, solR2);
        console2.log("solRes high:", solR3);

        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, a2, a3, 2 ** n, 0, 0, 0, "div");
        bytes memory res = vm.ffi(inputs);
        (pyR0, pyR1, pyR2, pyR3) = abi.decode(res, (uint, uint, uint, uint));
        console2.log("pyRes:", pyR0, pyR1, pyR2);
        console2.log("pyRes high:", pyR3);

        if (solR0 != pyR0) revert("R0 bits different");
        if (solR1 != pyR1) revert("R1 bits different");
        if (solR2 != pyR2) revert("R2 bits different");
        if (solR3 != pyR3) revert("R2 bits different");

        (solR1024, ) = Uint1024.div1024ByPowerOf2(solStA1024, n);
        if (solR1024._0 != pyR0) revert("R0 bits different struct");
        if (solR1024._1 != pyR1) revert("R1 bits different struct");
        if (solR1024._2 != pyR2) revert("R2 bits different struct");
        if (solR1024._3 != pyR3) revert("R3 bits different struct");
    }
}
