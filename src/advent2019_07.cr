require "./intcode.cr"

module Advent2019_07
  extend self

  private def parse(input)
    input.split(',').map { |n| n.to_i64 }
  end

  private def run(memory, input_values)
    vm = Intcode.new(memory, input_values)
    while !vm.halted?
      vm.step
    end

    vm.outputs[-1]
  end

  def name
    "2019 Day 7: Amplification Circuit"
  end

  def part1(input)
    max_thrust = 0

    (0..4).to_a.each_permutation(5) do |perm|
      input_value = 0.to_i64
      perm.each do |phase_setting|
        input_value = run(parse(input), [phase_setting.to_i64, input_value])
      end
      max_thrust = [max_thrust, input_value].max
    end

    max_thrust
  end

  def part2(input)
    max_thrust = 0

    (5..9).to_a.each_permutation(5) do |perm|
      amp_inputs = perm.map { |p| [p.to_i64] }
      amp_inputs[0] << 0.to_i64
      amps = amp_inputs.map { |inputs| Intcode.new parse(input), inputs }
      active = 0

      while !amps[4].halted?
        vm = amps[active % 5]
        prev_output_size = vm.outputs.size

        while !vm.halted?
          begin
            vm.step
          rescue IntcodeMissingInputError
            break
          end

          if vm.outputs.size > prev_output_size
            amp_inputs[(active + 1) % 5] << vm.outputs[-1]
            prev_output_size += 1
          end
        end

        active += 1
      end

      max_thrust = [max_thrust, amps[4].outputs[-1]].max
    end

    max_thrust
  end
end
