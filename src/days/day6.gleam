import util/problems.{type Output, IntOutput}
import util/files
import util/dict_helper
import gleam/dict.{type Dict}
import gleam/list
import gleam/string
import gleam/set.{type Set}
import gleam/option.{None, Some}
import gleam/int
import gleam/result
import gleam/io

type Point =
  #(Int, Int)

type Direction =
  #(Int, Int)

type GuardPatrol {
  GuardPatrol(grid: Dict(Point, String), guard_pos: Point, starting_pos: Point)
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
    Ok(".") ->
      count_unique_positions(
        GuardPatrol(patrol.grid, next, patrol.starting_pos),
        dir,
        seen,
      )
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
    Error(_) ->
      set.delete(obstacles, patrol.starting_pos)
      |> set.size

    Ok(".") -> {
      let obstacles = case
        dict.has_key(seen, next),
        next == patrol.starting_pos
      {
        False, False ->
          case
            patrol.grid
            |> dict.insert(next, "#")
            |> GuardPatrol(current, patrol.starting_pos)
            |> find_loops(dir, seen)
          {
            True -> set.insert(obstacles, next)
            False -> obstacles
          }
        _, _ -> obstacles
      }

      dict_helper.upsert_list(seen, current, dir)
      |> place_obstacles(
        GuardPatrol(patrol.grid, next, patrol.starting_pos),
        dir,
        _,
        obstacles,
      )
    }
    Ok("#") ->
      dict_helper.upsert_list(seen, current, dir)
      |> place_obstacles(patrol, turn_90(dir), _, obstacles)
    Ok(_) -> panic as "bad patrol character"
  }
}

fn find_loops(
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

  let seen = dict_helper.upsert_list(seen, current, dir)

  case dict.get(patrol.grid, next), has_looped {
    Error(_), _ -> False
    Ok(_), True -> {
      print_patrol(patrol, seen)
      True
    }
    Ok("#"), _ -> find_loops(patrol, turn_90(dir), seen)
    Ok("."), _ ->
      patrol.grid
      |> GuardPatrol(next, patrol.starting_pos)
      |> find_loops(dir, seen)
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
    GuardPatrol(dict.new(), #(0, 0), #(0, 0)),
  )
  use patrol, char, col <- list.index_fold(string.to_graphemes(line), patrol)
  case char {
    "^" ->
      GuardPatrol(dict.insert(patrol.grid, #(col, row), "."), #(col, row), #(
        col,
        row,
      ))
    any ->
      GuardPatrol(
        dict.insert(patrol.grid, #(col, row), any),
        patrol.guard_pos,
        patrol.guard_pos,
      )
  }
}

fn print_patrol(patrol: GuardPatrol, seen: Dict(Point, List(Direction))) {
  let r = list.range(0, 129)
  list.each(r, fn(y) {
    list.each(r, fn(x) {
      case dict.get(patrol.grid, #(x, y)), dict.get(seen, #(x, y)), x, y {
        _, _, 42, 47 -> io.print("^")
        _, Ok(dirs), _, _ -> {
          case
            list.contains(dirs, #(-1, 0))
            || list.contains(dirs, #(1, 0)),
            list.contains(dirs, #(0, -1))
            || list.contains(dirs, #(0, 1))
          {
            True, False -> io.print("-")
            False, True -> io.print("|")
            True, True -> io.print("+")
            _, _ -> panic as "AHHHHHHHHHHHHH"
          }
        }
        Ok("."), _, _, _ -> io.print(" ")
        Ok(c), _, _, _ -> io.print(c)
        _, _, _, _ -> panic as "nope"
      }
    })
    io.println("")
  })
  io.println("\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
}
