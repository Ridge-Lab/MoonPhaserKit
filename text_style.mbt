///|
pub(all) enum TextAlign {
  TextAlignLeft
  TextAlignCenter
  TextAlignRight
} derive(Eq, @debug.Debug)

///|
pub fn TextAlign::to_phaser_name(self : TextAlign) -> String {
  match self {
    TextAlignLeft => "left"
    TextAlignCenter => "center"
    TextAlignRight => "right"
  }
}

///|
pub(all) struct TextStyle {
  font_family : String
  font_size : Int
  color : String
  background_color : String
  stroke_color : String
  stroke_thickness : Int
  align : TextAlign
  fixed_width : Int
  fixed_height : Int
  word_wrap_width : Int
} derive(Eq, @debug.Debug)

///|
pub fn TextStyle::new(
  font_family? : String = "Inter, system-ui, sans-serif",
  font_size? : Int = 18,
  color? : String = "#ffffff",
  background_color? : String = "",
  stroke_color? : String = "",
  stroke_thickness? : Int = 0,
  align? : TextAlign = TextAlignLeft,
  fixed_width? : Int = 0,
  fixed_height? : Int = 0,
  word_wrap_width? : Int = 0,
) -> TextStyle {
  {
    font_family,
    font_size,
    color,
    background_color,
    stroke_color,
    stroke_thickness,
    align,
    fixed_width,
    fixed_height,
    word_wrap_width,
  }
}

///|
pub fn TextStyle::scoreboard() -> TextStyle {
  TextStyle::new(
    font_size=22,
    color="#ffffff",
    stroke_color="#0f172a",
    stroke_thickness=3,
  )
}

///|
pub fn TextStyle::dialogue() -> TextStyle {
  TextStyle::new(
    font_size=16,
    color="#f8fafc",
    background_color="#111827",
    fixed_width=360,
    word_wrap_width=328,
  )
}

///|
pub fn TextStyle::is_valid(self : TextStyle) -> Bool {
  self.font_family.length() > 0 &&
  self.font_size > 0 &&
  self.color.length() > 0 &&
  self.stroke_thickness >= 0 &&
  self.fixed_width >= 0 &&
  self.fixed_height >= 0 &&
  self.word_wrap_width >= 0
}

///|
pub fn TextStyle::has_background(self : TextStyle) -> Bool {
  self.background_color.length() > 0
}

///|
pub fn TextStyle::has_stroke(self : TextStyle) -> Bool {
  self.stroke_color.length() > 0 && self.stroke_thickness > 0
}

///|
pub fn TextStyle::with_color(self : TextStyle, color : String) -> TextStyle {
  {
    font_family: self.font_family,
    font_size: self.font_size,
    color,
    background_color: self.background_color,
    stroke_color: self.stroke_color,
    stroke_thickness: self.stroke_thickness,
    align: self.align,
    fixed_width: self.fixed_width,
    fixed_height: self.fixed_height,
    word_wrap_width: self.word_wrap_width,
  }
}
