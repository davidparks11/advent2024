import gleam/option.{None, Some}
import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import util/files
import util/problems

type HistorianList =
  #(List(Int), List(Int))

pub fn part_one(input: String) -> problems.Output {
  let #(left, right) = parse_input(input)
  let left = list.sort(left, int.compare)
  let right = list.sort(right, int.compare)
  let pairs = list.zip(left, right)
  let sum = {
    use acc, #(left, right) <- list.fold(over: pairs, from: 0)
    acc + int.absolute_value(left - right)
  }
  problems.IntOutput(sum)
}

pub fn part_two(input: String) -> problems.Output {
  let #(left, right) = parse_input(input)
  let occurence_map = {
    use map, value <- list.fold(right, dict.new())
    dict.upsert(map, value, fn(v) {
      case v {
        Some(i) -> i + 1
        None -> 1
      }
    })
  }
  let similarity_score = {
    use acc, value <- list.fold(left, 0)
    let occurrences = dict.get(occurence_map, value)
    acc + value * result.unwrap(occurrences, 0)
  }
  problems.IntOutput(similarity_score)
}

fn parse_input(input: String) -> HistorianList {
  let lines = files.lines(input)
  use #(left, right), line <- list.fold(over: lines, from: #([], []))

  let assert [a, b] = string.split(line, on: "   ")
  let assert Ok(a) = int.parse(a)
  let assert Ok(b) = int.parse(b)
  #([a, ..left], [b, ..right])
}
