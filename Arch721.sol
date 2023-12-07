// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts@5.0.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@5.0.0/access/Ownable.sol";

contract MyNFT is ERC721, Ownable {
    uint256 private _nextTokenId;


    mapping(uint256 => string) private _tokenURIs;


    //creation du contrat ARCH721
    constructor(address initialOwner) ERC721("ARCH721", "ARCH") Ownable(initialOwner) {

    }
 

    //pour creer/minter un nouveau NFT
    //on incrémente le tokenId pour assurer l'unicité des IDs
    function safeMint(address to) public onlyOwner {
        /*
        Utilisé pour minter un nouveau NFT autorisé uniquement pour le propriétaire
        */
        uint256 tokenId = _nextTokenId++; // Incrémenter automatiquement pour ne pas à avoir à gérer l'ID
        _safeMint(to, tokenId);//pour mint le token et l'assigner à l'adresse fournie
    }



    //méthode pour lier un URI de métadonnées à un token spécifique
    function _setTokenURI(uint256 tokenId, string memory newTokenURI) public onlyOwner {
        //check si token existe 
        require(ownerOf(tokenId) != address(0), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = newTokenURI; //associé l'URI au token ID
    }


    //'view' => modifie pas l'état du contrat
    //elle recup l'uri 
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(ownerOf(tokenId) != address(0), "ERC721Metadata: URI query for nonexistent token");
        return _tokenURIs[tokenId];
    }



    // Methode pour créer un nouveau NFT avec un URI de métadonnées spécifique
    function mintNFT(address recipient, string memory metadataURI) public onlyOwner {
        uint256 newTokenId = _nextTokenId++;
        _safeMint(recipient, newTokenId);
        _setTokenURI(newTokenId, metadataURI);
    }

    //**méthode pour créer un nouveau NFT avec les métadonnées spécifique** 
    function mintNFTHash(address recipient, string memory metadataHash) public onlyOwner {
    uint256 newTokenId = _nextTokenId++;
    _safeMint(recipient, newTokenId);
    _setTokenURI(newTokenId, metadataHash);
    }
    
}

