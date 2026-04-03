#!/usr/bin/env nu
def part-1 [parsed] {
  $parsed
  | par-each {
    |row| where {|x| into string
      | split chars
      | take (($in | length) // 2)
      | ($in | str join) + ($in | str join)
      | try {into int} catch {0}
      | $in == $x
    }
  } | flatten | math sum 
}

let input = open input
let parsed = $input
           | str trim
           | lines
           | str join
           | split row ','
           | split column '-'
           | rename l u
           | into int l u
           | each {|row| $row.l..$row.u}

timeit {print (part-1 $parsed)}
