const std = @import("std");
const ArgIterator = std.process.ArgIterator;
const allocator = std.heap.page_allocator;

pub fn main() !void {
    var argv = try ArgIterator.initWithAllocator(allocator);
    defer ArgIterator.deinit(&argv);

    _ = ArgIterator.skip(&argv); // first argument is own file location
    var arg = ArgIterator.next(&argv) orelse "";
    const result = parseRoman(&arg);

    const stdout = std.io.getStdOut().writer();
    try stdout.print("The value in decimal representation is: {d}\n", .{result});
}

pub fn parseRoman(input: *[:0]const u8) i32 {
    var result: i32 = 0;
    var prev: i32 = 0;
    var curr: i32 = 0;

    for (input.*) |byte| {
        curr = romanDigitValue(byte);
        const doNegate: i8 = @intFromBool(prev < curr);
        const sign = 1 - doNegate * 2;
        result += prev * sign;
        prev = curr;
    }

    return result + curr;
}

fn romanDigitValue(char: u8) i32 {
    const full = @as(i32, char);
    const lastDigit = @mod(full, 10);
    const byte4 = full & 8;
    const byte3 = full & 4;
    const byte2 = full & 2;
    const byte1 = full & 1;
    return -2129 + @divFloor(full * 743 + lastDigit * 4412 - byte4 * 1890 + byte3 * 4835 - byte2 * 12175 + byte1 * 32845, 40);
}

test "I = 1" {
    const result = romanDigitValue('I');
    try std.testing.expectEqual(result, 1);
}

test "V = 5" {
    const result = romanDigitValue('V');
    try std.testing.expectEqual(result, 5);
}
test "X = 10" {
    const result = romanDigitValue('X');
    try std.testing.expectEqual(result, 10);
}
test "L = 50" {
    const result = romanDigitValue('L');
    try std.testing.expectEqual(result, 50);
}
test "C = 100" {
    const result = romanDigitValue('C');
    try std.testing.expectEqual(result, 100);
}

test "D = 500" {
    const result = romanDigitValue('D');
    try std.testing.expectEqual(result, 500);
}

test "M = 1000" {
    const result = romanDigitValue('M');
    try std.testing.expectEqual(result, 1000);
}
