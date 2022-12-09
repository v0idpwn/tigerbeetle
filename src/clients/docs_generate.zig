const std = @import("std");

const Docs = @import("./docs_types.zig").Docs;
const go = @import("./go/docs.zig").GoDocs;

const languages = [_]Docs{go};

pub fn main() !void {
    for (languages) |language| {
        const file = try std.fs.cwd().openFileZ(language.readme, .{ .mode = .write_only });
        try file.setEndPos(0);
        defer file.close();

        const writer = file.writer();

        try writer.print("{s}\r\n\r\n## Development Setup\r\n\r\n### On Linux and macOS\r\n", .{language.header});
        // Bash setup
        try writer.print("```bash\r\n", .{});
        for (language.developer_setup_bash_commands) |cmd| {
            try writer.print("$ {s}\r\n", .{cmd});
        }
        try writer.print("```\r\n", .{});

        // Windows setup
        try writer.print("### On Windows\r\n\r\n```powershell\r\n", .{});
        for (language.developer_setup_windows_commands) |cmd| {
            try writer.print("$ {s}\r\n", .{cmd});
        }
        try writer.print("```\r\n", .{});
    }
}
