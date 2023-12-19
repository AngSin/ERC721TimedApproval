# Context
The vulnerability in the NFTTrader.io contract (https://twitter.com/0xCygaar/status/1736056050816876626) was because of improper reentrancy guards.

However, as NFTs are often programmed to be interacted with by `operators` using the `safeTransferFrom` method, it is possible that such a vulnerability appears again in the future.

Users had to revoke approvals for the NFTtrader contracts to save their assets. However, users should not be held responsible to actively monitor and revoke approval access to their tokens when needed.

# ERC721TimedApproval

An extension on the ERC721 standard. ERC721TimedApproval sets a time limit on an operator's approval for transferring a user's assets when calling `setApprovalForAll`.

The default approval period is set to 1 week in the variable `defaultApprovalTimePeriod`. This can be edited as desired. 
