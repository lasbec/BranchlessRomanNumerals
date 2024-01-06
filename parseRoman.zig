const std = @import("std");
const ArgIterator = std.process.ArgIterator;
const allocator = std.heap.page_allocator;

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    var argv = try ArgIterator.initWithAllocator(allocator);
    defer ArgIterator.deinit(&argv);
    const argv_p = &argv;
    _ = ArgIterator.skip(argv_p);
    var arg = ArgIterator.next(argv_p) orelse "";
    const value = parseRoman(&arg);
    try stdout.print("The value in decimal representation is, {d}!\n", .{value});
}

pub fn parseRoman(input: *[:0]const u8) *[]const u8 {
    return input;
}

fn romanDigit(char: u8) i32 {
    const c = @as(i32, char);
    const mod = @mod(c, 10);
    const b4 = c & 8;
    const b3 = c & 4;
    const b2 = c & 2;
    const b1 = c & 1;
    return -2129 + @divFloor(c * 743 + mod * 4412 - b4 * 1890 + b3 * 4835 - b2 * 12175 + b1 * 32845, 40);
}

test "Sandbox" {
    const i: i32 = 73; // 1001001
    try std.testing.expectEqual(@mod(i, 10), 3);
    try std.testing.expectEqual(i & 64, 64);
    try std.testing.expectEqual(i & 32, 0);
    try std.testing.expectEqual(i & 16, 0);
    try std.testing.expectEqual(i & 8, 8);
    try std.testing.expectEqual(i & 4, 0);
    try std.testing.expectEqual(i & 2, 0);
    try std.testing.expectEqual(i & 1, 1);
}

test "I = 1" {
    const result = romanDigit('I');
    try std.testing.expectEqual(result, 1);
}

test "V = 5" {
    const result = romanDigit('V');
    try std.testing.expectEqual(result, 5);
}
test "X = 10" {
    const result = romanDigit('X');
    try std.testing.expectEqual(result, 10);
}
test "L = 50" {
    const result = romanDigit('L');
    try std.testing.expectEqual(result, 50);
}
test "C = 100" {
    const result = romanDigit('C');
    try std.testing.expectEqual(result, 100);
}

test "D = 500" {
    const result = romanDigit('D');
    try std.testing.expectEqual(result, 500);
}

test "M = 1000" {
    const result = romanDigit('M');
    try std.testing.expectEqual(result, 1000);
}