defmodule Checkers do
  defmodule Rules do
    @size 8
    @range 0 .. @size - 1

    def initial() do
      {
        { +1,  0, +1,  0, +1,  0, +1,  0 },
        {  0, +1,  0, +1,  0, +1,  0, +1 },
        { +1,  0, +1,  0, +1,  0, +1,  0 },
        {  0,  0,  0,  0,  0,  0,  0,  0 },
        {  0,  0,  0,  0,  0,  0,  0,  0 },
        {  0, -1,  0, -1,  0, -1,  0, -1 },
        { -1,  0, -1,  0, -1,  0, -1,  0 },
        {  0, -1,  0, -1,  0, -1,  0, -1 }
      }
    end

    def get_p(b, x, y), do: elem(elem(b, y), x)

    def set_p(b, x, y, p), do: put_elem(b, y, put_elem(elem(b, y), x, p))

    def my_piece?(s, p), do: p == s

    def my_king?(s, p), do: p == 2 * s

    def mine?(s, p), do: my_piece?(s, p) || my_king?(s, p)

    def opp?(s, p), do: mine?(s, -p)

    def open?(p), do: p == 0

    def playable?(x, y), do: rem(x + y, 2) == 0

    def in_bounds?(x, y, nx, ny) do
      (x in @range) && (y in @range) && (nx in @range) && (ny in @range)
    end

    def is_jump?(x, y, nx, ny), do: (abs(nx - x) == 2) && (abs(ny - y) == 2)

    def promoted?(_nx, ny, p), do: (p == +1 && ny == @size - 1) || (p == -1 && ny == 0)

    def promote(nx, ny, p) do
      if promoted?(nx, ny, p), do: 2 * p, else: p
    end

    def squares(b) do
      for x <- @range,
          y <- @range,
          playable?(x, y), do: { x, y, get_p(b, x, y) }
    end

    def my_squares(b, s) do
      for { x, y, p } <- squares(b), mine?(s, p), do: { x, y, p }
    end

    def directions(p) do
      case p do
        +1 -> [{ +1, +1 }, { -1, +1 }]
        +2 -> [{ +1, +1 }, { -1, +1 }, { +1, -1 }, { -1, -1 }]
        -1 -> [{ -1, -1 }, { +1, -1 }]
        -2 -> [{ -1, -1 }, { +1, -1 }, { -1, +1 }, { +1, +1 }]
      end
    end

    def do_jump(b, s, x, y, nx, ny) do
      if in_bounds?(x, y, nx, ny) && is_jump?(x, y, nx, ny) do
        mx = div(x + nx, 2)
        my = div(y + ny, 2)

        if opp?(s, get_p(b, mx, my)) && open?(get_p(b, nx, ny)) do
          b |> set_p(x, y, 0)
            |> set_p(mx, my, 0)
            |> set_p(nx, ny, promote(nx, ny, get_p(b, x, y)))
        end
      end
    end

    def collect_jumps(b, s, x, y, p) do
      for { dx, dy } <- directions(p),
          nx = x + 2 * dx,
          ny = y + 2 * dy,
          nb = do_jump(b, s, x, y, nx, ny),
          jumps = collect_jumps(nb, s, nx, ny, p), do: [ { nx, ny } | jumps ]
    end

    def jumps_from(b, s, x, y) do
      jumps = collect_jumps(b, s, x, y, get_p(b, x, y))
      if length(jumps) > 0, do: [ { x, y } | jumps ]
    end

    def my_jumps(b, s) do
      for { x, y, _ } <- my_squares(b, s),
          jumps = jumps_from(b, s, x, y), do: jumps
    end

    def do_move(b, _s, x, y, nx, ny) do
      if in_bounds?(x, y, nx, ny) && open?(get_p(b, nx, ny)) do
        b |> set_p(x, y, 0)
          |> set_p(nx, ny, promote(nx, ny, get_p(b, x, y)))
      end
    end

    def collect_moves(b, s, x, y, p) do
      for { dx, dy } <- directions(p),
          nx = x + dx,
          ny = y + dy,
          do_move(b, s, x, y, nx, ny), do: [ { nx, ny } ]
    end

    def moves_from(b, s, x, y) do
      moves = collect_moves(b, s, x, y, get_p(b, x, y))
      if length(moves) > 0, do: [ { x, y } | moves ]
    end

    def my_moves(b, s) do
      for { x, y, _ } <- my_squares(b, s),
          moves = moves_from(b, s, x, y), do: moves
    end

    def my_plays(b, s) do
      jumps = my_jumps(b, s)
      if length(jumps) > 0, do: jumps, else: my_moves(b, s)
    end
  end
end
