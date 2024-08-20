import gleam/list
import globlin
import simplifile

/// An alias for `simplifile.FileError` needed for the glob methods below.
pub type FileError =
  simplifile.FileError

/// Glob files from the current working directory.
pub fn glob(pattern: globlin.Pattern) -> Result(List(String), FileError) {
  case simplifile.current_directory() {
    Ok(directory) -> glob_from(pattern:, directory:)
    Error(err) -> Error(err)
  }
}

/// Glob files from a chosen directory.
pub fn glob_from(
  pattern pattern: globlin.Pattern,
  directory directory: String,
) -> Result(List(String), FileError) {
  case simplifile.get_files(in: directory) {
    Ok(files) ->
      Ok(list.filter(files, keeping: globlin.match_pattern(pattern:, path: _)))
    Error(err) -> Error(err)
  }
}
