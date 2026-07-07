///|
test "velocity stores axis values without mutation" {
  let velocity = Velocity::new(120.0, -30.0)
  assert_eq(velocity.x, 120.0)
  assert_eq(velocity.y, -30.0)
}
