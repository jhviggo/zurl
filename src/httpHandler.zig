const std = @import("std");

pub fn handleHttpRequest(url: []u8) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var client = std.http.Client{ .allocator = allocator };
    defer client.deinit();

    const uri = try std.Uri.parse(url);
    const buf = try allocator.alloc(u8, 1024 * 1024 * 8);
    defer allocator.free(buf);
    var req = try client.open(.GET, uri, .{
        .server_header_buffer = buf,
    });
    defer req.deinit();

    try req.send();
    try req.finish();
    try req.wait();

    // var iter = req.response.iterateHeaders();

    // while (iter.next()) |header| {
    //     std.debug.print("Name:{s}, Value:{s}\n", .{ header.name, header.value });
    // }

    try std.testing.expectEqual(req.response.status, .ok);

    var rdr = req.reader();
    const body = try rdr.readAllAlloc(allocator, 1024 * 1024 * 8);
    defer allocator.free(body);

    std.debug.print("Body:\n{s}\n", .{body});
}
