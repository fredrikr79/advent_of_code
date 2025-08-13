package aoc2024day9

import "core:container/queue"
import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:unicode"

PUZZLE_INPUT_PATH :: "input.txt"
EXAMPLE_INPUT_PATH :: "example.txt"

main :: proc() {
	path := len(os.args) == 2 ? os.args[1] : PUZZLE_INPUT_PATH
	input := string(os.read_entire_file_from_filename(path) or_else panic("damn"))

	fmt.println("part 1:", part1(input))
	fmt.println("part 2:", part2(input))
}

part2 :: proc(input: string) -> int {
	mem: [dynamic]int
	defer delete(mem)
	free: map[int]int // start_index -> free_space_interval_delta
	defer delete(free)
	filesizes: map[int]int // fileid -> block_count
	defer delete(filesizes)

	next_fileid := 0
	memptr := 0

	for r, i in input {
		if !unicode.is_digit(r) {continue}
		d := strconv._digit_value(r)
		if i % 2 == 0 { 	// files
			for j := 0; j < d; j += 1 {
				append(&mem, next_fileid)
				memptr += 1
				filesizes[next_fileid] = j + 1
			}
			next_fileid += 1
		} else { 	// free
			for j := 0; j < d; j += 1 {
				append(&mem, -1)
				free[memptr - j] = j + 1
				memptr += 1
			}
		}
	}

	// fmt.println(free)
	// fmt.println(filesizes)

	used: [dynamic]int
	defer delete(used)

	#reverse for fid, i in mem {
		if fid < 0 || slice.contains(used[:], fid) {continue}
		append(&used, fid)
		move := false
		size := filesizes[fid]
		for f, j in mem {
			if f >= 0 || !(j in free) {continue} 	// TODO: scary slow
			t := free[j]
			if t >= size {
				move = true
				for k in 0 ..< size {
					mem[j + k] = fid
				}
				free[j + size] = t - size
				break
			}
		}
		if move {
			for k in 0 ..< size {
				mem[i - k] = -2
			}
		}
		for m in mem {
			if m < 0 {
				fmt.print("x")
			} else {
				fmt.print(m)
			}
		}
		fmt.println()
	}

	// for fid := next_fileid - 1; fid > 0; fid -= 1 {
	// 	size := filesizes[fid]
	// 	memptr -= size
	// }

	// keys := slice.map_keys(free) or_else panic("damn2")
	// slice.sort(keys)
	// ptr := 0
	// #reverse for fileid, i in mem {
	// 	if fileid < 0 {continue}
	// 	cur := mem[memptr - 1]
	// 	target := filesizes[cur]
	// 	for start, j in keys[ptr:] {
	// 		delta := free[start]
	// 		if delta < target {continue}
	// 		end := delta + start
	// 	}
	// }

	// #reverse for fileid, i in mem {
	// 	f := queue.peek_front(&free)^
	// 	if queue.len(free) <= 0 || f >= len(mem) {break}
	// 	if fileid >= 0 {
	// 		mem[f] = fileid
	// 		queue.pop_front(&free)
	// 	}
	// 	pop(&mem)
	// }

	sum := 0
	for fileid, i in mem {
		if fileid < 0 {continue}
		sum += fileid * i
	}

	return sum
}

part1 :: proc(input: string) -> int {
	mem: [dynamic]int
	defer delete(mem)
	free: queue.Queue(int)
	queue.init(&free)
	defer queue.destroy(&free)

	next_fileid := 0
	memptr := 0

	for r, i in input {
		if !unicode.is_digit(r) {continue}
		d := strconv._digit_value(r)
		if i % 2 == 0 { 	// files
			for j := 0; j < d; j += 1 {
				append(&mem, next_fileid)
				memptr += 1
			}
			next_fileid += 1
		} else { 	// free
			for j := 0; j < d; j += 1 {
				append(&mem, -1)
				queue.push_back(&free, memptr)
				memptr += 1
			}
		}
	}

	#reverse for fileid, i in mem {
		f := queue.peek_front(&free)^
		if queue.len(free) <= 0 || f >= len(mem) {break}
		if fileid >= 0 {
			mem[f] = fileid
			queue.pop_front(&free)
		}
		pop(&mem)
	}

	sum := 0
	for fileid, i in mem {
		if fileid < 0 {continue}
		sum += fileid * i
		// fmt.println(fileid, i)
	}

	return sum
}
