import gleam/list
import gleam/string
import gleeunit
import gleeunit/should
import globlin
import globlin_fs

pub fn main() {
  gleeunit.main()
}

pub fn glob_test() {
  globlin.new_pattern("**/test/*.gleam")
  |> should.be_ok
  |> globlin_fs.glob
  |> should.be_ok
  |> list.first
  |> should.be_ok
  |> string.ends_with("/test/globlin_fs_test.gleam")
  |> should.be_true
}
