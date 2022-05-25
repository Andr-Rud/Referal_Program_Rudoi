// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

import "./interfaces/IReferalTree.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ClientInfo is Ownable{

    // array of thresholds for lvls
    uint256[] private _thresholdForLevelsArray;

    // mapping client => his balance
    mapping(address=>uint256) private _balances;

    // array of commissions
    uint256[] private _commissionsArray;

    // address of our referal tree
    address private _referal_tree;

    /*
    *@param _tree - address of referal tree
    */
    function initialize(address _tree) public {
        _commissionsArray = [0, 10, 7, 5, 2, 1, 1, 1, 1, 1, 1];
        _thresholdForLevelsArray = [0.005 ether, 0.01 ether, 0.02 ether, 0.05 ether, 0.1 ether,
                                    0.2 ether, 0.5 ether, 1 ether, 2 ether, 5 ether];
        _referal_tree = _tree;
        
    }

    /*
    *@return balance of sender
    */
    function getMyBalance() public view returns(uint256){
        return _balances[msg.sender];
    }

    /*
    *@param _client - address of client
    *@return lvl of _client
    */
    function _getLevel(address _client) private view returns(uint256 i){
        uint256 target = _balances[_client];
        for(i = 0; i < _thresholdForLevelsArray.length; ++i){
            if (target < _thresholdForLevelsArray[i-1]){
                return i-1;
            }
        }
    }

    /*
    *@return lvl of sender
    */
    function getMyLevel() public view returns(uint256){
        return _getLevel(msg.sender);
    }

    /*
    *@return lvls of direct partners of sender
    */
    function getMyDirectPartnersLevels() public view returns(uint256[] memory){
        address[] memory partners = IReferalTree(_referal_tree).getAllDirectPartners(msg.sender);
        uint256[] memory levels = new uint256[](partners.length);

        for(uint256 i = 0; i < partners.length; ++i){
            levels[i] = _getLevel(partners[i]);
        }

        return levels;
    }

    /*
    *@return amount of direct partners of sender
    */
    function getMyDirectPartnersAmount() public view returns(uint){
        return IReferalTree(_referal_tree).getAllDirectPartners(msg.sender).length;
    }

    /*
    *@param _urlOwner - owner of referal url
    */
    function initClient(address _urlOwner) public{
        IReferalTree(_referal_tree).addNewClient(msg.sender, _urlOwner);
    }

    function investing() payable public{
        _balances[msg.sender] += msg.value;     
    }

    /*
    *@param _value - money, which we want to withdraw
    */
    function withdrawMoney(uint256 _value) internal{
        _balances[msg.sender] -= msg.value;
        uint256 depth = 1;
        uint256 max_depth = _thresholdForLevelsArray.length - 1;
        address iterator = msg.sender;
        uint256 commission = 0;

        while (depth < max_depth && iterator != address(0x0)){
            iterator = IReferalTree(_referal_tree).getFather(iterator);
            uint256 level = _getLevel(iterator);
            if (level >= depth){
                _balances[iterator] += _value * _commissionsArray[level] / 100;
                commission += _commissionsArray[level];
            }
            ++depth;
        }

        payable(msg.sender).transfer(_value * (100-commission) / 100);
    }

    /*
    *@param _lvl - lvl of commission, which we want to update
    *@param _newCommission - new commission for this lvl
    */
    function setCommission(uint256 _lvl, uint256 _newCommission) public onlyOwner{
        require(_lvl < _commissionsArray.length, "There is no such lvl");
        _commissionsArray[_lvl] = _newCommission;
    }

    /*
    *@param _lvl - lvl of threshold, which we want to update
    *@param _newThreshold - new threshold for this lvl
    */
    function setThresholdForLevel(uint256 _lvl, uint256 _newThreshold) public onlyOwner{
        require(_lvl < _thresholdForLevelsArray.length, "There is no such lvl");
        _thresholdForLevelsArray[_lvl] = _newThreshold;
    }
}