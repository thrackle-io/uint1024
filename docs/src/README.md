# Uint1024

## Getting started

After cloning the repository, run the following command to install the dependencies:

#### Python

First, make sure to have venv installed. If you don't have it installed, run the following command:

*__Note__* _This requires python3 to be installed_

```bash
python3 -m venv .venv
```

Next, create an instance of the virtual environment. There are many ways to do this, but the following command will create a virtual environment in the current directory:

```bash
source .venv/bin/activate
```

Now install the python dependencies:

*__Note__* _These python dependencies are needed for the python implementation of 1024 arithmetic. We use this implementation as a source of truth, one we can check the correctness of the solidity implementation against._

```bash
python3 -m pip install -r requirements.txt
```

#### Node.js

This will install the Prettier package in the current directory.

```bash
npm install
```

#### Foundry

If you dont have foundry installed already, it can be installed by running this command and following the installation instructions:

*__Note__* _The installation documentation for foundry can be found [here](https://book.getfoundry.sh/getting-started/installation)_

```bash
curl -L https://foundry.paradigm.xyz | bash
```

After foundry is installed and a quick foundryup is run, simply install the forge-std library with the following command:

```bash
forge install
```

Once everything is installed, the repo is ready to use locally.

## Usage

This library is intended to be used as an import, similar to how you would import any other library.

```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Uint1024} from "src/Uint1024.sol";
import {Uint512Extended} from "src/Uint512Extended.sol";
import {Uint512} from "src/Uint512.sol";

contract MyContractUsing1024BitArithmetic {
    using Uint1024 for uint256;
    using Uint512Extended for uint256;
    using Uint512 for uint256;

    function myMathFunction(uint256 a0, uint256 a1, uint256 b0, uint256 b1) public {
        (uint256 r0, uint256 r1, uint256 r2, uint256 r3) = a0.mul512x512In1024(a1, b0, b1);
        (r0, r1) = a0.sub512x512(a1, b0, b1);
        (r0, r1) = a0.safeAdd512x512(a1, b0, b1);
        ...
    }
}

```

## Math Theory

The mathematical principles used in the Uint1024 library are not dissimilar to those used in the Uint512 library. Sunzi's theorum, also known as the chinese remainder theorum, was used for our multiplication methods. Hensel's lemma, Montgomery reduction, as well as long division were used for different parts of our division methods. As for our addition and subtraction methods, we used classical algorithms which should be fairly familiar.

## Contribute

If you'd like to contribute, please check out our [contribution guide](./CONTRIBUTORS.md). Please do reach out if you feel something could be improved or done differently, or if you have any related needs that aren't met by this library.

## License

The Uint1024 library is released under the MIT License. Also included in this repo is the Uint512 library by Simon Suckut, which has it's original GPLv3 License. More on the Uint512 library can be found [here](https://github.com/SimonSuckut/Solidity_Uint512).

## Disclaimer

_These smart contracts are being provided as is. Although each fuzz test has run 100,000+ iterations successfully, no guarantee, representation or warranty is being made, express or implied, as to the safety or correctness of the user interface or the smart contracts. They have not been audited and as such there can be no assurance they will work as intended, and users may experience delays, failures, errors, omissions, loss of transmitted information or loss of funds. The creators are not liable for any of the foregoing. Users should proceed with caution and use at their own risk._