//SPDX-License-Identifier: MIT
pragma solidity > 0.5.0 <= 0.9.0;

contract encode_decode{

  uint256 constant clearLow  = 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000;
  uint256 constant clearHigh = 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff;
  uint256 constant factor =    0x100000000000000000000000000000000;

     function encodeTokenId(int x, int y) external pure returns (bytes32) {
    return _encodeTokenId(x, y);
  }

  function _encodeTokenId(int x, int y) internal pure returns (bytes32 result) {
    require(
      -1000 < x && x < 1000 && -1000 < y && y < 1000,
      "The coordinates should be inside bounds"
    );
    return _unsafeEncodeTokenId(x, y);
  }

  function _unsafeEncodeTokenId(int x, int y) internal pure returns (bytes32) {
    return bytes32(((uint(x) * factor) & clearLow) | (uint(y) & clearHigh));
  }

  function decodeTokenId(uint value) external pure returns (int, int) {
    return _decodeTokenId(value);
  }

  function _unsafeDecodeTokenId(uint value) internal pure returns (int x, int y) {
    x = expandNegative128BitCast((value & clearLow) >> 128);
    y = expandNegative128BitCast(value & clearHigh);
  }

  function _decodeTokenId(uint value) internal pure returns (int x, int y) {
    (x, y) = _unsafeDecodeTokenId(value);
    require(
      -1000 < x && x < 1000 && -1000 < y && y < 1000,
      "The coordinates should be inside bounds"
    );
  }

  function expandNegative128BitCast(uint value) internal pure returns (int) {
    if (value & (1<<127) != 0) {
      return int(value | clearLow);
    }
    return int(value);
  }
}
