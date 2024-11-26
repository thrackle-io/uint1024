# Uint512Extended
[Git Source](https://github.com/thrackle-io/uint1024/blob/e5c9bb6e87f25ef73bf152b2545f7cbe81569af1/src/Uint512Extended.sol)

**Author:**
@oscarsernarosero @mpetersoCode55 @cirsteve @Palmerg4


## Functions
### gt512

x > y

*tells if x is greater than y where x and y are 512 bit numbers*


```solidity
function gt512(uint256 x0, uint256 x1, uint256 y0, uint256 y1) internal pure returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`x0`|`uint256`|lower bits of x|
|`x1`|`uint256`|higher bits of x|
|`y0`|`uint256`|lower bits of y|
|`y1`|`uint256`|higher bits of y|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|boolean. True if x > y|


### eq512

x == y

*tells if x is equal to y where x and y are 512 bit numbers*


```solidity
function eq512(uint256 x0, uint256 x1, uint256 y0, uint256 y1) internal pure returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`x0`|`uint256`|lower bits of x|
|`x1`|`uint256`|higher bits of x|
|`y0`|`uint256`|lower bits of y|
|`y1`|`uint256`|higher bits of y|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|boolean. True if x = y|


### ge512

x >= y

*tells if x is greater or equal than y where x and y are 512 bit numbers*


```solidity
function ge512(uint256 x0, uint256 x1, uint256 y0, uint256 y1) internal pure returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`x0`|`uint256`|lower bits of x|
|`x1`|`uint256`|higher bits of x|
|`y0`|`uint256`|lower bits of y|
|`y1`|`uint256`|higher bits of y|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|boolean. True if x >= y|


### lt512

x < y

*tells if x is less than y where x and y are 512 bit numbers*


```solidity
function lt512(uint256 x0, uint256 x1, uint256 y0, uint256 y1) internal pure returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`x0`|`uint256`|lower bits of x|
|`x1`|`uint256`|higher bits of x|
|`y0`|`uint256`|lower bits of y|
|`y1`|`uint256`|higher bits of y|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|boolean. True if x < y|


### div512ByPowerOf2

very useful if a division of a 512 is expected to be also a 512.

*Calculates the division of a 512-bit unsigned integer by a denominator which is
a power of 2. It doesn't require the result to be a uint256.*


```solidity
function div512ByPowerOf2(uint256 a0, uint256 a1, uint8 n)
    internal
    pure
    returns (uint256 r0, uint256 r1, uint256 remainder);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing the low bits of the numerator|
|`a1`|`uint256`|A uint256 representing the high bits of the numerator|
|`n`|`uint8`|the power of 2 that the division will be carried out by (demominator = 2**n).|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r0`|`uint256`|The lower bits of the result|
|`r1`|`uint256`|The higher bits of the result|
|`remainder`|`uint256`|of the division|


### div512x512

*Calculates the division of a 512-bit unsigned integer by a 512-bit. The result will be a uint256.*


```solidity
function div512x512(uint256 a0, uint256 a1, uint256 b0, uint256 b1) internal pure returns (uint256 result);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing the low bits of the numerator|
|`a1`|`uint256`|A uint256 representing the high bits of the numerator|
|`b0`|`uint256`|A uint256 representing the low bits of the denominator|
|`b1`|`uint256`|A uint256 representing the high bits of the denominator|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`result`|`uint256`|result|


### safeMul512x256

block to avoid stack too deep
we find the amount of bits we need to shift in the higher bits of the denominator for it to be 0
d = 2**n;
if b = c * d + e, where e = k * (c * d) then b = c * d * ( 1 + e / (c * d))
if b = c * d * ( 1 + e / (c * d)) then a / b = (( a / d) / c) / (1 + e / (c * d)) where e / (c * d) is neglegibly small
making the whole term close to 1 and therefore an unnecessary step which yields a final computation of a / b = (a / d) / c
a / d
(a / d) / c
However, ignoring e can cause the result to be off by +1 which makes this whole division an approximation.
to make this exact, we need to check if the result is accurate. For this, we simply compute back *a*, and
a correct result must be in the range (a - b) < r*b <= a
our approximation can only be off by +1, which means that if theresult is incorrect, we just need to subtract 1

Calculates the product of two uint512 and uint256 safely

*Used the chinese remainder theorem*


```solidity
function safeMul512x256(uint256 a0, uint256 a1, uint256 b) internal pure returns (uint256 r0, uint256 r1);
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
|`r0`|`uint256`|The result as a uint512. r0 contains the lower bits|
|`r1`|`uint256`|The higher bits of the result|


### safeAdd512x512

Calculates the sum of two uint512 safely


```solidity
function safeAdd512x512(uint256 a0, uint256 a1, uint256 b0, uint256 b1)
    internal
    pure
    returns (uint256 r0, uint256 r1);
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
|`r0`|`uint256`|The result as a uint512. r0 contains the lower bits|
|`r1`|`uint256`|The higher bits of the result|


### safeSub512x512

Calculates the difference of two uint512 safely


```solidity
function safeSub512x512(uint256 a0, uint256 a1, uint256 b0, uint256 b1)
    internal
    pure
    returns (uint256 r0, uint256 r1);
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
|`r0`|`uint256`|The result as a uint512. r0 contains the lower bits|
|`r1`|`uint256`|The higher bits of the result|


### safeDiv512x256

Calculates the division of a 512 bit unsigned integer by a 256 bit integer safely. It
requires the result to fit in a 256 bit integer

*For a detailed explaination see:
https://www.researchgate.net/publication/235765881_Efficient_long_division_via_Montgomery_multiply*


```solidity
function safeDiv512x256(uint256 a0, uint256 a1, uint256 b) internal pure returns (uint256 r);
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


### log2

*calculates the logarithm base 2 of x*


```solidity
function log2(uint256 x) internal pure returns (uint256 n);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`x`|`uint256`|the number to calculate the logarithm base 2 of|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`n`|`uint256`|the result of log2(x)|


