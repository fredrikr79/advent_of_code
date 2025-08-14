package aoc2024day3

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:unicode"

EXAMPLE_INPUT_PATH :: "example.txt"
PUZZLE_INPUT_PATH :: "input.txt"

main :: proc() {
	fmt.println("result of part 1:", sol(false))
	fmt.println("result of part 2:", sol(true))
}

sol :: proc(part2 := false) -> int {
	file_path := len(os.args) == 2 ? os.args[1] : PUZZLE_INPUT_PATH

	input := string(
		os.read_entire_file_from_filename(file_path) or_else panic(
			fmt.tprintf("failed to read", file_path),
		),
	)

	homebrew_regex := `mul(%,%)`
	curptr := 0
	enable_regex := `do()`
	disable_regex := `don't()`
	doptr := 0
	dontptr := 0
	dontnt := true

	runes: [dynamic]rune
	defer delete(runes)
	numbers: [dynamic]int
	defer delete(numbers)

	for c, i in input {
		if part2 {
			// fmt.print(doptr)
			dontcur := rune(disable_regex[dontptr])
			if dontptr >= len(disable_regex) - 1 {
				// fmt.println("false")
				dontnt = false
				dontptr = 0
				doptr = 0
			}
			if c == dontcur {
				dontptr += 1
			} else {
				dontptr = 0
			}
			docur := rune(enable_regex[doptr])
			if doptr >= len(enable_regex) - 1 {
				// fmt.println("true")
				dontnt = true
				doptr = 0
				dontptr = 0
			}
			if c == docur {
				doptr += 1
			} else {
				doptr = 0
			}
		}

		if curptr >= len(homebrew_regex) {
			curptr = 0
			if dontnt {
				// fmt.println("gg")
				b: strings.Builder
				strings.builder_init_none(&b)
				for r in runes {
					strings.write_rune(&b, r)
				}
				str := strings.to_string(b)
				for s in strings.split_iterator(&str, ";") {
					append(
						&numbers,
						strconv.parse_int(s) or_else panic(fmt.tprintf("failed to parse", s)),
					)
				}
			}
			clear(&runes)
		}
		cur := rune(homebrew_regex[curptr])
		if cur == '%' {
			if unicode.is_digit(c) {
				append(&runes, c)
			} else if rune(homebrew_regex[curptr + 1]) == c {
				curptr += 2
				append(&runes, ';')
			} else {
				// fmt.println("gulag2", curptr)
				curptr = 0
				clear(&runes)
			}
		} else if cur == c {
			curptr += 1
		} else {
			// fmt.println("gulag", curptr)
			curptr = 0
			clear(&runes)
		}
	}

	// fmt.println(numbers)

	result := 0
	for n, i in numbers {
		if i % 2 == 1 {continue}
		if len(numbers) - 1 == i {break}
		next := numbers[i + 1]
		result += next * n
	}

	return result
}
