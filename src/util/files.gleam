import simplifile

pub type Output {
  StringOutput(value: String)
  IntOutput(value: Int)
}

pub fn get_file_content(path: String) -> String {
  case simplifile.read(from: path) {
    Ok(content) -> content
    Error(err) -> {
      let error_message = "Could not open path " <> path <> ": " <> simplifile.describe_error(err)
      panic as error_message
    }
  }
}
