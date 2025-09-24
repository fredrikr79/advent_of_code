# aoc 2016/2
&fras "input.txt"
⍜⇌(▽⊸(>0\+≠@\n)) # world's most complicated right-trim
# parse each letter of the puzzle input.
# update position vector.
⊂∧(
  ⍣(⍩(-i) ◌°.@U
  | ⍩(+i) ◌°.@D
  | ⍩(-1) ◌°.@L
  | ⍩(+1) ◌°.@R
  | ⍩(⟜⊂) ◌°.@\n)
  ⍜°ℂ∩(↥¯1↧1) # clamp vector
)⊙0⊙[]
⍉⊟°ℂ +ℂ1 1       # translate
⌝⊥10 ⊡⊙(+1°△3_3) # grab code
$Part₁
