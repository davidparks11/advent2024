import days/day_one
import gleam/int
import gleeunit
import gleeunit/should
import util/files
import util/problems

pub fn main() {
  gleeunit.main()
}

const resource_path = "./resources/test_inputs/"

pub fn get_file_content_test() {
  files.get_file_content(resource_path <> "test.txt")
  |> should.equal("foo\n")
}

pub fn day_one_part_one_test() {
  day_one.part_one(files.get_file_content(build_test_path_for_day(1)))
  |> should.equal(problems.IntOutput(11))
}

pub fn day_one_part_two_test() {
  day_one.part_two(files.get_file_content(build_test_path_for_day(1)))
  |> should.equal(problems.IntOutput(31))
}

fn build_test_path_for_day(day: Int) -> String {
  resource_path <> "day" <> int.to_string(day) <> ".txt"
}
