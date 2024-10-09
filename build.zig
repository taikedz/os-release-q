const std = @import("std");

pub fn build(b:*std.Build) void {

    const exe = b.addExecutable(.{
        .name = "os-release",
        .root_source_file = b.path("src/main.zig"),
        .target = b.host,
    });

    const ziglyph = b.dependency("ziglyph", .{
        .target = b.host,
    });
    exe.root_module.addImport("ziglyph", ziglyph.module("ziglyph"));

    b.installArtifact(exe);
}
