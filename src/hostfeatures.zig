const std = @import("std");
const mem = @import("mem.zig");
const commands = @import("commands.zig");

const file_reader = @import("file_reader.zig");
const Lines = file_reader.Lines;

pub fn get_features(alloc:std.mem.Allocator) ![]u8 {
    var features = std.ArrayList(u8).init(alloc);
    defer features.deinit();
    var output = try file_reader.readFileLines(alloc, "/proc/1/cmdline"); // FIXME - use /proc/1/stat
    defer output.destroy();

    var tokens = std.mem.splitScalar(u8, output.getLines()[0], '/');
    const last = getLast(&tokens);
    if(!std.mem.eql(u8, last, "init") and !std.mem.eql(u8, last, "systemd")) {
        try features.appendSlice("Non-init ");
    }

    if(try is_wsl(alloc)) {
        try features.appendSlice("WSL ");
    }

    return mem.own(alloc, features.items);
}

fn getLast(tokens:*std.mem.SplitIterator(u8, .scalar)) []const u8 {
    var last:[]const u8 = undefined;
    while(tokens.*.next()) |tok| {
        last = tok;
    }
    return last;
}

fn is_wsl(alloc:std.mem.Allocator) !bool {
    const out = try commands.callCommand(alloc, &[_][]const u8{"uname", "-r"});
    defer alloc.free(out);

    return std.mem.containsAtLeast(u8, out, 1, "WSL");
}
