import Checkers.Rules

init = initial()

IO.inspect(my_squares(init, +1))
IO.inspect(my_plays(init, +1))

init = {
  {  0,  0, +1,  0,  0,  0,  0,  0 },
  {  0, -1,  0, -1,  0,  0,  0,  0 },
  {  0,  0,  0,  0,  0,  0,  0,  0 },
  {  0,  0,  0, -1,  0, -1,  0,  0 },
  {  0,  0,  0,  0,  0,  0,  0,  0 },
  {  0,  0,  0,  0,  0, -1,  0,  0 },
  {  0,  0,  0,  0,  0,  0,  0,  0 },
  {  0,  0,  0,  0,  0,  0,  0,  0 }
}

IO.inspect(my_squares(init, +1))
IO.inspect(my_plays(init, +1))
