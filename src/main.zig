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

    var info:osr_info.OsInfo = undefined;
    defer info.destroy();
    {
        // We only need the lines for building the OsInfo object
        // Confine it to a block that we free as soon as we're done with it
        var lines = try etc_file.readEtcRelease(alloc);
        defer lines.destroy();

        info = try osr_info.extractReleaseInfo(alloc, lines);
    }

    var flags:u8 = 0;
    const args = arguments.load_cli_args(&flags);

    var output:[]const u8 = undefined;
    // output will only point to data that will be owned and reaped
    //   indepednently, so we do not try to reap it itself.
 
    // Holder for data that needs reaping from the current scope
    var owned_output:?[]const u8 = null;
    // As an optional, only free it if it was assigned.
    defer if(owned_output != null) alloc.free(owned_output.?);

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
            output = owned_output.?;
        },
    }

    if (lower) {
        var zg_case = try zg_CaseData.init(alloc);
        defer zg_case.deinit();

        const low_output = try zg_case.toLowerStr(alloc, output);
        defer alloc.free(low_output);

        // Final operations with a locally-owned item
        //   to free in current block
        try finalPrint("{s}\n", .{low_output});

    } else {

        // Final operations with an already-deferred dstroy()
        try finalPrint("{s}\n", .{output});
    }
}

fn finalPrint(comptime fmt:[]const u8, params:anytype) !void {
    // At the end of main() we duplicate the finalisation operation
    try stdout.print(fmt, params);
}
