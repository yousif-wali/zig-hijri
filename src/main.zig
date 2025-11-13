const std = @import("std");
const hijri = @import("hijri.zig");

pub fn main() !void {
    const h = hijri.gregorianToHijri(2025, 2, 3);

    std.debug.print(
        "Gregorian 2025-2-3 → Hijri {d}-{d}-{d}\n",
        .{ h.year, h.month, h.day }
    );
}
