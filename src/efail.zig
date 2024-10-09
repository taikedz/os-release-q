const std = @import("std");

pub fn fail(status:u8, comptime message:[]const u8, args:anytype) noreturn {
    std.debug.print(message, args);
    std.process.exit(status);
}

