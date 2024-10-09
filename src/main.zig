const osr_version = "0.3.0";

const std = @import("std");
const stdout = std.io.getStdOut().writer();

const etc_file = @import("etc_file.zig");
const osr_info = @import("release_info.zig");


pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    var lines = try etc_file.readEtcRelease(alloc);
    defer lines.destroy();

    var info = try osr_info.extractReleaseInfo(alloc, lines);
    defer info.destroy();

    // print desired mode
    // if `-l` , then convert to lower-case
    try stdout.print("{s}\n", .{info.id});
}

