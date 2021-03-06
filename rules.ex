defmodule Checkers do
  defmodule Rules do
    @size 8
    @range 0 .. @size - 1

    def initial do
      {
        {+1,  0, +1,  0, +1,  0, +1,  0},
        { 0, +1,  0, +1,  0, +1,  0, +1},
        {+1,  0, +1,  0, +1,  0, +1,  0},
        { 0,  0,  0,  0,  0,  0,  0,  0},
        { 0,  0,  0,  0,  0,  0,  0,  0},
        { 0, -1,  0, -1,  0, -1,  0, -1},
        {-1,  0, -1,  0, -1,  0, -1,  0},
        { 0, -1,  0, -1,  0, -1,  0, -1}
     }
    end

    def get_p(b, x, y), do: b |> elem(y) |> elem(x)

    def set_p(b, x, y, p), do: put_elem(b, y, b |> elem(y) |> put_elem(x, p))

    def my_piece?(s, p), do: p == s

    def my_king?(s, p), do: p == 2 * s

    def mine?(s, p), do: my_piece?(s, p) || my_king?(s, p)

    def opp?(s, p), do: mine?(-s, p)

    def open?(p), do: p == 0

    def playable?(x, y), do: rem(x + y, 2) == 0

    def in_bounds?(x, y, nx, ny),
      do: (x in @range) && (y in @range) && (nx in @range) && (ny in @range)

    def jump?(x, y, nx, ny),
      do: (abs(nx - x) == 2) && (abs(ny - y) == 2)

    def promoted?(_nx, ny, p),
      do: (p == +1 && ny == @size - 1) || (p == -1 && ny == 0)

    def promote(nx, ny, p) do
      if promoted?(nx, ny, p), do: 2 * p, else: p
    end

    def squares(b) do
      for x <- @range,
          y <- @range,
          playable?(x, y),
        do: {x, y, get_p(b, x, y)}
    end

    def my_squares(b, s) do
      for {x, y, p} <- squares(b),
          mine?(s, p),
        do: {x, y, p}
    end

    def directions(p) do
      case p do
        +1 -> [{+1, +1}, {-1, +1}]
        +2 -> [{+1, +1}, {-1, +1}, {+1, -1}, {-1, -1}]
        -1 -> [{-1, -1}, {+1, -1}]
        -2 -> [{-1, -1}, {+1, -1}, {-1, +1}, {+1, +1}]
      end
    end

    def do_jump(b, s, x, y, nx, ny) do
      if in_bounds?(x, y, nx, ny) && jump?(x, y, nx, ny) do
        mx = div(x + nx, 2)
        my = div(y + ny, 2)

        if opp?(s, get_p(b, mx, my)) && open?(get_p(b, nx, ny)) do
          b
          |> set_p(x, y, 0)
          |> set_p(mx, my, 0)
          |> set_p(nx, ny, promote(nx, ny, get_p(b, x, y)))
        end
      end
    end

    def collect_jumps(b, s, x, y, p) do
      for {dx, dy} <- directions(p),
          nx = x + 2 * dx,
          ny = y + 2 * dy,
          nb = do_jump(b, s, x, y, nx, ny),
          jumps = collect_jumps(nb, s, nx, ny, p),
        do: [{nx, ny} | jumps]
    end

    def jumps_from(b, s, x, y) do
      case collect_jumps(b, s, x, y, get_p(b, x, y)) do
        [] -> nil
        jumps -> [{x, y} | jumps]
      end
    end

    def my_jumps(b, s) do
      for {x, y, _} <- my_squares(b, s),
          jumps = jumps_from(b, s, x, y),
        do: jumps
    end

    def do_move(b, _s, x, y, nx, ny) do
      if in_bounds?(x, y, nx, ny) && open?(get_p(b, nx, ny)) do
        b
        |> set_p(x, y, 0)
        |> set_p(nx, ny, promote(nx, ny, get_p(b, x, y)))
      end
    end

    def collect_moves(b, s, x, y, p) do
      for {dx, dy} <- directions(p),
          nx = x + dx,
          ny = y + dy,
          do_move(b, s, x, y, nx, ny),
        do: [{nx, ny}]
    end

    def moves_from(b, s, x, y) do
      case collect_moves(b, s, x, y, get_p(b, x, y)) do
        [] -> nil
        moves -> [{x, y} | moves]
      end
    end

    def my_moves(b, s) do
      for {x, y, _} <- my_squares(b, s),
          moves = moves_from(b, s, x, y),
        do: moves
    end

    def do_play(b, s, x, y, nx, ny) do
      if jump?(x, y, nx, ny) do
        do_jump(b, s, x, y, nx, ny)
      else
        do_move(b, s, x, y, nx, ny)
      end
    end

    def do_plays(b, s, [{x, y}, {nx, ny}]) do
      do_play(b, s, x, y, nx, ny)
    end

    def do_plays(b, s, [{x, y}, {nx, ny} | more]) do
      b
      |> do_play(s, x, y, nx, ny)
      |> do_plays(s, [{nx, ny} | more])
    end

    def my_plays(b, s) do
      case my_jumps(b, s) do
        [] -> my_moves(b, s)
        jumps -> jumps
      end
    end

    def dump!(b) do
      for {y, r} <- :lists.reverse(Enum.zip(0..7, Tuple.to_list(b))) do
        IO.write(y)
        IO.write(" ")
        for {x, p} <- Enum.zip(0..7, Tuple.to_list(r)) do
          if playable?(x, y) do
            case p do
              +1 -> IO.write("b ")
              +2 -> IO.write("B ")
              -1 -> IO.write("r ")
              -2 -> IO.write("R ")
               _ -> IO.write("_ ")
            end
          else
            IO.write("  ")
          end
        end
        IO.write("\n")
      end
      IO.write("  0 1 2 3 4 5 6 7\n\n")
    end
    nil
  end
end
