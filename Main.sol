// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

import "./ClientInfo.sol";

interface Referal{ // методы, которые надо реализовать
    function init(address _url) external; // вход в систему

    function see_my_balance() external view returns(uint); // просмотр своего баланса

    function see_my_lvl() external view returns(uint); // просмотр своего уровня

    function see_my_partners_lvls() external view returns(uint[] calldata); // просмотр уровней реферальных партнеров

    function see_my_partners_amount() external view returns(uint); // просмотр кол-ва реферальных партнеров

    function take_money(uint _amount) external; // вывод денежных средств

    function give_money() external payable;  // инвестиция
}

contract Main is Referal{
    
    ClientInfo private info;

    uint[] private commissions;

    constructor(){
        info = new ClientInfo();
        commissions = [0, 10, 7, 5, 2, 1, 1, 1, 1, 1, 1];
    }

    function init(address _url) override public{
        info.add_new_client(msg.sender, _url);
    }

    function give_money() override payable public{
        info.add(msg.sender, msg.value);      
    }

    function see_my_partners_lvls() override public view returns(uint[] memory){
        return info.see_partners_lvs(msg.sender);
    }

    function see_my_partners_amount() override public view returns(uint){
        return info.see_partners_amount(msg.sender);
    }

    function take_money(uint _value) override public{
        info.sub(msg.sender, _value);

        address[] memory upper = info.see_upper(msg.sender);

        uint commission = 0;

        for(uint i = 0; i < 10; ++i){
            if (upper[i] == address(0x0)){
                break;
            }
            else{
                uint lvl = info.see_lvl(upper[i]);
                if (lvl >= i+1){
                    uint temp = commissions[lvl];

                    info.add(upper[i], _value * temp / 100);

                    commission += temp;
                }
            }
        }

        payable(msg.sender).transfer(_value * (100-commission) / 100);
    }

    function see_my_balance() override public view returns(uint256){
        return info.see_balance(msg.sender);
    }

    function see_my_lvl() override public view returns(uint256){
        return info.see_lvl(msg.sender);
    }
}