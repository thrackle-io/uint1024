# Uint1024
[Git Source](https://github.com/thrackle-io/uint1024/blob/22ddf238a691a8567c23d473fd67784b1462e5c6/src/Uint1024.sol)


## Functions
### add768x768

Calculates the sum of two uint768. The result is a uint768.


```solidity
function add768x768(uint256 a0, uint256 a1, uint256 a2, uint256 b0, uint256 b1, uint256 b2)
    internal
    pure
    returns (uint256 r0, uint256 r1, uint256 r2);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing the lower bits of the first addend|
|`a1`|`uint256`|A uint256 representing the higher bits of the first addend|
|`a2`|`uint256`|A uint256 representing the highest bits of the first addend|
|`b0`|`uint256`|A uint256 representing the lower bits of the second addend|
|`b1`|`uint256`|A uint256 representing the higher bits of the second addend|
|`b2`|`uint256`|A uint256 representing the highest bits of the second addend|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r0`|`uint256`|The lower bits of the result|
|`r1`|`uint256`|The higher bits of the result|
|`r2`|`uint256`|The highest bits of the result|


### sub768x768

Calculates the difference of two uint768. The result is a uint768.


```solidity
function sub768x768(uint256 a0, uint256 a1, uint256 a2, uint256 b0, uint256 b1, uint256 b2)
    internal
    pure
    returns (uint256 r0, uint256 r1, uint256 r2);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing the lower bits of the minuend|
|`a1`|`uint256`|A uint256 representing the higher bits of the minuend|
|`a2`|`uint256`|A uint256 representing the highest bits of the minuend|
|`b0`|`uint256`|A uint256 representing the lower bits of the subtrahend|
|`b1`|`uint256`|A uint256 representing the higher bits of the subtrahend|
|`b2`|`uint256`|A uint256 representing the highest bits of the subtrahend|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r0`|`uint256`|The lower bits of the result|
|`r1`|`uint256`|The higher bits of the result|
|`r2`|`uint256`|The highest bits of the result|


### mul512x256In768

Calculates the product of a uint512 and uint256. The result is a uint768.

*Used the chinese remainder theoreme*


```solidity
function mul512x256In768(uint256 a0, uint256 a1, uint256 b)
    internal
    pure
    returns (uint256 r0, uint256 r1, uint256 r2);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing the lower bits of the first factor|
|`a1`|`uint256`|A uint256 representing the higher bits of the first factor|
|`b`|`uint256`|A uint256 representing the second factor|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r0`|`uint256`|The lower bits of the result|
|`r1`|`uint256`|The higher bits of the result|
|`r2`|`uint256`|The highest bits of the result|


### mul512x512In1024

Calculates the product of two uint512. The result is a uint1024.

*Used the chinese remainder theoreme*


```solidity
function mul512x512In1024(uint256 a0, uint256 a1, uint256 b0, uint256 b1)
    internal
    pure
    returns (uint256 r0, uint256 r1, uint256 r2, uint256 r3);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing the lower bits of the first factor|
|`a1`|`uint256`|A uint256 representing the higher bits of the first factor|
|`b0`|`uint256`|A uint256 representing the lower bits of the second factor|
|`b1`|`uint256`|A uint256 representing the higher bits of the second factor|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r0`|`uint256`|The lower bits of the result|
|`r1`|`uint256`|The high bits of the result|
|`r2`|`uint256`|The higher bits of the result|
|`r3`|`uint256`|The highest bits of the result|


### mul512x512Mod512

r1
r2
r3


```solidity
function mul512x512Mod512(uint256 a0, uint256 a1, uint256 b0, uint256 b1)
    internal
    pure
    returns (uint256 r0, uint256 r1);
```

### div512x256In512

r1

Calculates the division of a uint512 by a uint256.
The result will be a uint512.

*For a detailed explaination see:
https://www.researchgate.net/publication/235765881_Efficient_long_division_via_Montgomery_multiply*


```solidity
function div512x256In512(uint256 a0, uint256 a1, uint256 b) internal pure returns (uint256 r0, uint256 r1);
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
|`r0`|`uint256`|The lower bits of the result|
|`r1`|`uint256`|The higher bits of the result|


### mulInverseMod512


```solidity
function mulInverseMod512(uint256 b0, uint256 b1) internal pure returns (uint256 inv0, uint256 inv1);
```

### lt768

expansion of the inverse with Hensel's lemma

Checks the minuend(a0-a2) is greater than the right operand(b0-b2)

*Used as an underflow/negative result indicator for subtraction methods*


```solidity
function lt768(uint256 a0, uint256 a1, uint256 a2, uint256 b0, uint256 b1, uint256 b2) internal pure returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing the lower bits of the minuend|
|`a1`|`uint256`|A uint256 representing the high bits of the minuend|
|`a2`|`uint256`|A uint256 representing the higher bits of the minuend|
|`b0`|`uint256`|A uint256 representing the lower bits of the subtrahend|
|`b1`|`uint256`|A uint256 representing the high bits of the subtrahend|
|`b2`|`uint256`|A uint256 representing the higher bits of the subtrahend|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|Returns true if there would be an underflow/negative result|


### lt1024

Checks the minuend(a0-a3) is greater than the right operand(b0-b3)

*Used as an underflow/negative result indicator for subtraction methods*


```solidity
function lt1024(uint256 a0, uint256 a1, uint256 a2, uint256 a3, uint256 b0, uint256 b1, uint256 b2, uint256 b3)
    internal
    pure
    returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing the lower bits of the minuend|
|`a1`|`uint256`|A uint256 representing the high bits of the minuend|
|`a2`|`uint256`|A uint256 representing the higher bits of the minuend|
|`a3`|`uint256`|A uint256 representing the highest bits of the minuend|
|`b0`|`uint256`|A uint256 representing the lower bits of the subtrahend|
|`b1`|`uint256`|A uint256 representing the high bits of the subtrahend|
|`b2`|`uint256`|A uint256 representing the higher bits of the subtrahend|
|`b3`|`uint256`|A uint256 representing the highest bits of the subtrahend|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|Returns true if there would be an underflow/negative result|


### add1024x1024

Calculates the sum of two Uint1024. The result is a Uint1024.


```solidity
function add1024x1024(uint256 a0, uint256 a1, uint256 a2, uint256 a3, uint256 b0, uint256 b1, uint256 b2, uint256 b3)
    internal
    pure
    returns (uint256 r0, uint256 r1, uint256 r2, uint256 r3);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing the lower bits of the first addend|
|`a1`|`uint256`|A uint256 representing the high bits of the first addend|
|`a2`|`uint256`|A uint256 representing the higher bits of the first addend|
|`a3`|`uint256`|A uint256 representing the highest bits of the first addend|
|`b0`|`uint256`|A uint256 representing the lower bits of the second addend|
|`b1`|`uint256`|A uint256 representing the high bits of the second addend|
|`b2`|`uint256`|A uint256 representing the higher bits of the second addend|
|`b3`|`uint256`|A uint256 representing the highest bits of the second addend|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r0`|`uint256`|The lower bits of the result|
|`r1`|`uint256`|The high bits of the result|
|`r2`|`uint256`|The higher bits of the result|
|`r3`|`uint256`|The highest bits of the result|


### sub1024x1024

Calculates the difference of two Uint1024. The result is a Uint1024.


```solidity
function sub1024x1024(uint256 a0, uint256 a1, uint256 a2, uint256 a3, uint256 b0, uint256 b1, uint256 b2, uint256 b3)
    internal
    pure
    returns (uint256 r0, uint256 r1, uint256 r2, uint256 r3);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing the lower bits of the minuend|
|`a1`|`uint256`|A uint256 representing the high bits of the minuend|
|`a2`|`uint256`|A uint256 representing the higher bits of the minuend|
|`a3`|`uint256`|A uint256 representing the highest bits of the minuend|
|`b0`|`uint256`|A uint256 representing the lower bits of the subtrahend|
|`b1`|`uint256`|A uint256 representing the high bits of the subtrahend|
|`b2`|`uint256`|A uint256 representing the higher bits of the subtrahend|
|`b3`|`uint256`|A uint256 representing the highest bits of the subtrahend|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r0`|`uint256`|The lower bits of the result|
|`r1`|`uint256`|The high bits of the result|
|`r2`|`uint256`|The higher bits of the result|
|`r3`|`uint256`|The highest bits of the result|


