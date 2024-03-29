// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.13;

import "forge-std/Test.sol";

import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";

interface ITSOwnable {
    function owner() external view returns (address);
    function pendingOwner() external view returns (address);

    function setPendingOwner(address pendingOwner) external;
    function acceptOwnership() external;
}

contract TSOwnableTest is Test {

    // The System under Test.
    ITSOwnable sut;

    // Events copied from SuT.
    event NewPendingOwner(
        address indexed previousPendingOwner,
        address indexed newPendingOwner
    );
    event NewOwner(address indexed previousOwner, address indexed newOwner);

    function setUp() public {
        address impl = HuffDeployer.deploy("TSOwnable");
        sut = ITSOwnable(impl);
    }

    function testDeploymentInvariants() public {
        assertEq(sut.owner(), address(this));
        assertEq(sut.pendingOwner(), address(0));
    }

    function testFailSetPendingOwnerToOwner() public {
        sut.setPendingOwner(address(this));
    }

    function testFailSetPendingOwnerOnlyCallableByOwner(address caller) public {
        vm.assume(caller != address(this));

        vm.startPrank(caller);
        sut.setPendingOwner(address(1));
    }

    function testSetPendingOwner(address first, address second) public {
        vm.assume(first != sut.owner());
        vm.assume(second != sut.owner());

        // Set pending owner to first.
        vm.expectEmit(true, true, true, true);
        emit NewPendingOwner(address(0), first);

        sut.setPendingOwner(first);
        assertEq(sut.pendingOwner(), first);

        // Set pending owner to second.
        vm.expectEmit(true, true, true, true);
        emit NewPendingOwner(first, second);

        sut.setPendingOwner(second);
        assertEq(sut.pendingOwner(), second);
    }

    function testAcceptOwnership(address pendingOwner) public {
        address owner = sut.owner();

        vm.assume(pendingOwner != owner);

        sut.setPendingOwner(pendingOwner);

        vm.expectEmit(true, true, true, true);
        emit NewOwner(owner, pendingOwner);

        vm.prank(pendingOwner);
        sut.acceptOwnership();

        assertEq(sut.owner(), pendingOwner);
        assertEq(sut.pendingOwner(), address(0));
    }

    function testFailAcceptOwnershipOnlyCallableByPendingOwner(address caller)
        public
    {
        vm.assume(caller != sut.pendingOwner());

        vm.startPrank(caller);
        sut.acceptOwnership();
    }

}
