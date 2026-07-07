///|
test "default game config is valid" {
  let config = @moonphaserkit.GameConfig::new()
  assert_true(config.is_valid())
  assert_eq(config.parent, "game")
  assert_eq(config.width, 800)
  assert_eq(config.height, 450)
  assert_eq(config.gravity_y, 900)
}

///|
test "custom game config preserves user choices" {
  let config = @moonphaserkit.GameConfig::new(
    parent="canvas",
    width=1024,
    height=576,
    background="#0b1020",
    gravity_y=700,
    debug=true,
  )
  assert_true(config.is_valid())
  assert_eq(config.parent, "canvas")
  assert_eq(config.width, 1024)
  assert_eq(config.height, 576)
  assert_eq(config.background, "#0b1020")
  assert_eq(config.debug, true)
}

///|
test "invalid game config catches bad canvas sizes" {
  let bad = @moonphaserkit.GameConfig::new(width=0)
  assert_false(bad.is_valid())
}

///|
test "sprite options model common arcade physics setup" {
  let options = @moonphaserkit.SpriteOptions::new(
    scale=2.0,
    immovable=true,
    collide_world_bounds=true,
    bounce_x=0.5,
    bounce_y=0.25,
    gravity_y=100.0,
  )
  assert_eq(options.scale, 2.0)
  assert_true(options.immovable)
  assert_true(options.collide_world_bounds)
  assert_eq(options.bounce_x, 0.5)
  assert_eq(options.bounce_y, 0.25)
  assert_eq(options.gravity_y, 100.0)
}

///|
test "image assets require key and path" {
  let asset = @moonphaserkit.ImageAsset::new("player", "/assets/player.svg")
  assert_true(asset.is_valid())
  assert_false(
    @moonphaserkit.ImageAsset::new("", "/assets/player.svg").is_valid(),
  )
  assert_false(@moonphaserkit.ImageAsset::new("player", "").is_valid())
}

///|
test "cursor directions map to phaser key names" {
  assert_eq(@moonphaserkit.Left.to_key_name(), "left")
  assert_eq(@moonphaserkit.Right.to_key_name(), "right")
  assert_eq(@moonphaserkit.Up.to_key_name(), "up")
  assert_eq(@moonphaserkit.Down.to_key_name(), "down")
}
