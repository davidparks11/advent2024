import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{None, Some}

pub fn upsert_list(
  d: Dict(key, List(value)),
  key: key,
  value: value,
) -> Dict(key, List(value)) {
  dict.upsert(d, key, fn(entry) {
    case entry {
      Some(entry) -> [value, ..entry]
      None -> [value]
    }
  })
}
