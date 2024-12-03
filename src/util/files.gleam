import gleam/int
import gleam/string
import simplifile

const input_files_path = "./resources/inputs/"

pub fn get_file_content(path: String) -> String {
  case simplifile.read(from: path) {
    Ok(content) -> content
    Error(err) -> {
      let error_message =
        "Could not open path " <> path <> ": " <> simplifile.describe_error(err)
      panic as error_message
    }
  }
}

pub fn get_input_for_day(day: Int) -> String {
  case day {
    d if d > 0 && d < 25 ->
      get_file_content(
        input_files_path <> "day" <> int.to_string(day) <> ".txt",
      )
    _ -> panic as "Day must be in range 1-25"
  }
}

pub fn lines(input: String) -> List(String) {
  string.split(input, "\n")
}
