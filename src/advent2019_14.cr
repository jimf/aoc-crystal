module Advent2019_14
  extend self

  # private def parse(input)
  #   input.lines.map do |line|
  #     left, right = line.split " => "
  #     left_parts = left.split ", "
  #     inputs_list = left_parts.map do |part|
  #       amount, unit = part.split ' '
  #       {amount: amount.to_i, unit: unit}
  #     end
  #     right_amount, right_unit = right.split ' '
  #     output = {amount: right_amount.to_i, unit: right_unit}
  #     {inputs: inputs_list, output: output}
  #   end
  # end

  private def parse(input)
    # result = {} of String => String

    # input.lines.map do |line|
    #   inputs, output = line.split " => "
    #   output_amount, output_unit = output.split ' '
    #   result[output] = inputs
    # end

    # result

    result = {} of String => NamedTuple(amount: Int32, inputs: Array(NamedTuple(amount: Int32, unit: String)))

    input.lines.each do |line|
      left, right = line.split " => "
      left_parts = left.split ", "
      inputs_list = left_parts.map do |part|
        amount, unit = part.split ' '
        {amount: amount.to_i, unit: unit}
      end
      right_amount, right_unit = right.split ' '
      output = {amount: right_amount.to_i, unit: right_unit}
      result[right_unit] = {amount: right_amount.to_i, inputs: inputs_list}
    end

    result

    # input.lines.map do |line|
    #   left, right = line.split " => "
    #   left_parts = left.split ", "
    #   inputs_list = left_parts.map do |part|
    #     amount, unit = part.split ' '
    #     {amount: amount.to_i, unit: unit}
    #   end
    #   right_amount, right_unit = right.split ' '
    #   output = {amount: right_amount.to_i, unit: right_unit}
    #   {inputs: inputs_list, output: output}
    # end
  end

  private def shrink(items)
    items_hash = {} of String => Int32

    items.each do |item|
      current = items_hash.fetch(item[:unit], 0)
      items_hash[item[:unit]] = current + item[:amount]
    end

    items_hash.to_a.map do |unit, amount|
      {amount: amount, unit: unit}
    end
  end

  private def substitutions(rules, items)
    result = [] of Array(NamedTuple(amount: Int32, unit: String))
    subs = items.select { |item| item[:unit] != "ORE" && rules[item[:unit]][:amount] <= item[:amount] }

    subs.each do |sub_item|
      sub = [] of NamedTuple(amount: Int32, unit: String)

      items.each do |item|
        if item == sub_item
          target = rules[item[:unit]]
          number, remainder = item[:amount].divmod(target[:amount])

          number.times do
            target[:inputs].each do |inp|
              sub << inp
            end
          end

          if remainder > 0
            sub << {amount: remainder, unit: item[:unit]}
          end
        else
          sub << item
        end
      end

      result << shrink(sub)
    end

    result
  end

  # private def substitute(rules, items)
  #   result = [] of NamedTuple(amount: Int32, unit: String)
  #   done = false

  #   items.each do |item|
  #     if !done && item[:unit] != "ORE" && rules[item[:unit]][:amount] <= item[:amount]
  #       target = rules[item[:unit]]
  #       number, remainder = item[:amount].divmod(target[:amount])

  #       number.times do
  #         target[:inputs].each do |inp|
  #           result << inp
  #         end
  #       end

  #       if remainder > 0
  #         result << {amount: remainder, unit: item[:unit]}
  #       end

  #       done = true
  #       next
  #     end

  #     result << item
  #   end

  #   # puts "#{items} -> #{shrink(result)}"
  #   shrink result
  # end

  # The first two reactions use only ORE as inputs; they indicate that you can
  # produce as much of chemical A as you want (in increments of 10 units, each
  # 10 costing 10 ORE) and as much of chemical B as you want (each costing 1
  # ORE). To produce 1 FUEL, a total of 31 ORE is required: 1 ORE to produce 1
  # B, then 30 more ORE to produce the 7 + 7 + 7 + 7 = 28 A (with 2 extra A
  # wasted) required in the reactions to convert the B into C, C into D, D into
  # E, and finally E into FUEL. (30 A is produced because its reaction requires
  # that it is created in increments of 10.)

  private def to_ore(rules, items, min_ore = Int32::MAX)
    # We have reduced down to only ore. Return the minimum amount seen.
    if items.size == 1 && items[0][:unit] == "ORE"
      return [items[0][:amount], min_ore].min
    end

    # Determine all the ways in which current list of items can be substituted.
    subs = substitutions(rules, items)

    if subs.empty?
      # No more substitutions can be made. Now we need to try adding more ingredients.
      ore_products = rules.select { |output_unit, val| val[:inputs][0][:unit] == "ORE" }
      items_with_added = ore_products.to_a.map do |output_unit, val|
        current = items.find { |item| item[:unit] == output_unit }

        if current.nil?
          items.concat([{amount: val[:amount], unit: output_unit}])
        else
          shrink items.concat([{amount: val[:amount] - current[:amount], unit: output_unit}])
        end
      end

      items_with_added.map { |added| to_ore(rules, added, min_ore) }.min
    else
      # Recurse, finding the minium amount of ore needed for each substitution.
      subs.map { |sub| to_ore(rules, sub, min_ore) }.min
    end
  end

  def name
    "2019 Day 14: Space Stoichiometry"
  end

  def part1(input)
    rules = parse(input)
    # ore_producers, rules = parse(input).partition do |rule|
    #   rule[:inputs].size == 1 && rule[:inputs][0][:unit] == "ORE"
    # end
    items = [{amount: 1, unit: "FUEL"}]
    # puts ore_producers
    to_ore rules, items
    # puts substitutions(rules, items)
    # puts substitute(rules, items)
    # 50.times do
    #   items = substitute(rules, items)
    # end
    # ore = to_ore parse(input), [{amount: 1, unit: "FUEL"}]
    # ore[0][:amount]
  end

  def part2(input)
    nil
  end
end
