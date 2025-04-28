const std = @import("std");
const game = @import("game.zig");

const snake = game.snake;
const food = game.food;

const SNAKE_HEAD = "●";
const SNAKE_BODY = "○";
const FOOD = "*";
const EMPTY = " ";

const HORIZONTAL = "━";
const VERTICAL = "┃";
const UPPER_LEFT_CORNER = "┏";
const UPPER_RIGHT_CORNER = "┓";
const BOTTOM_LEFT_CORNER = "┗";
const BOTTOM_RIGHT_CORNER = "┛";


pub fn draw_grid(grid_rows: u32, grid_cols: u32) !void {
    // std.debug.print("\x1B[2J\x1B[H", .{}); // Clear and reset cursor
    std.debug.print("\x1B[H", .{}); // Just reset cursor

    // Top border
    std.debug.print("{s}", .{UPPER_LEFT_CORNER});
    for (0..grid_cols) |_| {
        std.debug.print("{s}", .{HORIZONTAL});
    }
    std.debug.print("{s}\n", .{UPPER_RIGHT_CORNER});

    for (0..grid_rows) |row| {
        std.debug.print("{s}", .{VERTICAL}); // left vertical border
        for (0..grid_cols) |col| {
            if (game.snake.body[0].row == row and game.snake.body[0].col == col) {
                std.debug.print("{s}", .{SNAKE_HEAD});
            } else if (game.food.row == row and game.food.col == col) {
                std.debug.print("{s}", .{FOOD});
            } else {
                std.debug.print("{s}", .{EMPTY});
            }
        }
        std.debug.print("{s}\n", .{VERTICAL}); // right vertical border
    }

    // bottom border
    std.debug.print("{s}", .{BOTTOM_LEFT_CORNER});
    for (0..grid_cols) |_| {
        std.debug.print("{s}", .{HORIZONTAL});
    }
    std.debug.print("{s}\n", .{BOTTOM_RIGHT_CORNER});

}
