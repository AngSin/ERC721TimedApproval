// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IERC721TimedApproval is IERC721 {
    /**
    * @dev Set how long an approval should last for an `operator` to be able ot move assets of the caller.
    *
    */
    function setOperatorApprovalTimePeriod(address operator, bool approved) external;
}