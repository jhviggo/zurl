const std = @import("std");
const argumentParser = @import("./argumentParser.zig");

pub fn main() !void {
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // extract args
    var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
    const gpa = general_purpose_allocator.allocator();
    const args = try std.process.argsAlloc(gpa);
    defer std.process.argsFree(gpa, args);

    var map = try argumentParser.parse(args);
    defer map.clearAndFree();
    //defer map.deinit();
    //const item = map.get("test") orelse "";
    //std.debug.print("{s}", .{item});
    var it = map.iterator();
    while (it.next()) |entry| {
        std.debug.print("Key: {s}, Value: {s}\n", .{ entry.key_ptr.*, entry.value_ptr.* });
    }
}
