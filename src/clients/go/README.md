# tigerbeetle-go

The TigerBeetle client for Go.

[![Go Reference](https://pkg.go.dev/badge/github.com/tigerbeetledb/tigerbeetle-go.svg)](https://pkg.go.dev/github.com/tigerbeetledb/tigerbeetle-go)

Make sure to import `github.com/tigerbeetledb/tigerbeetle-go`, not
this repo and subdirectory.

## Installation

```bash
printf 'package main

import _ "github.com/tigerbeetledb/tigerbeetle-go"
import "fmt"

func main() {
  fmt.Println("Import ok!")
}
' > test.go
go mod init tbtest
go mod tidy
go build
```

## Examples

## Basic

See [./samples/basic](./samples/basic) for a Go project
showing many features of the client.

## Usage

### Creating a client

```go
client, err := tb.NewClient(0, []string{"3000"}, 1)
if err != nil {
	log.Printf("Error creating client: %s", err)
	return
}
defer client.Close()"
```

`NewClient` takes three arguments: a unique `uint32` representing the cluster ID, an array of addressess for all servers in the cluster, a `uint` max concurrency setting (`1` is a good default and can increase to `4096` as you need increased throughput).

The following are valid addresses:
* `3000` (interpreted as `127.0.0.1:3000`)
* `127.0.0.1:3000` (interpreted as `127.0.0.1:3000`)
* `127.0.0.1` (interpreted as `127.0.0.1:3001`, `3001` is the default port)

### Creating accounts

See details for account fields in the [Accounts reference](https://docs.tigerbeetle.com/reference/accounts).

```go
// Create two accounts
res, err := client.CreateAccounts([]tb_types.Account{
	{
		ID:     uint128("1"),
		Ledger: 1,
		Code:   1,
	},
	{
		ID:     uint128("2"),
		Ledger: 1,
		Code:   1,
	},
})
if err != nil {
	log.Printf("Error creating accounts: %s", err)
	return
}

for _, err := range res {
	log.Printf("Error creating account %d: %s", err.Index, err.Code)
	return
}
```



## Development Setup

### On Linux and macOS

```bash
git clone https://github.com/tigerbeetledb/tigerbeetle
cd tigerbeetle/src/clients/go
./tigerbeetle/scripts/install_zig.sh
./scripts/rebuild_binaries.sh
./zgo test
```

### On Windows

```powershell
git clone https://github.com/tigerbeetledb/tigerbeetle
cd tigerbeetle/src/clients/go
./tigerbeetle/scripts/install_zig.bat
./scripts/rebuild_binaries.sh
./zgo.bat test
```

