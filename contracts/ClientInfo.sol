// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.14;

import "./interfaces/IReferalTree.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ClientInfo is Ownable{

    // array of thresholds for levels
    uint256[] private _levels;

    // mapping client => his balance
    mapping(address=>uint256) private _balances;

    // array of commissions
    uint256[] private _commissions;

    // address of our referal tree
    address private _referralTreeContractAddress;

    modifier onlyPossibleLevel(uint level) {
      if (_levels.length >= level) {
         _;
      }
    }

    /*
    Initialize contract
    *@param _tree - address of referal tree
    */
    function initialize(address _tree) public {
        _commissions = [0, 10, 7, 5, 2, 1, 1, 1, 1, 1, 1];
        _levels = [0.005 ether, 0.01 ether, 0.02 ether, 0.05 ether, 0.1 ether,
                                    0.2 ether, 0.5 ether, 1 ether, 2 ether, 5 ether];
        _referralTreeContractAddress = _tree;
        
    }

    /*
    Get method for sender balance
    *@return balance of sender
    */
    function getMyBalance() public view returns(uint256){
        return _balances[msg.sender];
    }

    /*
    Get method for client level
    *@param _client - address of client
    *@return level of _client
    */
    function _getLevel(address _client) private view returns(uint256 i){
        for(i = 0; i < _levels.length; i++){
            if (_balances[_client] < _levels[i]){
                return i-1;
            }
        }
    }

    /*
    Get method for sender level
    *@return level of sender
    */
    function getMyLevel() public view returns(uint256){
        return _getLevel(msg.sender);
    }

    /*
    Get method for sender direct partners levels
    *@return levels of direct partners of sender
    */
    function getMyDirectPartnersLevels() public view returns(uint256[] memory){
        address[] memory partners = IReferalTree(_referralTreeContractAddress).getDirectPartners(msg.sender);
        uint256[] memory levels = new uint256[](partners.length);

        for(uint256 i = 0; i < partners.length; i++){
            levels[i] = _getLevel(partners[i]);
        }

        return levels;
    }

    /*
    Get method for sender direct partners amount
    *@return amount of direct partners of sender
    */
    function getMyDirectPartnersAmount() public view returns(uint){
        return IReferalTree(_referralTreeContractAddress).getDirectPartners(msg.sender).length;
    }

    /*
    Initialize for new client
    *@param _urlOwner - owner of referal url
    */
    function addClient(address _urlOwner) public{
        IReferalTree(_referralTreeContractAddress).addNewClient(msg.sender, _urlOwner);
    }

    /*
    Invest money to the contract
    */
    function investing(uint256 _value) payable public{
        _balances[msg.sender] += _value;

    }

    /*
    Withdraw money from the contract
    *@param _value - money, which we want to withdraw
    */
    function withdrawMoney(uint256 _value) internal{
        require(_value < _balances[msg.sender], "There is no such money on the balance");
        _balances[msg.sender] -= _value;
        uint256 depth = 1;
        address iterator = msg.sender;
        uint256 commission = 0;

        while (depth < _levels.length && iterator != address(0x0)){
            iterator = IReferalTree(_referralTreeContractAddress).getReferal(iterator);
            uint256 level = _getLevel(iterator);
            if (level >= depth){
                _balances[iterator] += _value * _commissions[level] / 100;
                commission += _commissions[level];
            }
            depth++;
        }

        payable(msg.sender).transfer(_value * (100-commission) / 100);
    }

    /*
    Set method for commission
    *@param _level - level of commission, which we want to update
    *@param _newCommission - new commission for this level
    */
    function setCommission(uint256 _level, uint256 _newCommission) public onlyOwner onlyPossibleLevel(_level){
        _commissions[_level] = _newCommission;
    }

    /*
    Set method for Threshold
    *@param _level - level of threshold, which we want to update
    *@param _newThreshold - new threshold for this level
    */
    function setThresholdForLevel(uint256 _level, uint256 _newThreshold) public onlyOwner onlyPossibleLevel(_level){
        _levels[_level] = _newThreshold;
    }
}