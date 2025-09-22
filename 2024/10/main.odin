package aoc2024day10

import "core:fmt"
import "core:os"
import "core:slice"
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

gpos :: proc(i: int) -> (row: int, col: int) {
	return i / g.width, i % g.width
}

gidx :: proc(row, col: int) -> (i: int) {
	return row * g.width + col
}

gidx_safe :: proc(row, col: int) -> (m: Maybe(int)) {
	if !(0 <= row && row <= g.height && 0 <= col && col <= g.width) do return nil
	return gidx(row, col)
}

gget :: proc(row, col: int) -> (value: int) {
	return g.data[gidx(row, col)]
}

gget_safe :: proc(row, col: int) -> (mvalue: Maybe(any)) {
	if m := gidx_safe(row, col); m == nil do return nil
	else do return g.data[m.(int)]
}

gset :: proc(row, col: int, value: $T) {
	g.data[gidx(row, col)] = value
}

// TODO: use enumerated array
gadj_idx :: proc(
	row, col: int,
) -> (
	north: Maybe(int),
	east: Maybe(int),
	south: Maybe(int),
	west: Maybe(int),
) {
	north = gidx_safe(row - 1, col)
	east = gidx_safe(row, col + 1)
	south = gidx_safe(row + 1, col)
	west = gidx_safe(row, col - 1)
	return
}

g: Grid(int)

main :: proc() {
	path := len(os.args) == 2 ? os.args[1] : EXAMPLE_INPUT_PATH
	input := string(
		os.read_entire_file_from_filename(path) or_else panic("failed to read input file"),
	)

	g = parse(input)
	fmt.println("part 1:", solve1())
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

solve1 :: proc() -> (res: int) {
	inner :: proc(row, col, cur: int) -> (score: int) {
		n, e, s, w := gadj_idx(row, col)
		dir: [4]Maybe(int) = {n, e, s, w}
		directions: []int = slice.mapper(
			slice.filter(dir[:], proc(m: Maybe(int)) -> bool {return m != nil}),
			proc(m: Maybe(int)) -> int {return m.(int)},
		)
		heights: []int = slice.mapper(directions, proc(i: int) -> int {return gget(gpos(i))})
		fmt.println(dir, directions, heights)
		cache[gidx(row, col)] = score
		return
	}

	@(static) cache: map[int]int
	return inner(0, 2, 0)
}

Test :: struct {
	hello:  int,
	method: proc(_: int) -> int,
}
