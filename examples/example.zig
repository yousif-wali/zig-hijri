const std = @import("std");
const hijri = @import("hijri");

pub fn main() !void {
    const h = hijri.gregorianToHijri(2025, 11, 13);
    std.debug.print("Hijri: {d}-{d}-{d}\n", .{h.year, h.month, h.day});
}
