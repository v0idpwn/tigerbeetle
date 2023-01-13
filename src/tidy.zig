//! Checks for various non-functional properties of the code itself.

const std = @import("std");
const fs = std.fs;
const mem = std.mem;
const math = std.math;

test "tidy: lines have reasonable length" {
    const allocator = std.testing.allocator;

    var src_dir = try fs.cwd().openDir("./src", .{ .iterate = true });
    defer src_dir.close();

    var walker = try src_dir.walk(allocator);
    defer walker.deinit();

    while (try walker.next()) |entry| {
        if (mem.startsWith(u8, entry.path, "clients")) continue;

        if (entry.kind == .File and mem.endsWith(u8, entry.path, ".zig")) {
            const source_file = try entry.dir.openFile(entry.basename, .{});
            defer source_file.close();

            const long_line = try find_long_line(allocator, source_file);

            if (long_line) |line_number| {
                if (!is_naughty(entry.path)) {
                    const stderr = std.io.getStdErr().writer();
                    try stderr.print(
                        "{s}:{d} line exceeds 100 columns\n",
                        .{ entry.path, line_number },
                    );
                    return error.LineToLong;
                }
            } else {
                if (is_naughty(entry.path)) {
                    const stderr = std.io.getStdErr().writer();
                    try stderr.print(
                        "{s} no longer contains long lines, remove it from `naughty_list`\n",
                        .{entry.path},
                    );
                    return error.OutdatedNaughtyList;
                }
            }
        }
    }
}

const naughty_list = [_][]const u8{
    "benchmark.zig",
    "config.zig",
    "constants.zig",
    "ewah_benchmark.zig",
    "ewah.zig",
    "io/benchmark.zig",
    "io/darwin.zig",
    "io/linux.zig",
    "io/test.zig",
    "io/windows.zig",
    "lsm/binary_search.zig",
    "lsm/compaction.zig",
    "lsm/eytzinger_benchmark.zig",
    "lsm/eytzinger.zig",
    "lsm/forest_fuzz.zig",
    "lsm/grid.zig",
    "lsm/groove.zig",
    "lsm/manifest_level.zig",
    "lsm/manifest_log.zig",
    "lsm/merge_iterator.zig",
    "lsm/posted_groove.zig",
    "lsm/segmented_array_benchmark.zig",
    "lsm/segmented_array.zig",
    "lsm/table_immutable.zig",
    "lsm/table_mutable.zig",
    "lsm/table.zig",
    "lsm/test.zig",
    "lsm/tree_fuzz.zig",
    "lsm/tree.zig",
    "message_bus.zig",
    "message_pool.zig",
    "ring_buffer.zig",
    "simulator.zig",
    "state_machine.zig",
    "state_machine/auditor.zig",
    "state_machine/workload.zig",
    "static_allocator.zig",
    "storage.zig",
    "test/cluster.zig",
    "test/cluster/network.zig",
    "test/cluster/state_checker.zig",
    "test/conductor.zig",
    "test/network.zig",
    "test/packet_simulator.zig",
    "test/priority_queue.zig",
    "test/storage.zig",
    "test/time.zig",
    "tigerbeetle/cli.zig",
    "tigerbeetle/main.zig",
    "time.zig",
    "tracer.zig",
    "vsr.zig",
    "vsr/client.zig",
    "vsr/clock.zig",
    "vsr/journal.zig",
    "vsr/replica.zig",
    "vsr/superblock_client_table.zig",
    "vsr/superblock_free_set.zig",
    "vsr/superblock_manifest.zig",
    "vsr/superblock_quorums.zig",
    "vsr/superblock.zig",
};

fn is_naughty(path: []const u8) bool {
    for (naughty_list) |naughty_path| {
        // Separator-agnositc path comparison.
        if (naughty_path.len == path.len) {
            var equal_paths = true;
            for (naughty_path) |c, i| {
                equal_paths = equal_paths and
                    (path[i] == c or path[i] == fs.path.sep and c == fs.path.sep_posix);
            }
            if (equal_paths) return true;
        }
    }
    return false;
}

fn find_long_line(allocator: mem.Allocator, file: fs.File) !?usize {
    const source = try file.readToEndAllocOptions(
        allocator,
        math.maxInt(usize),
        null,
        @alignOf(u8),
        0,
    );
    defer allocator.free(source);

    var line_iterator = mem.split(u8, source, "\n");
    var line_number: usize = 0;
    while (line_iterator.next()) |line| {
        line_number += 1;
        const line_length = try std.unicode.utf8CountCodepoints(line);
        if (line_length > 100) return line_number;
    }
    return null;
}
