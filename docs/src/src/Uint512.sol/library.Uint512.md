# Uint512
[Git Source](https://github.com/thrackle-io/uint1024/blob/22ddf238a691a8567c23d473fd67784b1462e5c6/src/Uint512.sol)

**Author:**
@oscarsernarosero @mpetersoCode55 @cirsteve @Palmerg4

*Ported from https://github.com/SimonSuckut/Solidity_Uint512 functions updated to internal for gas optimization*


## Functions
### mul256x256

Calculates the product of two uint256

This method has been changed from the original Uint512 library: visibility changed from public to internal

*Used the chinese remainder theoreme*


```solidity
function mul256x256(uint256 a, uint256 b) internal pure returns (uint256 r0, uint256 r1);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint256`|A uint256 representing the first factor|
|`b`|`uint256`|A uint256 representing the second factor|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r0`|`uint256`|The result as an uint512. r0 contains the lower bits|
|`r1`|`uint256`|The higher bits of the result|


### mul512x256

Calculates the product of two uint512 and uint256

This method has been changed from the original Uint512 library: visibility changed from public to internal

*Used the chinese remainder theoreme*


```solidity
function mul512x256(uint256 a0, uint256 a1, uint256 b) internal pure returns (uint256 r0, uint256 r1);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing lower bits of the first factor|
|`a1`|`uint256`|A uint256 representing higher bits of the first factor|
|`b`|`uint256`|A uint256 representing the second factor|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r0`|`uint256`|The result as an uint512. r0 contains the lower bits|
|`r1`|`uint256`|The higher bits of the result|


### mulMod256x256

Calculates the product and remainder of two uint256

This method has been changed from the original Uint512 library: visibility changed from public to internal

*Used the chinese remainder theorem*


```solidity
function mulMod256x256(uint256 a, uint256 b, uint256 c) internal pure returns (uint256 r0, uint256 r1, uint256 r2);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint256`|A uint256 representing the first factor|
|`b`|`uint256`|A uint256 representing the second factor|
|`c`|`uint256`||

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r0`|`uint256`|The result as an uint512. r0 contains the lower bits|
|`r1`|`uint256`|The higher bits of the result|
|`r2`|`uint256`|The remainder|


### add512x512

Calculates the sum of two uint512

This method has been changed from the original Uint512 library: visibility changed from public to internal


```solidity
function add512x512(uint256 a0, uint256 a1, uint256 b0, uint256 b1) internal pure returns (uint256 r0, uint256 r1);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing the lower bits of the first addend|
|`a1`|`uint256`|A uint256 representing the higher bits of the first addend|
|`b0`|`uint256`|A uint256 representing the lower bits of the second addend|
|`b1`|`uint256`|A uint256 representing the higher bits of the second addend|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r0`|`uint256`|The result as an uint512. r0 contains the lower bits|
|`r1`|`uint256`|The higher bits of the result|


### sub512x512

Calculates the difference of two uint512

This method has been changed from the original Uint512 library: visibility changed from public to internal


```solidity
function sub512x512(uint256 a0, uint256 a1, uint256 b0, uint256 b1) internal pure returns (uint256 r0, uint256 r1);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing the lower bits of the minuend|
|`a1`|`uint256`|A uint256 representing the higher bits of the minuend|
|`b0`|`uint256`|A uint256 representing the lower bits of the subtrahend|
|`b1`|`uint256`|A uint256 representing the higher bits of the subtrahend|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r0`|`uint256`|The result as an uint512. r0 contains the lower bits|
|`r1`|`uint256`|The higher bits of the result|


### divRem512x256

Calculates the division of a 512 bit unsigned integer by a 256 bit integer. It
requires the remainder to be known and the result must fit in a 256 bit integer

This method has been changed from the original Uint512 library: visibility changed from public to internal

*For a detailed explaination see:
https://www.researchgate.net/publication/235765881_Efficient_long_division_via_Montgomery_multiply*


```solidity
function divRem512x256(uint256 a0, uint256 a1, uint256 b, uint256 rem) internal pure returns (uint256 r);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing the low bits of the nominator|
|`a1`|`uint256`|A uint256 representing the high bits of the nominator|
|`b`|`uint256`|A uint256 representing the denominator|
|`rem`|`uint256`|A uint256 representing the remainder of the devision. The algorithm is cheaper to compute if the remainder is known. The remainder often be retreived cheaply using the mulmod and addmod operations|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r`|`uint256`|The result as an uint256. Result must have at most 256 bit|


### div512x256

Calculates the division of a 512 bit unsigned integer by a 256 bit integer. It
requires the result to fit in a 256 bit integer

This method has been changed from the original Uint512 library: visibility changed from public to internal

*For a detailed explaination see:
https://www.researchgate.net/publication/235765881_Efficient_long_division_via_Montgomery_multiply*


```solidity
function div512x256(uint256 a0, uint256 a1, uint256 b) internal pure returns (uint256 r);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing the low bits of the nominator|
|`a1`|`uint256`|A uint256 representing the high bits of the nominator|
|`b`|`uint256`|A uint256 representing the denominator|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r`|`uint256`|The result as an uint256. Result must have at most 256 bit|


### sqrt256

Calculates the square root of x, rounding down

This method has been changed from the original Uint512 library: visibility changed from public to internal

*Uses the Babylonian method https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method*


```solidity
function sqrt256(uint256 x) internal pure returns (uint256 s);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`x`|`uint256`|The uint256 number for which to calculate the square root|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`s`|`uint256`|The square root as an uint256|


### sqrt512

Calculates the square root of a 512 bit unsigned integer, rounding down

This method has been changed from the original Uint512 library: visibility changed from public to internal

*Uses the Karatsuba Square Root method. See https://hal.inria.fr/inria-00072854/document for details*


```solidity
function sqrt512(uint256 a0, uint256 a1) internal pure returns (uint256 s);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing the low bits of the input|
|`a1`|`uint256`|A uint256 representing the high bits of the input|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`s`|`uint256`|The square root as an uint256. Result has at most 256 bit|


