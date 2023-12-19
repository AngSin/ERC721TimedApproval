// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

abstract contract ERC721TimedApproval is ERC721 {
    uint256 public defaultApprovalTimePeriod = 1 weeks;
    mapping(address owner => mapping(address operator => uint256)) private _operatorApprovalTimestamps;
    mapping(address owner => mapping(address operator => uint256)) private _operatorApprovalTimePeriods;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {}

    /**
     * @dev See {IERC721TimedApproval-setOperatorApprovalTimePeriod}.
     */
    function setOperatorApprovalTimePeriod(address operator, uint256 timePeriod) public {
        _operatorApprovalTimePeriods[msg.sender][operator] = timePeriod;
    }

    /**
     * @dev See {IERC721-isApprovedForAll}.
     */
    function isApprovedForAll(address owner, address operator) public view override virtual returns (bool) {
        uint256 approvalTimePeriod = defaultApprovalTimePeriod;
        uint256 operatorApprovalTimePeriod = _operatorApprovalTimePeriods[owner][operator];
        if (operatorApprovalTimePeriod > 0) {
            approvalTimePeriod = operatorApprovalTimePeriod;
        }
        return _operatorApprovalTimestamps[owner][operator] + approvalTimePeriod > block.timestamp;
    }

    /**
     * @dev Approve `operator` to operate on all of `owner` tokens
     *
     * Requirements:
     * - operator can't be the address zero.
     *
     * Emits an {ApprovalForAll} event.
     */
    function _setApprovalForAll(address owner, address operator, bool approved) internal override virtual {
        if (operator == address(0)) {
            revert ERC721InvalidOperator(operator);
        }
        if (approved) {
            _operatorApprovalTimestamps[owner][operator] = block.timestamp;
        } else {
            _operatorApprovalTimestamps[owner][operator] = 0;
        }
        emit ApprovalForAll(owner, operator, approved);
    }
}