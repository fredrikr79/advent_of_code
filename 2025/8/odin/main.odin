package day_8

import "core:fmt"
import "core:strconv"
import "core:strings"

input :: cast(string)#load("../ex_input")

Pos :: [3]int

parse :: proc(input: string) -> (res: []Pos, ok: bool) {
	data: [dynamic]Pos
	for line in strings.split_lines(strings.trim_space(input)) {
		raw_pos := strings.split(line, ",")
		pos: Pos
		for &v, i in pos {
			v = strconv.parse_int(raw_pos[i]) or_return
		}
		append(&data, pos)
	}
	return data[:], true
}

solve_1 :: proc(data: []Pos) -> int {
	edges: map[Pos]Pos
	for p1 in data {
		for p2 in data {
			if p1 == p2 do continue
			if p1 not_in edges do edges[p1] = p2
		}
	}
	fmt.println(edges)
	return 0
}

main :: proc() {
	data, ok := parse(input)
	if !ok do fmt.eprintln("failed to parse")
	fmt.println(solve_1(data))
}
