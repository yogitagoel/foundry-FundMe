// SPDX-License-Identifier:MIT
pragma solidity ^0.8.28;

import {PriceConvertor} from "./PriceConverter.sol";

error Notowner();

contract fundMe {
    using PriceConvertor for uint256;

    uint public constant minUsd = 5e18;

    address[] public funders;
    mapping(address funder => uint256 amountFunded)
        public addressToAmountFunded;

    address public immutable owner;

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate() >= minUsd,
            "Didn't send minimum eth"
        );
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] =
            addressToAmountFunded[msg.sender] +
            msg.value;
    }

    function withdraw() public onlyOwner {
        for (
            uint256 funderindex = 0;
            funderindex < funders.length;
            funderindex++
        ) {
            address funder = funders[funderindex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
        //transfer
        // payable(msg.sender).transfer(address(this).balance);
        //send
        // bool sendSuccess=payable(msg.sender).send(address(this).balance);
        // require(sendSuccess,"Send failde");
        //call
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
        revert();
    }

    modifier onlyOwner() {
        //require(msg.sender==owner,"Must be owner!");
        if (msg.sender != owner) {
            revert Notowner();
        }
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
