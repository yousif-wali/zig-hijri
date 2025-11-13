const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // -----------------------------
    // Library module
    // -----------------------------
    const hijri_module = b.addModule("hijri", .{
        .root_source_file = b.path("src/hijri.zig"),
    });

    // -----------------------------
    // Unit Tests
    // -----------------------------
    const test_step = b.step("test", "Run unit tests");

    const unit_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/hijri.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    const run_unit_tests = b.addRunArtifact(unit_tests);
    test_step.dependOn(&run_unit_tests.step);

    // -----------------------------
    // Examples (you can add more)
    // -----------------------------
    const examples = [_]struct { name: []const u8, path: []const u8 }{
        .{ .name = "example", .path = "examples/example.zig" },
    };

    const examples_step = b.step("examples", "Build all examples");

    inline for (examples) |example| {
        const exe_module = b.createModule(.{
            .root_source_file = b.path(example.path),
            .target = target,
            .optimize = optimize,
        });

        // Add the Hijri module to the example module
        exe_module.addImport("hijri", hijri_module);

        // Build the example executable
        const exe = b.addExecutable(.{
            .name = example.name,
            .root_module = exe_module,
        });

        // Install the example binary
        b.installArtifact(exe);
        examples_step.dependOn(&b.addInstallArtifact(exe, .{}).step);

        // zig build run-example
        const run_cmd = b.addRunArtifact(exe);
        const run_step = b.step(
            b.fmt("run-{s}", .{example.name}),
            b.fmt("Run the {s} example", .{example.name}),
        );
        run_step.dependOn(&run_cmd.step);
    }
}
