defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
  """

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares

  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{ hex: hex}

  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail ]} = image) do
    # use pattern matching.
    %Identicon.Image{image | color: {r, g, b}}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten# reference a function. using &. /1 means use the function with one argument.
      |> Enum.with_index #because we need index, but Elixir doesn't provide it.

      %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [second, first] # append to row.  ++ is join operator.
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter grid, fn({code, _index})->
      rem(code, 2) == 0
    end
    %Identicon.Image{image | grid: grid}
  end
end
