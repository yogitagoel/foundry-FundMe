//SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundme;

    function setUp() external {
        fundme = new FundMe();
    }

    function testMinDollarIsFive() public {
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundme.i_owner(), address(this));
    }

    function testProceFeedVersionIsAccurate() public {
        uint256 version = fundme.getVersion();
        assertEq(version, 4);
    }
}
