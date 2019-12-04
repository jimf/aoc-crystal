# Advent of Code (Crystal)

My [Advent of Code](https://adventofcode.com) solutions in [Crystal](https://crystal-lang.org/).

## Prerequisites

A working Crystal environment. See the Crystal [install instructions](https://crystal-lang.org/install/)
for your system.

## Usage

All solutions are driven by [main.cr](main.cr) and take input from stdin:

    crystal build main.cr
    echo <YOUR INPUT> | ./main [YYYY-DD]

Specify YYYY-DD to run the solution for a particular day. If this arg is omitted
or invalid, the most recent solution will be run by default.

My inputs can be found in the [inputs/](inputs) directory.

## Running tests

    crystal spec

## License

MIT
