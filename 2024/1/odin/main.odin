package aoc2024day1

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"

main :: proc() {
	fmt.println("hello world")
	fmt.println("timmy's first odin")

	buf: [15000]byte
	num_bytes, _ := os.read(os.stdin, buf[:])

	dyn := make([dynamic]byte)
	for i := 0; i < num_bytes; i += 1 do append(&dyn, buf[i])

	s := strings.to_string({dyn})
	lines, _ := strings.split_lines(s)

	for l in lines {
		if l == "" do break

		t, _ := strings.split(l, "   ")
		l, r := t[0], t[1]
		a, _ := strconv.parse_int(l)
		b, _ := strconv.parse_int(r)

		fmt.println(a, b)
	}
}
