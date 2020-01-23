require "./intcode.cr"
require "./point.cr"
require "./turtle.cr"

module Advent2019_17
  extend self

  private def build_map(vm)
    while !vm.halted?
      vm.step
    end

    map = vm.outputs.map { |ch| ch.chr }.join
    result = {} of Point => Char

    map.lines.each_with_index do |line, y|
      line.chars.each_with_index do |ch, x|
        case ch
        when '#', '^', '>', 'v', '<'
          result[Point.new(x, y)] = ch
        end
      end
    end

    result
  end

  private def to_input_instructions(insts)
    (insts.join(",") + "\n").chars.map { |ch| ch.ord }
  end

  private def parse(input)
    input.split(',').map { |n| n.to_i64 }
  end

  def name
    "2019 Day 17: Set and Forget"
  end

  def part1(input)
    vm = Intcode.new parse(input)
    map = build_map vm
    intersections = Set.new [] of Point

    map.each_key do |p|
      if [p.up, p.down, p.left, p.right].all? { |point| map.has_key? point }
        intersections << p
      end
    end

    intersections.map { |p| p.x * p.y }.sum
  end

  def part2(input)
    # Step 1. Build map
    vm = Intcode.new parse(input)
    map = build_map vm

    # Step 2. Determine path through map and create path array of L|R <num>
    initial_pos, initial_dir = map.reject { |p, c| c == '#' }.first
    bot = Turtle.new initial_pos.x, initial_pos.y

    case initial_dir
    when '>'
      bot.right
    when 'v'
      bot.right.right
    when '<'
      bot.left
    end

    path = [] of Tuple(Char, Int32)

    loop do
      bot_right = bot.dup.right.forward
      bot_left = bot.dup.left.forward
      dir = 'R'

      if map.has_key? Point.new(bot_right.x, bot_right.y)
        bot.right
      elsif map.has_key? Point.new(bot_left.x, bot_left.y)
        bot.left
        dir = 'L'
      else
        break
      end

      n = 0
      loop do
        bot_forward = bot.dup.forward
        if map.has_key? Point.new(bot_forward.x, bot_forward.y)
          bot.forward
          n += 1
        else
          break
        end
      end

      path << {dir, n}
    end

    # Step 3. Gather n-gram data on path
    ngrams = {} of String => Int32

    (2..8).each do |len|
      path.each_cons(len) do |seq|
        key = seq.map { |tup| tup[0] + tup[1].to_s }.join
        current = ngrams.fetch(key, 0)
        ngrams[key] = current + 1
      end
    end

    ngrams = ngrams.to_a.sort_by! { |tup| -tup[1] }.reject { |tup| tup[0].size > 10 }

    # Step 4. Look for combination of 3 of the top n-grams that can fully replace path
    path_str = path.map { |tup| tup[0] + tup[1].to_s }.join
    solution = ngrams[0..ngrams.size // 2].each_permutation(3).find do |perm|
      current = path_str

      perm.each do |ngram|
        current = current.gsub ngram[0], ""
      end

      current.empty?
    end

    return nil if solution.nil?

    # Step 5. Run program
    a, b, c = solution.map { |ngram| ngram[0] }
    main = path_str.gsub(a, "A").gsub(b, "B").gsub(c, "C").chars
    a, b, c = [a, b, c].map do |ngram|
      ngram.scan(/([LR]|\d+)/).flat_map { |m| m.captures }
    end

    insts = [main, a, b, c, ['n']].flat_map { |insts| to_input_instructions(insts) }
    prog = parse input
    prog[0] = 2.to_i64
    vm = Intcode.new prog

    insts.each do |inst|
      vm << inst.to_i64
    end

    while !vm.halted?
      vm.step
    end

    vm.outputs[-1]
  end
end
