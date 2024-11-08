/// SPDX-License-Identifier: MIT
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

    uint256 solR0;
    uint256 solR1;
    uint256 solR2;
    uint256 solR3;

    uint256 pyR0;
    uint256 pyR1;
    uint256 pyR2;
    uint256 pyR3;
    uint256 pyR4;

    function testLt768(uint a0, uint a1, uint a2, uint b0, uint b1, uint b2) public {
        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, a2, 0, b0, b1, b2, 0, "lt");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, , , ) = abi.decode(res, (uint256, uint256, uint256, uint256));
        console2.log("pyRes: ", pyR0);

        bool solR = Uint1024.lt768(a0, a1, a2, b0, b1, b2);
        console2.log("solRes:", solR0, solR1);

        if (pyR0 == 0) assertFalse(solR, "Python said Nay, Solidity said Aye");
        else assertTrue(solR, "Python said Aye, Solidity said Nay");
    }

    function testLt1024(uint a0, uint a1, uint a2, uint a3, uint b0, uint b1, uint b2, uint b3) public {
        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, a2, a3, b0, b1, b2, b3, "lt");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, , , ) = abi.decode(res, (uint256, uint256, uint256, uint256));
        console2.log("pyRes: ", pyR0);

        bool solR = Uint1024.lt1024(a0, a1, a2, a3, b0, b1, b2, b3);
        console2.log("solRes:", solR);

        if (pyR0 == 0) assertFalse(solR, "Python said No, Solidity said Aye");
        else assertTrue(solR, "Python said Aye, Solidity said Nay");
    }

    function testDiv512x256In512(uint a0, uint a1, uint b) public {
        b = bound(b, 1, type(uint256).max);
        a1 = bound(a1, 1, type(uint256).max);

        (solR0, solR1) = Uint1024.div512x256In512(a0, a1, b);
        console2.log("solRes:", solR0, solR1);

        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, 0, 0, b, 0, 0, 0, "div");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, pyR1) = abi.decode(res, (uint, uint));
        console2.log("pythonRes:", pyR0, pyR1);

        if (solR0 != pyR0) revert("R0 bits different");
        if (solR1 != pyR1) revert("R1 bits different");
    }

    function testAdd768x768(uint a0, uint a1, uint a2, uint b0, uint b1, uint b2) public {
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
    }

    function testAdd1024x1024(uint a0, uint a1, uint a2, uint256 a3, uint b0, uint b1, uint b2, uint256 b3) public {
        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, a2, a3, b0, b1, b2, b3, "add");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, pyR1, pyR2, pyR3, pyR4) = abi.decode(res, (uint256, uint256, uint256, uint256, uint256));
        console2.log("pythonRes:", pyR0, pyR1, pyR2);
        console2.log("pythonRes cont:", pyR3, pyR4);

        if (pyR4 > 0) vm.expectRevert("Uint1024: add1024 overflow");
        (solR0, solR1, solR2, solR3) = Uint1024.add1024x1024(a0, a1, a2, a3, b0, b1, b2, b3);
        console2.log("solRes:", solR0, solR1, solR2);
        console2.log("solRes cont:", solR3);

        if (solR0 != pyR0) revert("R0 bits different");
        if (solR1 != pyR1) revert("R1 bits different");
        if (solR2 != pyR2) revert("R2 bits different");
        if (solR3 != pyR3) revert("R3 bits different");
    }

    function testSub768x768(uint a0, uint a1, uint a2, uint b0, uint b1, uint b2) public {
        if (b0 == 0 && b1 == 0 && b2 == 0) b0 = 1;

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
    }

    function testSub1024x1024(uint a0, uint a1, uint a2, uint256 a3, uint b0, uint b1, uint b2, uint256 b3) public {
        if (b0 == 0 && b1 == 0 && b2 == 0) b0 = 1;

        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, a2, a3, b0, b1, b2, b3, "sub");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, pyR1, pyR2, pyR3, pyR4) = abi.decode(res, (uint256, uint256, uint256, uint256, uint256));
        console2.log("pythonRes:", pyR0, pyR1, pyR2);
        console2.log("Python highest Bits: ", pyR3, pyR4);

        if (pyR4 > 0) vm.expectRevert("Uint1024: negative result sub1024x1024");
        (solR0, solR1, solR2, solR3) = Uint1024.sub1024x1024(a0, a1, a2, a3, b0, b1, b2, b3);
        console2.log("solRes:", solR0, solR1, solR2);
        console2.log("solRes cont:", solR3);

        if (solR0 != pyR0) revert("R0 bits different");
        if (solR1 != pyR1) revert("R1 bits different");
        if (solR2 != pyR2) revert("R2 bits different");
        if (solR3 != pyR3) revert("R3 bits different");
    }

    function testMul512x256In768(uint a0, uint a1, uint b) public {
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
    }

    function testMul512x512In1024(uint256 a0, uint256 a1, uint256 b0, uint256 b1) public {
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
    }

    function testDivMulInverse512(uint b0, uint b1) public {
        TesterContract testerContract = new TesterContract();
        b1 = bound(b1, 1, type(uint256).max);
        if (b0 % 2 == 0) vm.expectRevert("Uint1024: mulInverseMod512 denominator must be odd");
        (solR0, solR1) = testerContract.mulInverseMod512(b0, b1);
        console2.log("solRes:", solR0, solR1);

        if (b0 % 2 == 0) return; // python code will fail because inverse of an even number is not defined
        string[] memory inputs = _buildFFIMulInv512(b0, b1);
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, pyR1) = abi.decode(res, (uint, uint));
        console2.log("pythonRes:", pyR0, pyR1);

        if (solR0 != pyR0) revert("R0 bits different");
        if (solR1 != pyR1) revert("R1 bits different");
    }

    function testMul512x512Mod512(uint256 a0, uint256 a1, uint256 b0, uint256 b1) public {
        string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, 0, 0, b0, b1, 0, 0, "mul");
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (pyR0, pyR1, , ) = abi.decode(res, (uint256, uint256, uint256, uint256));
        console2.log("pyRes: ", pyR0, pyR1);

        (solR0, solR1) = Uint1024.mul512x512Mod512(a0, a1, b0, b1);
        console2.log("solRes:", solR0, solR1);

        if (solR0 != pyR0) revert("R0 bits different");
        if (solR1 != pyR1) revert("R1 bits different");
    }

    function testDiv1024x512In512Rem(uint b0, uint b1, uint r0, uint r1) public {
        // b0 = bound(b0, 1, type(uint256).max);
        // we avoid b being zero. We randomize what bits to set to 1
        if (b0 == 0 && b1 == 0) {
            if (r0 % 2 == 0) b1 = 1;
            else b0 = 1;
        }

        (uint a0, uint a1, uint a2, uint a3) = b0.mul512x512In1024(b1, r0, r1);

        (solR0, solR1) = a0.div1024x512In512Rem(a1, a2, a3, b0, b1, 0, 0);
        console2.log("solRes:", solR0, solR1);

        // string[] memory inputs = _buildFFI1024Arithmetic(a0, a1, 0, 0, b, 0, 0, 0, "div");
        // bytes memory res = vm.ffi(inputs);
        // console2.logBytes(res);
        // (uint pyValLo, uint pyValHi) = abi.decode(res, (uint, uint));
        // console2.log("pythonRes:", pyValLo, pyValHi);

        if (solR0 != r0) revert("lower bits different");
        if (solR1 != r1) revert("higher bits different");
    }
}
