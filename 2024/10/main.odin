package aoc2024day10

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:unicode"

EXAMPLE_INPUT_PATH :: "example.txt"
PUZZLE_INPUT_PATH :: "input.txt"

Grid :: struct($T: typeid) {
	data:   []T,
	width:  int,
	height: int,
}

gpos :: proc(g: Grid($T), i: int) -> (row: int, col: int) {
	return i / g.width, i % g.width
}

gidx :: proc(g: Grid($T), row, col: int) -> (i: int) {
	return row * g.width + col
}

gget :: proc(g: Grid($T), row, col: int) -> (value: Maybe(T)) {
	if !(0 <= row <= g.height && 0 <= col <= g.width) do return nil
	return g.data[gidx(g, row, col)]
}

gset :: proc(g: ^Grid($T), row, col: int, value: T) {
	g^.data[gidx(g, row, col)] = value
}

// TODO: use enumerated array
gadj :: proc(g: Grid($T), row, col: int) -> [4]Maybe(T) {
	return { 	//                            (0)  
		gget(g, row - 1, col), // (0)          ^    
		gget(g, row, col + 1), // (1)     (3)<-+->(1)
		gget(g, row + 1, col), // (2)          v    
		gget(g, row, col - 1), // (3)         (2)  
	}
}

main :: proc() {
	path := len(os.args) == 2 ? os.args[1] : EXAMPLE_INPUT_PATH
	input := string(
		os.read_entire_file_from_filename(path) or_else panic("failed to read input file"),
	)

	g := parse(input)
	fmt.println("part 1:", solve1(g))
}

parse :: proc(input: string) -> Grid(int) {
	data: [dynamic]int
	width, height := 0, 0

	for line in strings.split_lines(strings.trim_right_space(input)) {
		if width == 0 do width = len(line)
		for r in line {
			digit := strconv._digit_value(r)
			append(&data, digit)
		}
		height += 1
	}

	return {data[:], width, height}
}

solve1 :: proc(g: Grid(int)) -> (res: int) {
	inner :: proc(g: Grid(int), row, col: int) -> (order: int) {
		return
	}

	cache: map[int]int

	return
}
