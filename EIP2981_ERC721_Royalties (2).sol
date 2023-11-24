// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts@5.0.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@5.0.0/access/Ownable.sol";

contract MyNFT is ERC721, Ownable {
    uint256 private _nextTokenId;
    address private _royaltyReceiver;
    uint256 public ROYALTY_PERCENTAGE = 5; //royalties au taux de 5%.

    constructor(address initialOwner) ERC721("HLN721", "HLN") Ownable(initialOwner) {
        /*
    Initialise le contrat avec un propriétaire initial en utilisant l'adresse fourni
        Il y a un nom, un symbole et une adresse    
    */
        _royaltyReceiver = initialOwner; 
    }
 
    function safeMint(address to) public onlyOwner {
        /*
        Utilisé pour minter un nouveau NFT autorisé uniquement pour le propriétaire
        */
        uint256 tokenId = _nextTokenId++; // Incrémenter automatiquement pour ne pas à avoir à gérer l'ID
        _safeMint(to, tokenId);
    }

 

    function royaltyInfo(uint256 _salePrice) external view returns (address, uint256) {
        /*
        Calcule les redevances
        */
        uint256 _royaltyValue = (_salePrice * ROYALTY_PERCENTAGE) / 100;
        return (_royaltyReceiver, _royaltyValue);
    }

    
    function setRoyaltyReceiver(address newReceiver) external onlyOwner {
        _royaltyReceiver = newReceiver;
    }
}