/// SPDX-License-Identifier: UNLICENSED
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
        if (a1 >= b) vm.expectRevert("Uint512: a1 >= b div512x256");
        uint256 solR0 = a0.safeDiv512x256(a1, b);
        console2.log("solRes: ", solR0);

        string[] memory inputs = _buildFFIDiv1024x1024In1024(a0, a1, 0, 0, b, 0, 0, 0);
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (uint256 pyValLo,,,) = abi.decode(res, (uint256,uint256,uint256,uint256));
        console2.log("pyRes: ", pyValLo);

        if (solR0 != pyValLo) revert("lower bits different");
    }

    function testSafeMul512x256(uint256 a0, uint256 a1, uint256 b) public {
        bool willRevert;
        
        assembly {
            let mm := mulmod(a0, b, not(0))
            let r0 := mul(a0, b)
            let r1 := sub(sub(mm, r0), lt(mm, r0))
            r1 := add(r1, mul(a1, b))

            if lt(r1, a1) {
                willRevert := true
            }
        }

        if(willRevert) vm.expectRevert("mul512x256 overflow");
        (uint256 solR0, uint256 solR1) = a0.safeMul512x256(a1, b);
        console2.log("solRes:", solR0, solR1);

        string[] memory inputs = _buildFFIMul512x512In1024(a0, a1, 0, b, 0, 0);
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (uint256 pyValLo, uint256 pyValHi,,) = abi.decode(res, (uint256,uint256,uint256,uint256));
        console2.log("pyRes: ", pyValLo, pyValHi);

        if (solR0 != pyValLo) revert("lower bits different");
        if (solR1 != pyValHi) revert("higher bits different");
    }

    function testSafeAdd512x512(uint256 a0, uint256 a1, uint256 b0, uint256 b1) public {
        bool willRevert;
        
        assembly {
            let r0 := add(a0, b0)
            let r1 := add(add(a1, b1), lt(r0, a0))

            if lt(r1, b1) {
                willRevert := true
            }
        }

        if(willRevert) vm.expectRevert("add512x512 overflow");
        (uint256 solR0, uint256 solR1) = a0.safeAdd512x512(a1, b0, b1);
        console2.log("solRes:", solR0, solR1);

        string[] memory inputs = _buildFFIAdd1024x1024In1024(a0, a1, 0, 0, b0, b1, 0, 0);
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (uint256 pyValLo, uint256 pyValHi,,) = abi.decode(res, (uint256,uint256,uint256,uint256));
        console2.log("pyRes: ", pyValLo, pyValHi);

        if (solR0 != pyValLo) revert("lower bits different");
        if (solR1 != pyValHi) revert("higher bits different");
    }

    function testSafeSub512x512(uint256 a0, uint256 a1, uint256 b0, uint256 b1) public {
        if(Uint512Extended.lt512(a0, a1, b0, b1)) vm.expectRevert("Uint512: negative result sub512x512");
        (uint256 solR0, uint256 solR1) = a0.safeSub512x512(a1, b0, b1);
        console2.log("solRes:", solR0, solR1);

        string[] memory inputs = _buildFFISub1024x1024In1024(a0, a1, 0, 0, b0, b1, 0, 0);
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (uint256 pyValLo, uint256 pyValHi,,) = abi.decode(res, (uint256,uint256,uint256,uint256));
        console2.log("pyRes: ", pyValLo, pyValHi);

        if (solR0 != pyValLo) revert("lower bits different");
        if (solR1 != pyValHi) revert("higher bits different");
    }
}
