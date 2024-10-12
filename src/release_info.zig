const std = @import("std");

const freader = @import("file_reader.zig");
const osr_mem = @import("mem.zig");
const own = osr_mem.own;

pub const LineError = error {
    NotFound,
    NotValid
};

pub const OsInfo = struct {
    _alloc:std.mem.Allocator,
    id:[]const u8,
    version_id:[]const u8,
    pretty_name:[]const u8,
    id_like:[]const u8,

    pub fn new(alloc:std.mem.Allocator, id:[]const u8, version_id:[]const u8, pretty_name:[]const u8, id_like:[]const u8) !OsInfo {
        // For sanity, take responsibility for this struct's own content.
        // The struct holds references to u8 slices which must persist with it, rather than be
        //  tied to the lifetime of something that may or may not get deallocated independently.
        return OsInfo {
            ._alloc = alloc,
            .id = try own(alloc, id),
            .version_id = try own(alloc, version_id),
            .pretty_name = try own(alloc, pretty_name),
            .id_like = try own(alloc, id_like)
        };
    }

    pub fn destroy(self:*OsInfo) void {
        self._alloc.free(self.id);
        self._alloc.free(self.version_id);
        self._alloc.free(self.pretty_name);
        self._alloc.free(self.id_like);
    }
};

pub fn extractReleaseInfo(alloc:std.mem.Allocator, lines:freader.Lines) !OsInfo {
    const id          = try find_value("ID", lines);
    const version_id  = try find_value("VERSION_ID", lines);

    var buffer = [_]u8{undefined}**32;
    const default_pname = try std.fmt.bufPrint(&buffer, "{s} {s}", .{id, version_id});

    const pretty_name = try find_value_defaulting("PRETTY_NAME", lines, default_pname);
    const id_like     = try find_value_defaulting("ID_LIKE", lines, id);

    // All the above are slices into `lines` values
    // Hence, we pass alloc into OsInfo.new to get it to own its data.
    return OsInfo.new(alloc, id, version_id, pretty_name, id_like);
}

test {
    const alloc = std.testing.allocator;

    var lines = freader.Lines.init(alloc);
    defer lines.destroy();

    try lines.append("ID=zig\n");
    try lines.append("VERSION_ID=0.13.0\n");
    try lines.append("ID_LIKE=c\n");

    var info = try extractReleaseInfo(alloc, lines);
    defer info.destroy();

    try std.testing.expectEqualStrings("zig", info.id);
    try std.testing.expectEqualStrings("0.13.0", info.version_id);
    try std.testing.expectEqualStrings("zig 0.13.0", info.pretty_name);
    try std.testing.expectEqualStrings("c", info.id_like);
}

fn find_value(key:[]const u8, lines:freader.Lines) LineError![]const u8 {
    var idx:usize = 0;
    for(lines.getLines()) |line| {
        idx = std.mem.indexOf(u8, line, "=") orelse 0;
        if(idx == 0) return LineError.NotValid;

        // get slices left and right of "="
        const left = line[0..idx];
        const right = std.mem.trim(u8, line[idx+1..], " \"\r\n");

        // if left == key, return right
        if(std.mem.eql(u8, left, key)) return right;
    }

    return LineError.NotFound;
}

fn find_value_defaulting(key: []const u8, lines:freader.Lines, default:[]const u8) LineError![]const u8 {
    return find_value(key, lines) catch |err| {
        if (err == LineError.NotFound) {
            return default;
        } else {
            return err;
        }
    };
}


test {
    const alloc = std.testing.allocator;

    var lines = freader.Lines.init(alloc);
    defer lines.destroy();

    try lines.append("NAME=test\n");
    try lines.append("LANG=zig\n");

    const got_val = try find_value("LANG", lines);
    try std.testing.expectEqualStrings("zig", got_val );

    const def_val = try find_value_defaulting("LING", lines, "zug");
    try std.testing.expectEqualStrings("zug", def_val );
}

