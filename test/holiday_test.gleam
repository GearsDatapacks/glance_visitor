import glance
import gleeunit
import holiday

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn visit_expression_test() {
  let src =
    "
pub fn main() {
  a + a
  <<a:size(a)>>
  { a }
  a(a)
  case a {
    _ -> a
  }
  echo a
  a.a
  fn() { a }
  a(a, _, a)
  [a, ..a]
  !a
  -a
  panic as a
  A(..a, a: a)
  todo as a
  #(a, a, a)
  a.0
  a
}
"
  let assert Ok(module) = glance.module(src)

  let visitor =
    holiday.Visitor(..holiday.default, variable: fn(_, _, _, count) {
      count + 1
    })

  assert holiday.module(visitor, module, 0) == 28
}

pub fn visit_pattern_test() {
  let src =
    "
pub fn main() {
  case todo {
    a as a -> todo
    <<a, a:size(a)>> -> todo
    [a, ..a] -> todo
    #(a, a) -> todo
    A(a, a: a) -> todo
  }

  let #(a, a) = a

  let assert A(a) = a

  use #(a, a) <- a
  a
}
"
  let assert Ok(module) = glance.module(src)

  let visitor =
    holiday.Visitor(..holiday.default, pattern_variable: fn(_, _, _, count) {
      count + 1
    })

  assert holiday.module(visitor, module, 0) == 15
}

pub fn visit_type_test() {
  let src =
    "
pub fn wibble(a: fn(a, b) -> c, b: A(a, b), c: #(a, b, c)) -> a {
  let a: a = a
  let assert a: a = a
  use a: a <- a
  fn(a: a) -> a {}
}

const x: a = a

type A = a

type A {
  A(a)
  B(a: a)
}
"
  let assert Ok(module) = glance.module(src)

  let visitor =
    holiday.Visitor(..holiday.default, variable_type: fn(_, _, _, count) {
      count + 1
    })

  assert holiday.module(visitor, module, 0) == 18
}
