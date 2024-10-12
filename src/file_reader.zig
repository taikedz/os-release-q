const std = @import("std");

const efail = @import("efail.zig");
const osr_mem = @import("mem.zig");
const own = osr_mem.own;

pub const Lines = struct {
    alloc:std.mem.Allocator,
    list:std.ArrayList([]const u8),

    pub fn init(alloc:std.mem.Allocator) Lines {
        return Lines {
            .alloc = alloc,
            .list = std.ArrayList([]const u8).init(alloc),
        };
    }

    pub fn destroy(self:*Lines) void {
        for(self.list.items) |line| {
            self.alloc.free(line);
        }
        self.list.deinit();
    }

    pub fn append(self:*Lines, data:[]const u8) !void {
        try self.list.append(try own(self.alloc, data));
    }

    pub fn getLines(self:*const Lines) [][]const u8 {
        return self.list.items;
    }
};

pub fn readFileLines(alloc:std.mem.Allocator, path:[]const u8) !Lines {
    var fh = std.fs.openFileAbsolute(path, .{}) catch {
        efail.fail(1, "Could not open {s}", .{path});
    };
    defer fh.close();

    var line_buf_t = std.ArrayList(u8).init(alloc);
    defer line_buf_t.deinit();
    var buf_reader_t = std.io.bufferedReader(fh.reader());
    var reader = buf_reader_t.reader();

    var lines = Lines.init(alloc);

    while(reader.streamUntilDelimiter(line_buf_t.writer(), '\n', null)) {
        try lines.append(line_buf_t.items);
        line_buf_t.clearRetainingCapacity();
    } else |err| switch(err) {
        error.EndOfStream => {
            try lines.append(line_buf_t.items);
            return lines;
        },
        else => return err,
    }
}

test {
    var lines = try readFileLines(std.testing.allocator, "/etc/os-release");
    defer lines.destroy();
}
