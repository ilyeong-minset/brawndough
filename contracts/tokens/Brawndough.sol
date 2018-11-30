pragma solidity ^0.4.23;

import "../tokens/BurnableXcert.sol";
import "./Xcert.sol";

contract Brawndough is BurnableXcert {
    //structs contains all of the minted Brawndough tokens details, and such.
    struct Electrolight {
        address owner;
        uint256 tokenIdentifier;
        string description;
        uint256 cost;
    }
    // Store Electrolight struct
    // Fetch Electrolight
    mapping(uint => Electrolight) public electrolights;
    // Store count of minted Brawndough
    uint256 public brawndoughCount;
    //Initialize array of deletedtokenId to check for deletion otherwise delete
    uint256[] public existingTokenId;

    // Minted, Destroyed, Transfer, claim events
    event brawndoughEvent(address indexed _owner);

    constructor()
    public
    {
        nftName = "Brawndough";
        nftSymbol = "BDH";
        nftConventionId = 0x6be14f75;
    }

    function mintBrawndough(address _owner, string _uri, uint256 _cost)
    public
    {
        brawndoughCount ++;
        newEntity(brawndoughCount, brawndoughCount);
        //Will not need once deleteEntity is fixed
        existingTokenId.push(brawndoughCount);
        super._mint(_owner, brawndoughCount);
        super._setTokenUri(brawndoughCount, _uri);
        electrolights[brawndoughCount] = Electrolight(_owner, brawndoughCount, _uri, _cost);
        emit brawndoughEvent(_owner);
        // existingTokenId.push(brawndoughCount);
        // electrolights[brawndoughCount].tokenIdentifier = existingTokenId.push(brawndoughCount);
    }

    function destroyBrawndough(address _owner, uint256 _tokenId)
    public
    {
        require(existingTokenId[_tokenId]>0, "Not a valid tokenID");
        // delete existingTokenId[_tokenId];
        super._burn(_owner, _tokenId);
        emit brawndoughEvent(_owner);
        //Fix
        // deleteEntity(_tokenId);
    }

    // https://ethereum.stackexchange.com/questions/13167/are-there-well-solved-and-simple-storage-patterns-for-solidity
    //https://medium.com/@robhitchens/solidity-crud-part-2-ed8d8b4f74ec
    function isEntity(uint256 _tokenId) public view returns(bool isIndeed) {
        if(existingTokenId.length == 0) return false;
        return (existingTokenId[electrolights[_tokenId].tokenIdentifier] == _tokenId);
    }

    function getEntityCount() public view returns(uint entityCount) {
        return existingTokenId.length;
    }

    function newEntity(uint256 _tokenId, uint256 tokenIdentifier) public returns(bool success) {
        if(isEntity(_tokenId)) revert();
        electrolights[_tokenId].tokenIdentifier = tokenIdentifier;
        electrolights[_tokenId].tokenIdentifier = existingTokenId.push(_tokenId) - 1;
        return true;
    }

    //Fix
    function deleteEntity(uint256 _tokenId) public returns(bool success) {
        if(!isEntity(_tokenId)) revert();
        uint256 rowToDelete = electrolights[_tokenId].tokenIdentifier;
        uint256 keyToMove = existingTokenId[existingTokenId.length-1];
        existingTokenId[rowToDelete] = keyToMove;
        electrolights[keyToMove].tokenIdentifier = rowToDelete;
        existingTokenId.length--;
        return true;
    }

    // function updateEntity(uint256 _tokenId, uint tokenIdentifier) public returns(bool success) {
    //     if(!isEntity(existingTokenId)) revert();
    //     electrolights[existingTokenId].tokenIdentifier = tokenIdentifier;
    //     return true;
    // }

      // function displayBrawndough()
    // public
    // returns(bytes32) 
    // { 
    //     for (uint i = 0 ; i<=exstingTokenId.length; i++){
    //         return electrolights[existingTokenId[i]];
    //     }
    // }

    // function transferBrawndough(address _owner, address _to, uint256 _tokenId)
    // public
    // {
    //     super._approve(_to, _tokenId);
    //     super._safeTransferFrom(_owner, _to, _tokenId);
    //     emit brawndoughEvent(_owner);
    // }

}