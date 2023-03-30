pragma solidity ^0.8.0;

/**
 * @author berk cicek
 */

contract if_else{

    function learn(uint _value) public returns (string memory) {
        if(_value > 10){
            return "bigger then 10 ";
        }

      else if (_value < 10){
            return "smaller then 10";
        }

        else{
            return "equal to 10";
        }


}
