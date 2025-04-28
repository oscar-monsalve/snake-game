const std = @import("std");
const assert = std.debug.assert;
const testing = std.testing;


const MAX_LENGTH = 100;

pub var snake: Snake = undefined;
pub var food: Position = undefined;
pub var grid_rows: u32 = 0;
pub var grid_cols: u32 = 0;

// Initialize random seed (must reassign rng after reseeding prng)
var prng = std.Random.DefaultPrng.init(0);
var rng = prng.random();


const Errors = error{
    invalidGridSize,
};

const Direction = enum {
    Up,
    Down,
    Left,
    Right,
};

const Position = struct {
    row: u32,
    col: u32,
};

const Snake = struct {
    body: [MAX_LENGTH]Position,
    length: u32,
    direction: Direction
};


pub fn init(rows: u32, cols: u32) !void {
    if (rows == 0 or cols == 0) {
        return Errors.invalidGridSize;
    }

    // Create a random seed
    var seed: u64 = undefined;
    std.crypto.random.bytes(std.mem.asBytes(&seed));
    prng = std.Random.DefaultPrng.init(seed);
    rng = prng.random();

    snake = .{
        .body = [_]Position{undefined} ** MAX_LENGTH,
        .length = 1,
        .direction = .Right,
    };
    snake.body[0] = Position{ .row = rows / 2, .col = cols / 2 };

    // Check if the random food placement if not on top of the snake's body
    var new_food: Position = undefined;
    while (true) {
        new_food = Position{
            .row = rng.intRangeAtMost(u32, 0, rows - 1),
            .col = rng.intRangeAtMost(u32, 0, cols - 1),
        };
        if (!is_position_on_snake(new_food)) {
            break;
        }
    }
    food = new_food;

    grid_rows = rows;
    grid_cols = cols;

    assert(snake.body[0].row >= 0 and snake.body[0].row < grid_rows);
    assert(snake.body[0].col >= 0 and snake.body[0].col < grid_cols);

    // std.debug.print("Snake position: ({}, {})\n", .{snake.body[0].row, snake.body[0].col});
    // std.debug.print("Food position: ({}, {})\n", .{food.row, food.col});
}

/// Returns true if the row and col of the random food placement
/// is on top of the snake's body
fn is_position_on_snake(pos: Position) bool {
    var i: u32 = 0;
    while (i < snake.length) : (i += 1) {
        if (snake.body[i].row == pos.row and snake.body[i].col == pos.col) {
            return true;
        }
    }
    return false;
}

// Up -> (Row: decrease, col: const)
// Down -> (Row: increase, col: const)
// Left -> (Row: const, col: decrease)
// Right -> (Row: const, col: increase)
pub fn move_snake() void {
    var i: u32 = 0;
    while (i > 0) : (i -= 1) {
        snake.body[i] = snake.body[i - 1]; // Move each segment to the position of the one before it
    }

    // Update the head's position based on the direction
    const head = &snake.body[0];
    switch (snake.direction) {
        .Up => head.row -= 1,
        .Down => head.row += 1,
        .Left => head.col -= 1,
        .Right => head.col += 1,
    }
}

pub fn change_direction() !void {
}

pub fn check_collision() !void {
}

pub fn grow_snake() !void {
}

pub fn place_food() !void {
}



test "check init function with valid grid size" {
    const ROWS: u32 = 10;
    const COLS: u32 = 10;

    try init(ROWS, COLS);

    // Check snake position
    try testing.expect(snake.body[0].row == ROWS / 2);
    try testing.expect(snake.body[0].col == COLS / 2);

    // Check food position
    try testing.expect(!is_position_on_snake(food)); // No food should be on the snake's body
    try testing.expect(food.row < ROWS and food.col < COLS); // Food should be within bounds
}

test "test init function with invalid grid sizes" {
    // Test with 0 rows
    const result_0_rows = init(0, 10);
    try testing.expect(result_0_rows == Errors.invalidGridSize);

    const result_0_cols = init(10, 0);
    try testing.expect(result_0_cols == Errors.invalidGridSize);

    const result_0_both = init(0, 0);
    try testing.expect(result_0_both == Errors.invalidGridSize);
}

test "test global variables grid_rows and grid_cols" {
    const ROWS: u32 = 10;
    const COLS: u32 = 10;

    try init(ROWS, COLS);

    try testing.expect(grid_rows == ROWS);
    try testing.expect(grid_cols == COLS);
}

test "test move_snake with right (default) movement" {
    try init(10, 10);

    const initial_row = snake.body[0].row;
    const initial_col = snake.body[0].col;

    move_snake();

    try testing.expect(snake.body[0].row == initial_row);
    try testing.expect(snake.body[0].col == initial_col + 1);
}

test "test move_snake with left movement" {
    try init(10, 10);

    snake.direction = .Left;

    const initial_row = snake.body[0].row;
    const initial_col = snake.body[0].col;

    move_snake();

    try testing.expect(snake.body[0].row == initial_row);
    try testing.expect(snake.body[0].col == initial_col - 1);
}

test "test move_snake with up movement" {
    try init(10, 10);

    snake.direction = .Up;

    const initial_row = snake.body[0].row;
    const initial_col = snake.body[0].col;

    move_snake();

    try testing.expect(snake.body[0].row == initial_row - 1);
    try testing.expect(snake.body[0].col == initial_col);
}

test "test move_snake with down movement" {
    try init(10, 10);

    snake.direction = .Down;

    const initial_row = snake.body[0].row;
    const initial_col = snake.body[0].col;

    move_snake();

    try testing.expect(snake.body[0].row == initial_row + 1);
    try testing.expect(snake.body[0].col == initial_col);
}
