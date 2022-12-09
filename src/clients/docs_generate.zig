const std = @import("std");

const Docs = @import("./docs_types.zig").Docs;
const go = @import("./go/docs.zig").GoDocs;

const languages = [_]Docs{go};

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

pub fn main() !void {
    for (languages) |language| {
        //try validate_docs(language);
        
        const file = try std.fs.cwd().openFileZ(language.readme, .{ .mode = .write_only });
        // Truncate file
        try file.setEndPos(0);
        defer file.close();

        const writer = file.writer();

        try writer.print("# {s}\r\n\r\n{s}\r\n\r\n", .{language.name, language.description});

        try writer.print("## Installation\r\n\r\n```bash\r\n{s}```\r\n\r\n", .{language.install_commands});

        if (language.examples.len != 0) {
            try writer.print("## Examples\r\n\r\n{s}\r\n\r\n", .{language.examples});
        }

        try writer.print("## Development Setup\r\n\r\n", .{});
        // Bash setup
        try writer.print("### On Linux and macOS\r\n\r\n```bash\r\n{s}\r\n```", .{language.developer_setup_bash_commands});

        // Windows setup
        try writer.print("### On Windows\r\n\r\n```powershell\r\n{s}\r\n```", .{language.developer_setup_windows_commands});
        try writer.print("```\r\n", .{});
    }
}
