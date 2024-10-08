const std = @import("std");

pub fn build(b:*std.Build) void {
    const exe = b.addExecutable(.{
        .name = "os-release",
        .root_source_file = b.path("src/main.zig"),
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    });

    const ziglyph = b.dependency("ziglyph", .{});
    exe.root_module.addImport("ziglyph", ziglyph.module("ziglyph"));

    b.installArtifact(exe);
}

