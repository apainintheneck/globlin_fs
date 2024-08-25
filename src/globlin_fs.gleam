import filepath
import gleam/list
import globlin
import simplifile

/// An alias for `simplifile.FileError` needed for the glob methods below.
pub type FileError =
  simplifile.FileError

/// Used to determine which files should be returned by the glob function.
pub type FileType {
  /// Regular files that are not directories or symlinks.
  RegularFiles
  /// Directories that are not symlinks.
  Directories
  /// Both regular files and directories that are not symlinks.
  AllFiles
}

/// Use the specified glob pattern to return a list of the expected file type
/// starting from the current working directory.
/// 
/// Note: No order is guaranteed for the resulting path list.
pub fn glob(
  pattern pattern: globlin.Pattern,
  returning file_type: FileType,
) -> Result(List(String), FileError) {
  case simplifile.current_directory() {
    Ok(directory) -> glob_from(pattern:, directory:, returning: file_type)
    Error(err) -> Error(err)
  }
}

/// Use the specified glob pattern to return a list of the expected file type
/// starting from the provided directory.
/// 
/// Note: No order is guaranteed for the resulting path list.
pub fn glob_from(
  pattern pattern: globlin.Pattern,
  directory directory: String,
  returning file_type: FileType,
) -> Result(List(String), FileError) {
  let file_getter = case file_type {
    RegularFiles -> collect_files(_, [], is_file)
    Directories -> collect_files(_, [], is_directory)
    AllFiles -> collect_files(_, [], is_file_or_directory)
  }
  let keeping = globlin.match_pattern(pattern:, path: _)

  case file_getter(directory) {
    Ok(files) -> Ok(list.filter(files, keeping:))
    Error(err) -> Error(err)
  }
}

// Recursively collect files of the expected types based on the keeping function provided.
fn collect_files(
  directory: String,
  files: List(String),
  keeping: IsFileType,
) -> Result(List(String), FileError) {
  case simplifile.read_directory(directory) {
    Ok(contents) -> {
      list.try_fold(over: contents, from: files, with: fn(acc, content) {
        let path = filepath.join(directory, content)

        case keeping(path) {
          Ok(keep_path) -> {
            let acc = case keep_path {
              True -> [path, ..acc]
              False -> acc
            }

            case is_directory(path) {
              Ok(True) -> collect_files(path, acc, keeping)
              Ok(False) -> Ok(acc)
              Error(err) -> Error(err)
            }
          }
          Error(err) -> Error(err)
        }
      })
    }
    Error(err) -> Error(err)
  }
}

//--- File Type Checkers ---

type IsFileType =
  fn(String) -> Result(Bool, FileError)

fn is_file(path: String) -> Result(Bool, FileError) {
  case simplifile.is_symlink(path) {
    Ok(True) -> Ok(False)
    Ok(False) -> {
      case simplifile.is_directory(path) {
        Ok(True) -> Ok(False)
        Ok(False) -> simplifile.is_file(path)
        Error(err) -> Error(err)
      }
    }
    Error(err) -> Error(err)
  }
}

fn is_directory(path: String) -> Result(Bool, FileError) {
  case simplifile.is_symlink(path) {
    Ok(True) -> Ok(False)
    Ok(False) -> simplifile.is_directory(path)
    Error(err) -> Error(err)
  }
}

fn is_file_or_directory(path: String) -> Result(Bool, FileError) {
  case simplifile.is_symlink(path) {
    Ok(True) -> Ok(False)
    Ok(False) -> simplifile.is_file(path)
    Error(err) -> Error(err)
  }
}
