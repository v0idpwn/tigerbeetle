const Docs = @import("../docs_types.zig").Docs;

pub const GoDocs = Docs{
    .readme = "go/README.md",

    .markdown_name = "go",

    .test_linux_docker_image = "go:1.18",

    .name = "tigerbeetle-go",
    .description = 
    \\The TigerBeetle client for Go.
    \\
    \\[![Go Reference](https://pkg.go.dev/badge/github.com/tigerbeetledb/tigerbeetle-go.svg)](https://pkg.go.dev/github.com/tigerbeetledb/tigerbeetle-go)
    \\
    \\Make sure to import `github.com/tigerbeetledb/tigerbeetle-go`, not
    \\this repo and subdirectory.
    ,
    .install_commands = 
    \\printf 'package main
    \\
    \\import _ "github.com/tigerbeetledb/tigerbeetle-go"
    \\import "fmt"
    \\
    \\func main() {
    \\  fmt.Println("Import ok!")
    \\}
    \\' > test.go
    \\go mod init tbtest
    \\go mod tidy
    \\go build
    ,

    .examples = 
    \\## Basic
    \\
    \\See [./samples/basic](./samples/basic) for a Go project
    \\showing many features of the client.
    ,

    .client_object_example = 
    \\client, err := tb.NewClient(0, []string{"3000"}, 1)
    \\if err != nil {
    \\	log.Printf("Error creating client: %s", err)
    \\	return
    \\}
    \\defer client.Close()"
    ,

    .client_object_documentation = "`NewClient` takes three arguments: a unique `uint32` representing the cluster ID, an array of addressess for all servers in the cluster, a `uint` max concurrency setting (`1` is a good default and can increase to `4096` as you need increased throughput).",

    .create_accounts_example = 
    \\// Create two accounts
    \\res, err := client.CreateAccounts([]tb_types.Account{
    \\	{
    \\		ID:     uint128("1"),
    \\		Ledger: 1,
    \\		Code:   1,
    \\	},
    \\	{
    \\		ID:     uint128("2"),
    \\		Ledger: 1,
    \\		Code:   1,
    \\	},
    \\})
    \\if err != nil {
    \\	log.Printf("Error creating accounts: %s", err)
    \\	return
    \\}
    \\
    \\for _, err := range res {
    \\	log.Printf("Error creating account %d: %s", err.Index, err.Code)
    \\	return
    \\}
    ,

    .create_accounts_documentation = 
    \\The `tb_types` package can be imported from `"github.com/tigerbeetledb/tigerbeetle-go/pkg/types"`.
    \\
    \\And the `uint128` helper function above can be defined as follows:
    \\```go
    \\func uint128(value string) tb_types.Uint128 {
    \\	x, err := tb_types.HexStringToUint128(value)
    \\	if err != nil {
    \\		panic(err)
    \\	}
    \\	return x
    \\}
    \\```
    ,

    .account_flags_details = "",

    .lookup_accounts_example = 
    \\accounts, err := client.LookupAccounts([]tb_types.Uint128{uint128("1"), uint128("2")})
    \\if err != nil {
    \\	log.Printf("Could not fetch accounts: %s", err)
    \\	return
    \\}
    ,

    .developer_setup_bash_commands = 
    \\git clone https://github.com/tigerbeetledb/tigerbeetle
    \\cd tigerbeetle/src/clients/go
    \\./tigerbeetle/scripts/install_zig.sh
    \\./scripts/rebuild_binaries.sh
    \\./zgo test
    ,

    .developer_setup_windows_commands = 
    \\git clone https://github.com/tigerbeetledb/tigerbeetle
    \\cd tigerbeetle/src/clients/go
    \\./tigerbeetle/scripts/install_zig.bat
    \\./scripts/rebuild_binaries.sh
    \\./zgo.bat test
    ,
};
