// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/Berry.sol"; // Update this path based on your folder structure

contract BerryTest is Test {
    Berry private berry;

    address private owner = address(this);
    address private user1 = address(0x123);
    address private user2 = address(0x456);

    function setUp() public {
        berry = new Berry(18, 1000 ether, "Berry Token", "BERRY");
    }

    function testInitialSetup() view public {
        assertEq(berry.name(), "Berry Token");
        assertEq(berry.symbol(), "BERRY");
        assertEq(berry.decimals(), 18);
        assertEq(berry.totalSupply(), 1000 ether);
        assertEq(berry.balanceOf(owner), 1000 ether);
    }

    function testMint() public {
        uint256 amount = 500 ether;
        berry.mint(user1, amount);
        assertEq(berry.balanceOf(user1), amount);
        assertEq(berry.totalSupply(), 1500 ether);
    }

    function testMintRevertsForNonOwner() public {
        vm.prank(user1); // Simulate user1 calling the function
        vm.expectRevert("Berry: caller is not the owner");
        berry.mint(user1, 100 ether);
    }

    function testBurn() public {
        uint256 burnAmount = 100 ether;
        berry.burn(burnAmount);
        assertEq(berry.balanceOf(owner), 900 ether);
        assertEq(berry.totalSupply(), 900 ether);
    }

    function testBurnRevertsForInsufficientBalance() public {
        vm.prank(user1);
        vm.expectRevert("Berry: insufficient balance to burn");
        berry.burn(100 ether);
    }

    function testTransfer() public {
        berry.transfer(user1, 200 ether);
        assertEq(berry.balanceOf(user1), 200 ether);
        assertEq(berry.balanceOf(owner), 800 ether);
    }

    function testTransferRevertsForInsufficientBalance() public {
        vm.prank(user1); // Simulate user1 calling the function
        vm.expectRevert("Berry: insufficient balance");
        berry.transfer(user2, 100 ether);
    }

    function testApproveAndAllowance() public {
        berry.approve(user1, 100 ether);
        assertEq(berry.allowance(owner, user1), 100 ether);
    }

    function testTransferFrom() public {
        berry.approve(user1, 100 ether);
        vm.prank(user1); // Simulate user1 calling the function
        berry.transferFrom(owner, user2, 100 ether);

        assertEq(berry.balanceOf(user2), 100 ether);
        assertEq(berry.balanceOf(owner), 900 ether);
        assertEq(berry.allowance(owner, user1), 0 ether);
    }

    function testTransferFromRevertsForInsufficientAllowance() public {
        berry.approve(user1, 50 ether);
        vm.prank(user1);
        vm.expectRevert("Berry: insufficient allowance");
        berry.transferFrom(owner, user2, 100 ether);
    }

    function testTransferOwnership() public {
        berry.transferOwnership(user1);
        assertEq(berry.owner(), user1);

        vm.prank(user1); // Simulate the new owner calling a function
        berry.mint(user2, 100 ether);
    }

    function testTransferOwnershipRevertsForZeroAddress() public {
        vm.expectRevert("Berry: new owner is zero address");
        berry.transferOwnership(address(0));
    }
}
