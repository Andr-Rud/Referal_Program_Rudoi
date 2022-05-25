// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract ReferalTree{
    // mapping son=>father
    mapping(address=>address) private _treeSonFather;

    // mapping father=>children
    mapping(address=>address[]) private _treeFatherChildren;

    /*
    *@param _client
    *@param _urlOwner - owner of referal url
    */
    function addNewClient(address _client, address _urlOwner) public{
        _treeSonFather[_client] = _urlOwner;
        _treeFatherChildren[_urlOwner].push(_client);
    }

    /*
    *@param _client
    *@return father of _client
    */
    function getFather(address _client)public view returns(address){
        return _treeSonFather[_client];
    }

    /*
    *@param _client
    *@return all children of _client
    */
    function getAllDirectPartners(address _client) public view returns(address[] memory){
        return _treeFatherChildren[_client];
    }
}