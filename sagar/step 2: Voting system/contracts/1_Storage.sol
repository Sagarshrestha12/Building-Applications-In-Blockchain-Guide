pragma solidity >=0.7.0 <0.9.0;

contract Time {
    uint256 public createTime;
    uint public min;
    constructor() {
        createTime = block.timestamp;
    }
    function ss() public{
        require(createTime+30>block.timestamp);
        min=block.timestamp;
    }
}
