///|
fn main {
  let config = @moonphaserkit.GameConfig::new(parent="game")
  println(
    "MoonPhaserKit ready: \{config.width}x\{config.height}, parent=#\{config.parent}",
  )
}
