/* Bu derste bir nevi sahibinden sitesinin akıllı kontratını yazacağız.
Bu kontratın amacı, bir kullanıcıya ait olan bir ürünü başka bir kullanıcıya satmaktır.
Bu işlem için kullanıcılar, kontratın adresine bir miktar ETH gönderirler.
Bu ETH, satış işleminin gerçekleşmesi için kullanılır.*/
pragma solidity 0.8.0; 

/**
 * @author berk cicek
 */

contract Escrow {

    address admin; //adminin adresini tut. 
    mapping (address => uint) user_balances ; // kullanıcıların bakiyelerini tut.
    uint commission_percent= 1; // komisyon oranını tut.
    //uint total_commission=0; | toplam komisyon tutarını tut.

    constructor(uint _commission_percent){ //constructor fonksiyonu, kontratın ilk çalıştırılması için kullanılır.
        admin=msg.sender; // adminin adresini tut.
        commission_percent= _commission_percent; // komisyon oranını tut. 
    }

    function DepositEther() external payable { //fonksiyon içeriden çağırılmıyor !

        require(msg.value>= 1 ether); // msg.value= fonksiyon çağırılırken gönderilen eth miktarını verir
        // fonksiyonun çalışması ve devamı için minimum 1 ether gönderilmesi gerektiği şartını koydu
        // eğer 1 etherden küçük ise fonksiyon 'revert' ediliyor.

        user_balances[msg.sender] += msg.value; // kullanıcının bakiyesine gönderilen eth miktarını ekle.


    }

    function TransferEtherWithCommission(address receiver, uint amount) external payable { //fonksiyon içeriden çağırılmıyor !
        require(msg.sender ==admin); // fonksiyonu sadece admin çağırabilir.
        require(address(this).balance >= amount); // fonksiyonun çalışması ve devamı için kontratın bakiyesi
        user_balances[admin] += amount/100 *commission_percent; // adminin bakiyesine komisyon miktarını ekle.

        //total_commission += amount/100 * commission_percent;   | toplam komisyon tutarını tut.
        payable(receiver).transfer(amount - amount/100 *commission_percent); // alıcıya komisyon hariç miktarı gönder.


    }
     function TransferEtherWitoutCommission(address receiver, uint amount) external payable { //fonksiyon içeriden çağırılmıyor !
        require(msg.sender ==admin); // fonksiyonu sadece admin çağırabilir.
        require(address(this).balance >= amount); // fonksiyonun çalışması ve devamı için kontratın bakiyesi
        payable(receiver).transfer(amount); // alıcıya komisyon hariç miktarı gönder. 
     }

    function CollectCommission() external payable { //fonksiyon içeriden çağırılmıyor !
        require(msg.sender == admin); // fonksiyonu sadece admin çağırabilir.
        payable(admin).transfer(user_balances[admin]); // adminin bakiyesini adminin hesabına gönder. 
        user_balances[admin] = 0; // adminin bakiyesini sıfırla. 
    }
 
    function SetAdmin(address newAdmin) external {  //fonksiyon içeriden çağırılmıyor !
        require(msg.sender == admin); // fonksiyonu sadece admin çağırabilir.
        require(newAdmin != address(0)); // adresi set etmeden alınan girdilerde ethereum adrese 00000 gibi bir şey atabiliyor !
        /* adreslerin setindeki hatayı denetlemek adına 
        Karakterler yanlış yazılabilir, malware problemleri olabilir bunlar için adresleri
        bir array olarak tutuıp ardından yeni eklenen admini arraya ekleyip
        sonrasında remove admin tarzı bir fonksiyon ile ilk admin silinir.
        böylece yanlış bir new admin eklense bile ilk admin geçerliliğini korur.
        admin = newAdmin; // adminin adresini değiştir.   */  
           }
}
