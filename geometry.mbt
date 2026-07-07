///|
/// A 2D point in scene or camera coordinates.
pub(all) struct Point2 {
  x : Double
  y : Double
} derive(Eq, @debug.Debug)

///|
pub fn Point2::new(x : Double, y : Double) -> Point2 {
  { x, y }
}

///|
pub fn Point2::zero() -> Point2 {
  { x: 0.0, y: 0.0 }
}

///|
pub fn Point2::with_x(self : Point2, x : Double) -> Point2 {
  { x, y: self.y }
}

///|
pub fn Point2::with_y(self : Point2, y : Double) -> Point2 {
  { x: self.x, y }
}

///|
pub fn Point2::translate(self : Point2, delta : Point2) -> Point2 {
  { x: self.x + delta.x, y: self.y + delta.y }
}

///|
pub fn Point2::scale(self : Point2, factor : Double) -> Point2 {
  { x: self.x * factor, y: self.y * factor }
}

///|
pub fn Point2::distance_squared_to(self : Point2, other : Point2) -> Double {
  let dx = self.x - other.x
  let dy = self.y - other.y
  dx * dx + dy * dy
}

///|
/// A non-negative size used by cameras, tilemaps, and viewports.
pub(all) struct Size2 {
  width : Int
  height : Int
} derive(Eq, @debug.Debug)

///|
pub fn Size2::new(width : Int, height : Int) -> Size2 {
  { width, height }
}

///|
pub fn Size2::is_valid(self : Size2) -> Bool {
  self.width > 0 && self.height > 0
}

///|
pub fn Size2::area(self : Size2) -> Int {
  self.width * self.height
}

///|
pub fn Size2::is_landscape(self : Size2) -> Bool {
  self.width >= self.height
}

///|
pub fn Size2::is_portrait(self : Size2) -> Bool {
  self.height > self.width
}

///|
pub fn Size2::with_width(self : Size2, width : Int) -> Size2 {
  { width, height: self.height }
}

///|
pub fn Size2::with_height(self : Size2, height : Int) -> Size2 {
  { width: self.width, height }
}

///|
/// Axis-aligned rectangle for touch zones, camera bounds, and map regions.
pub(all) struct Rect {
  x : Double
  y : Double
  width : Double
  height : Double
} derive(Eq, @debug.Debug)

///|
pub fn Rect::new(
  x : Double,
  y : Double,
  width : Double,
  height : Double,
) -> Rect {
  { x, y, width, height }
}

///|
pub fn Rect::from_size(size : Size2) -> Rect {
  {
    x: 0.0,
    y: 0.0,
    width: size.width.to_double(),
    height: size.height.to_double(),
  }
}

///|
pub fn Rect::is_valid(self : Rect) -> Bool {
  self.width > 0.0 && self.height > 0.0
}

///|
pub fn Rect::left(self : Rect) -> Double {
  self.x
}

///|
pub fn Rect::right(self : Rect) -> Double {
  self.x + self.width
}

///|
pub fn Rect::top(self : Rect) -> Double {
  self.y
}

///|
pub fn Rect::bottom(self : Rect) -> Double {
  self.y + self.height
}

///|
pub fn Rect::center(self : Rect) -> Point2 {
  {
    x: self.x + self.width / 2.0,
    y: self.y + self.height / 2.0,
  }
}

///|
pub fn Rect::contains(self : Rect, point : Point2) -> Bool {
  point.x >= self.left() &&
  point.x <= self.right() &&
  point.y >= self.top() &&
  point.y <= self.bottom()
}

///|
pub fn Rect::move_to(self : Rect, point : Point2) -> Rect {
  { x: point.x, y: point.y, width: self.width, height: self.height }
}

///|
pub fn Rect::translate(self : Rect, delta : Point2) -> Rect {
  {
    x: self.x + delta.x,
    y: self.y + delta.y,
    width: self.width,
    height: self.height,
  }
}

///|
pub fn Rect::inflate(self : Rect, amount : Double) -> Rect {
  {
    x: self.x - amount,
    y: self.y - amount,
    width: self.width + amount * 2.0,
    height: self.height + amount * 2.0,
  }
}

///|
pub fn Rect::intersects(self : Rect, other : Rect) -> Bool {
  self.left() <= other.right() &&
  self.right() >= other.left() &&
  self.top() <= other.bottom() &&
  self.bottom() >= other.top()
}

///|
/// Phaser-compatible color literal stored as a CSS string.
pub(all) struct CssColor {
  value : String
} derive(Eq, @debug.Debug)

///|
pub fn CssColor::new(value : String) -> CssColor {
  { value, }
}

///|
pub fn CssColor::white() -> CssColor {
  { value: "#ffffff" }
}

///|
pub fn CssColor::black() -> CssColor {
  { value: "#000000" }
}

///|
pub fn CssColor::is_valid(self : CssColor) -> Bool {
  self.value.length() > 0
}

///|
pub fn CssColor::as_string(self : CssColor) -> String {
  self.value
}

///|
/// Millisecond duration passed to Phaser tweens, camera effects, and audio fades.
pub(all) struct DurationMs {
  value : Int
} derive(Eq, @debug.Debug)

///|
pub fn DurationMs::new(value : Int) -> DurationMs {
  { value, }
}

///|
pub fn DurationMs::zero() -> DurationMs {
  { value: 0 }
}

///|
pub fn DurationMs::seconds(seconds : Int) -> DurationMs {
  { value: seconds * 1000 }
}

///|
pub fn DurationMs::is_valid(self : DurationMs) -> Bool {
  self.value >= 0
}

///|
pub fn DurationMs::is_positive(self : DurationMs) -> Bool {
  self.value > 0
}

///|
pub fn DurationMs::plus(self : DurationMs, other : DurationMs) -> DurationMs {
  { value: self.value + other.value }
}

///|
pub fn DurationMs::max(self : DurationMs, other : DurationMs) -> DurationMs {
  if self.value >= other.value {
    self
  } else {
    other
  }
}
