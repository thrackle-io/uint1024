// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../gasReport/GasHelper.sol";
import "../../src/Uint1024.sol";
import "../../src/Uint512.sol";
import "../../src/Uint512Extended.sol";
import "forge-std/Test.sol";
import "forge-std/console2.sol";

contract GasReports is Test, GasHelpers {
    uint256 gasUsed = 0;
    string path = "test/gasReport/GasReport.json";

    // When compiling via ir, yul is highly optimized. Because of this, the gas report will be different when compiling via-ir.
    // Note: Compiling via-ir will increase compile times and could create some inefficiencies in solidity code.
    // The gas savings from the highly optimized yul may negate the solidity inefficiencies.

    // To run the gas report when compiling via-ir, comment out the previous setting of the path variable and use the path below:
    //string path = "test/gasReport/GasReportViaIr.json";

    function testMeasureGas() public {
        _primer();

        _add1024x1024GasUsed();

        _sqrt1024x1024GasUsed();

        _add768x768GasUsed();

        _safeAdd512x512GasUsed();

        _add512x512GasUsed();

        _sub1024x1024GasUsed();

        _sub768x768GasUsed();

        _safeSub512x512GasUsed();

        _sub512x512GasUsed();

        _mul512x512In1024GasUsed();

        _mul512x512Mod512GasUsed();

        _mul512x256In768GasUsed();

        _safeMul512x256GasUsed();

        _mul512x256GasUsed();

        _mul768x256In1024GasUsed();

        _mul256x256GasUsed();

        _mulMod256x256GasUsed();

        _mulInverseMod256GasUsed();

        _mulInverseMod512GasUsed();

        _div512ByPowerOf2GasUsed();

        _safeDiv512x256GasUsed();

        _div512x256In512GasUsed();

        _div512x256GasUsed();

        _div1024x256GasUsed();

        _divRem512x256GasUsed();

        _sqrt256GasUsed();

        _sqrt512GasUsed();

        _div768x256GasUsed();

        _div768x512GasUsed();

        _div768ByPowerOf2GasUsed();

        _mod768x256GasUsed();

        _mod1024x256GasUsed();

        _divRem1024x512In512GasUsed();

        _div512x512GasUsed();

        _log2GasUsed();
    }

    function _sqrt1024x1024GasUsed() internal {
        _resetGasUsed();

        uint1024 memory a = solR1024;

        startMeasuringGas("sqrt1024 returns 512");
        Uint1024.sqrt1024(a._0, a._1, a._2, a._3);
        gasUsed = stopMeasuringGas();
        _writeJson(".Sqrt.sqrt1024");
    }

    function _add1024x1024GasUsed() internal {
        _resetGasUsed();

        uint1024 memory a = solR1024;
        uint1024 memory b = solR1024;

        startMeasuringGas("add1024x1024 using structs - returns uint1024 struct");
        Uint1024.add1024x1024(a, b);
        gasUsed = stopMeasuringGas();
        _writeJson(".Add.add1024x1024Structs");
        _resetGasUsed();

        startMeasuringGas("add1024x1024 - returns uint1024");
        Uint1024.add1024x1024(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // a2
            10000000000000000000000000000, // a3
            10000000000000000000000000000, // b0
            10000000000000000000000000000, // b1
            10000000000000000000000000000, // b2
            10000000000000000000000000000 // b3
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Add.add1024x1024");
    }

    function _add768x768GasUsed() internal {
        _resetGasUsed();

        uint768 memory a = solR768;
        uint768 memory b = solR768;

        startMeasuringGas("add768x768 using structs - returns uint768 struct");
        Uint1024.add768x768(a, b);
        gasUsed = stopMeasuringGas();
        _writeJson(".Add.add768x768Structs");
        _resetGasUsed();

        startMeasuringGas("add768x768 - returns uint768");
        Uint1024.add768x768(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // a2
            10000000000000000000000000000, // b0
            10000000000000000000000000000, // b1
            10000000000000000000000000000 // b2
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Add.add768x768");
    }

    function _div768x256GasUsed() internal {
        _resetGasUsed();

        uint768 memory a = solR768;
        uint256 b = 10000000000000000000000000000;

        startMeasuringGas("div768x256 using structs - returns uint768 struct");
        Uint1024.div768x256(a, b);
        gasUsed = stopMeasuringGas();
        _writeJson(".Div.div768x256Structs");
        _resetGasUsed();

        startMeasuringGas("div768x256 - returns uint768");
        Uint1024.div768x256(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // a2
            10000000000000000000000000000 // b
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Div.div768x256");
    }

    function _div768x512GasUsed() internal {
        _resetGasUsed();
        uint768 memory a = uint768(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000 // a2
        );
        uint512 memory b = uint512(
            10000000000000000000000000000, // b0
            10000000000000000000000000000 // b1
        );
        startMeasuringGas("div768x512 - returns uint512");
        Uint1024.div768x512(a, b);
        gasUsed = stopMeasuringGas();
        _writeJson(".Div.div768x512");
    }

    function _div768ByPowerOf2GasUsed() internal {
        _resetGasUsed();

        uint768 memory a = solR768;
        uint8 n = 100;

        startMeasuringGas("div768ByPowerOf2 using structs - returns uint768 struct");
        Uint1024.div768ByPowerOf2(a, n);
        gasUsed = stopMeasuringGas();
        _writeJson(".Div.div768ByPowerOf2Structs");
        _resetGasUsed();

        startMeasuringGas("div768ByPowerOf2 - returns uint768");
        Uint1024.div768ByPowerOf2(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // a2
            100 // n
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Div.div768ByPowerOf2");
    }

    function _mod768x256GasUsed() internal {
        _resetGasUsed();

        uint768 memory a = solR768;
        uint256 b = 10000000000000000000000000000;

        startMeasuringGas("mod768x256 using structs - returns uint256");
        Uint1024.mod768x256(a, b);
        gasUsed = stopMeasuringGas();
        _writeJson(".Mod.mod768x256Structs");
        _resetGasUsed();

        startMeasuringGas("mod768x256 - returns uint256");
        Uint1024.mod768x256(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // a2
            10000000000000000000000000000 // b
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Mod.mod768x256");
    }

    function _mod1024x256GasUsed() internal {
        _resetGasUsed();

        uint1024 memory a = solR1024;
        uint256 b = 10000000000000000000000000000;

        startMeasuringGas("mod1024x256 using structs - returns uint256");
        Uint1024.mod1024x256(a, b);
        gasUsed = stopMeasuringGas();
        _writeJson(".Mod.mod1024x256Structs");
        _resetGasUsed();

        startMeasuringGas("mod1024x256 - returns uint256");
        Uint1024.mod1024x256(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // a2
            10000000000000000000000000000, // a3
            10000000000000000000000000000 // b0
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Mod.mod1024x256");
    }

    function _divRem1024x512In512GasUsed() internal {
        _resetGasUsed();

        uint1024 memory a = solR1024;
        uint512 memory b = solR512;
        uint512 memory rem = uint512(1, 1);

        startMeasuringGas("divRem1024x512In512 using structs - returns uint512 struct");
        Uint1024.divRem1024x512In512(a, b, rem);
        gasUsed = stopMeasuringGas();
        _writeJson(".Div.divRem1024x512In512Structs");
        _resetGasUsed();

        startMeasuringGas("divRem1024x512In512 - returns uint512");
        Uint1024.divRem1024x512In512(
            101, // a0
            1010, // a1
            90, // a2
            0, // a3
            1, // b0
            10, // b1
            1, // rem0
            1 // rem1
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Div.divRem1024x512In512");
    }

    function _div512x512GasUsed() internal {
        _resetGasUsed();

        uint512 memory a = solR512;
        uint512 memory b = solR512;

        startMeasuringGas("div512x512 using structs - returns uint256");
        Uint512Extended.div512x512(a, b);
        gasUsed = stopMeasuringGas();
        _writeJson(".Div.div512x512Structs");
        _resetGasUsed();

        startMeasuringGas("div512x512 - returns uint256");
        Uint512Extended.div512x512(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // b0
            10000000000000000000000000000 // b1
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Div.div512x512");
    }

    function _log2GasUsed() internal {
        _resetGasUsed();

        startMeasuringGas("log2 - returns uint256");
        Uint512Extended.log2(
            10000000000000000000000000000 // x
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Log.log2");
    }

    function _safeAdd512x512GasUsed() internal {
        _resetGasUsed();

        uint512 memory a = solR512;
        uint512 memory b = solR512;

        startMeasuringGas("safeAdd512x512 using structs - returns uint512 struct");
        Uint512Extended.safeAdd512x512(a, b);
        gasUsed = stopMeasuringGas();
        _writeJson(".Add.safeAdd512x512Structs");
        _resetGasUsed();

        startMeasuringGas("safeAdd512x512 - returns uint512");
        Uint512Extended.safeAdd512x512(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // b0
            10000000000000000000000000000 // b1
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Add.safeAdd512x512");
    }

    function _add512x512GasUsed() internal {
        _resetGasUsed();

        startMeasuringGas("add512x512 - returns uint512");
        Uint512.add512x512(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // b0
            10000000000000000000000000000 // b1
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Add.add512x512");
    }

    function _sub1024x1024GasUsed() internal {
        _resetGasUsed();

        uint1024 memory a = solR1024;
        uint1024 memory b = solR1024;

        startMeasuringGas("sub1024x1024 using structs - returns uint1024 struct");
        Uint1024.sub1024x1024(a, b);
        gasUsed = stopMeasuringGas();
        _writeJson(".Sub.sub1024x1024Structs");
        _resetGasUsed();

        startMeasuringGas("sub1024x1024 - returns uint1024");
        Uint1024.sub1024x1024(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // a2
            10000000000000000000000000000, // a3
            10000000000000000000000000000, // b0
            10000000000000000000000000000, // b1
            10000000000000000000000000000, // b2
            10000000000000000000000000000 // b3
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Sub.sub1024x1024");
    }

    function _sub768x768GasUsed() internal {
        _resetGasUsed();

        uint768 memory a = solR768;
        uint768 memory b = solR768;

        startMeasuringGas("sub768x768 using structs - returns uint768 struct");
        Uint1024.sub768x768(a, b);
        gasUsed = stopMeasuringGas();
        _writeJson(".Sub.sub768x768Structs");
        _resetGasUsed();

        startMeasuringGas("sub768x768 - returns uint768");
        Uint1024.sub768x768(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // a2
            10000000000000000000000000000, // b0
            10000000000000000000000000000, // b1
            10000000000000000000000000000 // b2
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Sub.sub768x768");
    }

    function _safeSub512x512GasUsed() internal {
        _resetGasUsed();

        uint512 memory a = solR512;
        uint512 memory b = solR512;

        startMeasuringGas("safeSub512x512 using structs - returns uint512 struct");
        Uint512Extended.safeSub512x512(a, b);
        gasUsed = stopMeasuringGas();
        _writeJson(".Sub.safeSub512x512Structs");
        _resetGasUsed();

        startMeasuringGas("safeSub512x512 - returns uint512");
        Uint512Extended.safeSub512x512(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // b0
            10000000000000000000000000000 // b1
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Sub.safeSub512x512");
    }

    function _sub512x512GasUsed() internal {
        _resetGasUsed();

        startMeasuringGas("sub512x512 - returns uint512");
        Uint512.sub512x512(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // b0
            10000000000000000000000000000 // b1
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Sub.sub512x512");
    }

    function _mul512x512In1024GasUsed() internal {
        _resetGasUsed();

        uint512 memory a = solR512;
        uint512 memory b = solR512;

        startMeasuringGas("mul512x512In1024 using structs - returns uint1024 struct");
        Uint1024.mul512x512In1024(a, b);
        gasUsed = stopMeasuringGas();
        _writeJson(".Mul.mul512x512In1024Structs");
        _resetGasUsed();

        startMeasuringGas("mul512x512In1024 - returns uint1024");
        Uint1024.mul512x512In1024(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // b0
            10000000000000000000000000000 // b1
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Mul.mul512x512In1024");
    }

    function _mul512x512Mod512GasUsed() internal {
        _resetGasUsed();

        uint512 memory a = solR512;
        uint512 memory b = solR512;

        startMeasuringGas("mul512x512Mod512 using structs - returns uint512 struct");
        Uint1024.mul512x512Mod512(a, b);
        gasUsed = stopMeasuringGas();
        _writeJson(".Mul.mul512x512Mod512Structs");
        _resetGasUsed();

        startMeasuringGas("mul512x512Mod512 - returns uint512");
        Uint1024.mul512x512Mod512(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // b0
            10000000000000000000000000000 // b1
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Mul.mul512x512Mod512");
    }

    function _mul512x256In768GasUsed() internal {
        _resetGasUsed();

        uint512 memory a = solR512;

        startMeasuringGas("mul512x256In768 using structs - returns uint768 struct");
        Uint1024.mul512x256In768(a, 10000000000000000000000000000);
        gasUsed = stopMeasuringGas();
        _writeJson(".Mul.mul512x256In768Structs");
        _resetGasUsed();

        startMeasuringGas("mul512x256In768 - returns uint768");
        Uint1024.mul512x256In768(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000 // b
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Mul.mul512x256In768");
    }

    function _safeMul512x256GasUsed() internal {
        _resetGasUsed();

        uint512 memory a = solR512;

        startMeasuringGas("safeMul512x256 using structs - returns uint512 struct");
        Uint512Extended.safeMul512x256(a, 10000000000000000000000000000);
        gasUsed = stopMeasuringGas();
        _writeJson(".Mul.safeMul512x256Structs");
        _resetGasUsed();

        startMeasuringGas("safeMul512x256 - returns uint512");
        Uint512Extended.safeMul512x256(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000 // b
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Mul.safeMul512x256");
    }

    function _mul512x256GasUsed() internal {
        _resetGasUsed();
        startMeasuringGas("mul512x256 - returns uint512");
        Uint512.mul512x256(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000 // b
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Mul.mul512x256");
    }

    function _mul768x256In1024GasUsed() internal {
        _resetGasUsed();

        uint768 memory a = solR768;

        startMeasuringGas("mul768x256 using structs - returns uint1024 struct");
        Uint1024.mul768x256In1024(a, 10000000000000000000000000000);
        gasUsed = stopMeasuringGas();
        _writeJson(".Mul.mul768x256Structs");
        _resetGasUsed();

        startMeasuringGas("mul768x256 - returns uint1024");
        Uint1024.mul768x256In1024(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // a2
            10000000000000000000000000000 // b
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Mul.mul768x256In1024");
    }

    function _mul256x256GasUsed() internal {
        _resetGasUsed();
        startMeasuringGas("mul256x256 - returns uint512");
        Uint512.mul256x256(
            10000000000000000000000000000, // a
            10000000000000000000000000000 // b
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Mul.mul256x256");
    }

    function _mulMod256x256GasUsed() internal {
        _resetGasUsed();
        startMeasuringGas("mulMod256x256 - returns uint512 and rem");
        Uint512.mulMod256x256(
            10000000000000000000000000000, // a
            10000000000000000000000000000, // b
            10000000000000000000000000000 // c
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Mul.mulMod256x256");
    }

    function _mulInverseMod256GasUsed() internal {
        _resetGasUsed();
        startMeasuringGas("mulInverseMod256 - returns uint256");
        Uint512.mulInverseMod256(
            10000000000000000000000000000 // b
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Mul.mulInverseMod256");
    }

    function _mulInverseMod512GasUsed() internal {
        _resetGasUsed();

        uint512 memory b = solR512;
        b._0 += 1;

        startMeasuringGas("mulInverseMod512 using structs - returns uint512 struct");
        Uint1024.mulInverseMod512(b);
        gasUsed = stopMeasuringGas();
        _writeJson(".Mul.mulInverseMod512Structs");
        _resetGasUsed();

        startMeasuringGas("mulInverseMod512 - returns uint512");
        Uint1024.mulInverseMod512(
            10000000000000000000000000001, // b0
            10000000000000000000000000000 // b1
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Mul.mulInverseMod512");
    }

    function _div512ByPowerOf2GasUsed() internal {
        _resetGasUsed();

        uint512 memory a = solR512;

        startMeasuringGas("div512ByPowerOf2 using structs - returns uint512 struct and remainder");
        Uint512Extended.div512ByPowerOf2(a, 100);
        gasUsed = stopMeasuringGas();
        _writeJson(".Div.div512ByPowerOf2Structs");
        _resetGasUsed();

        startMeasuringGas("div512ByPowerOf2 - returns uint512 and remainder");
        Uint512Extended.div512ByPowerOf2(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            100 // b
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Div.div512ByPowerOf2");
    }

    function _safeDiv512x256GasUsed() internal {
        _resetGasUsed();

        uint512 memory a = solR512;
        a._1 = 1000000000000000000000000000;

        startMeasuringGas("safeDiv512x256 using structs - returns uint256");
        Uint512Extended.safeDiv512x256(a, 10000000000000000000000000000);
        gasUsed = stopMeasuringGas();
        _writeJson(".Div.safeDiv512x256Structs");
        _resetGasUsed();

        startMeasuringGas("safeDiv512x256 - returns uint256");
        Uint512Extended.safeDiv512x256(
            10000000000000000000000000000, // a0
            1000000000000000000000000000, // a1
            10000000000000000000000000000 // b
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Div.safeDiv512x256");
    }

    function _div512x256GasUsed() internal {
        _resetGasUsed();
        startMeasuringGas("div512x256 - returns uint256");
        Uint512.div512x256(
            10000000000000000000000000000, // a0
            1000000000000000000000000000, // a1
            10000000000000000000000000000 // b
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Div.div512x256");
    }

    function _div1024x256GasUsed() internal {
        _resetGasUsed();

        uint1024 memory a = solR1024;

        startMeasuringGas("div1024x256 using structs - returns uint1024 struct");
        Uint1024.div1024x256(a, 10000000000000000000000000000);
        gasUsed = stopMeasuringGas();
        _writeJson(".Div.div1024x256Structs");
        _resetGasUsed();

        startMeasuringGas("div1024x256 - returns uint1024");
        Uint1024.div1024x256(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // a2
            10000000000000000000000000000, // a3
            10000000000000000000000000000 // b
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Div.div1024x256");
    }

    function _divRem512x256GasUsed() internal {
        _resetGasUsed();
        startMeasuringGas("divRem512x256 - returns uint256");
        Uint512.divRem512x256(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000, // b
            10000000000000000000000000000 // rem
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Div.divRem512x256");
    }

    function _div512x256In512GasUsed() internal {
        _resetGasUsed();

        uint512 memory a = solR512;

        startMeasuringGas("div512x256In512 using structs - returns uint512 struct");
        Uint1024.div512x256In512(a, 10000000000000000000000000000);
        gasUsed = stopMeasuringGas();
        _writeJson(".Div.div512x256In512Structs");
        _resetGasUsed();

        startMeasuringGas("div512x256In512 - returns uint512");
        Uint1024.div512x256In512(
            10000000000000000000000000000, // a0
            10000000000000000000000000000, // a1
            10000000000000000000000000000 // b
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Div.div512x256In512");
    }

    function _sqrt256GasUsed() internal {
        _resetGasUsed();
        startMeasuringGas("sqrt256 - returns uint256");
        Uint512.sqrt256(
            10000000000000000000000000000 // x
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Sqrt.sqrt256");
    }

    function _sqrt512GasUsed() internal {
        _resetGasUsed();
        startMeasuringGas("sqrt512 - returns uint256");
        Uint512.sqrt512(
            10000000000000000000000000000, // a0
            10000000000000000000000000000 // a1
        );
        gasUsed = stopMeasuringGas();
        _writeJson(".Sqrt.sqrt512");
    }

    function _writeJson(string memory obj) internal {
        vm.writeJson(vm.toString(gasUsed), path, obj);
    }

    function _resetGasUsed() internal {
        gasUsed = 0;
    }
}
