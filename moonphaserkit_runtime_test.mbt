///|
test "text style presets validate scoreboard and dialogue ui" {
  let scoreboard = @moonphaserkit.TextStyle::scoreboard()
  assert_true(scoreboard.is_valid())
  assert_true(scoreboard.has_stroke())
  assert_false(scoreboard.has_background())
  assert_eq(scoreboard.align.to_phaser_name(), "left")
  let dialogue = @moonphaserkit.TextStyle::dialogue()
  assert_true(dialogue.is_valid())
  assert_true(dialogue.has_background())
  assert_eq(dialogue.fixed_width, 360)
  assert_eq(dialogue.word_wrap_width, 328)
}

///|
test "text styles reject invalid sizing and preserve color updates" {
  assert_false(@moonphaserkit.TextStyle::new(font_size=0).is_valid())
  assert_false(@moonphaserkit.TextStyle::new(stroke_thickness=-1).is_valid())
  assert_false(@moonphaserkit.TextStyle::new(fixed_width=-10).is_valid())
  let base = @moonphaserkit.TextStyle::new(color="#ffffff")
  let warning = base.with_color("#facc15")
  assert_true(warning.is_valid())
  assert_eq(warning.color, "#facc15")
  assert_eq(warning.font_family, base.font_family)
}

///|
test "timer repeat modes map to Phaser timer options" {
  assert_eq(@moonphaserkit.TimerOnce.label(), "once")
  assert_eq(@moonphaserkit.TimerRepeat.label(), "repeat")
  assert_eq(@moonphaserkit.TimerLoop.label(), "loop")
  assert_false(@moonphaserkit.TimerOnce.should_loop())
  assert_true(@moonphaserkit.TimerLoop.should_loop())
  assert_eq(@moonphaserkit.TimerOnce.to_repeat_count(repeat_count=5), 0)
  assert_eq(@moonphaserkit.TimerRepeat.to_repeat_count(repeat_count=5), 5)
  assert_eq(@moonphaserkit.TimerLoop.to_repeat_count(repeat_count=5), 0)
}

///|
test "timer configs validate one shot repeat and loop behavior" {
  let once = @moonphaserkit.TimerEventConfig::once(250)
  assert_true(once.is_valid())
  assert_true(once.fires_once())
  assert_false(once.loops_forever())
  let repeat = @moonphaserkit.TimerEventConfig::repeat(100, 3)
  assert_true(repeat.is_valid())
  assert_eq(repeat.phaser_repeat(), 3)
  let looping = @moonphaserkit.TimerEventConfig::looping(500)
  assert_true(looping.is_valid())
  assert_true(looping.loops_forever())
  assert_false(@moonphaserkit.TimerEventConfig::repeat(100, 0).is_valid())
  assert_false(@moonphaserkit.TimerEventConfig::new(time_scale=0.0).is_valid())
}

///|
test "scene control commands describe multi scene workflows" {
  let start = @moonphaserkit.SceneControlCommand::new(
    @moonphaserkit.SceneStart,
    "level-1",
  )
  assert_true(start.is_valid())
  assert_true(start.is_transition())
  assert_false(start.action.keeps_current_scene())
  let overlay = @moonphaserkit.SceneControlCommand::new(
    @moonphaserkit.SceneLaunch,
    "pause-menu",
  )
  assert_true(overlay.is_transition())
  assert_true(overlay.action.keeps_current_scene())
  assert_eq(@moonphaserkit.ScenePause.label(), "pause")
  assert_false(
    @moonphaserkit.SceneControlCommand::new(@moonphaserkit.SceneStop, "").is_valid(),
  )
}

///|
test "display options support applying complete sprite presentation state" {
  let options = @moonphaserkit.DisplayObjectOptions::new(
    position=@moonphaserkit.Point2::new(64.0, 96.0),
    origin=@moonphaserkit.OriginPoint::top_left(),
    scale_x=1.5,
    scale_y=0.75,
    rotation=0.2,
    alpha=0.8,
    depth=50,
    visible=true,
    active=true,
  )
  assert_true(options.is_valid())
  assert_eq(options.position.x, 64.0)
  assert_eq(options.origin.kind.label(), "top-left")
  let hidden = options.hidden()
  assert_false(hidden.visible)
  assert_true(hidden.active)
}
