import glance
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/order

pub type Visitor(a) {
  Visitor(
    function: fn(Visitor(a), glance.Definition(glance.Function), a) -> a,
    constant: fn(Visitor(a), glance.Definition(glance.Constant), a) -> a,
    statement: fn(Visitor(a), glance.Statement, a) -> a,
    expression: fn(Visitor(a), glance.Expression, a) -> a,
    assert_: fn(
      Visitor(a),
      glance.Span,
      glance.Expression,
      Option(glance.Expression),
      a,
    ) ->
      a,
    use_: fn(
      Visitor(a),
      glance.Span,
      List(glance.UsePattern),
      glance.Expression,
      a,
    ) ->
      a,
    assignment: fn(
      Visitor(a),
      glance.Span,
      glance.AssignmentKind,
      glance.Pattern,
      Option(glance.Type),
      glance.Expression,
      a,
    ) ->
      a,
    binary_operator: fn(
      Visitor(a),
      glance.Span,
      glance.BinaryOperator,
      glance.Expression,
      glance.Expression,
      a,
    ) ->
      a,
    bit_string: fn(
      Visitor(a),
      glance.Span,
      List(
        #(
          glance.Expression,
          List(glance.BitStringSegmentOption(glance.Expression)),
        ),
      ),
      a,
    ) ->
      a,
    block: fn(Visitor(a), glance.Span, List(glance.Statement), a) -> a,
    call: fn(
      Visitor(a),
      glance.Span,
      glance.Expression,
      List(glance.Field(glance.Expression)),
      a,
    ) ->
      a,
    case_: fn(
      Visitor(a),
      glance.Span,
      List(glance.Expression),
      List(glance.Clause),
      a,
    ) ->
      a,
    echo_: fn(Visitor(a), glance.Span, Option(glance.Expression), a) -> a,
    field_access: fn(Visitor(a), glance.Span, glance.Expression, String, a) -> a,
    float: fn(Visitor(a), glance.Span, String, a) -> a,
    fn_: fn(
      Visitor(a),
      glance.Span,
      List(glance.FnParameter),
      Option(glance.Type),
      List(glance.Statement),
      a,
    ) ->
      a,
    fn_capture: fn(
      Visitor(a),
      glance.Span,
      Option(String),
      glance.Expression,
      List(glance.Field(glance.Expression)),
      List(glance.Field(glance.Expression)),
      a,
    ) ->
      a,
    int: fn(Visitor(a), glance.Span, String, a) -> a,
    list: fn(
      Visitor(a),
      glance.Span,
      List(glance.Expression),
      Option(glance.Expression),
      a,
    ) ->
      a,
    negate_bool: fn(Visitor(a), glance.Span, glance.Expression, a) -> a,
    negate_int: fn(Visitor(a), glance.Span, glance.Expression, a) -> a,
    record_update: fn(
      Visitor(a),
      glance.Span,
      Option(String),
      String,
      glance.Expression,
      List(glance.RecordUpdateField(glance.Expression)),
      a,
    ) ->
      a,
    panic_: fn(Visitor(a), glance.Span, Option(glance.Expression), a) -> a,
    string: fn(Visitor(a), glance.Span, String, a) -> a,
    todo_: fn(Visitor(a), glance.Span, Option(glance.Expression), a) -> a,
    tuple: fn(Visitor(a), glance.Span, List(glance.Expression), a) -> a,
    tuple_index: fn(Visitor(a), glance.Span, glance.Expression, Int, a) -> a,
    variable: fn(Visitor(a), glance.Span, String, a) -> a,
    pattern: fn(Visitor(a), glance.Pattern, a) -> a,
    pattern_assignment: fn(Visitor(a), glance.Span, glance.Pattern, String, a) ->
      a,
    pattern_bit_string: fn(
      Visitor(a),
      glance.Span,
      List(
        #(glance.Pattern, List(glance.BitStringSegmentOption(glance.Pattern))),
      ),
      a,
    ) ->
      a,
    pattern_concatenate: fn(
      Visitor(a),
      glance.Span,
      String,
      Option(glance.AssignmentName),
      glance.AssignmentName,
      a,
    ) ->
      a,
    pattern_discard: fn(Visitor(a), glance.Span, String, a) -> a,
    pattern_float: fn(Visitor(a), glance.Span, String, a) -> a,
    pattern_int: fn(Visitor(a), glance.Span, String, a) -> a,
    pattern_list: fn(
      Visitor(a),
      glance.Span,
      List(glance.Pattern),
      Option(glance.Pattern),
      a,
    ) ->
      a,
    pattern_string: fn(Visitor(a), glance.Span, String, a) -> a,
    pattern_tuple: fn(Visitor(a), glance.Span, List(glance.Pattern), a) -> a,
    pattern_variable: fn(Visitor(a), glance.Span, String, a) -> a,
    pattern_variant: fn(
      Visitor(a),
      glance.Span,
      Option(String),
      String,
      List(glance.Field(glance.Pattern)),
      Bool,
      a,
    ) ->
      a,
  )
}

pub const default = Visitor(
  function:,
  constant:,
  statement:,
  expression:,
  assert_:,
  use_:,
  assignment:,
  binary_operator:,
  bit_string:,
  block:,
  call:,
  case_:,
  echo_:,
  field_access:,
  float:,
  fn_:,
  fn_capture:,
  int:,
  list:,
  negate_bool:,
  negate_int:,
  record_update:,
  panic_:,
  string:,
  todo_:,
  tuple:,
  tuple_index:,
  variable:,
  pattern:,
  pattern_assignment:,
  pattern_bit_string:,
  pattern_concatenate:,
  pattern_discard:,
  pattern_float:,
  pattern_int:,
  pattern_list:,
  pattern_string:,
  pattern_tuple:,
  pattern_variable:,
  pattern_variant:,
)

pub fn module(visitor: Visitor(a), module: glance.Module, initial: a) -> a {
  let glance.Module(
    imports: _,
    custom_types: _,
    type_aliases: _,
    constants:,
    functions:,
  ) = module

  [
    list.map(constants, fn(constant) {
      #(
        fn(acc) { visitor.constant(visitor, constant, acc) },
        constant.definition.location,
      )
    }),
    list.map(functions, fn(function) {
      #(
        fn(acc) { visitor.function(visitor, function, acc) },
        function.definition.location,
      )
    }),
  ]
  |> list.flatten
  |> list.sort(fn(a, b) {
    let #(_, a) = a
    let #(_, b) = b
    int.compare(a.start, b.start) |> order.break_tie(int.compare(a.end, b.end))
  })
  |> list.fold(initial, fn(acc, pair) {
    let #(f, _) = pair
    f(acc)
  })
}

pub fn function(
  visitor: Visitor(a),
  function: glance.Definition(glance.Function),
  acc: a,
) -> a {
  list.fold(function.definition.body, acc, fn(acc, stmt) {
    visitor.statement(visitor, stmt, acc)
  })
}

pub fn statement(visitor: Visitor(a), statement: glance.Statement, acc: a) -> a {
  case statement {
    glance.Assert(location:, expression:, message:) ->
      visitor.assert_(visitor, location, expression, message, acc)
    glance.Assignment(location:, kind:, pattern:, annotation:, value:) ->
      visitor.assignment(
        visitor,
        location,
        kind,
        pattern,
        annotation,
        value,
        acc,
      )
    glance.Expression(expr) -> visitor.expression(visitor, expr, acc)
    glance.Use(location:, patterns:, function:) ->
      visitor.use_(visitor, location, patterns, function, acc)
  }
}

pub fn assignment(
  visitor: Visitor(a),
  _location: glance.Span,
  _kind: glance.AssignmentKind,
  pattern: glance.Pattern,
  _annotation: Option(glance.Type),
  value: glance.Expression,
  acc: a,
) -> a {
  let acc = visitor.pattern(visitor, pattern, acc)
  visitor.expression(visitor, value, acc)
}

pub fn use_(
  visitor: Visitor(a),
  _location: glance.Span,
  patterns: List(glance.UsePattern),
  function: glance.Expression,
  acc: a,
) -> a {
  let acc =
    list.fold(patterns, acc, fn(acc, pattern) {
      visitor.pattern(visitor, pattern.pattern, acc)
    })

  visitor.expression(visitor, function, acc)
}

pub fn assert_(
  visitor: Visitor(a),
  _location: glance.Span,
  expression: glance.Expression,
  message: Option(glance.Expression),
  acc: a,
) -> a {
  let acc = visitor.expression(visitor, expression, acc)
  case message {
    None -> acc
    Some(message) -> visitor.expression(visitor, message, acc)
  }
}

pub fn constant(
  visitor: Visitor(a),
  constant: glance.Definition(glance.Constant),
  acc: a,
) -> a {
  visitor.expression(visitor, constant.definition.value, acc)
}

pub fn expression(
  visitor: Visitor(a),
  expression: glance.Expression,
  acc: a,
) -> a {
  case expression {
    glance.BinaryOperator(location:, name:, left:, right:) ->
      visitor.binary_operator(visitor, location, name, left, right, acc)
    glance.BitString(location:, segments:) ->
      visitor.bit_string(visitor, location, segments, acc)
    glance.Block(location:, statements:) ->
      visitor.block(visitor, location, statements, acc)
    glance.Call(location:, function:, arguments:) ->
      visitor.call(visitor, location, function, arguments, acc)
    glance.Case(location:, subjects:, clauses:) ->
      visitor.case_(visitor, location, subjects, clauses, acc)
    glance.Echo(location:, expression:) ->
      visitor.echo_(visitor, location, expression, acc)
    glance.FieldAccess(location:, container:, label:) ->
      visitor.field_access(visitor, location, container, label, acc)
    glance.Float(location:, value:) ->
      visitor.float(visitor, location, value, acc)
    glance.Fn(location:, arguments:, return_annotation:, body:) ->
      visitor.fn_(visitor, location, arguments, return_annotation, body, acc)
    glance.FnCapture(
      location:,
      label:,
      function:,
      arguments_before:,
      arguments_after:,
    ) ->
      visitor.fn_capture(
        visitor,
        location,
        label,
        function,
        arguments_before,
        arguments_after,
        acc,
      )
    glance.Int(location:, value:) -> visitor.int(visitor, location, value, acc)
    glance.List(location:, elements:, rest:) ->
      visitor.list(visitor, location, elements, rest, acc)
    glance.NegateBool(location:, value:) ->
      visitor.negate_bool(visitor, location, value, acc)
    glance.NegateInt(location:, value:) ->
      visitor.negate_int(visitor, location, value, acc)
    glance.Panic(location:, message:) ->
      visitor.panic_(visitor, location, message, acc)
    glance.RecordUpdate(location:, module:, constructor:, record:, fields:) ->
      visitor.record_update(
        visitor,
        location,
        module,
        constructor,
        record,
        fields,
        acc,
      )
    glance.String(location:, value:) ->
      visitor.string(visitor, location, value, acc)
    glance.Todo(location:, message:) ->
      visitor.todo_(visitor, location, message, acc)
    glance.Tuple(location:, elements:) ->
      visitor.tuple(visitor, location, elements, acc)
    glance.TupleIndex(location:, tuple:, index:) ->
      visitor.tuple_index(visitor, location, tuple, index, acc)
    glance.Variable(location:, name:) ->
      visitor.variable(visitor, location, name, acc)
  }
}

pub fn binary_operator(
  visitor: Visitor(a),
  _location: glance.Span,
  _name: glance.BinaryOperator,
  left: glance.Expression,
  right: glance.Expression,
  acc: a,
) -> a {
  let acc = visitor.expression(visitor, left, acc)
  visitor.expression(visitor, right, acc)
}

pub fn bit_string(
  visitor: Visitor(a),
  _location: glance.Span,
  segments: List(
    #(glance.Expression, List(glance.BitStringSegmentOption(glance.Expression))),
  ),
  acc: a,
) -> a {
  use acc, #(value, options) <- list.fold(segments, acc)
  let acc = visitor.expression(visitor, value, acc)
  use acc, option <- list.fold(options, acc)
  case option {
    glance.BigOption
    | glance.BitsOption
    | glance.BytesOption
    | glance.FloatOption
    | glance.IntOption
    | glance.LittleOption
    | glance.NativeOption
    | glance.SignedOption
    | glance.SizeOption(_)
    | glance.UnitOption(_)
    | glance.UnsignedOption
    | glance.Utf16CodepointOption
    | glance.Utf16Option
    | glance.Utf32CodepointOption
    | glance.Utf32Option
    | glance.Utf8CodepointOption
    | glance.Utf8Option -> acc
    glance.SizeValueOption(value) -> visitor.expression(visitor, value, acc)
  }
}

pub fn block(
  visitor: Visitor(a),
  _location: glance.Span,
  statements: List(glance.Statement),
  acc: a,
) -> a {
  list.fold(statements, acc, fn(acc, statement) {
    visitor.statement(visitor, statement, acc)
  })
}

pub fn call(
  visitor: Visitor(a),
  _location: glance.Span,
  function: glance.Expression,
  arguments: List(glance.Field(glance.Expression)),
  acc: a,
) -> a {
  let acc = visitor.expression(visitor, function, acc)
  list.fold(arguments, acc, fn(acc, arg) {
    field(visitor, arg, visitor.expression, acc)
  })
}

fn field(
  visitor: Visitor(a),
  field: glance.Field(node),
  f: fn(Visitor(a), node, a) -> a,
  acc: a,
) -> a {
  case field {
    glance.LabelledField(item:, ..) | glance.UnlabelledField(item:) ->
      f(visitor, item, acc)
    glance.ShorthandField(..) -> acc
  }
}

pub fn case_(
  visitor: Visitor(a),
  _location: glance.Span,
  subjects: List(glance.Expression),
  clauses: List(glance.Clause),
  acc: a,
) -> a {
  let acc =
    list.fold(subjects, acc, fn(acc, subject) {
      visitor.expression(visitor, subject, acc)
    })
  list.fold(clauses, acc, fn(acc, clause_) { clause(visitor, clause_, acc) })
}

fn clause(visitor: Visitor(a), clause: glance.Clause, acc: a) -> a {
  let acc =
    list.fold(clause.patterns, acc, fn(acc, patterns) {
      list.fold(patterns, acc, fn(acc, pattern) {
        visitor.pattern(visitor, pattern, acc)
      })
    })

  let acc = case clause.guard {
    None -> acc
    Some(guard) -> visitor.expression(visitor, guard, acc)
  }
  visitor.expression(visitor, clause.body, acc)
}

pub fn echo_(
  visitor: Visitor(a),
  _location: glance.Span,
  expression: Option(glance.Expression),
  acc: a,
) -> a {
  case expression {
    None -> acc
    Some(expression) -> visitor.expression(visitor, expression, acc)
  }
}

pub fn field_access(
  visitor: Visitor(a),
  _location: glance.Span,
  container: glance.Expression,
  _label: String,
  acc: a,
) -> a {
  visitor.expression(visitor, container, acc)
}

pub fn float(
  _visitor: Visitor(a),
  _location: glance.Span,
  _value: String,
  acc: a,
) -> a {
  acc
}

pub fn fn_(
  visitor: Visitor(a),
  _location: glance.Span,
  _arguments: List(glance.FnParameter),
  _return_annotation: Option(glance.Type),
  body: List(glance.Statement),
  acc: a,
) -> a {
  list.fold(body, acc, fn(acc, statement) {
    visitor.statement(visitor, statement, acc)
  })
}

pub fn fn_capture(
  visitor: Visitor(a),
  _location: glance.Span,
  _label: Option(String),
  function: glance.Expression,
  arguments_before: List(glance.Field(glance.Expression)),
  arguments_after: List(glance.Field(glance.Expression)),
  acc: a,
) -> a {
  let acc = visitor.expression(visitor, function, acc)
  let acc =
    list.fold(arguments_before, acc, fn(acc, arg) {
      field(visitor, arg, visitor.expression, acc)
    })
  list.fold(arguments_after, acc, fn(acc, arg) {
    field(visitor, arg, visitor.expression, acc)
  })
}

pub fn int(
  _visitor: Visitor(a),
  _location: glance.Span,
  _value: String,
  acc: a,
) -> a {
  acc
}

pub fn list(
  visitor: Visitor(a),
  _location: glance.Span,
  elements: List(glance.Expression),
  rest: Option(glance.Expression),
  acc: a,
) -> a {
  let acc =
    list.fold(elements, acc, fn(acc, element) {
      visitor.expression(visitor, element, acc)
    })
  case rest {
    None -> acc
    Some(rest) -> visitor.expression(visitor, rest, acc)
  }
}

pub fn negate_bool(
  visitor: Visitor(a),
  _location: glance.Span,
  value: glance.Expression,
  acc: a,
) -> a {
  visitor.expression(visitor, value, acc)
}

pub fn negate_int(
  visitor: Visitor(a),
  _location: glance.Span,
  value: glance.Expression,
  acc: a,
) -> a {
  visitor.expression(visitor, value, acc)
}

pub fn record_update(
  visitor: Visitor(a),
  _location: glance.Span,
  _module: Option(String),
  _constructor: String,
  record: glance.Expression,
  fields: List(glance.RecordUpdateField(glance.Expression)),
  acc: a,
) -> a {
  let acc = visitor.expression(visitor, record, acc)
  list.fold(fields, acc, fn(acc, field) {
    case field.item {
      None -> acc
      Some(item) -> visitor.expression(visitor, item, acc)
    }
  })
}

pub fn panic_(
  visitor: Visitor(a),
  _location: glance.Span,
  message: Option(glance.Expression),
  acc: a,
) -> a {
  case message {
    None -> acc
    Some(message) -> visitor.expression(visitor, message, acc)
  }
}

pub fn string(
  _visitor: Visitor(a),
  _location: glance.Span,
  _value: String,
  acc: a,
) -> a {
  acc
}

pub fn todo_(
  visitor: Visitor(a),
  _location: glance.Span,
  message: Option(glance.Expression),
  acc: a,
) -> a {
  case message {
    None -> acc
    Some(message) -> visitor.expression(visitor, message, acc)
  }
}

pub fn tuple(
  visitor: Visitor(a),
  _location: glance.Span,
  elements: List(glance.Expression),
  acc: a,
) -> a {
  list.fold(elements, acc, fn(acc, element) {
    visitor.expression(visitor, element, acc)
  })
}

pub fn tuple_index(
  visitor: Visitor(a),
  _location: glance.Span,
  tuple: glance.Expression,
  _index: Int,
  acc: a,
) -> a {
  visitor.expression(visitor, tuple, acc)
}

pub fn variable(
  _visitor: Visitor(a),
  _location: glance.Span,
  _name: String,
  acc: a,
) -> a {
  acc
}

pub fn pattern(visitor: Visitor(a), pattern: glance.Pattern, acc: a) -> a {
  case pattern {
    glance.PatternAssignment(location:, attern: pattern, name:) ->
      visitor.pattern_assignment(visitor, location, pattern, name, acc)
    glance.PatternBitString(location:, segments:) ->
      visitor.pattern_bit_string(visitor, location, segments, acc)
    glance.PatternConcatenate(location:, prefix:, prefix_name:, rest_name:) ->
      visitor.pattern_concatenate(
        visitor,
        location,
        prefix,
        prefix_name,
        rest_name,
        acc,
      )
    glance.PatternDiscard(location:, name:) ->
      visitor.pattern_discard(visitor, location, name, acc)
    glance.PatternFloat(location:, value:) ->
      visitor.pattern_float(visitor, location, value, acc)
    glance.PatternInt(location:, value:) ->
      visitor.pattern_int(visitor, location, value, acc)
    glance.PatternList(location:, elements:, tail:) ->
      visitor.pattern_list(visitor, location, elements, tail, acc)
    glance.PatternString(location:, value:) ->
      visitor.pattern_string(visitor, location, value, acc)
    glance.PatternTuple(location:, elements:) ->
      visitor.pattern_tuple(visitor, location, elements, acc)
    glance.PatternVariable(location:, name:) ->
      visitor.pattern_variable(visitor, location, name, acc)
    glance.PatternVariant(
      location:,
      module:,
      constructor:,
      arguments:,
      with_spread:,
    ) ->
      visitor.pattern_variant(
        visitor,
        location,
        module,
        constructor,
        arguments,
        with_spread,
        acc,
      )
  }
}

pub fn pattern_assignment(
  visitor: Visitor(a),
  _location: glance.Span,
  pattern: glance.Pattern,
  _name: String,
  acc: a,
) -> a {
  visitor.pattern(visitor, pattern, acc)
}

pub fn pattern_bit_string(
  visitor: Visitor(a),
  _location: glance.Span,
  segments: List(
    #(glance.Pattern, List(glance.BitStringSegmentOption(glance.Pattern))),
  ),
  acc: a,
) -> a {
  use acc, #(pattern, options) <- list.fold(segments, acc)
  let acc = visitor.pattern(visitor, pattern, acc)
  use acc, option <- list.fold(options, acc)
  case option {
    glance.BigOption
    | glance.BitsOption
    | glance.BytesOption
    | glance.FloatOption
    | glance.IntOption
    | glance.LittleOption
    | glance.NativeOption
    | glance.SignedOption
    | glance.SizeOption(_)
    | glance.UnitOption(_)
    | glance.UnsignedOption
    | glance.Utf16CodepointOption
    | glance.Utf16Option
    | glance.Utf32CodepointOption
    | glance.Utf32Option
    | glance.Utf8CodepointOption
    | glance.Utf8Option -> acc
    glance.SizeValueOption(pattern) -> visitor.pattern(visitor, pattern, acc)
  }
}

pub fn pattern_concatenate(
  _visitor: Visitor(a),
  _location: glance.Span,
  _prefix: String,
  _prefix_name: Option(glance.AssignmentName),
  _rest_name: glance.AssignmentName,
  acc: a,
) -> a {
  acc
}

pub fn pattern_discard(
  _visitor: Visitor(a),
  _location: glance.Span,
  _name: String,
  acc: a,
) -> a {
  acc
}

pub fn pattern_float(
  _visitor: Visitor(a),
  _location: glance.Span,
  _value: String,
  acc: a,
) -> a {
  acc
}

pub fn pattern_int(
  _visitor: Visitor(a),
  _location: glance.Span,
  _value: String,
  acc: a,
) -> a {
  acc
}

pub fn pattern_list(
  visitor: Visitor(a),
  _location: glance.Span,
  elements: List(glance.Pattern),
  tail: Option(glance.Pattern),
  acc: a,
) -> a {
  let acc =
    list.fold(elements, acc, fn(acc, element) {
      visitor.pattern(visitor, element, acc)
    })

  case tail {
    None -> acc
    Some(tail) -> visitor.pattern(visitor, tail, acc)
  }
}

pub fn pattern_string(
  _visitor: Visitor(a),
  _location: glance.Span,
  _value: String,
  acc: a,
) -> a {
  acc
}

pub fn pattern_tuple(
  visitor: Visitor(a),
  _location: glance.Span,
  elements: List(glance.Pattern),
  acc: a,
) -> a {
  list.fold(elements, acc, fn(acc, element) {
    visitor.pattern(visitor, element, acc)
  })
}

pub fn pattern_variable(
  _visitor: Visitor(a),
  _location: glance.Span,
  _name: String,
  acc: a,
) -> a {
  acc
}

pub fn pattern_variant(
  visitor: Visitor(a),
  _location: glance.Span,
  _module: Option(String),
  _constructor: String,
  arguments: List(glance.Field(glance.Pattern)),
  _with_spread: Bool,
  acc: a,
) -> a {
  list.fold(arguments, acc, fn(acc, argument) {
    field(visitor, argument, visitor.pattern, acc)
  })
}
