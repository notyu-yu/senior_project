// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PaymentToken {
    function transfer(
        uint256 balance,
        address payable receiver
    ) public returns (bool) {
        return true;
    }
}

contract SGXVerifier {
    function verify(
        string calldata attestation,
        string calldata MANEFEST
    ) public returns (bool) {
        return true;
    }
}

contract GenomeBounty {
    string constant MANEFEST = '[loader]\nentrypoint = "file:/usr/lib/x86_64-linux-gnu/gramine/libsysdb.so"\nlog_level = "error"\ninsecure__use_cmdline_argv = true\n\n[loader.env]\nLD_LIBRARY_PATH = "/lib:/lib:/lib/x86_64-linux-gnu:/usr//lib/x86_64-linux-gnu"\nOMP_NUM_THREADS = "4"\n\n[libos]\nentrypoint = "/usr/bin/python3.8"\n\n[sys]\nenable_sigterm_injection = true\nenable_extra_runtime_domain_names_conf = true\n\n[sys.stack]\nsize = "2M"\n\n[[fs.mounts]]\npath = "/lib"\nuri = "file:/usr/lib/x86_64-linux-gnu/gramine/runtime/glibc"\n\n[[fs.mounts]]\npath = "/lib/x86_64-linux-gnu"\nuri = "file:/lib/x86_64-linux-gnu"\n\n[[fs.mounts]]\npath = "/usr//lib/x86_64-linux-gnu"\nuri = "file:/usr//lib/x86_64-linux-gnu"\n\n[[fs.mounts]]\npath = "/usr/lib/python3.8"\nuri = "file:/usr/lib/python3.8"\n\n[[fs.mounts]]\npath = "/usr/lib/python3.8/lib-dynload"\nuri = "file:/usr/lib/python3.8/lib-dynload"\n\n[[fs.mounts]]\npath = "/usr/local/lib/python3.8/dist-packages"\nuri = "file:/usr/local/lib/python3.8/dist-packages"\n\n[[fs.mounts]]\npath = "/usr/lib/python3/dist-packages"\nuri = "file:/usr/lib/python3/dist-packages"\n\n[[fs.mounts]]\npath = "/usr/bin/python3.8"\nuri = "file:/usr/bin/python3.8"\n\n[[fs.mounts]]\npath = "/bin/sh"\nuri = "file:/bin/sh"\n\n[[fs.mounts]]\ntype = "tmpfs"\npath = "/tmp"\n\n[sgx]\ndebug = false\nedmm_enable = false\nenclave_size = "4G"\nmax_threads = 32\nremote_attestation = "none"\nra_client_spid = ""\nra_client_linkable = false\ntrusted_files = [\n    { uri = "file:/usr/lib/x86_64-linux-gnu/gramine/libsysdb.so" },\n    { uri = "file:/usr/bin/python3.8" },\n    { uri = "file:/usr/lib/x86_64-linux-gnu/gramine/runtime/glibc/" },\n    { uri = "file:/lib/x86_64-linux-gnu/" },\n    { uri = "file:/usr//lib/x86_64-linux-gnu/" },\n    { uri = "file:/usr/lib/python3.8/" },\n    { uri = "file:/usr/lib/python3.8/lib-dynload/" },\n    { uri = "file:/usr/local/lib/python3.8/dist-packages/" },\n    { uri = "file:/usr/lib/python3/dist-packages/" },\n    { uri = "file:/bin/sh" },\n    { uri = "file:./" },\n    { uri = "file:submission.py" },\n    { uri = "file:interface.py" },\n    { uri = "file:public_key.txt" },\n    { uri = "file:submitter_key.txt" },\n]\nisvprodid = 0\nisvsvn = 0\nenable_stats = false\nuse_exinfo = false\n\n[sgx.cpu_features]\navx = "unspecified"\navx512 = "unspecified"\namx = "unspecified"\nmpx = "disabled"\npkru = "disabled"\n';
    string constant VERIFIER = '\'\'\'\nVerifies validity of encrypted code, keys, key_hash, and exploit code\n\'\'\'\nfrom hashlib import sha256\nimport rsa\nfrom submission import exploit_entry\nfrom interface import database_interface, database_init, verify_results\nfrom cryptography.fernet import Fernet\n\n\ndef generate_commitments():\n    \'\'\'\n    Generate encrypted files and hashes for commitment\n    Print encrypted key hash and hash of encrypted code\n    \'\'\'\n    # Import encryption keys\n    with open(\'public_key.txt\', \'r\', encoding=\'utf-8\') as fp:\n        public_key = rsa.PublicKey.load_pkcs1(fp.read().encode(\'utf-8\'))\n    with open(\'submitter_key.bytes\', \'rb\') as fp:\n        submitter_key = fp.read()\n    fernet = Fernet(submitter_key)\n\n    # Generate encrypted_key.txt\n    with open(\'encrypted_key.bytes\', \'wb+\') as fp:\n        public_encrypted_key = rsa.encrypt(\n            submitter_key, public_key)\n        fp.write(public_encrypted_key)\n\n    # Generate key_hash.txt\n    with open(\'key_hash.txt\', \'w+\', encoding=\'utf-8\') as fp:\n        fp.write(sha256(public_encrypted_key).hexdigest())\n        print(sha256(public_encrypted_key).hexdigest())\n\n    # Generate ecrypted_code.txt\n    with open(\'submission.py\', \'r\', encoding=\'utf-8\') as code_fp, \\\n            open(\'encrypted_code.bytes\', \'wb\') as encrypted_fp:\n        code_str = code_fp.read().encode(\'utf-8\')\n        code_public_encrypted = b\'\'.join([rsa.encrypt(\n            code_str[i:i+245], public_key) for i in range(0, len(code_str), 245)])\n        code_fernet_encrypted = fernet.encrypt(code_public_encrypted)\n        encrypted_fp.write(code_fernet_encrypted)\n        print(sha256(code_fernet_encrypted).hexdigest())\n\n\nif __name__ == "__main__":\n    # Generate commitments for submission\n    generate_commitments()\n\n    # Initialize database\n    hashes = database_init()\n\n    # Run exploit\n    results = exploit_entry(database_interface)\n\n    # Check submission hash\n    print(verify_results(results))\n';
    string constant INTERFACE = '\'\'\'\nDefines interaction interface of database\n\'\'\'\nimport random\nfrom hashlib import sha256\nimport numpy as np\nimport faiss\n\nrand_data = None\ndata_hashes = None\nindex = None\n\nLENGTH = 1000  # Length of sequences\nDATA_SIZE = 1000  # Number of datapoints generated\nRESULT_SIZE = 100  # Max number of result sequences accepted\nMAX_DISTANCE = LENGTH/100  # Maximum hamming distance variation allowed for results\n\n\ndef database_init():\n    \'\'\'\n    Generate random numpy arrays for dataset\n    Returns a list of hashes\n    \'\'\'\n    global rand_data\n    global data_hashes\n    global index\n    rand_data = np.random.randint(0, high=4, size=(DATA_SIZE, LENGTH))\n    data_hashes = [sha256(x).hexdigest() for x in rand_data]\n\n    # Create LSH neighbor search object\n    index = faiss.IndexLSH(LENGTH,40)\n    index.add(rand_data)\n\n    return data_hashes\n\n\ndef database_interface(command):\n    \'\'\'\n    Simulate interaction interface, URL request, etc.\n    \'\'\'\n    if command == \'leak\':\n        return random.choice(rand_data)\n    return ""\n\n\ndef verify_results(results_list):\n    \'\'\'\n    Check if any entry in results_list is close to a database entry\n    Returns boolean as result\n    \'\'\'\n    assert len(\n        results_list) <= RESULT_SIZE, f\'Result size {RESULT_SIZE} exceeded\'\n    _, reference_matches = index.search(results_list, 1)\n    for reference, exploit in zip(reference_matches, results_list):\n        if np.sum(rand_data[reference] != exploit) <= MAX_DISTANCE:\n            return True\n    return False\n';
    string constant PUBKEY = '-----BEGIN RSA PUBLIC KEY-----\nMIIBCgKCAQEAjBGkgQo/WFc+qlNOPlx4SSRVfEVL0HSzeVzploPuoHyQohjdLkNr\nJ8l9Jy3EoYpBU4mcCdeHm0rAS2CwB3BWY+7l5U3ttiBpmE9PfGsP59skug1bQscw\ntHH1bHk+nhvCwAapq7Ktpj9trlgxbmWZO564kAWR0bf/bpiJ1NBdhBtIT7jw4ArB\nHTjWsXRWczNCT8p7X5hVJIXtKBQogSy7Hr+NmDGUzgXNrKsHZhl+dmxqRaMfx4Z8\nnCc1CP4HcBclqE4ZmkK05WCYFnMBL2YQkNCsGRvqb0sek8bjAh28MuWW7yZ16ox3\nOugdOExQE24SeCvbvRslv4Nhg3p2m2lp3wIDAQAB\n-----END RSA PUBLIC KEY-----\n';

    address private owner;
    uint256 public balance = 1000; // Balance of tokens/ether

    mapping(address => bool) public user_registered;
    mapping(address => bool) public code_received;
    mapping(address => uint256) public key_hash_map;
    mapping(address => uint256) public code_hash_map;
    mapping(address => bytes) public submitter_key_map;

    // External Contracts
    SGXVerifier public verifier;
    PaymentToken public token;

    modifier isOwner() {
        require(msg.sender == owner, "Function only available to owner");
        _;
    }

    modifier validUser() {
        require(user_registered[msg.sender], "User not registered");
        _;
    }

    event submissionReceived(
        address indexed submitter,
        uint256 indexed code_hash,
        string indexed attestation
    );

    event keyReceived(address indexed submitter, bytes indexed submitter_key);

    constructor(address owner_addr) {
        owner = owner_addr;
        verifier = new SGXVerifier();
        token = new PaymentToken();
    }

    function submission(
        uint256 code_hash,
        uint256 key_hash,
        string calldata attestation
    ) public validUser {
        // Verify attestation
        require(
            verifier.verify(attestation, MANEFEST) == true,
            "attestation not valid"
        );

        // Store key hash
        key_hash_map[msg.sender] = key_hash;
        code_hash_map[msg.sender] = code_hash;

        // Emit submission event
        emit submissionReceived(msg.sender, code_hash, attestation);
    }

    function claimRewards(bytes calldata submitter_key) public validUser {
        require(
            key_hash_map[msg.sender] == uint256(sha256(submitter_key)),
            "Key is incorrect"
        );
        require(
            code_received[msg.sender],
            "Code not received yet, send to host at example@example.com"
        );

        // Store key and send payment
        submitter_key_map[msg.sender] = submitter_key;
        token.transfer(balance, payable(msg.sender));

        // Emit key received event
        emit keyReceived(msg.sender, submitter_key);
    }

    function registerUser(address new_id) public isOwner {
        // Allow owner to register users
        user_registered[new_id] = true;
    }

    function codeReceived(address submitter) public isOwner {
        // Allow owner to mark which code is received
        code_received[submitter] = true;
    }
}
