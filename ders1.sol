pragma solidity 0.8.0; //solidity versiyonu 0.8.0 olduğunu belirtiyor.

contract HelloWorld { //contract ismi HelloWorld

    function PrintHelloWorld() public returns(string memory) { //fonksiyon ismi PrintHelloWorld, fonksiyonun döndürdüğü değer string memory, fonksiyonun erişim tipi public
        return "Hello  Cuberium"; //fonksiyonun döndürdüğü değer
    }

}