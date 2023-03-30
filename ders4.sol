// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0; 

/**
 * @author berk cicek
 */

contract EscrowApp2 {
    mapping (uint => address) transaction_receivers_list; // bu kod  transaction_receivers_list adında bir mapping oluşturduk. Bu mappingin key değeri uint, value değeri address.
    mapping (uint => address) transaction_owners_list; // bu kod transaction_owners_list adında bir mapping oluşturduk. Bu mappingin key değeri uint, value değeri address.
    mapping (uint => uint) transaction_payment_list; // transaction_payment_list adında bir mapping oluşturduk. Bu mappingin key değeri uint, value değeri uint.
    mapping (uint => bool) transaction_stasus_list; // transaction_stasus_list adında bir mapping oluşturduk. Bu mappingin key değeri uint, value değeri bool.
    uint transaction_count = 0; // bu kod satırı ile transaction_count adında bir uint tipinde değişken oluşturduk.

    address admin;  // bu kod satırı ile admin adında bir address tipinde değişken oluşturduk.
    uint commission_percent = 1;    // bu kod  commission_percent adında bir uint tipinde değişken oluşturduk.
    uint collected_commission = 0; // bu kod satırı collected_commission adında bir uint tipinde değişken oluşturduk.

    constructor(uint _commission_percent){ // bu kod satırı ile constructor oluşturduk. Bu constructor içerisinde _commission_percent adında bir uint tipinde değişken oluşturduk.
        admin = msg.sender; // bu kod satırı ile admin değişkenine msg.sender değerini atadık.
        commission_percent = _commission_percent;   // bu kod satırı ile commission_percent değişkenine _commission_percent değerini atadık.
    }  

    nodifier onlyAdmin(){  // bu kod satırı ile onlyAdmin adında bir nodifier oluşturduk.
        require(msg.sender == admin); // bu kod satırı ile msg.sender değeri admin değerine eşit olmalıdır. Eğer değilse revert işlemi gerçekleşir.
        _; 
    }

    nodifier onlyTransactionOwner(uint _transaction_id){ // bu kod satırı ile onlyTransactionOwner adında bir nodifier oluşturduk. Bu nodifier içerisinde _transaction_id adında bir uint tipinde değişken oluşturduk.
        require(transaction_owners_list[_transaction_id] == msg.sender); // bu kod satırı ile transaction_owners_list[_transaction_id] değeri msg.sender değerine eşit olmalıdır. Eğer değilse revert işlemi gerçekleşir.
        _;
    }


    nodifier CheckIfTransactionNotZero(uint _transaction_id){ // bu kod satırı ile CheckIfTransactionNotZero adında bir nodifier oluşturduk. Bu nodifier içerisinde _transaction_id adında bir uint tipinde değişken oluşturduk.
        require(transaction_status_list[_transaction_id] != 0); // bu kod satırı ile transaction_status_list[_transaction_id] değeri 0 değerine eşit olmamalıdır. Eğer değilse revert işlemi gerçekleşir.
        _;
    }

    nodifier CheckTransactionsActive(uint _transaction_id){ // bu kod satırı ile CheckTransactionsActive adında bir nodifier oluşturduk. Bu nodifier içerisinde _transaction_id adında bir uint tipinde değişken oluşturduk.
        require(transaction_status_list[_transaction_id] == false); // bu kod satırı ile transaction_status_list[_transaction_id] değeri false değerine eşit olmalıdır. Eğer değilse revert işlemi gerçekleşir. 
        _;
    }

//user(buyer) functions

    function CheckTransaction(address _transaction_receiver) external payble { // bu kod satırı ile CheckTransaction adında bir fonksiyon oluşturduk. Bu fonksiyon içerisinde _transaction_receiver adında bir address tipinde değişken oluşturduk.
        require(msg.value >= 1 ether); // bu kod satırı ile msg.value değeri 1 ether değerinden büyük olmalıdır. Eğer değilse revert işlemi gerçekleşir. 
        require(_transaction_receiver != address(0)); // bu kod satırı ile _transaction_receiver değeri address(0) değerine eşit olmamalıdır. Eğer değilse revert işlemi gerçekleşir. 

        transaction_receivers_list[transaction_count] = _transaction_receiver; // bu kod satırı ile transaction_receivers_list[transaction_count] değerine _transaction_receiver değerini atadık.
        transaction_owners_list[transaction_count] = msg.sender; // bu kod satırı ile transaction_owners_list[transaction_count] değerine msg.sender değerini atadık. 
        transaction_payment_list[transaction_count] = msg.value; // bu kod satırı ile transaction_payment_list[transaction_count] değerine msg.value değerini atadık.
        transaction_status_list[transaction_count] = false; // bu kod satırı ile transaction_status_list[transaction_count] değerine false değerini atadık. 
        transaction_count += 1;
    }

    function confirmTransaction(uint _transaction_id) external onlyTransactionOwner(_transaction_id) CheckIfTransactionNotZero(_transaction_id) CheckTransactionsActive(_transaction_id){
        transaction_status_list[_transaction_id] += msg.value; // bu kod satırı ile transaction_status_list[_transaction_id] değerine msg.value değerini atadık. 
    }

    function cancelTransaction(uint _transaction_id) external onlyTransactionOwner(_transaction_id) CheckIfTransactionNotZero(_transaction_id) CheckTransactionsActive(_transaction_id){
        TransferPayment(transaction_owners_list[_transaction_id], transaction_payment_list[_transaction_id]); // bu kod satırı ile TransferPayment fonksiyonunu çağırdık. Bu fonksiyon içerisinde transaction_owners_list[_transaction_id] ve transaction_payment_list[_transaction_id] değerlerini gönderdik. 
        transaction_payment_list[_transaction_id] = 0; //  transaction_payment_list[_transaction_id] değerine 0 değerini atadık.
        transaction_owner_list[_transaction_id] = address(0); //transaction_owner_list[_transaction_id] değerine address(0) değerini atadık.
        transaction_receivers_list[_transaction_id] = address(0); //  transaction_receivers_list[_transaction_id] değerine address(0) değerini atadık.
    }

    function confirmTransaction(uint _transaction_id) external onlyTransactionOwner(_transaction_id) CheckIfTransactionNotZero(_transaction_id) CheckTransactionsActive(_transaction_id){
        transaction_status_list[_transaction_id] = true; // btransaction_status_list[_transaction_id] değerine true değerini atadık.
    }


//user(seller) functions
    function withdrawTransaction(uint _transaction_id) external payble;{ // bu kod satır withdrawTransaction adında bir fonksiyon oluşturduk. Bu fonksiyon içerisinde _transaction_id adında bir uint tipinde değişken oluşturduk.
        require(transaction_receivers_list[_transaction_id] == msg.sender);
        require(transaction_status_list[_transaction_id] == true); // bu kod satırı  transaction_status_list[_transaction_id] değeri true değerine eşit olmalıdır. Eğer değilse revert işlemi gerçekleşir.
        collected_commission += (transaction_payment_list[_transaction_id] * commission_percent) / 100; // bu kod collected_commission değerine (transaction_payment_list[_transaction_id] * commission_percent) / 100 değerini atadık.
        TransferPayment(transaction_receivers_list[_transaction_id], transaction_payment_list[_transaction_id] - ((transaction_payment_list[_transaction_id] * commission_percent) / 100));,

        transaction_payment_list[_transaction_id] = 0; // bu kod satırı ile transaction_payment_list[_transaction_id] değerine 0 değerini atadık.
    }

    function TransferPayment(address _receiver, uint _amount) internal { // bu kod satırı ile TransferPayment adında bir fonksiyon oluşturduk. Bu fonksiyon içerisinde _receiver adında bir address tipinde değişken ve _amount adında bir uint tipinde değişken oluşturduk.
        payable(_receiver).transfer(_amount); // bu kod satırı ile payable(_receiver).transfer(_amount) değerini atadık.
    } 

// Admin only funtions 
    function setAdmin(address _new_admin) external onlyAdmin{ //setAdmin adında bir fonksiyon oluşturduk. Bu fonksiyon içerisinde _new_admin adında bir address tipinde değişken oluşturduk.
        admin = _new_admin; // admin değerine _new_admin değerini atadık.
    }

    function CollectCommission() external onlyAdmin{
        TransferPayment(admin, collected_commission);
        collected_commission = 0; 
    }
    
    function forceCancelTransaction(uint _transaction_id) external onlyAdmin{
        TransferPayment(transaction_owners_list[_transaction_id], transaction_payment_list[_transaction_id]);
        transaction_payment_list[_transaction_id] = 0;
        transaction_owner_list[_transaction_id] = address(0);
        transaction_receivers_list[_transaction_id] = address(0);
    }

    function forceConfirmTransaction(uint _transaction_id) external onlyAdmin{
        transaction_status_list[_transaction_id] = true;
    }

//getter functions

    function getTransactionOwner(uint _transaction_id) external view returns(address){
        return transaction_owners_list[_transaction_id];
    }

    function getTransactionReceiver(uint _transaction_id) external view returns(address){
        return transaction_receivers_list[_transaction_id];
    }

    function getTransactionPayment(uint _transaction_id) external view returns(uint){
        return transaction_payment_list[_transaction_id];
    }

    function getTransactionStatus(uint _transaction_id) external view returns(bool){
        return transaction_status_list[_transaction_id];
    }

    function getTransactionCount() external view returns(uint){
        return transaction_count;
    }

    function getCollectedCommission() external view returns(uint){
        return collected_commission;
    }

    function getAdmin() external view returns(address){
        return admin;
    }

    function getCommissionPercent() external view returns(uint){
        return commission_percent;
    }

}
