import Checkers.Rules
import Checkers.Player

init = initial()

IO.inspect(my_squares(init, +1))
IO.inspect(my_plays(init, +1))

IO.inspect(do_play(init, +1, 2, 2, 3, 3))
IO.inspect(do_plays(init, +1, [{2, 2}, {3, 3}]))

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

IO.inspect(my_squares(init, +1))
IO.inspect(my_plays(init, +1))

IO.inspect(best_play(init, +1))
