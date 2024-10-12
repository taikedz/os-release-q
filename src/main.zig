const std = @import("std");
const stdout = std.io.getStdOut().writer();
const zg_CaseData = @import("zg_CaseData");

const ver = @import("version/version.zig");
const etc_file = @import("etc_file.zig");
const osr_info = @import("release_info.zig");
const arguments = @import("arguments.zig");
const hostfeatures = @import("hostfeatures.zig");


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
    // output will only point to data that will be owned and reaped
    //   indepednently, so we do not try to reap it itself.
 
    // Holder for data that needs reaping from the current scope
    var owned_output:?[]const u8 = null;
    defer {
        if(owned_output != null) {
            const value = owned_output orelse unreachable;
            alloc.free(value);
        }
    }

    const fv = @intFromEnum(arguments.Flags.version);
    if(flags & fv  == fv) {
        std.debug.print("os-release {s}\n", .{ver.osr_version});
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
        // info will be reaped at end of function ; output only points to its data locations
        arguments.Mode.name => {output = info.id;},
        arguments.Mode.version => {output = info.version_id;},
        arguments.Mode.pretty => {output = info.pretty_name;},
        arguments.Mode.family => {output = info.id_like;},
        arguments.Mode.host => {
            // We get a locally owned string ; it will be reaped at end of _function_
            owned_output = try hostfeatures.get_features(alloc);

            // We pass the actual value to the non-repaing  output holder
            //   which references a section of owned_output that will itself be reaped.
            output = owned_output orelse unreachable;
        },
    }

    if (lower) {
        var zg_case = try zg_CaseData.init(alloc);
        defer zg_case.deinit();

        const low_output = try zg_case.toLowerStr(alloc, output);
        defer alloc.free(low_output);

        // This is a new allocation, and defer-free is to the end of this "if" block
        // So, we suffer some code duplication ...
        try stdout.print("{s}\n", .{low_output});
    } else {
        try stdout.print("{s}\n", .{output});
    }
}
