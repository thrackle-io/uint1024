/// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Uint1024} from "src/Uint1024.sol";

/**
 * @title Tester contract for math library Uint1024
 * @dev Useful for gas consumption tests
 * @author @oscarsernarosero @Palmerg4
 */
contract TesterContract {
    using Uint1024 for uint256;

    function mulInverseMod512(uint b0, uint b1) public pure returns (uint inv0, uint inv1) {
        (inv0, inv1) = b0.mulInverseMod512(b1);
    }
}
