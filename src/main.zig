const osr_version = "0.3.0"; // ALSO UPDATE build.zig.zon

const std = @import("std");
const stdout = std.io.getStdOut().writer();
const ziglyph = @import("ziglyph");

const etc_file = @import("etc_file.zig");
const osr_info = @import("release_info.zig");
const arguments = @import("arguments.zig");


pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    var lines = try etc_file.readEtcRelease(alloc);
    defer lines.destroy();

    var info = try osr_info.extractReleaseInfo(alloc, lines);
    defer info.destroy();

    var flags:u8 = 0;
    const args = arguments.load_cli_args(&flags);
    var output:[]const u8 = undefined;

    const fv = @intFromEnum(arguments.Flags.version);
    if(flags & fv  == fv) {
        std.debug.print("os-release {s}\n", .{osr_version});
        std.process.exit(0);
    }

    const fl = @intFromEnum(arguments.Flags.lower);
    var lower = false;
    if(flags & fl  == fl) {
        lower = true;
    }

    switch(args) {
        arguments.Mode.empty => {
            var buf = [_]u8{undefined} ** 64;
            output = try std.fmt.bufPrint(&buf, "{s}:{s}", .{info.id, info.version_id});
        },
        arguments.Mode.name => {output = info.id;},
        arguments.Mode.version => {output = info.version_id;},
        arguments.Mode.pretty => {output = info.pretty_name;},
        arguments.Mode.family => {output = info.id_like;},
    }

    if (lower) {
        output = try ziglyph.toLowerStr(alloc, output);
        defer alloc.free(output);
        // This is a new allocation, and defer-free is to the end of this "if" block
        // So, we suffer some code duplication ...
        try stdout.print("{s}\n", .{output});
    } else {
        try stdout.print("{s}\n", .{output});
    }
}

