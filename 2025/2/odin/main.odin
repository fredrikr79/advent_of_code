package day2

import "core:fmt"
import "core:math"
import "core:strconv"
import "core:strings"

EXAMPLE_INPUT :: "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"
RANGE_COUNT :: 11

Data :: [RANGE_COUNT][2]int

// split input string into an array of each range end point
parse :: proc(input: string, allocator := context.allocator) -> (data: ^Data, ok: bool) {
	defer free_all(context.temp_allocator)
	data = new(Data, allocator)
	ranges, err := strings.split_n(input, ",", RANGE_COUNT, context.temp_allocator)
	if err != .None do return nil, false
	for range, i in ranges {
		if i > RANGE_COUNT do break
		endpoints, err := strings.split_n(range, "-", 2, context.temp_allocator)
		if err != .None do return nil, false
		for j := 0; j < 2; j += 1 do data[i][j] = strconv.parse_int(endpoints[j]) or_return
	}
	return data, true
}

part_1 :: proc(data: ^Data) -> (sum: int) {
	defer free_all(context.temp_allocator)
	sum = 0
	for range in data {
		start := range[0]
		end := range[1]
		start_digit_count := int(math.log10(f32(start))) + 1
		end_digit_count := int(math.log10(f32(end))) + 1
		if start_digit_count == end_digit_count && start_digit_count % 2 != 0 do continue
		if start_digit_count % 2 != 0 {
			start = end
			start_digit_count = end_digit_count
		}
		if end_digit_count % 2 != 0 {
			end = start
			end_digit_count = start_digit_count
		}
		for j := strconv.atoi(string(start)[:start_digit_count / 2 + 1]);
		    j < strconv.atoi(string(end)[:end_digit_count / 2 + 1]);
		    j += 1 {}
		start_str := make([]u8, start_digit_count, context.temp_allocator)
		strconv.itoa(start_str, start)
		for i := 0; i < start_digit_count; i += 1 {
			if i >= start_digit_count / 2 {
				start_str[i] = start_str[i % (start_digit_count / 2)]
			}
		}
		end_str := make([]u8, end_digit_count, context.temp_allocator)
		strconv.itoa(end_str, end)
		for i := 0; i < end_digit_count; i += 1 {
			if i >= end_digit_count / 2 {
				end_str[i] = end_str[i % (end_digit_count / 2)]
			}
		}
		fmt.println(start, end, strconv.atoi(string(start_str)), strconv.atoi(string(end_str)))
	}
	return
}

main :: proc() {
	data, ok := parse(EXAMPLE_INPUT)
	if !ok do panic("failed to parse")
	defer free(data)

	part_1(data)

	fmt.println(data)

}
