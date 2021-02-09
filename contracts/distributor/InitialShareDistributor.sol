pragma solidity ^0.6.0;

import '@openzeppelin/contracts/math/SafeMath.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

import '../interfaces/IDistributor.sol';
import '../interfaces/IRewardDistributionRecipient.sol';

contract InitialShareDistributor is IDistributor {
    using SafeMath for uint256;

    event Distributed(address pool, uint256 cashAmount);

    bool public once = true;

    IERC20 public share;
    IRewardDistributionRecipient[] public daibacLPPool;
    uint256[] public daibacInitialBalance;
    IRewardDistributionRecipient[] public daibasLPPool;
    uint256[] public daibasInitialBalance;

    constructor(
        IERC20 _share,
        IRewardDistributionRecipient[] memory _daibacLPPool,
        uint256[] memory _daibacInitialBalance,
        IRewardDistributionRecipient[] memory _daibasLPPool,
        uint256[] memory _daibasInitialBalance
    ) public {
        share = _share;
        daibacLPPool = _daibacLPPool;
        daibacInitialBalance = _daibacInitialBalance;
        daibasLPPool = _daibasLPPool;
        daibasInitialBalance = _daibasInitialBalance;
    }

    function distribute() public override {
        require(
            once,
            'InitialShareDistributor: you cannot run this function twice'
        );

        for (uint256 i = 0; i < daibacLPPool.length; i++) {
            share.transfer(address(daibacLPPool[i]), daibacInitialBalance[i]);
            daibacLPPool[i].notifyRewardAmount(daibacInitialBalance[i]);
            emit Distributed(address(daibacLPPool[i]), daibacInitialBalance[i]);
        }

        for (uint256 i = 0; i < daibasLPPool.length; i++) {
            share.transfer(address(daibasLPPool[i]), daibasInitialBalance[i]);
            daibasLPPool[i].notifyRewardAmount(daibasInitialBalance[i]);
            emit Distributed(address(daibasLPPool[i]), daibasInitialBalance[i]);
        }

        once = false;
    }
}
