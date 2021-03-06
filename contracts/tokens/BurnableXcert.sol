pragma solidity ^0.4.24;

import "./Xcert.sol";

/**
 * @dev Xcert implementation where tokens can be destroyed by the owner or operator.
 */
contract BurnableXcert is Xcert {

  /**
   * @dev Contract constructor.
   * @notice When implementing this contract don't forget to set nftConventionId, nftName and
   * nftSymbol.
   */
  constructor()
    public
  {
    supportedInterfaces[0x42966c68] = true; // BurnableXcert
  }

  /**
   * @dev Burns a specified NFT.
   * @param _tokenId Id of the NFT we want to burn.
   */
  function burn(
    uint256 _tokenId
  )
    canOperate(_tokenId)
    validNFToken(_tokenId)
    external
  {
    super._burn(msg.sender, _tokenId);
    delete data[_tokenId];
    delete config[_tokenId];
    delete idToProof[_tokenId];
  }
}