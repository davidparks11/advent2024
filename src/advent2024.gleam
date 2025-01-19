import days/day1
import days/day2
import days/day3
import days/day4
import days/day5
import days/day6
import gleam/int
import gleam/io
import util/files
import util/problems.{type Output, IntOutput, StringOutput}

pub fn main() {
  solve_days([
    day1.part_one,
    day1.part_two,
    day2.part_one,
    day2.part_two,
    day3.part_one,
    day3.part_two,
    day4.part_one,
    day4.part_two,
    day5.part_one,
    day5.part_two,
    day6.part_one,
    day6.part_two,
  ])
}

fn solve_days(solutions: List(fn(String) -> Output)) {
  solve_days_loop(solutions, 1, 1)
}

fn solve_days_loop(solutions: List(fn(String) -> Output), day, part) {
  case solutions, day, part {
    [solution, ..rest], day, part -> {
      io.println(solve(day, part, solution))
      solve_days_loop(rest, produce_day(day, part), produce_part(part))
    }
    _, _, _ -> Nil
  }
}

fn solve(day: Int, part: Int, solution: fn(String) -> problems.Output) -> String {
  let answer = case solution(files.get_input_for_day(day)) {
    IntOutput(v) -> int.to_string(v)
    StringOutput(v) -> v
    _ -> "Unsolved!"
  }
  "Day "
  <> int.to_string(day)
  <> " part "
  <> int.to_string(part)
  <> ": "
  <> answer
}

fn produce_day(prev_day: Int, part: Int) -> Int {
  case prev_day, part {
    day, 1 -> day
    day, _ -> day + 1
  }
}

fn produce_part(prev: Int) -> Int {
  case prev {
    1 -> 2
    _ -> 1
  }
}
