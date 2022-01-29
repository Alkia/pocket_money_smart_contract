// SPDX-License-Identifier: MIT
// Version of solitity in use
// This contract handles time
pragma solidity ^0.8.4;

//In a recent update of Solidity the Integer type variables cannot overflow anymore. Hence, Safemath library not required for subtraction.
//OpenZeppelin contract for hardened security
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Allowance  {
    address public owner;
    uint256 public nextAllowanceTimeDate;

    // Let's migrate to "object coding" to save gas cost
    struct User {
        string name;
        uint allowance;
        uint256 nextAllowanceTimeDate;
        bytes32 city;
        bytes32 state;
        bytes32 country;
        bytes32[] myPicture;
    }
    mapping(address => uint) public allowance;
    // Event for declaring a change in the allowance values
    event AllowanceChanged(address indexed _who, address indexed _byWhom, uint _oldAmount, uint _newAmount);

    constructor() {
            // Note: Choose to accesse state variables via their name and not via e.g. `this.owner`.
            // Indeed, functions can be accessed directly or through `this.f`, but the latter provides an external view
            // to the function. Especially in the constructor, you should not access functions externally, because the function does not exist yet.
            
        //set the owner allowed to modify the contract
        owner = msg.sender;
        // Set the start time
        nextAllowanceTimeDate = block.timestamp + ( 0 days);
    }

    // Setting specific allowance for each non-owner user
    function setAllowance(address _who, uint _amount) public {
            require(isOwner() , "You are not the owner therefore not allowed to set allowances");
            emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
            allowance[_who] = _amount;
    }

    function isOwner() internal view returns(bool) {
            // Check simply the owner's address 
            return owner == msg.sender;
    }
        
    modifier onlyOwnerOrAllowed(uint _amount) {
            require(isOwner() || allowance[msg.sender] >= _amount, "You are not allowed");
            _;
    }

    function showAllowance() public view returns(uint256) {
        // Get the allowance
        return allowance[msg.sender];
    }

    function sendViaCall() public payable {
        // Call returns a boolean value indicating success or failure.
        // This is the current recommended method to use.
        require(block.timestamp >= nextAllowanceTimeDate,"Too early to claim the allowance");
        nextAllowanceTimeDate = block.timestamp + (7 days);
        (bool sent, bytes memory data) = msg.sender.call{value: allowance[msg.sender]}("");       
        require(sent, "Failed to send Ether");
    }

}
