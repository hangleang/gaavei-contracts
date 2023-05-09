// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/Staking1155Base.sol";

contract Staking is Staking1155Base {
    constructor(
        uint256 _defaultTimeUnit,
        uint256 _defaultRewardsPerUnitTime,
        address _stakingToken,
        address _rewardToken,
        address _nativeTokenWrapper
    ) Staking1155Base(_defaultTimeUnit, _defaultRewardsPerUnitTime, _stakingToken, _rewardToken, _nativeTokenWrapper) {}

    /**
     *  @dev    Mint ERC20 rewards to the staker. Must override.
     *
     *  @param _staker    Address for which to calculated rewards.
     *  @param _rewards   Amount of tokens to be given out as reward.
     *
     */
    function _mintRewards(address _staker, uint256 _rewards) internal virtual override {
        // Mint or transfer reward-tokens here.
        // e.g.
        //
        IERC20(rewardToken).transfer(_staker, _rewards);
        //
        // OR
        //
        // Use a mintable ERC20, such as thirdweb's `TokenERC20.sol`
        //
        // TokenERC20(rewardToken).mintTo(_staker, _rewards);
        // note: The staking contract should have minter role to mint tokens.
    }
}
