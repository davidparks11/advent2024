import gleam/io
import util/files

const input_files_path = "./resources/inputs/"

pub fn main() {
  io.print(files.get_file_content(input_files_path <> "day1.txt"))
}
