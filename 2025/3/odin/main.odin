package day3

import "core:fmt"
import "core:mem"
import "core:os"
import "core:strings"
import "core:time"

PUZZLE_INPUT :: `
    987654321111111
    811111111111119
    234234234234278
    818181911112111
`

Data_Is_Empty_Error :: distinct struct{}

Data_Is_Ragged_Error :: distinct struct {
	line: int,
}

Illegal_Token_Error :: distinct struct {
	line, col: int,
	token:     rune,
}

Parsing_Error :: union {
	mem.Allocator_Error,
	Illegal_Token_Error,
	Data_Is_Ragged_Error,
	Data_Is_Empty_Error,
}

Grid :: struct {
	data:       []int,
	rows, cols: int,
}

parse :: proc(input: string, allocator := context.allocator) -> (grid: Grid, err: Parsing_Error) {
	context.allocator = context.temp_allocator
	defer context.allocator = allocator

	lines := strings.split_lines(strings.trim_space(input)) or_return
	if lines[0] == "" do return {}, Data_Is_Empty_Error{}

	rows := len(lines)
	cols := len(strings.trim_space(lines[0]))

	data := make([dynamic]int, 0, rows * cols, allocator) or_return

	for line, row in lines {
		clean_line := strings.trim_space(line)
		if len(clean_line) != cols do return {}, Data_Is_Ragged_Error{row}

		for char, col in clean_line {
			digit := int(char - '0')
			if digit < 0 || digit > 9 do return {}, Illegal_Token_Error{row, col, char}
			append(&data, digit) or_return
		}
	}

	return Grid{data[:], rows, cols}, nil
}

remove_digits :: proc(
	row: []int,
	k: int,
	allocator := context.allocator,
) -> (
	output: []int,
	err: mem.Allocator_Error,
) {
	stack := make([dynamic]int, 0, len(row) - k, allocator) or_return
	dels := k
	for digit in row {
		for len(stack) > 0 && digit > stack[len(stack) - 1] && dels > 0 {
			pop(&stack)
			dels -= 1
		}
		append(&stack, digit) or_return
	}
	return stack[:], .None
}

process :: proc(row: []int, n: int) -> (output: int, err: mem.Allocator_Error) {
	digits := remove_digits(row, len(row) - n) or_return
	for digit in digits[:n] {
		output = 10 * output + digit
	}
	return
}

solve :: proc(grid: Grid, n: int) -> (solution: int, err: mem.Allocator_Error) {
	context.allocator = context.temp_allocator

	bank_solutions := make([]int, grid.rows) or_return

	for row in 0 ..< grid.rows {
		row_data := grid.data[row * grid.cols:(row + 1) * grid.cols]
		bank_solutions[row] = process(row_data, n) or_return
	}

	for bank in bank_solutions do solution += bank
	return
}

part_1 :: proc(grid: Grid) -> (solution: int, err: mem.Allocator_Error) {
	return solve(grid, 2)
}

part_2 :: proc(grid: Grid) -> (solution: int, err: mem.Allocator_Error) {
	return solve(grid, 12)
}

main :: proc() {
	time_start := time.now()
	input := string(os.read_entire_file("input") or_else panic("failed to read input"))
	time_read := time.since(time_start)

	data, parsing_error := parse(input, context.temp_allocator)
	defer free_all(context.temp_allocator)
	if parsing_error != nil do fmt.panicf("failed to parse: %v\n", parsing_error)

	time_parse := time.since(time_start) - time_read
	fmt.println("part 1: ", part_1(data) or_else panic("part 1 failed"))
	time_solve_1 := time.since(time_start) - time_read - time_parse
	fmt.println("part 2: ", part_2(data) or_else panic("part 2 failed"))
	time_solve_2 := time.since(time_start) - time_read - time_parse - time_solve_1
	time_total := time.since(time_start)

	fmt.println("performance benchmarks [ms]:")
	fmt.println("total\tread\tparse\tpart 1\tpart 2")
	fmt.printf(
		"%.3f\t%.3f\t%.3f\t%.3f\t%.3f\n",
		time.duration_milliseconds(time_total),
		time.duration_milliseconds(time_read),
		time.duration_milliseconds(time_parse),
		time.duration_milliseconds(time_solve_1),
		time.duration_milliseconds(time_solve_2),
	)
}
