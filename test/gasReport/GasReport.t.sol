// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "test/gasReport/GasHelper.sol";
import "src/Uint1024.sol";
import "src/Uint512.sol";
import "src/Uint512Extended.sol";
import "forge-std/Test.sol";
import "forge-std/console2.sol";

contract GasReports is Test, GasHelpers {
    uint256 gasUsed = 0;
    string path = "test/gasReport/GasReport.json";

    function testMeasureGas() public {
        _primer();
        
        _resetGasUsed();
        _add1024x1024GasUsed();
        _writeJson(".Add.add1024x1024");

        _resetGasUsed();
        _add768x768GasUsed();
        _writeJson(".Add.add768x768");

        _resetGasUsed();
        _safeAdd512x512GasUsed();
        _writeJson(".Add.safeAdd512x512");

        _resetGasUsed();
        _add512x512GasUsed();
        _writeJson(".Add.add512x512");

        _resetGasUsed();
        _sub1024x1024GasUsed();
        _writeJson(".Sub.sub1024x1024");

        _resetGasUsed();
        _sub768x768GasUsed();
        _writeJson(".Sub.sub768x768");

        _resetGasUsed();
        _safeSub512x512GasUsed();
        _writeJson(".Sub.safeSub512x512");

        _resetGasUsed();
        _sub512x512GasUsed();
        _writeJson(".Sub.sub512x512");

        _resetGasUsed();
        _mul512x512In1024GasUsed();
        _writeJson(".Mul.mul512x512In1024");

        _resetGasUsed();
        _mul512x512Mod512GasUsed();
        _writeJson(".Mul.mul512x512Mod512");

        _resetGasUsed();
        _mul512x256In768GasUsed();
        _writeJson(".Mul.mul512x256In768");

        _resetGasUsed();
        _safeMul512x256GasUsed();
        _writeJson(".Mul.safeMul512x256");

        _resetGasUsed();
        _mul512x256GasUsed();
        _writeJson(".Mul.mul512x256");

        _resetGasUsed();
        _mul256x256GasUsed();
        _writeJson(".Mul.mul256x256");

        _resetGasUsed();
        _mulInverseMod256GasUsed();
        _writeJson(".Mul.mulInverseMod256");

        _resetGasUsed();
        _div512ByPowerOf2GasUsed();
        _writeJson(".Div.div512ByPowerOf2");

        _resetGasUsed();
        _safeDiv512x256GasUsed();
        _writeJson(".Div.safeDiv512x256");

        _resetGasUsed();
        _div512x256In512GasUsed();
        _writeJson(".Div.div512x256In512");

        _resetGasUsed();
        _div512x256GasUsed();
        _writeJson(".Div.div512x256");

        _resetGasUsed();
        _divRem512x256GasUsed();
        _writeJson(".Div.divRem512x256");

        _resetGasUsed();
        _sqrt256GasUsed();
        _writeJson(".Sqrt.sqrt256");

        _resetGasUsed();
        _sqrt512GasUsed();
        _writeJson(".Sqrt.sqrt512");
    }

    function _add1024x1024GasUsed() internal {
        startMeasuringGas("add1024x1024 - returns uint1024");
        Uint1024.add1024x1024(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // a2
            10000000000000000000000000000, // a3
            10000000000000000000000000000, // b0
            10000000000000000000000000000, // b1
            10000000000000000000000000000, // b2
            10000000000000000000000000000  // b3
        );
        gasUsed = stopMeasuringGas();
    }

    function _add768x768GasUsed() internal {
        startMeasuringGas("add768x768 - returns uint768");
        Uint1024.add768x768(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // a2
            10000000000000000000000000000, // b0
            10000000000000000000000000000, // b1
            10000000000000000000000000000  // b2
        );
        gasUsed = stopMeasuringGas();
    }

    function _safeAdd512x512GasUsed() internal {
        startMeasuringGas("safeAdd512x512 - returns uint512");
        Uint512Extended.safeAdd512x512(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // b0
            10000000000000000000000000000  // b1
        );
        gasUsed = stopMeasuringGas();
    }

    function _add512x512GasUsed() internal {
        startMeasuringGas("add512x512 - returns uint512");
        Uint512.add512x512(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // b0
            10000000000000000000000000000  // b1
        );
        gasUsed = stopMeasuringGas();
    }

    function _sub1024x1024GasUsed() internal {
        startMeasuringGas("sub1024x1024 - returns uint1024");
        Uint1024.sub1024x1024(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // a2
            10000000000000000000000000000, // a3
            10000000000000000000000000000, // b0
            10000000000000000000000000000, // b1
            10000000000000000000000000000, // b2
            10000000000000000000000000000  // b3
        );
        gasUsed = stopMeasuringGas();
    }

    function _sub768x768GasUsed() internal {
        startMeasuringGas("sub768x768 - returns uint768");
        Uint1024.sub768x768(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // a2
            10000000000000000000000000000, // b0
            10000000000000000000000000000, // b1
            10000000000000000000000000000  // b2
        );
        gasUsed = stopMeasuringGas();
    }

    function _safeSub512x512GasUsed() internal {
        startMeasuringGas("safeSub512x512 - returns uint512");
        Uint512Extended.safeSub512x512(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // b0
            10000000000000000000000000000  // b1
        );
        gasUsed = stopMeasuringGas();
    }

    function _sub512x512GasUsed() internal {
        startMeasuringGas("sub512x512 - returns uint512");
        Uint512.sub512x512(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // b0
            10000000000000000000000000000  // b1
        );
        gasUsed = stopMeasuringGas();
    }

    function _mul512x512In1024GasUsed() internal {
        startMeasuringGas("mul512x512In1024 - returns uint1024");
        Uint1024.mul512x512In1024(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // b0
            10000000000000000000000000000  // b1
        );
        gasUsed = stopMeasuringGas();
    }

    function _mul512x512Mod512GasUsed() internal {
        startMeasuringGas("mul512x512Mod512 - returns uint512");
        Uint1024.mul512x512Mod512(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // b0
            10000000000000000000000000000  // b1
        );
        gasUsed = stopMeasuringGas();
    }

    function _mul512x256In768GasUsed() internal {
        startMeasuringGas("mul512x256In768 - returns uint768");
        Uint1024.mul512x256In768(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000  // b
        );
        gasUsed = stopMeasuringGas();
    }

    function _safeMul512x256GasUsed() internal {
        startMeasuringGas("safeMul512x256 - returns uint512");
        Uint512Extended.safeMul512x256(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000  // b
        );
        gasUsed = stopMeasuringGas();
    }

    function _mul512x256GasUsed() internal {
        startMeasuringGas("mul512x256 - returns uint512");
        Uint512.mul512x256(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000  // b
        );
        gasUsed = stopMeasuringGas();
    }

    function _mul256x256GasUsed() internal {
        startMeasuringGas("mul256x256 - returns uint512");
        Uint512.mul256x256(
            10000000000000000000000000000, // a
            10000000000000000000000000000  // b
        );
        gasUsed = stopMeasuringGas();
    }

    function _mulInverseMod256GasUsed() internal {
        startMeasuringGas("mulInverseMod256 - returns uint256");
        Uint512Extended.mulInverseMod256(
            10000000000000000000000000000 // b
        );
        gasUsed = stopMeasuringGas();
    }

    function _safeDiv512x256GasUsed() internal {
        startMeasuringGas("safeDiv512x256 - returns uint256");
        Uint512Extended.safeDiv512x256(
            10000000000000000000000000000, // a0
            1000000000000000000000000000,  // a1
            10000000000000000000000000000  // b
        );
        gasUsed = stopMeasuringGas();
    }

    function _div512ByPowerOf2GasUsed() internal {
        startMeasuringGas("div512ByPowerOf2 - returns uint512 and remainder");
        Uint512Extended.div512ByPowerOf2(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            100                            // b
        );
        gasUsed = stopMeasuringGas();
    }

    function _div512x256GasUsed() internal {
        startMeasuringGas("div512x256 - returns uint256");
        Uint512.div512x256(
            10000000000000000000000000000, // a0
            1000000000000000000000000000,  // a1
            10000000000000000000000000000  // b
        );
        gasUsed = stopMeasuringGas();
    }

    function _divRem512x256GasUsed() internal {
        startMeasuringGas("divRem512x256 - returns uint256");
        Uint512.divRem512x256(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // b
            10000000000000000000000000000  // rem
        );
        gasUsed = stopMeasuringGas();
    }

    function _div512x256In512GasUsed() internal {
        startMeasuringGas("div512x256In512 - returns uint512");
        Uint1024.div512x256In512(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000  // b
        );
        gasUsed = stopMeasuringGas();
    }

    function _sqrt256GasUsed() internal {
        startMeasuringGas("sqrt256 - returns uint256");
        Uint512.sqrt256(
            10000000000000000000000000000 // x
        );
        gasUsed = stopMeasuringGas();
    }

    function _sqrt512GasUsed() internal {
        startMeasuringGas("sqrt512 - returns uint256");
        Uint512.sqrt512(
            10000000000000000000000000000, // a0
            10000000000000000000000000000  // a1
        );
        gasUsed = stopMeasuringGas();
    }

    function _writeJson(string memory obj) internal {
        vm.writeJson(vm.toString(gasUsed), path, obj);
    }

    function _resetGasUsed() internal {
        gasUsed = 0;
    }
}
