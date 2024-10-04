const osr_version = "0.2.0";

const std = @import("std");
const stdout = std.io.getStdOut().writer();

const etc_file = @import("etc_file.zig");
const osr_info = @import("release_info.zig");


pub fn main() !void {
    const gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    const lines = etc_file.read_etc_release(alloc);
    defer _ = lines.destroy(); // is this right ?

    const info = osr_info.extract_release_info(alloc, lines);

    // print desired mode
    // if `-l` , then convert to lower-case
    try stdout.print("Start\n", .{});
}

