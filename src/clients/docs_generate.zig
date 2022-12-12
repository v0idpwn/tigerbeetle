const std = @import("std");

const Docs = @import("./docs_types.zig").Docs;
const go = @import("./go/docs.zig").GoDocs;
const node = @import("./node/docs.zig").NodeDocs;

const languages = [_]Docs{go, node};

// pub fn run_in_docker(image: []const u8, cmds: [][]const u8) !void {
//     var cp = std.child_process.ChildProcess.init("docker", &[_][]const u8{
//         "run",
//         language,
//         },
//                                                  );
// }

// pub fn validate_docs(language: Docs) {
//     try run_in_docker(
//         language.test_linux_docker_image,
//         language.install,
//     );
//     try run_in_docker(
//         language.test_linux_docker_image,
//         language.developer_setup_bash_commands,
//     );
// }

pub fn printHeader(writer: std.fs.File.Writer, n: i8, content: []const u8) !void {
    var x = n;
    while (x > 0) {
        try writer.print("#", .{});
        x -= 1;
    }

    try writer.print(" {s}\n\n", .{content});
}

pub fn printParagraph(writer: std.fs.File.Writer, content: []const u8) !void {
    try writer.print("{s}\n\n", .{content});
}

pub fn printCodeBlock(writer: std.fs.File.Writer, language: []const u8, content: []const u8) !void {
    try writer.print("```{s}\n{s}\n```\n\n", .{ language, content });
}

pub fn printLanguageCodeBlock(writer: std.fs.File.Writer, language: Docs, content: []const u8) !void {
    try printCodeBlock(writer, language.markdown_name, content);
}

pub fn main() !void {
    for (languages) |language| {
        //try validate_docs(language);

        const file = try std.fs.cwd().openFileZ(language.readme, .{ .mode = .write_only });
        // Truncate file
        try file.setEndPos(0);
        defer file.close();

        const writer = file.writer();

        try printHeader(writer, 1, language.name);
        try printParagraph(writer, language.description);

        try printHeader(writer, 2, "Installation");
        try printCodeBlock(writer, "bash", language.install_commands);

        if (language.examples.len != 0) {
            try printHeader(writer, 2, "Examples");
            try printParagraph(writer, language.examples);
        }

        try printHeader(writer, 2, "Creating a Client");
        try printLanguageCodeBlock(writer, language, language.client_object_example);
        try printParagraph(writer, language.client_object_documentation);

        try writer.print("The following are valid addresses:\n", .{});
        try writer.print("* `3000` (interpreted as `127.0.0.1:3000`)\n", .{});
        try writer.print("* `127.0.0.1:3000` (interpreted as `127.0.0.1:3000`)\n", .{});
        try writer.print("* `127.0.0.1` (interpreted as `127.0.0.1:3001`, `3001` is the default port)\n\n", .{});

        try printHeader(writer, 2, "Creating Accounts");
        try printParagraph(writer, "See details for account fields in the [Accounts reference](https://docs.tigerbeetle.com/reference/accounts).");
        try printLanguageCodeBlock(writer, language, language.create_accounts_example);
        try printParagraph(writer, language.create_accounts_documentation);

        try printHeader(writer, 3, "Account Flags");
        try printParagraph(writer, "The account flags value is a bitfield. See details for these flags in the [Accounts reference](https://docs.tigerbeetle.com/reference/accounts#flags).");
        try printParagraph(writer, language.account_flags_details);

        try printHeader(writer, 3, "Response and Errors");
        try printParagraph(writer, "The response is an empty array if all accounts were created successfully. If the response is non-empty, each object in the response array contains error information for an account that failed. The error object contains an error code and the index of the account in the request batch.");

        try printHeader(writer, 2, "Account Lookup");
        try printParagraph(writer, "Account lookup is batched, like account creation. Pass in all IDs to fetch, and matched accounts are returned.");
        try printParagraph(writer, "If no account matches an ID, no object is returned for that account. So the order of accounts in the response is not necessarily the same as the order of IDs in the request. You can refer to the ID field in the response to distinguish accounts.");
        try printLanguageCodeBlock(writer, language, language.lookup_accounts_example);

        try printHeader(writer, 2, "Development Setup");
        // Bash setup
        try printHeader(writer, 3, "On Linux and macOS");
        try printCodeBlock(writer, "bash", language.developer_setup_bash_commands);

        // Windows setup
        try printHeader(writer, 3, "On Windows");
        try printCodeBlock(writer, "powershell", language.developer_setup_windows_commands);
    }
}
