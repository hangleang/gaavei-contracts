// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC20Base.sol";

contract TestRewardToken is ERC20Base {
    constructor() ERC20Base("TestRewardToken", "TRT") {}
}
