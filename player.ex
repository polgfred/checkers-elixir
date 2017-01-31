defmodule Checkers do
  defmodule Player do
    import Checkers.Rules

    @depth 5

    @pb_vals {
      { 100,   0, 104,   0, 104,   0, 100,   0 },
      {   0, 100,   0, 102,   0, 102,   0, 100 },
      { 102,   0, 105,   0, 105,   0, 102,   0 },
      {   0, 105,   0, 110,   0, 110,   0, 105 },
      { 110,   0, 120,   0, 120,   0, 110,   0 },
      {   0, 120,   0, 130,   0, 130,   0, 120 },
      { 130,   0, 142,   0, 142,   0, 130,   0 },
      {   0,   0,   0,   0,   0,   0,   0,   0 }
    }

    @pr_vals {
      {   0,   0,   0,   0,   0,   0,   0,   0 },
      {   0, 130,   0, 142,   0, 142,   0, 130 },
      { 120,   0, 130,   0, 130,   0, 120,   0 },
      {   0, 110,   0, 120,   0, 120,   0, 110 },
      { 105,   0, 110,   0, 110,   0, 105,   0 },
      {   0, 102,   0, 105,   0, 105,   0, 102 },
      { 100,   0, 102,   0, 102,   0, 100,   0 },
      {   0, 100,   0, 104,   0, 104,   0, 100 }
    }

    @kb_vals {
      { 152,   0, 152,   0, 152,   0, 164,   0 },
      {   0, 164,   0, 164,   0, 164,   0, 164 },
      { 152,   0, 180,   0, 180,   0, 164,   0 },
      {   0, 164,   0, 180,   0, 180,   0, 152 },
      { 152,   0, 180,   0, 180,   0, 164,   0 },
      {   0, 164,   0, 180,   0, 180,   0, 152 },
      { 164,   0, 164,   0, 164,   0, 164,   0 },
      {   0, 164,   0, 152,   0, 152,   0, 152 }
    }

    @kr_vals @kb_vals

    def compare_plays(+1, plays) do
      Enum.max_by plays,
        fn ({score, _}) -> +score end,
        fn () -> {-2147483648, nil} end
    end

    def compare_plays(-1, plays) do
      Enum.max_by plays,
        fn ({score, _}) -> -score end,
        fn () -> {+2147483648, nil} end
    end

    def calculate_score(b) do
      vals = for {x, y, p} <- squares(b) do
        case p do
          +1 -> get_p(@pb_vals, x, y)
          -1 -> get_p(@pr_vals, x, y)
          +2 -> get_p(@kb_vals, x, y)
          -2 -> get_p(@kr_vals, x, y)
           _ -> 0
        end
      end

      :lists.sum(vals)
    end

    def calculate_score_recursive(b, s, v) do
      if (v > 0) || (length(my_jumps(b, -s)) > 0) do
        {score, _} = best_play(b, -s, v - 1)
        score
      else
        calculate_score(b)
      end
    end

    def best_play_from(b, s, v, acc, [_]) do
      {calculate_score_recursive(b, s, v), :lists.reverse(acc)}
    end

    def best_play_from(b, s, v, acc, [{x, y} | more]) do
      plays = for [{nx, ny} | _] = tree <- more,
                  nb = do_play(b, s, x, y, nx, ny),
                do: best_play_from(nb, s, v, [{nx, ny} | acc], tree)

      compare_plays(s, plays)
    end

    def best_play(b, s, v \\ @depth) do
      plays = for [{x, y} | _] = tree <- my_plays(b, s),
                do: best_play_from(b, s, v, [{x, y}], tree)

      compare_plays(s, plays)
    end
  end
end
