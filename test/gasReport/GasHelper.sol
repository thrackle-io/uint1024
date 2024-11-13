// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract GasHelpers {
    string private checkpointLabel;
    uint256 private checkpointGasLeft = 1; // Start the slot warm.

    event Gas_Log(string _label, uint256 _gasDelta);

    function startMeasuringGas(string memory label) internal virtual {
        checkpointLabel = label;

        checkpointGasLeft = gasleft();
    }

    function stopMeasuringGas() internal virtual returns(uint256){
        uint256 checkpointGasLeft2 = gasleft();

        // Subtract 100 to account for the warm SLOAD in startMeasuringGas.
        uint256 gasDelta = checkpointGasLeft - checkpointGasLeft2 - 100;

        emit Gas_Log(string(abi.encodePacked(checkpointLabel, " Gas")), gasDelta);
        return gasDelta;
    }

    // This primer is needed to warm certain slots before accurate gas measurement can take place. Without this the gas report for the first call will be inflated.
    function _primer() internal {
        startMeasuringGas("Gas Report Primer");
        stopMeasuringGas();
    }
}
