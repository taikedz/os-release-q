const std = @import("std");
const mem = @import("mem.zig");
const commands = @import("commands.zig");

const linereader = @import("linereader");
const Lines = linereader.Lines;

const TokenError = error { NotEnough };

pub fn get_features(alloc:std.mem.Allocator) ![]u8 {
    var features = std.ArrayList(u8).init(alloc);
    defer features.deinit();
    if(!try isInit(alloc)) {
        try features.appendSlice("Non-init ");
    }

    if(try isWsl(alloc)) {
        try features.appendSlice("WSL ");
    }

    return mem.own(alloc, features.items);
}


fn isInit(alloc:std.mem.Allocator) !bool {
    var output = try linereader.readFileLines(alloc, "/proc/1/stat");
    defer output.destroy();

    var tokens = std.mem.tokenizeScalar(u8, output.getLines()[0], ' ');
    const name = try getIdx(&tokens, 1);

    return std.mem.eql(u8, name, "init") or std.mem.eql(u8, name, "systemd");
}

fn getIdx(tokens:*std.mem.TokenIterator(u8, .scalar), idx:usize) ![]const u8 {
    // Unlike `for`, we cannot `while(tokens.*.next(), 0..) |tok, i| ...`
    var i:usize = 0;
    while(tokens.*.next() ) |tok| {
        if(i == idx) {
            return std.mem.trim(u8, tok, "()");
        }
        i += 1;
    }
    return TokenError.NotEnough;
}

fn isWsl(alloc:std.mem.Allocator) !bool {
    const out = try commands.callCommand(alloc, &[_][]const u8{"uname", "-r"});
    defer alloc.free(out);

    return std.mem.containsAtLeast(u8, out, 1, "WSL");
}
