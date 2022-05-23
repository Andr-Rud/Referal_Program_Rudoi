// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

contract ReferalTree{ // реализация древовидной структуры реферальной программы
    mapping(address=>address) private tree1; // отношения сын -> отец

    mapping(address=>address[]) private tree2; // отношения отец -> дети

    constructor(){
        tree1[address(0x0)] = address(0x0);
    }
    function add_new_client(address _who, address _to) public{ // добавление нового элемента в дерево
        tree1[_who] = _to;
        tree2[_to].push(_who);
    }

    function see_up(address _client)public view returns(address[] memory){ // просмотр адресов отца, деда, ... (10 итераций)
        address[] memory answer = new address[](10);
        address temp = _client;

        for(uint i = 0; i < 10; ++i){
            answer[i] = tree1[temp];
            temp = tree1[temp];
        }

        return answer;
    }

    function get_all_partners(address _who) public view returns(address[] memory){ // просмотр адресов всех детей
        return tree2[_who];
    }
}