import util/problems
import days/day1
import days/day2
import days/day3
import days/day4
import days/day5
import days/day6
import gleam/int
import gleeunit
import gleeunit/should
import util/files

pub fn main() {
  gleeunit.main()
}

const resource_path = "./resources/test_inputs/"

pub fn get_file_content_test() {
  files.get_file_content(resource_path <> "test.txt")
  |> should.equal("foo\n")
}

pub fn day1_part_one_test() {
  day1.part_one(files.get_file_content(build_test_path_for_day(1)))
  |> should.equal(problems.IntOutput(11))
}

pub fn day1_part_two_test() {
  day1.part_two(files.get_file_content(build_test_path_for_day(1)))
  |> should.equal(problems.IntOutput(31))
}

pub fn day2_part_one_test() {
  day2.part_one(files.get_file_content(build_test_path_for_day(2)))
  |> should.equal(problems.IntOutput(2))
}

pub fn day2_part_two_test() {
  day2.part_two(files.get_file_content(build_test_path_for_day(2)))
  |> should.equal(problems.IntOutput(4))
}

pub fn day3_part_one_test() {
  day3.part_one(files.get_file_content(build_test_path_for_day(3)))
  |> should.equal(problems.IntOutput(161))
}

pub fn day3_part_two_test() {
  day3.part_two(files.get_file_content(build_test_path_for_day(3)))
  |> should.equal(problems.IntOutput(33))
}

pub fn day4_part_one_test() {
  day4.part_one(files.get_file_content(build_test_path_for_day(4)))
  |> should.equal(problems.IntOutput(18))
}

pub fn day4_part_two_test() {
  day4.part_two(files.get_file_content(build_test_path_for_day(4)))
  |> should.equal(problems.IntOutput(9))
}

pub fn day5_part_one_test() {
  day5.part_one(files.get_file_content(build_test_path_for_day(5)))
  |> should.equal(problems.IntOutput(143))
}

pub fn day5_part_two_test() {
  day5.part_two(files.get_file_content(build_test_path_for_day(5)))
  |> should.equal(problems.IntOutput(123))
}

pub fn day6_part_one_test() {
  day6.part_one(files.get_file_content(build_test_path_for_day(6)))
  |> should.equal(problems.IntOutput(41))
}

pub fn day6_part_two_test() {
  day6.part_two(files.get_file_content(build_test_path_for_day(6)))
  |> should.equal(problems.IntOutput(6))
}

fn build_test_path_for_day(day: Int) -> String {
  resource_path <> "day" <> int.to_string(day) <> ".txt"
}
