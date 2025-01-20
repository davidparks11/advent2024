import gleam/int
import gleam/list
import gleam/option.{Some}
import gleam/regexp
import util/files
import util/problems.{IntOutput}

pub fn part_one(input: String) -> problems.Output {
  let assert Ok(re) = regexp.from_string("mul\\((\\d+),(\\d+)\\)")
  files.lines(input)
  |> list.map(fn(line) { regexp.scan(re, line) })
  |> list.flatten
  |> list.map(fn(matches) { matches.submatches })
  |> list.map(fn(pair) {
    case pair {
      [Some(a), Some(b)] -> {
        let assert Ok(a) = int.parse(a)
        let assert Ok(b) = int.parse(b)
        a * b
      }
      _ -> panic as "all matches should contain two numbers"
    }
  })
  |> int.sum
  |> IntOutput
}

pub fn part_two(input: String) -> problems.Output {
  let assert Ok(re) =
    regexp.from_string("(do\\(\\))|(don't\\(\\))|mul\\((\\d+),(\\d+)\\)")
  files.lines(input)
  |> list.map(fn(line) { regexp.scan(re, line) })
  |> list.flatten
  |> list.map(fn(matches) { matches.submatches })
  |> list.flatten
  |> option.values
  |> execute_memory(True, 0)
  |> problems.IntOutput
}

fn execute_memory(memory: List(String), enabled: Bool, acc: Int) -> Int {
  case memory, enabled, acc {
    ["do()", ..rest], _, acc -> execute_memory(rest, True, acc)
    ["don't()", ..rest], _, acc -> execute_memory(rest, False, acc)
    [_, _, ..rest], False, acc -> execute_memory(rest, False, acc)
    [a, b, ..rest], True, acc ->
      execute_memory(rest, True, acc + parse_and_multiply(a, b))
    _, _, _ -> acc
  }
}

fn parse_and_multiply(a: String, b: String) -> Int {
  let assert Ok(a) = int.parse(a)
  let assert Ok(b) = int.parse(b)
  a * b
}
