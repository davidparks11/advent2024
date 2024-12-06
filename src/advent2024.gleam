import days/day1
import gleam/int
import days/day2
import gleam/io
import util/files
import util/problems.{IntOutput, StringOutput}

pub fn main() {
  io.println(solve(1, 1, day1.part_one))
  io.println(solve(1, 2, day1.part_two))
  io.println(solve(2, 1, day2.part_one))
  io.println(solve(2, 2, day2.part_two))
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
