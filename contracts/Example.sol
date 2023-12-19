// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;
import "./ERC721TimedApproval.sol";

contract Example is ERC721TimedApproval {
    constructor() ERC721TimedApproval("EXAMPLE", "EXAMPLE") {
        for (uint256 i = 1; i < 11; i++) {
            super._mint(msg.sender, i);
        }
    }
}