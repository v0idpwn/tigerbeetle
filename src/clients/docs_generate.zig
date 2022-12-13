const std = @import("std");

const Docs = @import("./docs_types.zig").Docs;
const go = @import("./go/docs.zig").GoDocs;
const node = @import("./node/docs.zig").NodeDocs;

const languages = [_]Docs{ go, node };

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

const MarkdownWriter = struct {
    buf: *std.ArrayList(u8),
    writer: std.ArrayList(u8).Writer,

    fn init(buf: *std.ArrayList(u8)) MarkdownWriter {
        return MarkdownWriter{ .buf = buf, .writer = buf.writer() };
    }

    fn header(mw: *MarkdownWriter, n: i8, content: []const u8) !void {
        var x = n;
        while (x > 0) {
            try mw.print("#", .{});
            x -= 1;
        }
        try mw.print(" {s}\n\n", .{content});
    }

    fn paragraph(mw: *MarkdownWriter, content: []const u8) !void {
        try mw.print("{s}\n\n", .{content});
    }

    fn code(mw: *MarkdownWriter, language: []const u8, content: []const u8) !void {
        try mw.print("```{s}\n{s}\n```\n\n", .{ language, content });
    }

    fn print(mw: *MarkdownWriter, comptime fmt: []const u8, args: anytype) !void {
        try mw.writer.print(fmt, args);
    }

    fn reset(mw: *MarkdownWriter) void {
        mw.buf.clearRetainingCapacity();
    }

    fn save(mw: *MarkdownWriter, filename: [*:0]const u8) !void {
        const file = try std.fs.cwd().openFileZ(filename, .{ .write = true });
        defer file.close();

        try file.setEndPos(0);
        try file.writeAll(mw.buf.items);
    }
};

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();
    var buf = std.ArrayList(u8).init(allocator);
    var mw = MarkdownWriter.init(&buf);

    for (languages) |language| {
        //try validate_docs(language);

        mw.reset();

        try mw.header(1, language.name);
        try mw.paragraph(language.description);

        try mw.header(2, "Installation");
        try mw.code("bash", language.install_commands);

        if (language.examples.len != 0) {
            try mw.header(2, "Examples");
            try mw.paragraph(language.examples);
        }

        try mw.header(2, "Creating a Client");
        try mw.code(language.markdown_name, language.client_object_example);
        try mw.paragraph(language.client_object_documentation);

        try mw.print("The following are valid addresses:\n", .{});
        try mw.print("* `3000` (interpreted as `127.0.0.1:3000`)\n", .{});
        try mw.print("* `127.0.0.1:3000` (interpreted as `127.0.0.1:3000`)\n", .{});
        try mw.print("* `127.0.0.1` (interpreted as `127.0.0.1:3001`, `3001` is the default port)\n\n", .{});

        try mw.header(2, "Creating Accounts");
        try mw.paragraph("See details for account fields in the [Accounts reference](https://docs.tigerbeetle.com/reference/accounts).");
        try mw.code(language.markdown_name, language.create_accounts_example);
        try mw.paragraph(language.create_accounts_documentation);

        try mw.header(3, "Account Flags");
        try mw.paragraph("The account flags value is a bitfield. See details for these flags in the [Accounts reference](https://docs.tigerbeetle.com/reference/accounts#flags).");
        try mw.paragraph(language.account_flags_details);

        try mw.header(3, "Response and Errors");
        try mw.paragraph("The response is an empty array if all accounts were created successfully. If the response is non-empty, each object in the response array contains error information for an account that failed. The error object contains an error code and the index of the account in the request batch.");

        try mw.header(2, "Account Lookup");
        try mw.paragraph("Account lookup is batched, like account creation. Pass in all IDs to fetch, and matched accounts are returned.");
        try mw.paragraph("If no account matches an ID, no object is returned for that account. So the order of accounts in the response is not necessarily the same as the order of IDs in the request. You can refer to the ID field in the response to distinguish accounts.");
        try mw.code(language.markdown_name, language.lookup_accounts_example);

        try mw.header(2, "Development Setup");
        // Bash setup
        try mw.header(3, "On Linux and macOS");
        try mw.code("bash", language.developer_setup_bash_commands);

        // Windows setup
        try mw.header(3, "On Windows");
        try mw.code("powershell", language.developer_setup_windows_commands);

        try mw.save(language.readme);
    }
}
