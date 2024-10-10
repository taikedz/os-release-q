const std = @import("std");

test {
    defer { if(true) { std.debug.print("Second\n", .{}); } }
    std.debug.print("First\n", .{});
    std.debug.print("Third\n", .{});
}
