/// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/console2.sol";
import "forge-std/Test.sol";
import {Uint1024} from "src/Uint1024.sol";
import {PythonUtils} from "test/PythonUtils.sol";

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

        string[] memory inputs = _buildFFIDiv512x256In512(a0, a1, b);
        bytes memory res = vm.ffi(inputs);
        console2.logBytes(res);
        (uint pyValLo, uint pyValHi) = abi.decode(res, (uint, uint));
        console2.log("pythonRes:", pyValLo, pyValHi);

        if (solR0 != pyValLo) revert("lower bits different");
        if (solR1 != pyValHi) revert("higher bits different");
    }
}
