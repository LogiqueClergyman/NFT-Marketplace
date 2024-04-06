//SPDX-License Identifier-Identifier: MIT

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Collection is ERC721URIStorage, Ownable {
    uint256 private _tokenIds;
    uint256 private _totalMinted;
    mapping(address => uint8) private mintedAddress;
    mapping(string => uint8) private URIMapping;
    uint256 public PRICE_PER_TOKEN = 0.01 ether;
    uint256 public LIMIT_PER_ADDRESS = 2;
    uint256 public MAX_SUPPLY = 5;

    constructor() ERC721("Collection", "NFT") Ownable(msg.sender) {}  

    function setPrice(uint256 _price) external onlyOwner{
        PRICE_PER_TOKEN = _price;
    }

    function setLimit(uint256 _limit) external onlyOwner{
        LIMIT_PER_ADDRESS = _limit;
    }

    function setMaxSupply(uint256 _maxSupply) external onlyOwner{
        MAX_SUPPLY = _maxSupply;
    }

    function mintNFT(string memory tokenURI) payable external returns (uint256){
        require(msg.value >= PRICE_PER_TOKEN, "Funds insufficient");
        require(_totalMinted < MAX_SUPPLY, "Max supply exceeded");
        require(mintedAddress[msg.sender] < LIMIT_PER_ADDRESS, "Individual limit exceeded");
        require(URIMapping[tokenURI] == 0, "NFT already minted");
        URIMapping[tokenURI] += 1;
        mintedAddress[msg.sender] += 1;
        _tokenIds += 1;
        _totalMinted += 1;

        uint256 newItemId = _tokenIds;
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    function withdraw() external onlyOwner{
        address payable to = payable(msg.sender);
        to.transfer(address(this).balance);
    }
}