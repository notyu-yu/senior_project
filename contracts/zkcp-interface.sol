// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PaymentToken {
    function transfer(uint256 balance, address payable receiver) public returns(bool) {
        return true;
    }
}

contract SGXVerifier {
    function verify(string calldata attestation, string calldata MANEFEST) public returns(bool) {
        return true;
    }
}

contract GenomeBounty {
    uint256 public constant SUBMISSION_COOLDOWN = 259200; // 3 day cooldown
    string constant MANEFEST = "";
    string constant PUBKEY = "";
    address private owner;
    uint256 public balance = 1000; // Balance of tokens/ether
    mapping(address => bool) user_registered;
    mapping(address => uint256) submission_keyhash;
    mapping(address => uint256) submit_time; // Track last submission time for rate limit

    // External Contracts
    SGXVerifier public verifier;
    PaymentToken public token;

    modifier isOwner() {
        require(msg.sender == owner, "Function only available to owner");
        _;
    }

    event submissionReceived(
        address indexed submitter,
        string indexed code,
        string indexed attestation
    );

    event keyReceived(address indexed submitter, string indexed key);

    constructor(address owner_addr) {
        owner = owner_addr;
        verifier = new SGXVerifier();
        token = new PaymentToken();
    }

    function submission(
        string calldata encrypted_code,
        uint256 key_hash,
        string calldata attestation
    ) public {
        // Check rate limit
        require(
            user_registered[msg.sender] &&
                block.timestamp >= submit_time[msg.sender] &&
                block.timestamp - submit_time[msg.sender] >=
                SUBMISSION_COOLDOWN,
            "Submission for account still in cooldown"
        );

        // Verify attestation (Placeholder)
        require(
            verifier.verify(attestation, MANEFEST) == true,
            "attestation not valid"
        );
        submit_time[msg.sender] == block.timestamp;
        submission_keyhash[msg.sender] = key_hash;

        // Emit submission event
        emit submissionReceived(msg.sender, encrypted_code, attestation);
    }

    function claimRewards(string calldata encrypted_submitter_key) public {
        require(
            submission_keyhash[msg.sender] == uint256(sha256(bytes(encrypted_submitter_key))),
            "Key has incorrect"
        );
        token.transfer(balance, payable(msg.sender));

        // Emit key received event
        emit keyReceived(msg.sender, encrypted_submitter_key);
    }

    function registerID(address new_id) public isOwner {
        // Allow owner to register users
        user_registered[new_id] = true;
    }
}
