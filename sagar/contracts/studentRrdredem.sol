// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/** 
 * @title Ballot
 * @dev Implements voting process along with vote delegation
 */
contract RecordStudent {
        struct Students {
        string name;
        uint roll;
        uint percentage;
        bool reedem;
        address eoaaddress;
       // address eoaaddress;
        }
        uint public amount;
        uint totalstds=0;
        mapping(uint=> Students) students;
        address recorder;
        
        modifier isRecorder
        {
            require(msg.sender==recorder);
            _;
        }
        constructor(){
            recorder= msg.sender;
        }
        
        function registerStudent(string memory _name, uint _roll, uint _percentage, address _stdaddress) public isRecorder {
            totalstds+=1;
            students[_roll]=Students(_name,_roll,_percentage,false,_stdaddress);
        }
        
        function getStudent(uint _roll) public view returns(Students memory){
            return students[_roll];
        }
        
        function updateStudent(string memory _name, uint _roll,bool _redeem, uint _percentage,address _stdaddress) public isRecorder{
        
            students[_roll]=Students(_name,_roll,_percentage,_redeem,_stdaddress);
        }
        
        function deletesStudent(uint _roll) public isRecorder{
            delete students[_roll];
        }
        
        //since an smart contract can own ether   
        function recieve() payable public{
            amount += msg.value;
        }
        
        function reedeem(uint _roll) public{
            if (students[_roll].eoaaddress!=msg.sender && students[_roll].reedem==true){
                revert();
            }
           // uint _z= amount/totalstds;
            payable(msg.sender).transfer(1 wei);
        }
        
    }

   
