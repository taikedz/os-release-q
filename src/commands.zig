const std = @import("std");
const Child = std.process.Child;

const RunError = error {
    Failed,
};

pub fn callCommand(alloc:std.mem.Allocator, command:[]const[]const u8) !std.ArrayList(u8) {
    var caller = Child.init(command, alloc);
    caller.stdout_behavior = .Pipe;
    caller.stderr_behavior = .Pipe;

    var stdout = std.ArrayList(u8).init(alloc);
    var stderr = std.ArrayList(u8).init(alloc);
    errdefer stdout.deinit();
    defer stderr.deinit();

    try caller.spawn();
    try caller.collectOutput(&stdout, &stderr, 1024);

    const res = try caller.wait();

    if(res.Exited > 0) {
        std.debug.print("{s}\n", .{stderr.items});
        return RunError.Failed;
    } else {
        return stdout;
    }
}

test {
    const alloc = std.testing.allocator;

    const out = try callCommand(alloc, &[_][]const u8{"uname", "-r"});
    defer out.deinit();
    std.debug.print("{s}\n", .{out.items});

    if(std.mem.containsAtLeast(u8, out.items, 1, "WSL")) {
        std.debug.print("This is windows\n", .{});
    }
}
