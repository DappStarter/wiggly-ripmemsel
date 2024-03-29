pragma solidity  >=0.5.0;

import "./interfaces/IDappState.sol";
import "./DappLib.sol";


/********************************************************************************************/
/* This contract is auto-generated based on your choices in DappStarter. You can make       */
/* changes, but be aware that generating a new DappStarter project will require you to      */
/* merge changes. One approach you can take is to make changes in Dapp.sol and have it      */
/* call into this one. You can maintain all your data in this contract and your app logic   */
/* in Dapp.sol. This lets you update and deploy Dapp.sol with revised code and still        */
/* continue using this one.                                                                 */
/********************************************************************************************/

contract DappState is IDappState {
    // Allow DappLib(SafeMath) functions to be called for all uint256 types
    // (similar to "prototype" in Javascript)
    using DappLib for uint256; 

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> FILE STORAGE: IPFS  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
    using DappLib for DappLib.Multihash;


/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ S T A T E @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/

    // Account used to deploy contract
    address private contractOwner;                  

/*>>>>>>>>>>>>>>>>>>>>>>>>>>> ACCESS CONTROL: CONTRACT RUN STATE  <<<<<<<<<<<<<<<<<<<<<<<<<<*/
    // Contract run state
    bool private contractRunState = true;          

/*>>>>>>>>>>>>>>>>>>>>>>>>>>> ACCESS CONTROL: ADMINISTRATOR ROLE  <<<<<<<<<<<<<<<<<<<<<<<<<<*/
    // Track authorized admins count to prevent lockout
    uint256 private authorizedAdminsCount = 1;                      

    // Admins authorized to manage contract
    mapping(address => uint256) private authorizedAdmins;                      

/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> FILE STORAGE: IPFS  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
    struct IpfsDocument {
        // Unique identifier -- defaults to multihash digest of file
        bytes32 docId;    

        bytes32 label;

        // Registration timestamp                                          
        uint256 timestamp;  

        // Owner of document                                        
        address owner;    

        // External Document reference                                          
        DappLib.Multihash docRef;                                   
    }

    // All added documents
    mapping(bytes32 => IpfsDocument) ipfsDocs;                            

    uint constant IPFS_DOCS_PAGE_SIZE = 50;
    uint256 public ipfsLastPage = 0;

    // All documents organized by page
    mapping(uint256 => bytes32[]) public ipfsDocsByPage;         

    // All documents for which an account is the owner
    mapping(address => bytes32[]) public ipfsDocsByOwner;              


/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ C O N S T R U C T O R @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/

    constructor() public 
    {
        contractOwner = msg.sender;       

/*>>>>>>>>>>>>>>>>>>>>>>>>>>> ACCESS CONTROL: ADMINISTRATOR ROLE  <<<<<<<<<<<<<<<<<<<<<<<<<<*/
        // Add account that deployed contract as an authorized admin
        authorizedAdmins[msg.sender] = 1;       

    }

/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ E V E N T S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/


/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> FILE STORAGE: IPFS  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
    // Event fired when doc is added
    event AddIpfsDocument      
                    (
                        bytes32 indexed docId,
                        address indexed owner,
                        uint256 timestamp
                    );


/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ M O D I F I E R S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/


/*>>>>>>>>>>>>>>>>>>>>>>>>>>> ACCESS CONTROL: CONTRACT RUN STATE  <<<<<<<<<<<<<<<<<<<<<<<<<<*/
    /**
    * @dev Modifier that requires the "contractRunState" boolean variable to be "true"
    *      This is used on all state changing functions to pause the contract in 
    *      the event there is an issue that needs to be fixed
    */
    modifier requireContractRunStateActive() 
    {
        require(contractRunState, "Contract is currently not active");
        // Modifiers require an "_" which indicates where the function body will be added
        _; 
    }

/*>>>>>>>>>>>>>>>>>>>>>>>>>>> ACCESS CONTROL: ADMINISTRATOR ROLE  <<<<<<<<<<<<<<<<<<<<<<<<<<*/
    /**
    * @dev Modifier that requires the function caller to be a contract admin
    */
    modifier requireContractAdmin()
    {
        require(isContractAdmin(msg.sender), "Caller is not a contract administrator");
        // Modifiers require an "_" which indicates where the function body will be added
        _;
    }


/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ F U N C T I O N S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/
/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/


/*>>>>>>>>>>>>>>>>>>>>>>>>>>> ACCESS CONTROL: CONTRACT RUN STATE  <<<<<<<<<<<<<<<<<<<<<<<<<<*/
    /**
    * @dev Get active status of contract
    *
    * @return A bool that is the current active status
    */    
    function isContractRunStateActive()
                        external 
                        view 
                        returns(bool)
    {
        return contractRunState;
    }

    /**
    * @dev Sets contract active status on/off
    *
    * When active status is off, all write transactions except for this one will fail
    */    
    function setContractRunState
                    (
                        bool mode
                    ) 
                    external 
                    // **** WARNING: Adding requireContractRunStateActive modifier will result in contract lockout ****
                    requireContractAdmin  // Administrator Role block is required to ensure only authorized individuals can pause contract
    {
        contractRunState = mode;
    }
                        

/*>>>>>>>>>>>>>>>>>>>>>>>>>>> ACCESS CONTROL: ADMINISTRATOR ROLE  <<<<<<<<<<<<<<<<<<<<<<<<<<*/
    /**
    * @dev Checks if an account is an admin
    *
    * @param account Address of the account to check
    */
    function isContractAdmin
                            (
                                address account
                            ) 
                            public 
                            view
                            returns(bool) 
    {
        return authorizedAdmins[account] == 1;
    }


    /**
    * @dev Adds a contract admin
    *
    * @param account Address of the admin to add
    */
    function addContractAdmin
                            (
                                address account
                            ) 
                            external 
                            requireContractRunStateActive 
                            requireContractAdmin
    {
        require(account != address(0), "Invalid address");
        require(authorizedAdmins[account] < 1, "Account is already an administrator");

        authorizedAdmins[account] = 1;
        authorizedAdminsCount++;
    }

    /**
    * @dev Removes a previously added admin
    *
    * @param account Address of the admin to remove
    */
    function removeContractAdmin
                            (
                                address account
                            ) 
                            external 
                            requireContractRunStateActive
                            requireContractAdmin
    {
        require(account != address(0), "Invalid address");
        require(authorizedAdminsCount >= 2, "Cannot remove last admin");

        delete authorizedAdmins[account];
        authorizedAdminsCount--;
    }

    /**
    * @dev Removes the last admin fully decentralizing the contract
    *
    * @param account Address of the admin to remove
    */
    function removeLastContractAdmin
                            (
                                address account
                            ) 
                            external 
                            requireContractRunStateActive
                            requireContractAdmin
    {
        require(account != address(0), "Invalid address");
        require(authorizedAdminsCount == 1, "Not the last admin");

        delete authorizedAdmins[account];
        authorizedAdminsCount--;
    }


/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> FILE STORAGE: IPFS  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
    /**
    * @dev Adds a new IPFS doc
    *
    * @param docId Unique identifier (multihash digest of doc audio)
    * @param label Short, descriptive label for document
    * @param digest Digest of folder with doc binary and metadata
    * @param hashFunction Function used for generating doc folder hash
    * @param digestLength Length of doc folder hash
    */
    function addIpfsDocument
                        (
                            bytes32 docId,
                            bytes32 label,
                            bytes32 digest,
                            uint8 hashFunction,
                            uint8 digestLength
                        ) 
                        external 
                           requireContractAdmin
    {
        // Prevent empty string for docId
        require(docId[0] != 0, "Invalid docId");  

        // Prevent empty string for digest                             
        require(digest[0] != 0, "Invalid ipfsDoc folder digest");            

        // Prevent duplicate docIds   
        require(ipfsDocs[docId].timestamp == 0, "Document already exists");     

        ipfsDocs[docId] = IpfsDocument({
                                    docId: docId,
                                    label: label,
                                    timestamp: now,
                                    owner: msg.sender,
                                    docRef: DappLib.Multihash({
                                                    digest: digest,
                                                    hashFunction: hashFunction,
                                                    digestLength: digestLength
                                                })
                               });

        ipfsDocsByOwner[msg.sender].push(docId);
        if (ipfsDocsByPage[ipfsLastPage].length == IPFS_DOCS_PAGE_SIZE) {
            ipfsLastPage++;
        }
        ipfsDocsByPage[ipfsLastPage].push(docId);

        emit AddIpfsDocument(docId, msg.sender, ipfsDocs[docId].timestamp);
    }

    /**
    * @dev Gets individual IPFS doc by docId
    *
    * @param id DocumentId of doc
    */
    function getIpfsDocument
                    (
                        bytes32 id
                    )
                    external
                    view
                    returns(
                                bytes32 docId, 
                                bytes32 label,
                                uint256 timestamp, 
                                address owner, 
                                bytes32 docDigest,
                                uint8 docHashFunction,
                                uint8 docDigestLength
                    )
    {
        IpfsDocument memory ipfsDoc = ipfsDocs[id];
        docId = ipfsDoc.docId;
        label = ipfsDoc.label;
        timestamp = ipfsDoc.timestamp;
        owner = ipfsDoc.owner;
        docDigest = ipfsDoc.docRef.digest;
        docHashFunction = ipfsDoc.docRef.hashFunction;
        docDigestLength = ipfsDoc.docRef.digestLength;

    }

    /**
    * @dev Gets docs where account is/was an owner
    *
    * @param account Address of owner
    */
    function getIpfsDocumentsByOwner
                            (
                                address account
                            )
                            external
                            view
                            returns(bytes32[] memory)
    {
        require(account != address(0), "Invalid account");

        return ipfsDocsByOwner[account];
    }


    /**
    * @dev This is an EXAMPLE function that illustrates how functions in this contract can be
    *      called securely from another contract. Using the Contract Access block will enable
    *      you to make your contract more secure by restricting which external contracts can
    *      call functions in this contract.
    *
    */
    function getContractOwner()
                                external
                                view
                                returns(address)
    {
        // NOTE: If a contract is calling this function, then msg.sender will be the address
        //       of the calling contract and NOT the address of the user who initiated the
        //       transaction. It is possible to get the address of the user, but this is 
        //       spoofable and therefore not recommended.
        
        return contractOwner;
    }
}   


