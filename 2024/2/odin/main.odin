package aoc2024day2

import "core:fmt"
import "core:math"
import "core:os"
import "core:strconv"
import "core:strings"

EXAMPLE_INPUT_PATH :: "example.txt"
PUZZLE_INPUT_PATH :: "input.txt"

main :: proc() {
	path := len(os.args) == 2 ? os.args[1] : EXAMPLE_INPUT_PATH
	data := os.read_entire_file(path) or_else panic(fmt.tprintf("failed to read", path))
	defer delete(data)

	numbers: [dynamic]int
	defer delete(numbers)

	counter1 := 0
	counter2 := 0

	it := string(data)
	for line in strings.split_lines_iterator(&it) {
		for word in strings.split(line, " ") {
			number := strconv.parse_int(word) or_else panic(fmt.tprintf("failed to parse", word))
			append(&numbers, number)
		}

		diffs := diff(&numbers)
		counter1 += int(safe(&diffs))

		// or-reduction on safe of each tolerated diff
		b := false
		for &combination in tolerate(&numbers) {
			diffs := diff(&combination)
			if safe(&diffs) {
				b = true
				break
			}
		}
		counter2 += int(b)

		clear(&numbers)
	}

	fmt.println("part 1: there were", counter1, "safe reports.")
	fmt.println("part 2: there were", counter2, "safe reports.")
}

diff :: proc(nums: ^[dynamic]int) -> [dynamic]int {
	out: [dynamic]int
	for cur, i in nums {
		if len(nums) - 1 == i {break}
		next := nums[i + 1]
		append(&out, next - cur)
	}
	return out
}

safe :: proc(diffs: ^[dynamic]int) -> bool {
	for cur, i in diffs {
		// not on last element of list ? ... : default
		next := len(diffs) - 1 != i ? diffs[i + 1] : cur
		// not (same sign and greater than zero && at most 3)
		if !(cur * next > 0 && cur * cur <= 9) {
			return false
		}
	}
	// fmt.println(safe ? "safe" : "unsafe")
	return true
}

tolerate :: proc(diffs: ^[dynamic]int) -> [dynamic][dynamic]int {
	out: [dynamic][dynamic]int
	for d, i in diffs {
		new: [dynamic]int
		append(&out, new)
	}
	for d, i in diffs {
		start: []int = diffs^[0:i]
		end: []int = diffs^[i + 1:len(diffs)]
		append(&out[i], ..start)
		append(&out[i], ..end)
	}
	return out
}
