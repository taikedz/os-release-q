const std = @import("std");

const files = @import("file_reader.zig");

pub fn read_etc_release(alloc:std.mem.Allocator) !void {
    var lines = try files.readFileLines(alloc, "/etc/os-release");
    defer lines.destroy();
    for(lines.getLines()) |line| {
        std.debug.print("{s}\n", .{line});
    }
}

test {
    try read_etc_release(std.testing.allocator);
}