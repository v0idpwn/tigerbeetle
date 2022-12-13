const Docs = @import("../docs_types.zig").Docs;

pub const NodeDocs = Docs{
    .readme = "node/README.md",

    .markdown_name = "javascript",
    .extension = "js",

    .test_linux_docker_image = "node:18",

    .name = "tigerbeetle-node",
    .description = 
    \\The TigerBeetle client for Node.js.
    ,

    .prerequisites = 
    \\* NodeJS >= `14`. _(If the correct version is not installed, an installation error will occur)_
    \\
    \\> Your operating system should be Linux (kernel >= v5.6) or macOS.
    \\> Windows support is not yet available.
        ,

    .install_sample_file =
        \\const Client = require("tigerbeetle-node");
        \\console.log("Import ok!");
        ,

    .install_sample_file_test_commands = "node run test.js",

        .install_commands = "npm install tigerbeetle-node",

    .install_documentation = 
    \\If you run into issues, check out the distribution-specific install
    \\steps that are run in CI to test support:
    \\
    \\* [Alpine](./scripts/test_install_on_alpine.sh)
    \\* [Amazon Linux](./scripts/test_install_on_amazonlinux.sh)
    \\* [Debian](./scripts/test_install_on_debian.sh)
    \\* [Fedora](./scripts/test_install_on_fedora.sh)
    \\* [Ubuntu](./scripts/test_install_on_ubuntu.sh)
    \\* [RHEL](./scripts/test_install_on_rhelubi.sh)
    ,

    .examples = "",

    .client_object_example = 
    \\const client = createClient({
    \\  cluster_id: 0,
    \\  replica_addresses: ['3001', '3002', '3003']
    \\});
    ,

    .client_object_documentation = "",

    .create_accounts_example = 
    \\const account = {
    \\  id: 137n, // u128
    \\  user_data: 0n, // u128, opaque third-party identifier to link this account to an external entity:
    \\  reserved: Buffer.alloc(48, 0), // [48]u8
    \\  ledger: 1,   // u32, ledger value
    \\  code: 718, // u16, a chart of accounts code describing the type of account (e.g. clearing, settlement)
    \\  flags: 0,  // u16
    \\  debits_pending: 0n,  // u64
    \\  debits_posted: 0n,  // u64
    \\  credits_pending: 0n, // u64
    \\  credits_posted: 0n, // u64
    \\  timestamp: 0n, // u64, Reserved: This will be set by the server.
    \\};
    \\
    \\const errors = await client.createAccounts([account]);
    \\if (errors.length) {
    \\  // Grab a human-readable message from the response
    \\  console.log(CreateAccountError[errors[0].code]);
    \\}
    ,

    .create_accounts_documentation = "",

    .account_flags_details = 
    \\To toggle behavior for an account, combine enum values stored in the
    \\`AccountFlags` object (in TypeScript it is an actual enum) with
    \\bitwise-or:
    \\
    \\* `AccountFlags.linked`
    \\* `AccountFlags.debits_must_not_exceed_credits`
    \\* `AccountFlags.credits_must_not_exceed_credits`
    \\
    \\For example, to link `account0` and `account1`, where `account0`
    \\additionally has the `debits_must_not_exceed_credits` constraint:
    \\
    \\```js
    \\const account0 = { ... account values ... };
    \\const account1 = { ... account values ... };
    \\account0.flags = AccountFlags.linked | AccountFlags.debits_must_not_exceed_credits;
    \\// Create the account
    \\const errors = client.createAccounts([account0, account1]);
    \\```
    ,

    .lookup_accounts_example = 
    \\// account 137n exists, 138n does not
    \\const accounts = await client.lookupAccounts([137n, 138n]);
    \\/* console.log(accounts);
    \\ * [{
    \\ *   id: 137n,
    \\ *   user_data: 0n,
    \\ *   reserved: Buffer,
    \\ *   ledger: 1,
    \\ *   code: 718,
    \\ *   flags: 0,
    \\ *   debits_pending: 0n,
    \\ *   debits_posted: 0n,
    \\ *   credits_pending: 0n,
    \\ *   credits_posted: 0n,
    \\ *   timestamp: 1623062009212508993n,
    \\ * }]
    \\ */
    ,

    .developer_setup_bash_commands = 
    \\npm install --include dev # This will automatically install and build everything you need.
    ,

    .developer_setup_windows_commands = 
    \\npm install --include dev # This will automatically install and build everything you need.
    ,
};
