// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

interface IReferalTree{ // реализация древовидной структуры реферальной программы

    function addNewClient(address, address) external;

    function getFather(address) external view returns(address);

    function getAllDirectPartners(address) external view returns(address[] memory);
}