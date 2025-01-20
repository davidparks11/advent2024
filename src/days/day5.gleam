import gleam/dict.{type Dict}
import gleam/int
import gleam/list.{Continue, Stop}
import gleam/option.{None, Some}
import gleam/order
import gleam/result
import gleam/set.{type Set}
import gleam/string
import util/files
import util/func
import util/problems

type Rules =
  Dict(Int, List(Int))

type Pages =
  List(List(Int))

pub fn part_one(input: String) -> problems.Output {
  let #(rules, pages) = parse_input(input)
  list.filter(pages, is_in_order(rules))
  |> count_middle_pages
  |> problems.IntOutput
}

pub fn part_two(input: String) -> problems.Output {
  let #(rules, pages) = parse_input(input)
  list.filter(pages, func.negate(is_in_order(rules)))
  |> list.map(sort_pages(rules))
  |> count_middle_pages
  |> problems.IntOutput
}

fn is_in_order(rules: Rules) -> fn(List(Int)) -> Bool {
  fn(page_updates: List(Int)) -> Bool {
    is_valid_update(page_updates, rules, set.new())
  }
}

fn is_valid_update(
  page_updates: List(Int),
  rules: Rules,
  seen: Set(Int),
) -> Bool {
  case page_updates {
    [] -> True
    [first, ..rest] -> {
      let rule =
        dict.get(rules, first)
        |> result.unwrap([])
      case contains_any(seen, rule) {
        True -> False
        False -> is_valid_update(rest, rules, set.insert(seen, first))
      }
    }
  }
}

fn contains_any(s: Set(Int), l: List(Int)) {
  use _, v <- list.fold_until(l, False)
  case set.contains(s, v) {
    True -> Stop(True)
    False -> Continue(False)
  }
}

fn count_middle_pages(pages: Pages) -> Int {
  use acc, page_updates <- list.fold(pages, 0)
  acc
  + {
    list.drop(page_updates, list.length(page_updates) / 2)
    |> list.first
    |> result.unwrap(0)
  }
}

fn sort_pages(rules: Rules) -> fn(List(Int)) -> List(Int) {
  fn(page_updates: List(Int)) -> List(Int) {
    list.sort(page_updates, fn(a, b) { compare_pages(rules, a, b) })
  }
}

fn compare_pages(rules: Rules, page_1: Int, page_2: Int) -> order.Order {
  let page_1_afters =
    dict.get(rules, page_1)
    |> result.unwrap([])
  let page_2_afters =
    dict.get(rules, page_2)
    |> result.unwrap([])

  case
    list.contains(page_1_afters, page_2),
    list.contains(page_2_afters, page_1)
  {
    False, True -> order.Gt
    True, False -> order.Lt
    False, False -> order.Eq
    _, _ -> panic as "Circular page reference rule found"
  }
}

fn parse_input(input: String) -> #(Rules, Pages) {
  let assert #(ordering_rules, pages) =
    string.split(input, "\n")
    |> list.split_while(fn(a) { a != "" })
  let pages =
    list.rest(pages)
    |> result.unwrap([])
    |> files.remove_empty
  // remove empty line
  #(parse_rules(ordering_rules), parse_pages(pages))
}

fn parse_rules(input: List(String)) -> Rules {
  use rules, line <- list.fold(input, dict.new())
  let assert [before, after] = string.split(line, "|")
  let assert Ok(before) = int.parse(before)
  let assert Ok(after) = int.parse(after)
  dict.upsert(rules, before, fn(entry) {
    case entry {
      Some(pages) -> [after, ..pages]
      None -> [after]
    }
  })
}

fn parse_pages(input: List(String)) -> Pages {
  use line <- list.map(input)
  use entry <- list.map(string.split(line, ","))
  let assert Ok(int_value) = int.parse(entry)
  int_value
}
