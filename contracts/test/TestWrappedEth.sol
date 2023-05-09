// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "@thirdweb-dev/contracts/interfaces/IWETH.sol";
import "@thirdweb-dev/contracts/base/ERC20Base.sol";

contract TestWrappedEth is ERC20Base {
    event Deposit(address indexed sender, uint256 amount);
    event Withdrawal(address indexed recipient, uint256 amount);

    constructor() ERC20Base("Wrapped Ether", "WETH") {}

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        _mint(msg.sender, msg.value);
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint amount) public {
        require(balanceOf(msg.sender) >= amount, "not enough balance");
        _burn(msg.sender, amount);
        address payable recipient = payable(msg.sender);
        recipient.transfer(amount);
        emit Withdrawal(recipient, amount);
    }

    function withdraw(uint amount, address payable recipient) public {
        require(balanceOf(msg.sender) >= amount, "not enough balance");
        _burn(msg.sender, amount);
        recipient.transfer(amount);
        emit Withdrawal(recipient, amount);
    }
}
