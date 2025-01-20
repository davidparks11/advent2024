import util/problems.{type Output, IntOutput}
import util/files
import util/dict_helper
import gleam/dict.{type Dict}
import gleam/list
import gleam/string
import gleam/set.{type Set}
import gleam/result
import gleam/bool

type Point =
  #(Int, Int)

type Direction =
  #(Int, Int)

type GuardPatrol {
  GuardPatrol(grid: Dict(Point, String), guard_pos: Point)
}

const up: Direction = #(0, -1)

pub fn part_one(input: String) -> Output {
  let patrol = parse(input)
  count_unique_positions(patrol, up, set.new())
  |> IntOutput
}

pub fn part_two(input: String) -> Output {
  parse(input)
  |> place_obstacles(up, dict.new(), set.new())
  |> IntOutput
}

fn count_unique_positions(
  patrol: GuardPatrol,
  dir: Direction,
  seen: Set(Point),
) -> Int {
  let current = patrol.guard_pos
  let seen = set.insert(seen, current)
  let next = #(current.0 + dir.0, current.1 + dir.1)
  case dict.get(patrol.grid, next) {
    Error(_) -> set.size(seen)
    Ok(".") -> count_unique_positions(GuardPatrol(patrol.grid, next), dir, seen)
    Ok("#") -> count_unique_positions(patrol, turn_90(dir), seen)
    Ok(_) -> panic as "bad patrol character"
  }
}

fn place_obstacles(
  patrol: GuardPatrol,
  dir: Direction,
  seen: Dict(Point, List(Direction)),
  obstacles: Set(Point),
) -> Int {
  let current = patrol.guard_pos
  let next = #(current.0 + dir.0, current.1 + dir.1)

  case dict.get(patrol.grid, next) {
    Error(_) -> set.size(obstacles)
    Ok(".") -> {
      let obstacles = {
        use <- bool.guard(dict.has_key(seen, next), obstacles)
        let is_loop =
          patrol.grid
          |> dict.insert(next, "#")
          |> GuardPatrol(current)
          |> is_loop(dir, seen)
          |> bool.negate
        use <- bool.guard(is_loop, obstacles)
        set.insert(obstacles, next)
      }
      dict_helper.upsert_list(seen, current, dir)
      |> place_obstacles(GuardPatrol(patrol.grid, next), dir, _, obstacles)
    }
    Ok("#") ->
      dict_helper.upsert_list(seen, current, dir)
      |> place_obstacles(patrol, turn_90(dir), _, obstacles)
    Ok(_) -> panic as "bad patrol character"
  }
}

fn is_loop(
  patrol: GuardPatrol,
  dir: Direction,
  seen: Dict(Point, List(Direction)),
) -> Bool {
  let current = patrol.guard_pos
  let next = #(current.0 + dir.0, current.1 + dir.1)
  let has_looped =
    dict.get(seen, current)
    |> result.unwrap([])
    |> list.contains(dir)

  case dict.get(patrol.grid, next), has_looped {
    Error(_), _ -> False
    Ok(_), True -> True
    Ok("#"), _ -> is_loop(patrol, turn_90(dir), seen)
    Ok("."), _ ->
      patrol.grid
      |> GuardPatrol(next)
      |> is_loop(dir, dict_helper.upsert_list(seen, current, dir))
    Ok(_), _ -> panic as "bad patrol character checking loop"
  }
}

fn turn_90(dir: Direction) -> Direction {
  case dir {
    #(0, -1) -> #(1, 0)
    #(1, 0) -> #(0, 1)
    #(0, 1) -> #(-1, 0)
    #(-1, 0) -> #(0, -1)
    _ -> panic as "bad direction"
  }
}

fn parse(input: String) -> GuardPatrol {
  use patrol, line, row <- list.index_fold(
    files.lines(input),
    GuardPatrol(dict.new(), #(0, 0)),
  )
  use patrol, char, col <- list.index_fold(string.to_graphemes(line), patrol)
  case char {
    "^" -> GuardPatrol(dict.insert(patrol.grid, #(col, row), "."), #(col, row))
    any ->
      GuardPatrol(dict.insert(patrol.grid, #(col, row), any), patrol.guard_pos)
  }
}
