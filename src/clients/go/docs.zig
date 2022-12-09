const Docs = @import("../docs_types.zig").Docs;

pub const GoDocs = Docs{
    .readme = "go/README.md",

    .header = 
    \\# tigerbeetle-go
    \\
    \\The TigerBeetle client for Go.
    \\
    \\[![Go Reference](https://pkg.go.dev/badge/github.com/tigerbeetledb/tigerbeetle-go.svg)](https://pkg.go.dev/github.com/tigerbeetledb/tigerbeetle-go)
    \\
    \\Make sure to import `github.com/tigerbeetledb/tigerbeetle-go`, not
    \\this repo and subdirectory.
    \\
    \\For example:
    \\
    \\```bash
    \\$ cat test.go
    \\package main
    \\
    \\import _ "github.com/tigerbeetledb/tigerbeetle-go"
    \\import "fmt"
    \\
    \\func main() {
    \\  fmt.Println("Import ok!")
    \\}
    \\
    \\$ go mod init tigerbeetle-test
    \\$ go mod tidy
    \\$ go build
    \\$ ./tigerbeetle-test
    \\Import ok!
    \\```
    \\
    \\## A more real example
    \\
    \\See [./samples/basic](./samples/basic) for a Go project
    \\showing many features of the client.
    ,

    .developer_setup_bash_commands = [5][]const u8{
        "git clone https://github.com/tigerbeetledb/tigerbeetle",
        "cd tigerbeetle/src/clients/go",
        "./tigerbeetle/scripts/install_zig.sh",
        "./scripts/rebuild_binaries.sh",
        "./zgo test",
    },

    .developer_setup_windows_commands = [5][]const u8{
        "git clone https://github.com/tigerbeetledb/tigerbeetle",
        "cd tigerbeetle/src/clients/go",
        "./tigerbeetle/scripts/install_zig.bat",
        "./scripts/rebuild_binaries.sh",
        "./zgo.bat test",
    },
};
