const std = @import("std");

const files = @import("file_reader.zig");

pub fn readEtcRelease(alloc:std.mem.Allocator) !files.Lines {
    var lines = try files.readFileLines(alloc, "/etc/os-release");
    defer lines.destroy();

    var valid_lines = files.Lines.init(alloc);

    for(lines.getLines()) |line| {
        const trimline = std.mem.trim(u8, line, " \t\n");
        const comment_idx:i128 = std.mem.indexOf(u8, line, "#") orelse -1;
        const eq_pos:i128      = std.mem.indexOf(u8, line, "=") orelse -1;
        if(comment_idx != 0 or eq_pos > 0) {
            try valid_lines.append(trimline);
        }
    }

    return valid_lines;
}

test {
    var lines = try readEtcRelease(std.testing.allocator);
    lines.destroy();
}