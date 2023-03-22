// SPDX-License-Identifier: MIT

//pragma
pragma solidity ^0.8.8;

//imports
import "./PriceConverter.sol";

//error codes
error FundMe__NotOwner();

// interfaces, libraries

//contracts

/**
 * @title A contract for crowd funding
 * @author Rawad Bahsas
 * @notice this contract is to demo a sample funding contract
 * @dev this implements price feeds as our libaray
 */
contract FundMe {
    //Type declorations
    //library to add functionality to uint256
    using PriceConverter for uint256;

    //State variables
    uint256 public constant MINIMUM_USD = 50 * 1e18;
    address[] private s_funders;
    mapping(address => uint256) private s_addressToAmountFunded;
    address private immutable i_owner;
    AggregatorV3Interface private s_priceFeed;

    //Modifiers
    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
        _;
    }

    //Functions
    constructor(address priceFeedAddress) {
        //immutable can only be declared in a constant
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    receive() external payable {
        fund();
    }

    // called when calldata is not blank
    fallback() external payable {
        fund();
    }

    /**
     * @notice this functions funds this contract
     */
    function fund() public payable {
        //want to be able to set a minumum amount in USD
        //require(getConversionRate(msg.value)>= minimumUsd, "didnt sent enough"); //1e18 = 1 * 10^18
        // call oracle or chainlink data feeds
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "didnt sent enough!"
        );
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public payable onlyOwner {
        //reset the index
        for (uint256 i = 0; i < s_funders.length; i++) {
            s_addressToAmountFunded[s_funders[i]] = 0;
        }
        // reset the array
        s_funders = new address[](0);
        // withdraw
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "call failed");
    }

    function cheaperWithdraw() public payable onlyOwner {
        address[] memory funders = s_funders;
        for (uint256 i = 0; i < funders.length; i++) {
            s_addressToAmountFunded[funders[i]] = 0;
        }
        s_funders = new address[](0);
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "call failed");
    }

    //view / pure getters
    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getAddressToAmountFunded(
        address funder
    ) public view returns (uint256) {
        return s_addressToAmountFunded[funder];
    }

    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }
}
