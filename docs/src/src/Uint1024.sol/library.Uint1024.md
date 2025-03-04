# Uint1024
[Git Source](https://github.com/thrackle-io/uint1024/blob/de533978886e948519d62c7bc35e591ac86bf087/src/Uint1024.sol)


## State Variables
### M1
*The following are constants for the multiplication algorithm *B from Knuth. All Mn represent a
modulus which are the mersenne numbers of the powers 245, 247, 248, 249, and 251. The Cij are also
precomputed where Cij is the inverse multiplicative of Mi modulo Mj.*


```solidity
uint256 constant M1 = 56539106072908298546665520023773392506479484700019806659891398441363832831;
```


### M2

```solidity
uint256 constant M2 = 226156424291633194186662080095093570025917938800079226639565593765455331327;
```


### M3

```solidity
uint256 constant M3 = 452312848583266388373324160190187140051835877600158453279131187530910662655;
```


### M4

```solidity
uint256 constant M4 = 904625697166532776746648320380374280103671755200316906558262375061821325311;
```


### M5

```solidity
uint256 constant M5 = 3618502788666131106986593281521497120414687020801267626233049500247285301247;
```


### C12

```solidity
uint256 constant C12 = 75385474763877731395554026698364523341972646266693075546521864588485110441;
```


### C13

```solidity
uint256 constant C13 = 323080606130904563123802971564419385751311341142970323770807991093507616181;
```


### C14

```solidity
uint256 constant C14 = 60308379811102185116443221358691618673578117013354460437217491670788088353;
```


### C15

```solidity
uint256 constant C15 = 3503629684264031706764796669409703561036442988394878177781206658969593704381;
```


### C23

```solidity
uint256 constant C23 = 452312848583266388373324160190187140051835877600158453279131187530910662653;
```


### C24

```solidity
uint256 constant C24 = 301541899055510925582216106793458093367890585066772302186087458353940441769;
```


### C25

```solidity
uint256 constant C25 = 3136035750177313626055047510651964171026062084694431942735309566880980594413;
```


### C34

```solidity
uint256 constant C34 = 904625697166532776746648320380374280103671755200316906558262375061821325309;
```


### C35

```solidity
uint256 constant C35 = 2584644849047236504990423772515355086010490729143762590166463928748060929461;
```


### C45

```solidity
uint256 constant C45 = 1206167596222043702328864427173832373471562340267089208744349833415761767081;
```


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


### add768x768

Calculates the sum of two uint768. The result is a uint768.


```solidity
function add768x768(uint768 memory a, uint768 memory b) internal pure returns (uint768 memory r);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint768`|A uint768 representing the first addend|
|`b`|`uint768`|A uint768 representing the second addend|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r`|`uint768`|The result of the addition|


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


### sub768x768

Calculates the difference of two Uint768. The result is a Uint768.


```solidity
function sub768x768(uint768 memory a, uint768 memory b) internal pure returns (uint768 memory r);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint768`|A uint768 representing the minuend|
|`b`|`uint768`|A uint768 representing the subtrahend|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r`|`uint768`|The 768 result of the subtraction|


### mul512x256In768

Calculates the product of a uint512 and uint256. The result is a uint768.

*Used the chinese remainder theorem*


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


### mul512x256In768

Calculates the product of a uint512 and uint256. The result is a uint768.

*Used the chinese remainder theorem*


```solidity
function mul512x256In768(uint512 memory a, uint256 b) internal pure returns (uint768 memory r);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint512`|A uint512 representing the first factor|
|`b`|`uint256`|A uint256 representing the second factor|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r`|`uint768`|The result of the multiplication|


### mul768x256In1024

Calculates the product of a uint768 and uint256. The result is a uint1024.

*Used the chinese remainder theorem*


```solidity
function mul768x256In1024(uint256 a0, uint256 a1, uint256 a2, uint256 b)
    internal
    pure
    returns (uint256 r0, uint256 r1, uint256 r2, uint256 r3);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing the lower bits of the first factor|
|`a1`|`uint256`|A uint256 representing the middle bits of the first factor|
|`a2`|`uint256`|A uint256 representing the higher bits of the first factor|
|`b`|`uint256`|A uint256 representing the second factor|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r0`|`uint256`|The lowest bits of the result|
|`r1`|`uint256`|The middle-lower bits of the result|
|`r2`|`uint256`|The middle-higher bits of the result|
|`r3`|`uint256`|The highest bits of the result|


### mul728x512In1240Unsafe

a uses the type uint768 for convinience and gas efficieny. However a._2 can only be as large as 216 bits. Same goes for
for the result r which uses a type uint1280, but where r._4 can only be as large as 216 bits.

*Calculates the product of a uint728 and uint512. The result is a uint1240. Use modular multiplication algorithm from Knuth*


```solidity
function mul728x512In1240Unsafe(uint768 memory a, uint512 memory b) internal pure returns (uint1280 memory r);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint768`|A uint 728 number representing one of the factors|
|`b`|`uint512`|A uint512 representing the second factor|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r`|`uint1280`|The result of a*b as a uint1240|


### mul768x256In1024

w5*(m4 + 1)
w5*m4 + w4
(m3 + 1)*(w4*m4 + w4) + w3
w3 + m3*(w4*m4 + w4)
(m2 + 1)*(w3 + m3*(w4*m4 + w4)) + w2
m2*(w3 + m3*(w4*m4 + w4)) + w2
(m1 + 1)*(m2*(w3 + m3*(w4*m4 + w4)) + w2) + w1

Calculates the product of a uint768 and uint256. The result is a uint1024.

*Used the chinese remainder theorem*


```solidity
function mul768x256In1024(uint768 memory a, uint256 b) internal pure returns (uint1024 memory r);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint768`|A uint768 representing the first factor|
|`b`|`uint256`|A uint256 representing the second factor|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r`|`uint1024`|The result of the multiplication|


### mul512x512In1024

Calculates the product of two uint512. The result is a uint1024.

*Used the chinese remainder theorem*


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


### mul512x512In1024

r1
r2
r3

Calculates the product of two uint512. The result is a uint1024.

*Used the chinese remainder theorem*


```solidity
function mul512x512In1024(uint512 memory a, uint512 memory b) internal pure returns (uint1024 memory r);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint512`|A uint512 representing the first factor|
|`b`|`uint512`|A uint512 representing the second factor|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r`|`uint1024`|The result of the multiplication|


### mul512x512Mod512

Used the chinese remainder theorem

*Calculates the product of two uint512 modulo 512. The result is a uint512.*


```solidity
function mul512x512Mod512(uint256 a0, uint256 a1, uint256 b0, uint256 b1)
    internal
    pure
    returns (uint256 r0, uint256 r1);
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


### mul512x512Mod512

r1

Used the chinese remainder theorem

*Calculates the product of two uint512 modulo 512. The result is a uint512.*


```solidity
function mul512x512Mod512(uint512 memory a, uint512 memory b) internal pure returns (uint512 memory r);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint512`|A uint512 representing the first factor|
|`b`|`uint512`|A uint512 representing the second factor|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r`|`uint512`|The result of the multiplication mod512|


### div512x256In512

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


### div512x256In512

Calculates the division of a uint512 by a uint256.
The result will be a uint512.


```solidity
function div512x256In512(uint512 memory a, uint256 b) internal pure returns (uint512 memory r);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint512`|A uint512 representing the nominator|
|`b`|`uint256`|A uint256 representing the denominator|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r`|`uint512`|The result of the division|


### div768x256

Used long division

*Calculates the division of a uint768 by a uint256. The result is a uint768.*


```solidity
function div768x256(uint256 a0, uint256 a1, uint256 a2, uint256 b)
    internal
    pure
    returns (uint256 r0, uint256 r1, uint256 r2);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing the lower bits of the first factor|
|`a1`|`uint256`|A uint256 representing the middle bits of the first factor|
|`a2`|`uint256`|A uint256 representing the higher bits of the first factor|
|`b`|`uint256`|A uint256 representing the divisor|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r0`|`uint256`|The lower bits of the result|
|`r1`|`uint256`|The middle bits of the result|
|`r2`|`uint256`|The higher bits of the result|


### div768x256

Used long division

*Calculates the division of a uint768 by a uint256. The result is a uint768.*


```solidity
function div768x256(uint768 memory a, uint256 b) internal pure returns (uint768 memory r);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint768`|A uint768 representing the first factor|
|`b`|`uint256`|A uint256 representing the divisor|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r`|`uint768`|The result of the division|


### div768x512

*Calculates the division of a 768-bit dividend by a 512-bit divisor. The result will be a uint512.*


```solidity
function div768x512(uint768 memory a, uint512 memory b) internal pure returns (uint512 memory result);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint768`|A uint768 representing the numerator|
|`b`|`uint512`|A uint512 representing the denominator|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`result`|`uint512`|uint512 value|


### _approxDiv768x512

this is a private helper function. It also returns some helper values to make the division exact.

*Calculates the approximation of the division of a 768-bit dividend by a 512-bit divisor. The result will be a uint512.*


```solidity
function _approxDiv768x512(uint768 memory a, uint512 memory b) private pure returns (uint512 memory approxResult);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint768`|A uint768 representing the numerator|
|`b`|`uint512`|A uint512 representing the denominator|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`approxResult`|`uint512`|the approximation of a/b|


### getShiftedBitsDiv768x512

this is a private helper function.

*returns a and b shifted to the right by the amount of bits necessary to make b a uint256 value*


```solidity
function getShiftedBitsDiv768x512(uint768 memory a, uint512 memory b)
    private
    pure
    returns (uint256 bShifted, uint768 memory aShifted);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint768`|A uint768 representing the numerator|
|`b`|`uint512`|A uint512 representing the denominator|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`bShifted`|`uint256`|the denominator shifted to the right by n bits|
|`aShifted`|`uint768`|the numerator shifted to the right by n bits|


### div1024x512

we find the amount of bits we need to shift in the higher bits of the denominator for it to be 0
d = 2**n;
if b = c * d + e, where e = k * (c * d) then b = c * d * ( 1 + e / (c * d))
if b = c * d * ( 1 + e / (c * d)) then a / b = (( a / d) / c) / (1 + e / (c * d)) where e / (c * d) is neglegibly small
making the whole term close to 1 and therefore an unnecessary step which yields a final computation of a / b = (a / d) / c
a / d

*Calculates the division of a 1024-bit dividend by a 512-bit divisor. The result will be a uint512.*


```solidity
function div1024x512(uint1024 memory a, uint512 memory b) internal pure returns (uint768 memory result);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint1024`|A uint1024 representing the numerator|
|`b`|`uint512`|A uint512 representing the denominator|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`result`|`uint768`|uint768 value|


### evaluateDiv1024Accuracy

*evaluates the accuracy of the current result of the division 1024x512, and tries to adjust the result
to make it exact through recursion.*


```solidity
function evaluateDiv1024Accuracy(
    uint256 condition0,
    uint256 condition1,
    uint256 condition2,
    uint256 condition3,
    uint256 condition4,
    uint1024 memory a,
    uint512 memory b,
    uint768 memory _result
) private pure returns (uint768 memory result);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`condition0`|`uint256`|the least significant word of the condition being evaluated|
|`condition1`|`uint256`|the second least significant word of the condition being evaluated|
|`condition2`|`uint256`|the third least significant word of the condition being evaluated|
|`condition3`|`uint256`|the second most significant word of the condition being evaluated|
|`condition4`|`uint256`|the most significant word of the condition being evaluated|
|`a`|`uint1024`|the 1024 numerator|
|`b`|`uint512`|the 512 denominator|
|`_result`|`uint768`|the current result of the division|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`result`|`uint768`|the adjusted result|


### _approxDiv1024x512

this is a private helper function

*Calculates the approximation of the division of a 1024-bit dividend by a 512-bit divisor. The result will be a uint768.*


```solidity
function _approxDiv1024x512(uint1024 memory a, uint512 memory b) private pure returns (uint768 memory approxResult);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint1024`|A uint1024 representing the numerator|
|`b`|`uint512`|A uint512 representing the denominator|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`approxResult`|`uint768`|the approximation of a/b|


### getShiftedBitsDiv1024x512

this is a private helper function.

*returns a and b shifted to the right by the amount of bits necessary to make b a uint256 value*


```solidity
function getShiftedBitsDiv1024x512(uint1024 memory a, uint512 memory b)
    private
    pure
    returns (uint256 bShifted, uint1024 memory aShifted);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint1024`|A uint1024 representing the numerator|
|`b`|`uint512`|A uint512 representing the denominator|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`bShifted`|`uint256`|the denominator shifted to the right by n bits|
|`aShifted`|`uint1024`|the numerator shifted to the right by n bits|


### div1024x256

we find the amount of bits we need to shift in the higher bits of the denominator for it to be 0
d = 2**n;
if b = c * d + e, where e = k * (c * d) then b = c * d * ( 1 + e / (c * d))
if b = c * d * ( 1 + e / (c * d)) then a / b = (( a / d) / c) / (1 + e / (c * d)) where e / (c * d) is neglegibly small
making the whole term close to 1 and therefore an unnecessary step which yields a final computation of a / b = (a / d) / c
a / d

Used long division

*Calculates the division of a uint1024 by a uint256. The result is a uint1024.*


```solidity
function div1024x256(uint256 a0, uint256 a1, uint256 a2, uint256 a3, uint256 b)
    internal
    pure
    returns (uint256 r0, uint256 r1, uint256 r2, uint256 r3);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing the lowest bits of the first factor|
|`a1`|`uint256`|A uint256 representing the middle-lower bits of the first factor|
|`a2`|`uint256`|A uint256 representing the middle-higher bits of the first factor|
|`a3`|`uint256`|A uint256 representing the highest bits of the first factor|
|`b`|`uint256`|A uint256 representing the divisor|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r0`|`uint256`|The lowest bits of the result|
|`r1`|`uint256`|The middle-lower bits of the result|
|`r2`|`uint256`|The middle-higher bits of the result|
|`r3`|`uint256`|The highest bits of the result|


### div1024x256

Used long division

*Calculates the division of a uint1024 by a uint256. The result is a uint1024.*


```solidity
function div1024x256(uint1024 memory a, uint256 b) internal pure returns (uint1024 memory r);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint1024`|A uint1024 representing the first factor|
|`b`|`uint256`|A uint256 representing the divisor|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r`|`uint1024`|The result of the division|


### div768ByPowerOf2

*Calculates the division of a 768-bit unsigned integer by a denominator which is
a power of 2 less than 256.*


```solidity
function div768ByPowerOf2(uint256 a0, uint256 a1, uint256 a2, uint8 n)
    internal
    pure
    returns (uint256 r0, uint256 r1, uint256 r2, uint256 remainder);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing the low bits of the numerator|
|`a1`|`uint256`|A uint256 representing the middle bits of the numerator|
|`a2`|`uint256`|A uint256 representing the high bits of the numerator|
|`n`|`uint8`|the power of 2 that the division will be carried out by (demominator = 2**n).|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r0`|`uint256`|The lower bits of the result|
|`r1`|`uint256`|The middle bits of the result|
|`r2`|`uint256`|The higher bits of the result|
|`remainder`|`uint256`|of the division|


### div1024ByPowerOf2

*Calculates the division of a 768-bit unsigned integer by a denominator which is
a power of 2 less than 256.*


```solidity
function div1024ByPowerOf2(uint256 a0, uint256 a1, uint256 a2, uint256 a3, uint8 n)
    internal
    pure
    returns (uint256 r0, uint256 r1, uint256 r2, uint256 r3, uint256 remainder);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing the low bits of the numerator|
|`a1`|`uint256`|A uint256 representing the middle-lower bits of the numerator|
|`a2`|`uint256`|A uint256 representing the middle-higher bits of the numerator|
|`a3`|`uint256`|A uint256 representing the high bits of the numerator|
|`n`|`uint8`|the power of 2 that the division will be carried out by (demominator = 2**n).|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r0`|`uint256`|The lower bits of the result|
|`r1`|`uint256`|The middle-lower bits of the result|
|`r2`|`uint256`|The middle-higher bits of the result|
|`r3`|`uint256`|The higher bits of the result|
|`remainder`|`uint256`|of the division|


### div1024ByPowerOf2

*Calculates the division of a 1024-bit unsigned integer by a denominator which is
a power of 2 less than 256.*


```solidity
function div1024ByPowerOf2(uint1024 memory a, uint8 n) internal pure returns (uint1024 memory r, uint256 rem);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint1024`|A uint1024 representing the low bits of the numerator|
|`n`|`uint8`|the power of 2 that the division will be carried out by (demominator = 2**n).|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r`|`uint1024`|The result of the division|
|`rem`|`uint256`|The remainder of the division|


### div768ByPowerOf2

*Calculates the division of a 768-bit unsigned integer by a denominator which is
a power of 2 less than 256.*


```solidity
function div768ByPowerOf2(uint768 memory a, uint8 n) internal pure returns (uint768 memory r, uint256 rem);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint768`|A uint768 representing the low bits of the numerator|
|`n`|`uint8`|the power of 2 that the division will be carried out by (demominator = 2**n).|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r`|`uint768`|The result of the division|
|`rem`|`uint256`|The remainder of the division|


### mod768x256

*Calculates *a* modulo *b* where *a* is a 768-bit unsigned integer and *b* is a uint256.*


```solidity
function mod768x256(uint256 a0, uint256 a1, uint256 a2, uint256 b) internal pure returns (uint256 rem);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing the low bits of *a*|
|`a1`|`uint256`|A uint256 representing the middle bits of *a*|
|`a2`|`uint256`|A uint256 representing the high bits of *a*|
|`b`|`uint256`|A uint256 representing the base of the modulo|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`rem`|`uint256`|the modulo of a%b|


### mod768x256

*Calculates *a* modulo *b* where *a* is a 768-bit unsigned integer and *b* is a uint256.*


```solidity
function mod768x256(uint768 memory a, uint256 b) internal pure returns (uint256 rem);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint768`|A uint768 representing *a*|
|`b`|`uint256`|A uint256 representing the base of the modulo|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`rem`|`uint256`|the modulo of a%b|


### mod1024x256

*Calculates *a* modulo *b* where *a* is a 1024-bit unsigned integer and *b* is a uint256.*


```solidity
function mod1024x256(uint256 a0, uint256 a1, uint256 a2, uint256 a3, uint256 b) internal pure returns (uint256 rem);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing the low bits of *a*|
|`a1`|`uint256`|A uint256 representing the middle bits of *a*|
|`a2`|`uint256`|A uint256 representing the high bits of *a*|
|`a3`|`uint256`|A uint256 representing the high bits of *a*|
|`b`|`uint256`|A uint256 representing the base of the modulo|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`rem`|`uint256`|the modulo of a%b|


### mod1024x256

*Calculates *a* modulo *b* where *a* is a 1024-bit unsigned integer and *b* is a uint256.*


```solidity
function mod1024x256(uint1024 memory a, uint256 b) internal pure returns (uint256 rem);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint1024`|A uint1024 representing *a*|
|`b`|`uint256`|A uint256 representing the base of the modulo|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`rem`|`uint256`|the modulo of a%b|


### divRem1024x512In512

it requires to previously know the remainder of the division

*Calculates the division *a* / *b* where *a* is a 1024-bit unsigned integer and *b* is
a uint512.*


```solidity
function divRem1024x512In512(
    uint256 a0,
    uint256 a1,
    uint256 a2,
    uint256 a3,
    uint256 b0,
    uint256 b1,
    uint256 rem0,
    uint256 rem1
) internal pure returns (uint256 r0, uint256 r1);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing the lowest bits of *a*|
|`a1`|`uint256`|A uint256 representing the mid-lower bits of *a*|
|`a2`|`uint256`|A uint256 representing the mid-higher bits of *a*|
|`a3`|`uint256`|A uint256 representing the highest bits of *a*|
|`b0`|`uint256`|A uint256 representing the lower bits of *b*|
|`b1`|`uint256`|A uint256 representing the higher bits of *b*|
|`rem0`|`uint256`|A uint256 representing the lower bits of the remainder of the division|
|`rem1`|`uint256`|A uint256 representing the higher bits of the remainder of the division|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r0`|`uint256`|The lower bits of the result|
|`r1`|`uint256`|The high bits of the result|


### divRem1024x512In512

it requires to previously know the remainder of the division

*Calculates the division *a* / *b* where *a* is a 1024-bit unsigned integer and *b* is
a uint512.*


```solidity
function divRem1024x512In512(uint1024 memory a, uint512 memory b, uint512 memory rem)
    internal
    pure
    returns (uint512 memory r);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint1024`|A uint1024 representing *a*|
|`b`|`uint512`|A uint512 representing *b*|
|`rem`|`uint512`|A uint512 representing the remainder of the division|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r`|`uint512`|The result of the division|


### mulInverseMod512

this is a 512 implementation of the Helsen's lemma and Montgomery reduction.

*Calculates the multiplicative inverse of *b* modulo 2**512 where *b* is a uint512.*


```solidity
function mulInverseMod512(uint256 b0, uint256 b1) internal pure returns (uint256 inv0, uint256 inv1);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`b0`|`uint256`|A uint256 representing the lower bits of *b*|
|`b1`|`uint256`|A uint256 representing the higher bits of *b*|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`inv0`|`uint256`|The lower bits of the inverse|
|`inv1`|`uint256`|The higher bits of the inverse|


### mulInverseMod512

expansion of the inverse with Hensel's lemma

this is a 512 implementation of the Helsen's lemma and Montgomery reduction.

*Calculates the multiplicative inverse of *b* modulo 2**512 where *b* is a uint512.*


```solidity
function mulInverseMod512(uint512 memory b) internal pure returns (uint512 memory r);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`b`|`uint512`|A uint512 representing *b*|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r`|`uint512`|A uint512 representing the inverse|


### lt768

*Checks if a < b where a and b are uint768*


```solidity
function lt768(uint256 a0, uint256 a1, uint256 a2, uint256 b0, uint256 b1, uint256 b2)
    internal
    pure
    returns (bool res);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing the lower bits of a|
|`a1`|`uint256`|A uint256 representing the high bits of a|
|`a2`|`uint256`|A uint256 representing the higher bits of a|
|`b0`|`uint256`|A uint256 representing the lower bits of b|
|`b1`|`uint256`|A uint256 representing the high bits of b|
|`b2`|`uint256`|A uint256 representing the higher bits of b|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`res`|`bool`|Returns true if a < b|


### lt768

Checks if the left opperand is less than the right opperand


```solidity
function lt768(uint768 memory a, uint768 memory b) internal pure returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint768`|A uint768 representing the left operand|
|`b`|`uint768`|A uint768 representing the right operand|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|Returns true if there would be an underflow/negative result|


### gt768

*Checks if a > b where a and b are uint768*


```solidity
function gt768(uint256 a0, uint256 a1, uint256 a2, uint256 b0, uint256 b1, uint256 b2)
    internal
    pure
    returns (bool res);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing the lower bits of a|
|`a1`|`uint256`|A uint256 representing the high bits of a|
|`a2`|`uint256`|A uint256 representing the higher bits of a|
|`b0`|`uint256`|A uint256 representing the lower bits of b|
|`b1`|`uint256`|A uint256 representing the high bits of b|
|`b2`|`uint256`|A uint256 representing the higher bits of b|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`res`|`bool`|Returns true if a > b|


### gt768

Checks if the left opperand is greater than the right opperand


```solidity
function gt768(uint768 memory a, uint768 memory b) internal pure returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint768`|A uint768 representing the left operand|
|`b`|`uint768`|A uint768 representing the right operand|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|Returns true if there would be an overflow result|


### lt1024

Checks the minuend(a0-a3) is greater than the right operand(b0-b3)

*Used as an underflow/negative result indicator for subtraction methods*


```solidity
function lt1024(uint256 a0, uint256 a1, uint256 a2, uint256 a3, uint256 b0, uint256 b1, uint256 b2, uint256 b3)
    internal
    pure
    returns (bool res);
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
|`res`|`bool`|Returns true if there would be an underflow/negative result|


### gt1024

*Checks the a > b where a and b are 1024 bits*


```solidity
function gt1024(uint256 a0, uint256 a1, uint256 a2, uint256 a3, uint256 b0, uint256 b1, uint256 b2, uint256 b3)
    internal
    pure
    returns (bool res);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|A uint256 representing the lower bits of a|
|`a1`|`uint256`|A uint256 representing the high bits of a|
|`a2`|`uint256`|A uint256 representing the higher bits of a|
|`a3`|`uint256`|A uint256 representing the highest bits of a|
|`b0`|`uint256`|A uint256 representing the lower bits of b|
|`b1`|`uint256`|A uint256 representing the high bits of b|
|`b2`|`uint256`|A uint256 representing the higher bits of b|
|`b3`|`uint256`|A uint256 representing the highest bits of b|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`res`|`bool`|Returns true if there would be an underflow/negative result|


### lt1024

Checks if the left opperand is less than the right opperand


```solidity
function lt1024(uint1024 memory a, uint1024 memory b) internal pure returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint1024`|A uint1024 representing the left operand|
|`b`|`uint1024`|A uint1024 representing the right operand|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|Returns true if there would be an underflow/negative result|


### gt1024

Checks if the left opperand is greater than the right opperand


```solidity
function gt1024(uint1024 memory a, uint1024 memory b) internal pure returns (bool);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint1024`|A uint1024 representing the left operand|
|`b`|`uint1024`|A uint1024 representing the right operand|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`bool`|Returns true a > b|


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


### add1024x1024

Calculates the sum of two Uint1024. The result is a Uint1024.


```solidity
function add1024x1024(uint1024 memory a, uint1024 memory b) internal pure returns (uint1024 memory r);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint1024`|A uint1024 representing the one addend|
|`b`|`uint1024`|A uint1024 representing the other addend|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r`|`uint1024`|The 1024 result|


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


### sub1024x1024

Calculates the difference of two Uint1024. The result is a Uint1024.


```solidity
function sub1024x1024(uint1024 memory a, uint1024 memory b) internal pure returns (uint1024 memory r);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint1024`|A uint1024 representing the minuend|
|`b`|`uint1024`|A uint1024 representing the subtrahend|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r`|`uint1024`|The 1024 result|


### sqrt1024

*calculates the square root of a uint1024 number *a**


```solidity
function sqrt1024(uint256 a0, uint256 a1, uint256 a2, uint256 a3) internal pure returns (uint256 s0, uint256 s1);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a0`|`uint256`|the lowest bits of *a*|
|`a1`|`uint256`|the middle lower bits of *a*|
|`a2`|`uint256`|the middle higher bits of *a*|
|`a3`|`uint256`|the highest bits of *a*|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`s0`|`uint256`|the lower bits of the square root of *a*|
|`s1`|`uint256`|the higher bits of the square root of *a*|


### _helperSqrt1024

*helper function for the calculation of the square root of a uint1024*


```solidity
function _helperSqrt1024(uint1024 memory a) private pure returns (uint256 s0, uint256 s1, uint256 s2);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint1024`|the normalized packed version of *a*|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`s0`|`uint256`|the lower bits of the square root of normalized *a*|
|`s1`|`uint256`|the middle bits of the shifted square root of normalized *a*|
|`s2`|`uint256`|the higher bits of the shifted square root of normalized *a*|


### sub1024x1024Modular

Calculates the difference of two Uint1024. The result is a Uint1024.


```solidity
function sub1024x1024Modular(
    uint256 a0,
    uint256 a1,
    uint256 a2,
    uint256 a3,
    uint256 b0,
    uint256 b1,
    uint256 b2,
    uint256 b3
) internal pure returns (uint256 r0, uint256 r1, uint256 r2, uint256 r3);
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


### sub1024x1024Modular

Calculates the difference of two Uint1024. The result is a Uint1024.


```solidity
function sub1024x1024Modular(uint1024 memory a, uint1024 memory b) internal pure returns (uint1024 memory r);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`a`|`uint1024`|A uint1024 representing the minuend|
|`b`|`uint1024`|A uint1024 representing the subtrahend|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`r`|`uint1024`|The 1024 result|


