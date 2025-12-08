package main

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

PUZZLE_INPUT: string : #load("example")

Pos :: distinct struct {
	x, y, z: int,
}

parse :: proc(input: string) -> (output: []Pos) {
	lines := strings.split_lines(input)
	output = make([]Pos, len(lines))
	digits := make([dynamic]int, context.temp_allocator)
	defer free_all(context.temp_allocator)
	nums: [3]int
	for line, row in lines {
		for num, i in strings.split(line, ",") do nums[i], _ = strconv.parse_int(num)
		output[row] = Pos{nums[0], nums[1], nums[2]}
	}
	return
}

solve :: proc(data: []Pos) -> (output: int) {
	context.allocator = context.temp_allocator

	distances := make([]int, len(data) * len(data))
	for p1, row in data {
		for p2, col in data {
			d := Pos{p1.x - p2.x, p1.y - p2.y, p1.z - p2.z}
			distance := d.x * d.x + d.y * d.y + d.z * d.z
			distances[row * len(data) + col] = distance == 0 ? 1e9 : distance // TODO: triangle
		}
	}
	fmt.println(distances)
	shortest := make([]int, len(data))
	for i in 0 ..< len(data) {
		row := distances[i * len(data):(i + 1) * len(data)]
		shortest[i] = slice.min_index(row)
	}
	fmt.println(shortest)
	return
}

main :: proc() {
	fmt.println(solve(parse(PUZZLE_INPUT)))
}
