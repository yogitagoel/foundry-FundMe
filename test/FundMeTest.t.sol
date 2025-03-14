//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test{
    FundMe fundMe;

    function setUp() external {
        FundMe fundMe = new FundMe();
    }

    function testMinDollarIsFive() public{
        assertEq(minUsd(), 5e18);
    }
    
    function testOwnerIsMsgSender() public{
        assertEq(fundMe.i_owner(),msg.sender);
    } 
}