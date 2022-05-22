// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

import "./ReferalTree.sol";

contract ClientInfo{ // вся информация о пользователях

    uint256[] private arr; // вспомогательный массив для определения уровня

    ReferalTree private tree;

    mapping(address=>uint256) private balances; // адрес -> баланс

    constructor(){
        tree = new ReferalTree();
        arr = [5000000000000000, 10000000000000000, 20000000000000000, 50000000000000000, 100000000000000000, 200000000000000000, 500000000000000000, 1000000000000000000, 2000000000000000000, 5000000000000000000];
    }

    function add_new_client(address _who, address _to) public{ // добавление нового клиента
        tree.add_new_client(_who, _to);
        balances[_who] = 0;
    }

    function search(uint256 target) private view returns(uint256 i){ // вспомогательная функция для определения уровня
        for(i = arr.length; i > 0; --i){
            if (target >= arr[i-1]){
                return i;
            }
        }
    }

    function see_balance(address _who) public view returns(uint){ // просмотр баланса
        return balances[_who];
    }

    function see_lvl(address _who) public view returns(uint){ // просмотр уровня
        return search(balances[_who]);
    }

    function see_partners_lvs(address _who) public view returns(uint[] memory){ // просмотр уровней партнеров
        address[] memory partners = tree.get_all_partners(_who);
        uint[] memory lvls = new uint[](partners.length);

        for(uint i = 0; i < partners.length; ++i){
            lvls[i] = see_lvl(partners[i]);
        }

        return lvls;
    }

    function see_partners_amount(address _who) public view returns(uint){ // просмотр кол-ва партнеров
        return tree.get_all_partners(_who).length;
    }

    function add(address _who, uint _value) public{ // увеличение баланса
        balances[_who] += _value;
    }

    function sub(address _who, uint _value) public{ // уменьшение баланса
        balances[_who] -= _value;
    }

    function see_upper(address _who) public view returns(address[] memory){
        return tree.see_up(_who);
    }
}