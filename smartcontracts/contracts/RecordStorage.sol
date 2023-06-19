//SPDX-License-Identifier:MIT
pragma solidity ^0.8.17;
import {KeyStorage} from "./KeyStorage.sol";
import {IRecordStorage} from "./interfaces/IRecordStorage.sol";


abstract contract RecordStorage is KeyStorage, IRecordStorage {


    //  _records: A mapping that stores the records for each preset ID and key hash.
    mapping(uint256 => mapping(uint256 => string)) internal _records;

    //   _tokenPresets: A mapping that stores the preset ID for each token ID.
    mapping(uint256 => uint256) internal _tokenPresets;


    //get: Retrieves the value of a record given a key and token ID.
    function get(string calldata key, uint256 tokenId) external view override returns (string memory value) {
        value = _get(key, tokenId);
    }

    //getMany: Retrieves the values of multiple records given an array of keys and a token ID.
    function getMany(string[] calldata keys, uint256 tokenId) external view override returns (string[] memory values) {
        values = new string[](keys.length);
        for (uint256 i = 0; i < keys.length; i++) {
            values[i] = _get(keys[i], tokenId);
        }
    }

    //getByHash: Retrieves the key and value of a record given a key hash and token ID.
    function getByHash(uint256 keyHash, uint256 tokenId)
        external
        view
        override
        returns (string memory key, string memory value)
    {
        (key, value) = _getByHash(keyHash, tokenId);
    }


    //getManyByHash: Retrieves the keys and values of multiple records given an array of key hashes and a token ID.
    function getManyByHash(uint256[] calldata keyHashes, uint256 tokenId)
        external
        view
        override
        returns (string[] memory keys, string[] memory values)
    {
        keys = new string[](keyHashes.length);
        values = new string[](keyHashes.length);
        for (uint256 i = 0; i < keyHashes.length; i++) {
            (keys[i], values[i]) = _getByHash(keyHashes[i], tokenId);
        }
    }

    //_presetOf: Returns the preset ID for a given token ID.
    function _presetOf(uint256 tokenId) internal view virtual returns (uint256) {
        return _tokenPresets[tokenId] == 0 ? tokenId : _tokenPresets[tokenId];
    }

    //_set: Sets a record with the specified key, value, and token ID.
    function _set(
        string calldata key,
        string calldata value,
        uint256 tokenId
    ) internal {
        uint256 keyHash = uint256(keccak256(abi.encodePacked(key)));
        _addKey(keyHash, key);
        _set(keyHash, key, value, tokenId);
    }

    //_setMany: Sets multiple records with the specified keys, values, and token ID.
    function _setMany(
        string[] calldata keys,
        string[] calldata values,
        uint256 tokenId
    ) internal {
        for (uint256 i = 0; i < keys.length; i++) {
            _set(keys[i], values[i], tokenId);
        }
    }

    // _setByHash: Sets a record with the specified key hash, value, and token ID.
    function _setByHash(
        uint256 keyHash,
        string calldata value,
        uint256 tokenId
    ) internal {
        require(_existsKey(keyHash), 'RecordStorage: KEY_NOT_FOUND');
        _set(keyHash, getKey(keyHash), value, tokenId);
    }

    //_setManyByHash: Sets multiple records with the specified key hashes, values, and token ID.
    function _setManyByHash(
        uint256[] calldata keyHashes,
        string[] calldata values,
        uint256 tokenId
    ) internal {
        for (uint256 i = 0; i < keyHashes.length; i++) {
            _setByHash(keyHashes[i], values[i], tokenId);
        }
    }

    //_reconfigure: Resets all records for a token ID and sets new records with the specified keys and values.
    function _reconfigure(
        string[] calldata keys,
        string[] calldata values,
        uint256 tokenId
    ) internal {
        _reset(tokenId);
        _setMany(keys, values, tokenId);
    }

    //_reset: Resets the preset ID for a token ID.
    function _reset(uint256 tokenId) internal {
        _tokenPresets[tokenId] = uint256(keccak256(abi.encodePacked(_presetOf(tokenId))));
        emit ResetRecords(tokenId);
    }

    //_get: Retrieves the value of a record given a key hash and token ID.
    function _get(string memory key, uint256 tokenId) private view returns (string memory) {
        return _get(uint256(keccak256(abi.encodePacked(key))), tokenId);
    }

    //_getByHash: Retrieves the key and value of a record given a key hash and token ID.
    function _getByHash(uint256 keyHash, uint256 tokenId)
        private
        view
        returns (string memory key, string memory value)
    {
        key = getKey(keyHash);
        value = _get(keyHash, tokenId);
    }

    //_get: Retrieves the value of a record given a key and token ID.
    function _get(uint256 keyHash, uint256 tokenId) private view returns (string memory) {
        return _records[_presetOf(tokenId)][keyHash];
    }

    //_set: Sets a record with the specified key, value, and token ID.
    function _set(
        uint256 keyHash,
        string memory key,
        string memory value,
        uint256 tokenId
    ) private {
        if (bytes(_records[_presetOf(tokenId)][keyHash]).length == 0) {
            emit NewKey(tokenId, key, key);
        }

        _records[_presetOf(tokenId)][keyHash] = value;
        emit Set(tokenId, key, value, key, value);
    }
}