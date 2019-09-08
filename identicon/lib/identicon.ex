defmodule Identicon do
  @moduledoc """
  Documentation for Identicon.
  """

  import Enum

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  defp hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end

  defp pick_color(image) do
    %Identicon.Image{hex: [r, g, b | _tail]} = image
    %Identicon.Image{image | color: {r, g, b}}
  end

  defp build_grid(image) do
    %Identicon.Image{hex: hex_list} = image

    grid =
      hex_list
      |> chunk_every(3, 3, :discard)
      |> map(&mirrow_row/1)
      |> List.flatten()
      |> with_index()

    %Identicon.Image{image | grid: grid}
  end

  defp mirrow_row(row) do
    [first, second | _tail] = row
    row ++ [first, second]
  end

  defp filter_odd_squares(image) do
    %Identicon.Image{grid: grid} = image

    grid = Enum.filter(grid, fn {code, _index} -> rem(code, 2) == 0 end)
    %Identicon.Image{image | grid: grid}
  end

  defp build_pixel_map(image) do
    %Identicon.Image{grid: grid} = image

    pixel_map =
      map(grid, fn {_code, index} ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50

        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}

        {top_left, bottom_right}
      end)

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  defp draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    each(pixel_map, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, fill)
    end)

    :egd.render(image)
  end

  defp save_image(image, filename) do
    File.write("#{filename}.png", image)
  end
end
