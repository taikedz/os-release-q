const std = @import("std");

pub fn own(alloc:std.mem.Allocator, value:[]const u8) ![]u8 {
    const val_p = try alloc.alloc(u8, value.len);
    @memcpy(val_p, value);
    return val_p;
}