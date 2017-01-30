defmodule Checkers do
  defmodule Player do
    import Checkers.Rules

    @depth 3

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
      # if (v > 0) || (length(my_jumps(b, -s)) > 0) do
      #   with {score, _} <- best_play(b, -s, v - 1), do: score
      # else
        calculate_score(b)
      # end
    end

    # def compare_plays(s, plays) do
    #   case {s, plays} do
    #     {+1, []} -> -2147483648
    #     {+1, _} ->
    #     {-1, []} -> +2147483647
    #     {-1, _} ->
    #   end
    # end

    def best_play_from(b, s, v, acc, tree) do
      with [{x, y} | plays] = tree do
        if length(plays) == 0 do
          {calculate_score_recursive(b, s, v), :lists.reverse(acc)}
        else
          all = for tree <- plays do
            with [{nx, ny} | _] = tree,
                 nb = do_play(b, s, x, y, nx, ny),
              do: best_play_from(nb, s, v, [{nx, ny} | acc], tree)
          end
          List.first(all)
        end
      end
    end

    def best_play(b, s, v \\ 0) do
      all = for tree <- my_plays(b, s) do
        with [{x, y} | plays] = tree, do: best_play_from(b, s, v, [{x, y}], tree)
      end
      List.first(all)
    end
  end
end
