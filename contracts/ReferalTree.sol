// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.14;

contract ReferalTree{
    // mapping direct partner=>his referal
    mapping(address=>address) private _treeDirectPartnerToReferal;

    // mapping referal=>his direct partners
    mapping(address=>address[]) private _treeReferalToDirectPartners;

    /*
    Add method for new client
    *@param _client
    *@param _urlOwner - owner of referal url
    */
    function addNewClient(address _client, address _urlOwner) public{
        if (_treeDirectPartnerToReferal[_client] != _urlOwner){
            _treeDirectPartnerToReferal[_client] = _urlOwner;
            _treeReferalToDirectPartners[_urlOwner].push(_client);
        }
    }

    /*
    Get method, which returns father of our client
    *@param _client
    *@return father of _client
    */
    function getReferal(address _client) public view returns(address){
        return _treeDirectPartnerToReferal[_client];
    }

    /*
    Get method, which returns direct partners of our client
    *@param _client
    *@return all children of _client
    */
    function getDirectPartners(address _client) public view returns(address[] memory){
        return _treeReferalToDirectPartners[_client];
    }
}