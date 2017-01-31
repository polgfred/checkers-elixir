import Checkers.Rules
import Checkers.Player

init = initial()

dump!(init)

IO.inspect(my_squares(init, +1))
IO.inspect(my_plays(init, +1))

IO.puts("")

IO.inspect({_, bp} = best_play(init, +1))
dump!(do_plays(init, +1, bp))

IO.puts("")

init = {
  {  0,  0, +1,  0,  0,  0,  0,  0 },
  {  0, -1,  0, -1,  0,  0,  0,  0 },
  {  0,  0,  0,  0,  0,  0,  0,  0 },
  {  0,  0,  0, -1,  0, -1,  0,  0 },
  {  0,  0,  0,  0,  0,  0,  0,  0 },
  {  0, +1,  0,  0,  0, -1,  0,  0 },
  {  0,  0, -1,  0,  0,  0,  0,  0 },
  {  0,  0,  0,  0,  0,  0,  0,  0 }
}

dump!(init)

IO.inspect(my_squares(init, +1))
IO.inspect(my_plays(init, +1))

IO.puts("")

IO.inspect({_, bp} = best_play(init, +1))
dump!(do_plays(init, +1, bp))

IO.puts("")
