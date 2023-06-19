//SPDX-License-Identifier:MIT
pragma solidity ^0.8.17;


import {ITRC721} from "./ITRC721.sol";


interface ITRC721Metadata is ITRC721 {
    /**
     * @dev Returns the token collection name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the token collection symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}