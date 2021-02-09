pragma solidity ^0.6.0;


// File: @openzeppelin/contracts/math/Math.sol

import '@openzeppelin/contracts/math/Math.sol';

// File: @openzeppelin/contracts/math/SafeMath.sol

import '@openzeppelin/contracts/math/SafeMath.sol';

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

// File: @openzeppelin/contracts/utils/Address.sol

import '@openzeppelin/contracts/utils/Address.sol';

// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol

import '@openzeppelin/contracts/token/ERC20/SafeERC20.sol';

// File: contracts/IRewardDistributionRecipient.sol

import '../interfaces/IRewardDistributionRecipient.sol';

contract HTWrapper {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function stake() public virtual payable{
        _totalSupply = _totalSupply.add(msg.value);
        _balances[msg.sender] = _balances[msg.sender].add(msg.value);
    }

    function withdraw(uint256 amount) public virtual {
        _totalSupply = _totalSupply.sub(amount);
        _balances[msg.sender] = _balances[msg.sender].sub(amount);
        address payable addr=msg.sender;
        addr.transfer(amount);
    }
}

contract BYCHTPool is HTWrapper, IRewardDistributionRecipient {
    IERC20 public basisYoloCash;
    uint256 public DURATION = 5 days;
    
    uint256 public starttime;
    uint256 public periodFinish = 0;
    uint256 public rewardRate = 0;
    uint256 public lastUpdateTime;
    uint256 public rewardPerTokenStored;
    uint256 private _contributorReward;
    mapping(address => uint256) public userRewardPerTokenPaid;
    mapping(address => uint256) public rewards;
    mapping(address => uint256) public deposits;

    event RewardAdded(uint256 reward);
    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);

    constructor(
        address basisYoloCash_,
        uint256 starttime_
    ) public {
        basisYoloCash = IERC20(basisYoloCash_);
        starttime = starttime_;
    }

    modifier checkStart() {
        require(block.timestamp >= starttime, 'BYCHRC20Pool: not start');
        _;
    }

    modifier updateReward(address account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = lastTimeRewardApplicable();
        if (account != address(0)) {
            rewards[account] = earned(account);
            userRewardPerTokenPaid[account] = rewardPerTokenStored;
        }
        _;
    }

    function lastTimeRewardApplicable() public view returns (uint256) {
        return Math.min(block.timestamp, periodFinish);
    }

    function rewardPerToken() public view returns (uint256) {
        if (totalSupply() == 0) {
            return rewardPerTokenStored;
        }
        return
            rewardPerTokenStored.add(
                lastTimeRewardApplicable()
                    .sub(lastUpdateTime)
                    .mul(rewardRate)
                    .mul(1e18)
                    .div(totalSupply())
            );
    }

    function earned(address account) public view returns (uint256) {
        return
            balanceOf(account)
                .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
                .div(1e18)
                .add(rewards[account]);
    }

    // stake visibility is public as overriding LPTokenWrapper's stake() function
    function stake()
        public
        payable
        override
        updateReward(msg.sender)
        checkStart
    {
        require(address(msg.sender) == address(tx.origin), "no contract");
        uint256 amount=msg.value;
        require(amount > 0, 'BYCHRC20Pool: Cannot stake 0');
        uint256 newDeposit = deposits[msg.sender].add(amount);
        deposits[msg.sender] = newDeposit;
        super.stake();
        emit Staked(msg.sender, amount);
    }

    function withdraw(uint256 amount)
        public
        override
        updateReward(msg.sender)
        checkStart
    {
        require(address(msg.sender) == address(tx.origin), "no contract");
        require(amount > 0, 'BYCHRC20Pool: Cannot withdraw 0');
        deposits[msg.sender] = deposits[msg.sender].sub(amount);
        super.withdraw(amount);
        emit Withdrawn(msg.sender, amount);
    }

    function exit() external {
        require(address(msg.sender) == address(tx.origin), "no contract");
        withdraw(balanceOf(msg.sender));
        getReward();
    }

    function getReward() public updateReward(msg.sender) checkStart {
        require(address(msg.sender) == address(tx.origin), "no contract");
        uint256 reward = earned(msg.sender);
        if (reward > 0) {
            rewards[msg.sender] = 0;
            basisYoloCash.safeTransfer(msg.sender, reward);
            emit RewardPaid(msg.sender, reward);
        }
    }

    function notifyRewardAmount(uint256 totalReward)
        external
        override
        onlyRewardDistribution
        updateReward(address(0))
    {
        uint256 teamReward = totalReward.div(100).mul(5);
        uint256 reward = totalReward.sub(teamReward);
        _contributorReward = _contributorReward.add(teamReward);

        if (block.timestamp > starttime) {
            if (block.timestamp >= periodFinish) {
                rewardRate = reward.div(DURATION);
            } else {
                uint256 remaining = periodFinish.sub(block.timestamp);
                uint256 leftover = remaining.mul(rewardRate);
                rewardRate = reward.add(leftover).div(DURATION);
            }
            lastUpdateTime = block.timestamp;
            periodFinish = block.timestamp.add(DURATION);
            emit RewardAdded(reward);
        } else {
            rewardRate = reward.div(DURATION);
            lastUpdateTime = starttime;
            periodFinish = starttime.add(DURATION);
            emit RewardAdded(reward);
        }
    }
    
    function contributionFund(address target, uint256 amount) public onlyOwner {
        require(amount > 0, 'BYCHRC20Pool: Cannot withdraw 0');
        _contributorReward = _contributorReward.sub(amount);
        basisYoloCash.safeTransfer(address(target), amount);
    }
}
