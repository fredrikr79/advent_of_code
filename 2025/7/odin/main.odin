package day7

import "core:fmt"
import "core:slice"
import "core:strings"
import "core:time"

PUZZLE_INPUT: string : #load("input")

Pos :: distinct struct {
	row: int,
	col: int,
}

Parsed_Data :: struct {
	lines:      []string,
	rows, cols: int,
	start:      Pos,
}

not_empty_line :: proc(line: string) -> (output: bool) {
	output = true
	for char in line do output &&= char == '.'
	return !output
}

parse :: proc(input: string) -> (output: Parsed_Data) {
	lines := strings.split_lines(input)
	output.start = {0, strings.index(lines[0], "S")}
	output.lines = slice.filter(lines, not_empty_line)
	output.rows = len(output.lines)
	output.cols = len(output.lines[0])
	return
}

solve_part_1 :: proc(data: Parsed_Data) -> (output: int) {
	beams := make(map[Pos]bool, context.temp_allocator)
	hit := make(map[Pos]bool, context.temp_allocator)
	defer free_all(context.temp_allocator)
	beams[data.start] = true
	for line, row in data.lines {
		for char, col in line {
			for pos, exists in beams {
				if exists && char == '^' && pos == {row - 1, col} {
					beams[{row, col + 1}] = true
					beams[{row, col - 1}] = true
					hit[{row, col}] = true
				} else if pos == {row - 1, col} {
					beams[{row, col}] = true
				}
			}
		}
	}
	return len(hit)
}

solve_part_2 :: proc(data: Parsed_Data) -> (output: int) {
	memo := make(map[Pos]int)
	defer delete(memo)

	count_timelines :: proc(lines: []string, row, col: int, memo: ^map[Pos]int) -> int {
		pos := Pos{row, col}

		// Check memo first
		if cached, exists := memo[pos]; exists {
			return cached
		}

		// Bounds check
		if row >= len(lines) || col < 0 || col >= len(lines[0]) {
			memo[pos] = 1
			return 1
		}

		char := lines[row][col]
		result: int

		if char == '^' {
			left := count_timelines(lines, row + 1, col - 1, memo)
			right := count_timelines(lines, row + 1, col + 1, memo)
			result = left + right
		} else {
			result = count_timelines(lines, row + 1, col, memo)
		}

		memo[pos] = result
		return result
	}

	return count_timelines(data.lines, data.start.row, data.start.col, &memo)
}


main :: proc() {
	start := time.now()
	data := parse(PUZZLE_INPUT)
	fmt.println("part 1 solution:", solve_part_1(data))
	fmt.println("part 2 solution:", solve_part_2(data))
	total := time.since(start)
	fmt.println("total time taken:", total)
}
