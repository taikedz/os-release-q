const std = @import("std");

pub const Mode = enum {
    empty,
    name,
    version,
    pretty,
    family,
};

pub const Flags = enum(u8) {
    lower = pow2(1),
};

fn pow2(n:u8) u8 {
    return std.math.pow(u8, 2, n);
}

fn eqs(left:[]const u8, right:[]const u8) bool {
    return std.mem.eql(u8, left, right);
}

pub fn load_cli_args(flags:*u8) Mode {
    var buf = [128]u8{};
    const fb_alloc = std.heap.FixedBufferAllocator(&buf);

    const args = std.process.argsWithAllocator(fb_alloc);

    var action = Mode.empty;

    for(args) |token| {
        if eqs(token, "id"); // want to see if equal, and assign of action not yet assigned
        // if we get a flag, register it agains flags
    }

    flags.* &= 1;//Flags.lower;
    return Mode.pretty;
}