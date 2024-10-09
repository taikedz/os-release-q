const std = @import("std");
const efail = @import("efail.zig");

pub const Mode = enum {
    empty,
    name,
    version,
    pretty,
    family,
};

pub const Flags = enum(u8) {
    lower = pow2(0),
    version = pow2(1),
};

fn pow2(n:u8) u8 {
    return std.math.pow(u8, 2, n);
}

fn eqs(left:[]const u8, right:[]const u8) bool {
    return std.mem.eql(u8, left, right);
}

fn set_action(action:*Mode, new_value:Mode) void {
    if(action.* != Mode.empty) {
        efail.fail(1, "Cannot set action {} - action is already {}\n", .{action.* , new_value});
    }

    action.* = new_value;
}

pub fn load_cli_args(flags:*u8) Mode {
    var buf = [_]u8{undefined} ** 128;
    var fb_alloc_t = std.heap.FixedBufferAllocator.init(&buf);
    const fb_alloc = fb_alloc_t.allocator();

    var args = try std.process.argsWithAllocator(fb_alloc);
    defer args.deinit();
    _ = args.next(); // throw away first value, this script

    var action = Mode.empty;

    while(args.next()) |token| {
        if(eqs(token, "name")) { set_action(&action, Mode.name); }
        else if(eqs(token, "version")) { set_action(&action, Mode.version); }
        else if(eqs(token, "pretty")) { set_action(&action, Mode.pretty); }
        else if(eqs(token, "family")) { set_action(&action, Mode.family); }
        else if(eqs(token, "-v")) {
            flags.* |= @intFromEnum(Flags.version) ;
        }
        else if(eqs(token, "-l")) { flags.* |= @intFromEnum(Flags.lower) ; }
        else {
            efail.fail(1, "Unrecognized argument: {s}\n", .{token});
        }
    }


    return action;
}
