pragma solidity  >=0.5.0;

// Shared library for all contracts
library DappLib {


/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> FILE STORAGE: IPFS  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
    // All IPFS references will be stored using Multihash struct. 
    // This ensures that if/when the IPFS hash function changes, 
    // there will be no adverse impact on this contract

    // Struct for storing IPFS multi-hash
    struct Multihash {              
        // Hash digest                    
        bytes32 digest;         

        // Function used -- initially sha256                          
        uint8 hashFunction;    

        // Length of digest                         
        uint8 digestLength;                             
    }

    
// *** BEGIN SafeMath -- Copyright (c) 2016 Smart Contract Solutions, Inc. ***

// It's important to avoid vulnerabilities due to numeric overflow bugs
// OpenZeppelin's SafeMath library, when used correctly, protects agains such bugs

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
        return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
    
}

