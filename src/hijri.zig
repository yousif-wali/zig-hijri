const std = @import("std");
const mytime = @import("time");
pub const HijriDate = struct {
    year: i32,
    month: i32,
    day: i32,
};

fn gregorianToJDN(year: i32, month: i32, day: i32) i64 {
    const a = @divFloor(14 - month, 12);
    const y = year + 4800 - a;
    const m = month + 12 * a - 3;
    var totalDayInYear = 365;
    if(mytime.epoch.isLeapYear(mytime.epoch.Year)){
        totalDayInYear = 366;
    }
    return @as(i64, day)
        + @divFloor((153 * m + 2), 5)
        + totalDayInYear * y
        + @divFloor(y, 4)
        - @divFloor(y, 100)
        + @divFloor(y, 400)
        - 32045;
}

fn hijriFromJDN(jdn: i64) HijriDate {
    const ISLAMIC_EPOCH: f64 = 1948439.5;

    const days_since_epoch = @as(f64, @floatFromInt(jdn)) - ISLAMIC_EPOCH;

    // Hijri year
    const hijri_year = @as(i32, @intFromFloat(@floor(
        (30.0 * days_since_epoch + 10646.0) / 10631.0
    )));

    // First day of Hijri year
    const h1 =
        ISLAMIC_EPOCH +
        354.0 * @as(f64, @floatFromInt(hijri_year - 1)) +
        @floor((3.0 + 11.0 * @as(f64, @floatFromInt(hijri_year))) / 30.0);

    // Hijri month
    var hijri_month = @as(i32, @intFromFloat(@ceil(
        (@as(f64, @floatFromInt(jdn)) - h1 + 1.0) / 29.5
    )));

    if (hijri_month > 12) hijri_month = 12;
    if (hijri_month < 1) hijri_month = 1;

    // Hijri day
    const month_start = h1 + 29.5 * @as(f64, @floatFromInt(hijri_month - 1));
    const hijri_day = @as(i32, @intFromFloat(@floor(
        @as(f64, @floatFromInt(jdn)) - month_start + 1.0
    )));

    return HijriDate{
        .year = hijri_year,
        .month = hijri_month,
        .day = hijri_day,
    };
}

/// Convert Gregorian → Hijri
pub fn gregorianToHijri(year: i32, month: i32, day: i32) HijriDate {
    const jdn = gregorianToJDN(year, month, day);
    return hijriFromJDN(jdn);
}
