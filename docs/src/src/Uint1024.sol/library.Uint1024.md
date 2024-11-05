# Uint1024
[Git Source](https://github.com/thrackle-io/uint1024/blob/3fff9207dd27fad1c0078f6e7d4e632ca48ddc2d/src/Uint1024.sol)


## Functions
### add768x768


```solidity
function add768x768(uint256 a0, uint256 a1, uint256 a2, uint256 b0, uint256 b1, uint256 b2)
    internal
    pure
    returns (uint256 r0, uint256 r1, uint256 r2);
```

### sub768x768


```solidity
function sub768x768(uint256 a0, uint256 a1, uint256 a2, uint256 b0, uint256 b1, uint256 b2)
    internal
    pure
    returns (uint256 r0, uint256 r1, uint256 r2);
```

### mul512x256In768


```solidity
function mul512x256In768(uint256 a0, uint256 a1, uint256 b)
    internal
    pure
    returns (uint256 r0, uint256 r1, uint256 r2);
```

### mul512x512In1024


```solidity
function mul512x512In1024(uint256 a0, uint256 a1, uint256 b0, uint256 b1)
    internal
    pure
    returns (uint256 r0, uint256 r1, uint256 r2, uint256 r3);
```

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


```solidity
function div512x256In512(uint256 a0, uint256 a1, uint256 b) internal pure returns (uint256 r0, uint256 r1);
```

### mulInverseMod512


```solidity
function mulInverseMod512(uint256 b0, uint256 b1) internal pure returns (uint256 inv0, uint256 inv1);
```

### lt768

expansion of the inverse with Hensel's lemma


```solidity
function lt768(uint256 a0, uint256 a1, uint256 a2, uint256 b0, uint256 b1, uint256 b2) internal pure returns (bool);
```

