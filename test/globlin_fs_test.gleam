import gleam/list
import gleam/string
import gleeunit
import gleeunit/should
import globlin
import globlin_fs

pub fn main() {
  gleeunit.main()
}

pub fn glob_files_test() {
  globlin.new_pattern("**/test/*.gleam")
  |> should.be_ok
  |> globlin_fs.glob(returning: globlin_fs.RegularFiles)
  |> should.be_ok
  |> list.first
  |> should.be_ok
  |> string.ends_with("/test/globlin_fs_test.gleam")
  |> should.be_true
}

pub fn glob_directories_test() {
  globlin.new_pattern("**/.github/work*/**")
  |> should.be_ok
  |> globlin_fs.glob(returning: globlin_fs.Directories)
  |> should.be_ok
  |> list.first
  |> should.be_ok
  |> string.ends_with("/.github/workflows")
  |> should.be_true
}
