pragma solidity 0.8.0; //solidity versiyonu 0.8.0 olduğunu belirtiyor.

/**
 * @author berk cicek
 */
 
contract ArithmeticOperations  { //contract ismi ArithmeticOperations


    int number1 = -123; // int değerler -123 ile 123 arasında olabilir.
    int number2 = 100; // int değerler -123 ile 123 arasında olabilir.


    uint number3 = 10; // uint değerler 0 ile 123 arasında olabilir.
    uint number4 = 0; // uint değerler 0 ile 123 arasında olabilir.

    function sum() public returns(int) { //fonksiyon ismi sum, fonksiyonun döndürdüğü değer int, fonksiyonun erişim tipi public
    return number1 + number2 ; //fonksiyonun döndürdüğü değer number1 + number2 
    }

    function sub() public returns(int) { // fonksiyon ismi sub, fonksiyonun döndürdüğü değer int, fonksiyonun erişim tipi public
        return number1 - number2 ; //fonksiyonun döndürdüğü değer number1 - number2 
    }
    {return number1 - number2 ; //fonksiyonun döndürdüğü değer number1 - number2 
    }

    function sum2() public returns(int) { //fonksiyon ismi sum2, fonksiyonun döndürdüğü değer int, fonksiyonun erişim tipi public
        return number1 + int(number3) ; //fonksiyonun döndürdüğü değer number1 + int(number3)
    }

     function Test() public returns(int) { //fonksiyon ismi Test, fonksiyonun döndürdüğü değer int, fonksiyonun erişim tipi public
        return number1 + number1 ; //fonksiyonun döndürdüğü değer number1 + number1
        
    }


    function set_number1(int value) public{ //dışarıdan int değer kabul edebilir hale getirdik.
        number1 = value ; //number1 değerini value olarak değiştirdik.
    }

}
