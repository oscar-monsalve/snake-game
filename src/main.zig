const std = @import("std");
const game = @import("game.zig");
const render = @import("render.zig");
const input = @import("input.zig");

const ROWS: u32 = 10 * 2;
const COLS: u32 = 30 * 2;
const UPDATE_TIME: f32 = 0.6;

pub fn main() !void {
    try game.init(ROWS, COLS);

    const SEC_IN_NANO_SEC: u64 = 1_000_000_000; // 1 sec = 1_000_000_000 nsec
    const DELAY_IN_NSEC = @as(u64, @intFromFloat(UPDATE_TIME * SEC_IN_NANO_SEC));

    while (true) {
        try render.draw_grid(ROWS, COLS);
        std.Thread.sleep(DELAY_IN_NSEC);
        game.move_snake();
    }
}
