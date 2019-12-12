module Advent2019_08
  extend self

  def name
    "2019 Day 8: Space Image Format"
  end

  def part1(input, width = 25, height = 6)
    min_zeros = Int32::MAX
    result = -1

    input.chomp.chars.each_slice(width * height) do |layer|
      num_zeros = layer.count('0')

      if num_zeros < min_zeros
        min_zeros = num_zeros
        result = layer.count('1') * layer.count('2')
      end
    end

    result
  end

  def part2(input, width = 25, height = 6)
    layer_size = width * height
    result = Array.new layer_size, '.'

    input.chomp.chars.each_slice(layer_size) do |layer|
      layer.each_with_index do |c, i|
        if result[i] == '.' && c != '2'
          result[i] = c == '0' ? ' ' : '#'
        end
      end
    end

    '\n' + result.each_slice(width).join('\n') { |layer| layer.join }
  end
end
