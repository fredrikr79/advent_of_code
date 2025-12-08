# day 11

Parse ← (
  ⊜(∩□⊙(⊜∘⊸≠@ )°$"_: _")⊸≠@\n
  ∧(insert°□°⊟)⊙[]⍉⊟
)
Go‼   ← ⊙◌path(0°□memoget|≍^1)^0
Part₁ ← ⧻Go‼"you" "out"
Part₂ ← ⧻⊚≡◇(↧∩/↥⌕□"fft"⤙⌕□"dac"≡□)Go‼"svr" "out"

⍤⤙≍ 5 Part₁ Parse $ aaa: you hhh
                  $ you: bbb ccc
                  $ bbb: ddd eee
                  $ ccc: ddd eee fff
                  $ ddd: ggg
                  $ eee: out
                  $ fff: out
                  $ ggg: out
                  $ hhh: ccc fff iii
                  $ iii: out

⍤⤙≍ 2 Part₂ Parse $ svr: aaa bbb
                  $ aaa: fft
                  $ fft: ccc
                  $ bbb: tty
                  $ tty: ccc
                  $ ccc: ddd eee
                  $ ddd: hub
                  $ hub: fff
                  $ eee: dac
                  $ dac: fff
                  $ fff: ggg hhh
                  $ ggg: out
                  $ hhh: out

⍜now(Part₂ Parse &fras "input")
