pub fn negate(func: fn(t) -> Bool) -> fn(t) -> Bool {
  fn(a) -> Bool {
    !func(a)
  }
}

