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

        try writer.print("# {s}\n\n{s}\n\n", .{language.name, language.description});

        try writer.print("## Installation\n\n```bash\n{s}\n```\n\n", .{language.install_commands});

        if (language.examples.len != 0) {
            try writer.print("## Examples\n\n{s}\n\n", .{language.examples});
        }

        try writer.print("## Development Setup\n\n", .{});
        // Bash setup
        try writer.print("### On Linux and macOS\n\n```bash\n{s}\n```", .{language.developer_setup_bash_commands});

        // Windows setup
        try writer.print("### On Windows\n\n```powershell\n{s}\n```", .{language.developer_setup_windows_commands});
        try writer.print("```\n", .{});
    }
}
