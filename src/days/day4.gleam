import util/problems.{IntOutput}
import gleam/list
import gleam/dict.{type Dict}
import util/files
import gleam/string

type Position {
  Position(x: Int, y: Int)
}

type Letter {
  X
  M
  A
  S
}

pub fn part_one(input: String) -> problems.Output {
  let letters = parse(input)
  count_xmas_word(letters)
  |> IntOutput
}

pub fn part_two(input: String) -> problems.Output {
  let letters = parse(input)
  count_xmas_x(letters)
  |> IntOutput
}

fn count_xmas_word(letters: Dict(Position, Letter)) -> Int {
  let offsets = [
    Position(0, 1),
    Position(0, -1),
    Position(-1, 0),
    Position(1, 0),
    Position(-1, -1),
    Position(-1, 1),
    Position(1, -1),
    Position(1, 1),
  ]

  use acc, pos, _ <- dict.fold(letters, 0)
  use acc, offset <- list.fold(offsets, acc)
  acc + check_surrounding(letters, X, pos, offset)
}

fn count_xmas_x(letters: Dict(Position, Letter)) -> Int {
  let offsets = [Position(-1, -1), Position(1, 1)]
  use acc, pos, _ <- dict.fold(letters, 0)
  use acc, offset <- list.fold(offsets, acc)
  acc
  + {
    check_surrounding(letters, M, pos, offset)
    * check_surrounding(
      letters,
      M,
      Position(pos.x, pos.y + { offset.y * 2 }),
      Position(offset.x, -offset.y),
    )
  }
  + {
    check_surrounding(letters, M, pos, offset)
    * check_surrounding(
      letters,
      M,
      Position(pos.x + { offset.x * 2 }, pos.y),
      Position(-offset.x, offset.y),
    )
  }
}

fn check_surrounding(
  letters: Dict(Position, Letter),
  expected: Letter,
  pos: Position,
  offset: Position,
) -> Int {
  let next = Position(pos.x + offset.x, pos.y + offset.y)
  case dict.get(letters, pos), expected {
    Ok(X), X -> check_surrounding(letters, M, next, offset)
    Ok(M), M -> check_surrounding(letters, A, next, offset)
    Ok(A), A -> check_surrounding(letters, S, next, offset)
    Ok(S), S -> 1
    _, _ -> 0
  }
}

fn parse(input: String) -> Dict(Position, Letter) {
  let input = files.lines(input)
  use letters, line, l_index <- list.index_fold(input, dict.new())
  use letters, char, c_index <- list.index_fold(
    string.to_graphemes(line),
    letters,
  )
  case char {
    "X" -> dict.insert(letters, Position(l_index, c_index), X)
    "M" -> dict.insert(letters, Position(l_index, c_index), M)
    "A" -> dict.insert(letters, Position(l_index, c_index), A)
    "S" -> dict.insert(letters, Position(l_index, c_index), S)
    _ -> panic as "unexpected letter, should be one of X,M,A, or S"
  }
}
