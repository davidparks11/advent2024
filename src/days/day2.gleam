import gleam/int
import gleam/bool
import gleam/result
import gleam/list
import gleam/string
import util/files
import util/problems

type ReportList =
  List(List(Int))

pub fn part_one(input: String) -> problems.Output {
  let reports = parse_input(input)
  problems.IntOutput(list.count(reports, is_safe))
}

pub fn part_two(input: String) -> problems.Output {
  let reports = parse_input(input)
  problems.IntOutput(list.count(reports, is_safe_lenient))
}

fn is_safe(report: List(Int)) -> Bool {
  let pairs =
    list.window_by_2(report)
    |> list.map(fn(pair) { pair.0 - pair.1 })
  list.all(pairs, fn(abs) { abs > 0 && abs <= 3 })
  || list.all(pairs, fn(abs) { abs < 0 && abs >= -3 })
}

fn is_safe_lenient(report: List(Int)) -> Bool {
  use <- bool.guard(is_safe(report), True)
  list.combinations(report, list.length(report) - 1)
  |> list.find(is_safe)
  |> result.is_ok
}

fn parse_input(input: String) -> ReportList {
  use line <- list.map(files.lines(input))
  let levels =
    string.split(line, " ")
    |> list.filter(fn(line) { !string.is_empty(line) })
  use level <- list.map(levels)
  case int.parse(level) {
    Ok(num) -> num
    _ -> panic as "Could not read report value"
  }
}
