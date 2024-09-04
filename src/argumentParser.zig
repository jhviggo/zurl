const std = @import("std");

const ParserError = error{
    NotEnoughArgs,
    DoubleOptionDetected,
};

pub fn parse(args: [][]u8) !std.StringHashMap([]u8) {
    if (args.len <= 2) {
        return ParserError.NotEnoughArgs;
    }

    const allocator = std.heap.page_allocator;
    var argMap = std.StringHashMap([]u8).init(allocator);
    var optionName: []u8 = "";

    for (args, 0..) |arg, i| {
        if (i == 0) continue; // skip executable arg
        if (i == 1) {
            try argMap.put("url", arg);
        }
        if (isOption(arg) and optionName.len != 0) {
            return ParserError.DoubleOptionDetected;
        }
        if (optionName.len != 0) {
            try argMap.put(optionName, arg);
            optionName = "";
        } else if (isOption(arg)) {
            optionName = arg[2..arg.len];
        }

        std.debug.print("{}: {s}\n", .{ i, arg });
    }
    return argMap;
}

fn isOption(arg: []u8) bool {
    if (arg.len < 2) return false;
    if (arg[0] == '-' and arg[1] == '-') {
        return true;
    }
    return false;
}
