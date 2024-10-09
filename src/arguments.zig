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

pub fn load_cli_args(flags:*u8) Mode {
    flags.* &= 1;//Flags.lower;
    return Mode.pretty;
}