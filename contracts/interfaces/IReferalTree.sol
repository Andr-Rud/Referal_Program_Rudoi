// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.14;

interface IReferalTree{

    function addNewClient(address, address) external;

    function getReferal(address) external view returns(address);

    function getDirectPartners(address) external view returns(address[] memory);
}