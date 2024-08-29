# globlin_fs

[![Package Version](https://img.shields.io/hexpm/v/globlin_fs)](https://hex.pm/packages/globlin_fs)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/globlin_fs/)

This package adds onto the functionality in the [globlin](https://hexdocs.pm/globlin) package by adding file system globbing. The main reason to keep it separate is to not require `simplifile` in the original `globlin` package so it can be used in the browser.

Note: This library only currently supports Unix file paths. That means it should work on Linux, macOS and BSD.

## Add Dependency
```sh
gleam add globlin_fs
```

## Example
```gleam
 import gleam/io
 import gleam/list
 import gleam/string
 import globlin
 import globlin_fs

 pub fn main() {
   let assert Ok(pattern) = globlin.new_pattern("**/*.gleam")
   case globlin_fs.glob(pattern) {
     Ok(files) -> {
       files
       |> list.sort(string.compare)
       |> list.each(io.println)
     }
     Error(err) -> {
       io.print("File error: ")
       io.debug(err)
       Nil
     }
   }
 }
 ```

Further documentation can be found at <https://hexdocs.pm/globlin_fs>.

## Development

```sh
gleam test  # Run the tests
```
