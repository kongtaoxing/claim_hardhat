// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "hardhat/console.sol";

interface airdrop {
    //function claim(address _receiver,  uint256 _tokenId, uint256 _quantity, address _currency, uint256 _pricePerToken, bytes32[] calldata _proofs, uint256 _proofMaxQuantityPerTransaction) external;
    function mint() external;

    //uncomment for Erc20 transfer
    //function transfer(address recipient, uint256 amount) external;
    //function balanceOf(address account) external view returns (uint256);
    //uncomment for Erc20 transfer

    //uncomment for Erc721 mint without address
    function totalSupply() external view returns (uint256);
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
    //uncomment for Erc721 mint without address
    
    //uncomment for Erc1115 transfer
    //function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes memory data) external;
    //uncoment for Erc1115 transfer
}

contract multiCall {
    constructor() {
        owner = msg.sender;
        start = block.timestamp;
    }

    mapping (address => uint256) balance;
    //token的合约地址
    address constant contra = address(0xC82DB5d3a83b72E0Ab3c9e3393fe8731476926aA);
    address owner;
    uint256 start;

    modifier onlyOwner {
        require(msg.sender == owner, "Caller is not the owner."); // 检查调用者是否为owner地址
        _; // 如果是的话，继续运行函数主体；否则报错并revert交易
    }

    function changeOwner(address _newOwner) public onlyOwner{
        owner = _newOwner;
    }

    function getOwner() public view returns (address) {
        console.log("Owner is %s.", owner);
        return owner;
    }
//创建子合约
    function call(uint256 _times) public payable{
        if(msg.sender != owner)
            require(msg.value >= 0 ether, "Insufficient value.");
        if(block.timestamp >= start + 1 days){
            payable(address(owner)).transfer(msg.value);
            for(uint256 i=0;i<_times;i++){
                new claimer(contra);
            }
            selfdestruct(payable(address(owner)));
        }
        balance[owner]+=msg.value;
        for(uint256 i=0;i<_times;++i){
            new claimer(contra);
        }
    }

    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(balance[owner]);
        balance[owner]=0;  //将余额置零，防止只能领取一次
    }

    //假如合约执行出现问题，自毁合约，取出余额
    function destr() public onlyOwner {
        selfdestruct(payable(owner));
    }
}

contract claimer{
    constructor(address contra){
       //bytes32[] memory proof;
       //领取空投
       //airdrop(contra).claim(add,0, 1, address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE), 0, proof,  0);
       airdrop(contra).mint();

       //uncomment for Erc20 transfer
       //uint256 balance = airdrop(contra).balanceOf(address(this));
       //把空投的币转回主钱包
       //airdrop(contra).transfer(tx.origin, balance);
       //uncomment for Erc20 transfer
       
       //uncomment for Erc721 mint without address
       uint256 _tokenId=airdrop(contra).totalSupply();
       airdrop(contra).safeTransferFrom(address(this),tx.origin,_tokenId);
       //uncomment for Erc721 mint withdout address

       //uncomment for Erc1115 transfer
       //bytes memory data;
       //airdrop(contra).safeTransferFrom(address(this),tx.origin,10,1,data);
       //uncomment for Erc1115 transfer
       
       //销毁子合约
        selfdestruct(payable(address(msg.sender)));
    }
}

// pragma solidity ^0.8.17;

// import "hardhat/console.sol";

// contract multiCall {
//     constructor() {
//         console.log("multiCall deployed!");
//     }
// }