import gleam/int
import util/problems.{IntOutput, StringOutput}
import days/day_one
import gleam/io
import util/files

pub fn main() {
  io.println(solve(1, 1, day_one.part_one))
  io.println(solve(1, 2, day_one.part_two))
}


fn solve(day: Int, part: Int, solution: fn(String) -> problems.Output) -> String {
  let answer = case solution(files.get_input_for_day(day)) {
    IntOutput(v) -> int.to_string(v)
    StringOutput(v) -> v
    _ -> "Unsolved!"
  }
  "Day " <> int.to_string(day) <> " part " <> int.to_string(part) <> ": " <> answer
}
