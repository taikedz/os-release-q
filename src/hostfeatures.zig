const std = @import("std");
const mem = @import("mem.zig");
const commands = @import("commands.zig");

const file_reader = @import("file_reader.zig");
const Lines = file_reader.Lines;

pub fn get_features(alloc:std.mem.Allocator) ![]u8 {
    var features = std.ArrayList(u8).init(alloc);
    defer features.deinit();
    const output = try file_reader.readFileLines(alloc, "/proc/1/cmdline");
    defer output.destroy();

    const tokens = std.mem.splitScalar(u8, output.getLines()[0], '/');
    const last = tokens[tokens.len-1];
    if(!std.mem.eql(u8, last, "init") and !std.mem.eql(u8, last, "systemd")) {
        features.appendSlice("Non-init ");
    }

    if(is_wsl(alloc)) {
        features.appendSlice("WSL ");
    }

    return mem.own(alloc, features.items);
}

fn is_wsl() bool {
    var buffer = [_]u8{undefined} ** 1024;
    var alloc_t = std.heap.FixedBufferAllocator.init(&buffer);
    const alloc = alloc_t.allocator();

    const res = try commands.callCommand(alloc, [_][]u8{"uname", "-r"});

    return std.mem.containsAtLeast(u8, res.items, 1, "WSL");
}

