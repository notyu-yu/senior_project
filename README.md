Sample implemetation of the Blockchain-Based Genome Bug Bounty Program described in this paper:
*TODO: Include link of final report*

This example uses gramine-direct to simulate SGX execution, but cannot generate attestations.

# File Structure:
- contracts: Smart contract component of protocol, written in Solidity.
- python: python scripts
    - host_init: Files for host initialization, including key generation and verifier scripts.
    - submitter_init: Files for submitter initialization, including key generation and sample exploit script.
    - verification_code: Files to execute verifier under simulated SGX with gramine-direct.
    - host_decryption: Helper scripts for host to recover exploit code from smart contract information.
    - test_scripts: Used for testing encryption and hashing

# Protocol Workflow: Check individual scripts for usage documentation
0. **Setup:** 

    a. Go to python/host_init/ and do the following:

        1. Create verifier.py and interface.py for testing exploits, the sample implemetation interface can be used as reference.

        2. Generate RSA keys with rsa_key_gen.py.

        3. Crate python.manifest for Gramine, the sample manifest if for a Ubuntu system.

        4. Use file_to_string.py to convert the files into Solidity string literals for pasting.

    b. Paste the verifier scripts, public key, and manifest files to the corresponding constants in contracts/zkcp-interface.sol.

    c. Deploy the GenomeBounty contract from zkcp-interface.sol in Remix, with the corresponding host Ethereum address

    d. Create the exploit submission.py, and generate a $k_{submitter}$ with python/submitter_init/submitter_key_gen.py

1. **Verifier Retrieval:** Retrieve verifier.py, interface.py, python.manifest, and public_key.txt from the smart contract constants, place them in the same folder (/python/verification_code used in example). (If the host verified the Solidity code on Etherscan, this can be copied from the source code)

2. **Exploit Verification:** Execute verifier.py and save outputs and attestation

    a. To execute with Gramine simulated SGX, do `gramine-direct python verifier.py`.

    b. For testing, executing verifier.py directly with python3 may be faster

3. **Upload Commitment:** Call the `submissionHandler` function with the hash of encrypted $k_{submitter}$ (First line of output) and encrypted exploit (Second line of output).

4. **Off-Chain Communication:** Send encrypted_code.bytes to the service provider through off-chain communication.

5. **Code Received Verification:** Service provider calls `codeReceived` with the corresponding submitter's address

6. **Claim Reward:** Submitter calls `rewardHandler` with the encrypted key to claim reward. (Use bytes_to_hex.py on encrypted_key.bytes)

7. **Recover Exploit:** Service provider go to /python/host_decryption and do the following:

    a. Put encrypted key in a bytes file with hex_to_bytes.py

    b. Decrypt the key with decrypt_key.py

    c. Decrypt the code with decrypt_code.py

