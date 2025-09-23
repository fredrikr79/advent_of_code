# aoc 2016/1
&fras $ input.txt
°/$"_, _" ⍜⇌↘₁
∧◇(⍥\+⋕ ⍣(
    ⍩⊙⍜⊢(×i) °(⊂@L)
  | ⍩⊙⍜⊢(×¯i) °(⊂@R))
)⊙i_0
⌵+°ℂ⊣
$Part₁
# the idea is to represent our position
# as a complex number (2d vector). rotate by
# 90 or -90 degrees when you encounter L or R
# by multiplying by i or -i on the direction
# vector. 
# this can be done by folding with the initial
# values i (direction) and 0 (position), pattern-
# matching the next token on L or R and recognizing
# them by ⍩.
# once the direction vector has been rotated
# accordingly, ⍥\+⋕ to add the direction unit vector
# to the position vector n times for token Ln or Rn.
# 
# we can see many awesome pieces of functional and
# array oriented code!
