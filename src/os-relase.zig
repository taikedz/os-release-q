const std = @import("std");
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    // open /etc/os-release
    // remove empty and comment lines
    // parse key=value pairs
    // print desired mode
    try stdout.print("Start\n", .{});
}
