// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SimpleDeFiLending is Ownable {
    IERC20 public token; // The token being lent
    uint256 public interestRate; // Annual interest rate (in percentage)
    uint256 public totalDeposits; // Total deposited amount
    uint256 public totalLoans; // Total borrowed amount
    uint256 public totalInterestPaid; // Total interest paid
    uint256 public loanDuration; // Duration of each loan (in seconds)
    
    mapping(address => uint256) public deposits; // User deposits
    mapping(address => uint256) public loans; // User loans

    event DepositMade(address indexed user, uint256 amount);
    event LoanTaken(address indexed user, uint256 amount);
    event LoanRepaid(address indexed user, uint256 amount, uint256 interest);
    event CheckBalance(string text, unit amount);
    
    constructor(
        address _tokenAddress,
        uint256 _initialInterestRate,
        uint256 _initialLoanDuration
    ) {
        token = IERC20(_tokenAddress);
        interestRate = _initialInterestRate;
        loanDuration = _initialLoanDuration;
    }

    function deposit(uint256 amount) external {
        require(amount > 0, "Deposit amount must be greater than zero");
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        
        deposits[msg.sender] += amount;
        totalDeposits += amount;
        
        emit DepositMade(msg.sender, amount);
    }

    function takeLoan(uint256 amount) external {
        require(amount > 0, "Loan amount must be greater than zero");
        require(deposits[msg.sender] >= amount, "Insufficient funds for the loan");
        
        uint256 interest = (amount * interestRate * loanDuration) / (365 days * 100); // Simple interest calculation
        
        loans[msg.sender] += amount;
        deposits[msg.sender] -= amount;
        totalLoans += amount;
        totalInterestPaid += interest;
        
        emit LoanTaken(msg.sender, amount);
    }

    function repayLoan(uint256 amount) external {
        require(amount > 0, "Repayment amount must be greater than zero");
        require(loans[msg.sender] >= amount, "Loan amount exceeds your balance");

        uint256 interest = (loans[msg.sender] * interestRate * loanDuration) / (365 days * 100);
        
        loans[msg.sender] -= amount;
        deposits[msg.sender] += amount;
        totalLoans -= amount;
        
        emit LoanRepaid(msg.sender, amount, interest);
    }

    function getBalance(address user_account) external returns (uint){
    
       string memory data = "User Balance is : ";
       uint user_bal = user_account.balance;
       emit CheckBalance(data, user_bal );
       return (user_bal);

    }
}
