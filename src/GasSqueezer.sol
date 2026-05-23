// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SoulCodeGasSqueezer {

    function disperseERC20(address token, address[] calldata recipients, uint256[] calldata values) external {
        assembly {
            
            let recLength := calldataload(recipients.offset)
            let valLength := calldataload(values.offset)
            
            
            if iszero(eq(recLength, valLength)) {
                revert(0, 0)
            }
            
        
            let recipientsOffset := add(recipients.offset, 0x20)
            let valuesOffset := add(values.offset, 0x20)
            
            
            let ptr := mload(0x40)
            
            
            mstore(ptr, 0x23b872dd00000000000000000000000000000000000000000000000000000000)
            
            mstore(add(ptr, 0x04), caller())
            
            
            for { let i := 0 } lt(i, recLength) { i := add(i, 1) } {
                
                
                let rec := calldataload(add(recipientsOffset, mul(i, 0x20)))
                let val := calldataload(add(valuesOffset, mul(i, 0x20)))
                
            
                mstore(add(ptr, 0x24), rec)
            
                
                mstore(add(ptr, 0x44), val)
                
                let success := call(gas(), token, 0, ptr, 0x64, 0, 0)
                
                
                if iszero(success) {
                    revert(0, 0)
                }
            }
        }
    }
}
