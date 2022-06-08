// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

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
        // Compile huff contract via `huffc --bytecode src/TSOwnable.huff` and
        // paste bytecode here.
        bytes memory code = hex"33600055610109806100116000396000f3346101035760003560e01c8063c42069ec1461003757806379ba5097146100a75780638da5cb5b146100eb578063e30c3978146100f7575b60005433146100465760006000fd5b6004357f000000000000000000000000ffffffffffffffffffffffffffffffffffffffff168033146100a157806001547fb3d55174552271a4f1aaf36b72f50381e892171636b3fb5447fe00e995e7a37b60006000a3600155005b60006000fd5b60015433146100b65760006000fd5b336000547f70aea8d848e8a90fb7661b227dc522eb6395c3dac71b63cb59edd5c9899b236460006000a3336000556000600155005b60005460005260206000f35b60015460005260206000f35b60006000fd";

        // Deploy contract to deterministic address via create2 and save
        // address to storage.
        address impl;
        bytes32 salt = keccak256(abi.encode(1));

        assembly {
           impl := create2(0, add(code, 0x20), mload(code), salt)
        }
        assert(impl != address(0));

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

    function testSetPendingOwner(address to) public {
        vm.assume(to != sut.owner());

        vm.expectEmit(true, true, true, true);
        emit NewPendingOwner(address(0), to);

        sut.setPendingOwner(to);
        assertEq(sut.pendingOwner(), to);
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
