const std = @import("std");

pub fn build(b:*std.Build) void {
    const exe = b.addExecutable(.{
        .name = "os-release",
        .root_source_file = b.path("src/main.zig"),
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    });

    // Find the dependency named "zg" as declared in build.zg.zon
    const zg = b.dependency("zg", .{});

    // Get the `CaseData` module from the `zg` dependency
    //   and register as importable module "zg_CaseData"
    // In project code, use @import("zg_CaseData")
    exe.root_module.addImport("zg_CaseData", zg.module("CaseData"));

    b.installArtifact(exe);
}

