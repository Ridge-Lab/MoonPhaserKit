///|
test "geometry point and rect helpers support pointer hit testing" {
  let origin = @moonphaserkit.Point2::zero()
  let moved = origin.translate(@moonphaserkit.Point2::new(12.0, 16.0))
  assert_eq(moved.x, 12.0)
  assert_eq(moved.y, 16.0)
  assert_eq(moved.distance_squared_to(origin), 400.0)
  let rect = @moonphaserkit.Rect::new(10.0, 10.0, 80.0, 60.0)
  assert_true(rect.is_valid())
  assert_true(rect.contains(@moonphaserkit.Point2::new(20.0, 20.0)))
  assert_false(rect.contains(@moonphaserkit.Point2::new(200.0, 20.0)))
  assert_true(rect.center() == @moonphaserkit.Point2::new(50.0, 40.0))
  let inflated = rect.inflate(10.0)
  assert_eq(inflated.width, 100.0)
  assert_eq(inflated.height, 80.0)
}

///|
test "size and duration helpers reject invalid dimensions" {
  let size = @moonphaserkit.Size2::new(960, 540)
  assert_true(size.is_valid())
  assert_true(size.is_landscape())
  assert_false(size.is_portrait())
  assert_eq(size.area(), 518400)
  assert_false(@moonphaserkit.Size2::new(0, 540).is_valid())
  let duration = @moonphaserkit.DurationMs::seconds(2)
  assert_eq(duration.value, 2000)
  assert_true(duration.is_positive())
  assert_eq(duration.plus(@moonphaserkit.DurationMs::new(250)).value, 2250)
}

///|
test "texture and spritesheet assets validate runtime preload data" {
  let image = @moonphaserkit.TextureAsset::new("hero", "/assets/hero.png")
  assert_true(image.is_valid())
  let from_image = @moonphaserkit.TextureAsset::from_image(
    @moonphaserkit.ImageAsset::new("star", "/assets/star.svg"),
  )
  assert_eq(from_image.key, "star")
  let sheet = @moonphaserkit.SpriteSheetAsset::new(
    "hero-run",
    "/assets/hero-run.png",
    32,
    48,
    spacing=2,
  )
  assert_true(sheet.is_valid())
  assert_true(sheet.frame_size() == @moonphaserkit.Size2::new(32, 48))
  assert_false(
    @moonphaserkit.SpriteSheetAsset::new("bad", "/bad.png", 0, 48).is_valid(),
  )
}

///|
test "atlas audio tilemap and bitmap font descriptors catch missing paths" {
  let atlas = @moonphaserkit.TextureAtlasAsset::new(
    "ui",
    "/assets/ui.png",
    "/assets/ui.json",
  )
  assert_true(atlas.is_valid())
  assert_false(
    @moonphaserkit.TextureAtlasAsset::new("ui", "/assets/ui.png", "").is_valid(),
  )
  assert_true(
    @moonphaserkit.AudioAsset::new("jump", "/assets/jump.ogg").is_valid(),
  )
  assert_false(@moonphaserkit.AudioAsset::new("jump", "").is_valid())
  assert_true(
    @moonphaserkit.TilemapJsonAsset::new("level1", "/maps/level1.json").is_valid(),
  )
  assert_true(
    @moonphaserkit.BitmapFontAsset::new(
      "score",
      "/fonts/score.png",
      "/fonts/score.xml",
    ).is_valid(),
  )
}

///|
test "asset manifest records secondary path requirements" {
  let image = @moonphaserkit.AssetManifestEntry::new(
    @moonphaserkit.AssetImage,
    "hero",
    "/assets/hero.png",
  )
  assert_true(image.is_complete())
  assert_false(image.requires_secondary_path())
  let atlas = @moonphaserkit.AssetManifestEntry::new(
    @moonphaserkit.AssetAtlas,
    "ui",
    "/assets/ui.png",
    secondary_path="/assets/ui.json",
  )
  assert_true(atlas.requires_secondary_path())
  assert_true(atlas.is_complete())
  let incomplete = @moonphaserkit.AssetManifestEntry::new(
    @moonphaserkit.AssetBitmapFont,
    "font",
    "/font.png",
  )
  assert_false(incomplete.is_complete())
  assert_eq(@moonphaserkit.AssetAudio.label(), "audio")
}

///|
test "animation frame ranges and repeat mapping match Phaser semantics" {
  let range = @moonphaserkit.FrameRange::new(0, 5)
  assert_true(range.is_valid())
  assert_eq(range.count(), 6)
  assert_eq(
    @moonphaserkit.AnimRepeatOnce.to_repeat_count(fixed_count=8),
    0,
  )
  assert_eq(
    @moonphaserkit.AnimRepeatForever.to_repeat_count(fixed_count=8),
    -1,
  )
  assert_eq(
    @moonphaserkit.AnimRepeatFixed.to_repeat_count(fixed_count=3),
    3,
  )
  assert_true(@moonphaserkit.AnimReverse.is_reverse())
  assert_eq(@moonphaserkit.EaseBounceOut.to_phaser_name(), "Bounce.easeOut")
}

///|
test "animation config validates key texture frames and timing" {
  let config = @moonphaserkit.AnimationConfig::new(
    "hero-run",
    "hero-sheet",
    @moonphaserkit.FrameRange::new(0, 7),
    frame_rate=14,
    repeat_mode=@moonphaserkit.AnimRepeatForever,
    yoyo=true,
  )
  assert_true(config.is_valid())
  assert_true(config.loops_forever())
  assert_false(config.plays_once())
  assert_eq(config.phaser_repeat(), -1)
  let invalid = @moonphaserkit.AnimationConfig::new(
    "",
    "hero-sheet",
    @moonphaserkit.FrameRange::new(7, 0),
  )
  assert_false(invalid.is_valid())
}

///|
test "animation play options tween config and state snapshots cover edge cases" {
  let play = @moonphaserkit.AnimationPlayOptions::new(
    ignore_if_playing=false,
    start_frame=2,
    delay_ms=20,
    repeat_override=1,
  )
  assert_true(play.is_valid())
  let tween = @moonphaserkit.SpriteTween::new(
    @moonphaserkit.Point2::new(0.0, 0.0),
    @moonphaserkit.Point2::new(100.0, 20.0),
    alpha_to=0.5,
    scale_to=1.5,
    config=@moonphaserkit.TweenConfig::new(
      duration_ms=400,
      ease=@moonphaserkit.EaseQuadOut,
    ),
  )
  assert_true(tween.is_valid())
  let state = @moonphaserkit.AnimationStateSnapshot::new("run", true, 0.5, 3)
  assert_true(state.is_valid())
  assert_false(@moonphaserkit.AnimationStateSnapshot::new("run", true, 2.0, 3).is_valid())
}

///|
test "sound options model loop rate and volume behavior" {
  let options = @moonphaserkit.SoundOptions::new(
    volume=0.7,
    rate=1.1,
    detune=20,
    seek=0.1,
    delay_ms=40,
    loop_mode=@moonphaserkit.SoundLoop,
  )
  assert_true(options.is_valid())
  assert_true(options.should_loop())
  assert_false(@moonphaserkit.SoundOptions::new(rate=0.0).is_valid())
  let muted = @moonphaserkit.SoundOptions::muted()
  assert_eq(muted.volume, 0.0)
  assert_false(muted.should_loop())
}

///|
test "sound markers fades and audio bus state validate playback metadata" {
  let marker = @moonphaserkit.SoundMarker::new(
    "coin",
    0.2,
    0.5,
    config=@moonphaserkit.SoundOptions::new(volume=0.8),
  )
  assert_true(marker.is_valid())
  assert_false(@moonphaserkit.SoundMarker::new("", 0.0, 0.5).is_valid())
  let fade = @moonphaserkit.AudioFade::new(1.0, 0.0, 500)
  assert_true(fade.is_valid())
  let bus = @moonphaserkit.AudioBusState::new(
    @moonphaserkit.BusMusic,
    volume=0.4,
    muted=true,
  )
  assert_eq(bus.effective_volume(), 0.0)
  assert_eq(@moonphaserkit.BusEffects.label(), "effects")
}

///|
test "camera bounds follow fade shake pan and zoom options validate ranges" {
  let bounds = @moonphaserkit.CameraBounds::new(0.0, 0.0, 2000.0, 1200.0)
  assert_true(bounds.is_valid())
  assert_eq(bounds.as_rect().width, 2000.0)
  let follow = @moonphaserkit.CameraFollowOptions::new(
    lerp_x=0.2,
    lerp_y=0.25,
    deadzone_width=160.0,
    deadzone_height=90.0,
  )
  assert_true(follow.is_valid())
  assert_false(@moonphaserkit.CameraFollowOptions::new(lerp_x=-1.0).is_valid())
  assert_true(@moonphaserkit.CameraFadeOptions::new(red=255, green=20, blue=0).is_valid())
  assert_false(@moonphaserkit.CameraFadeOptions::new(red=300).is_valid())
  assert_true(@moonphaserkit.CameraShakeOptions::new(intensity=0.02).is_valid())
  assert_true(
    @moonphaserkit.CameraPanOptions::new(
      @moonphaserkit.Point2::new(300.0, 200.0),
    ).is_valid(),
  )
  assert_true(@moonphaserkit.CameraZoomOptions::new(1.5).is_valid())
  assert_false(@moonphaserkit.CameraZoomOptions::new(0.0).is_valid())
}

///|
test "pointer snapshots touch zones and swipe detection cover mobile controls" {
  let pointer = @moonphaserkit.PointerSnapshot::new(
    1,
    @moonphaserkit.Point2::new(50.0, 40.0),
    @moonphaserkit.Point2::new(150.0, 140.0),
    true,
    true,
  )
  assert_true(pointer.is_valid())
  assert_eq(pointer.screen_x(), 50.0)
  let zone = @moonphaserkit.TouchZone::new(
    "jump",
    @moonphaserkit.Rect::new(20.0, 20.0, 120.0, 120.0),
  )
  assert_true(zone.is_valid())
  assert_true(zone.contains(pointer))
  assert_false(zone.disable().contains(pointer))
  let swipe = @moonphaserkit.SwipeSnapshot::new(
    @moonphaserkit.Point2::new(100.0, 100.0),
    @moonphaserkit.Point2::new(30.0, 100.0),
    120,
  )
  assert_true(swipe.direction() == @moonphaserkit.SwipeLeft)
  assert_eq(@moonphaserkit.ActionJump.label(), "jump")
  assert_true(@moonphaserkit.KeyBinding::new(@moonphaserkit.ActionPause, "ESC").is_valid())
}

///|
test "tilemap descriptors cover tiled json maps layers and collisions" {
  let config = @moonphaserkit.TilemapConfig::new(
    "level1",
    16,
    16,
    width=120,
    height=64,
  )
  assert_true(config.is_valid())
  assert_true(config.tile_size() == @moonphaserkit.Size2::new(16, 16))
  assert_eq(@moonphaserkit.TilemapOrthogonal.label(), "orthogonal")
  let tileset = @moonphaserkit.TilesetConfig::new(
    "terrain",
    "terrain-image",
    16,
    16,
    spacing=1,
  )
  assert_true(tileset.is_valid())
  let layer = @moonphaserkit.TileLayerConfig::new(
    "ground",
    "terrain",
    alpha=0.8,
  )
  assert_true(layer.is_valid())
  assert_false(@moonphaserkit.TileLayerConfig::new("", "terrain").is_valid())
  assert_true(@moonphaserkit.TileCollisionRange::new(1, 20).is_valid())
  assert_false(@moonphaserkit.TileCollisionRange::new(20, 1).is_valid())
  assert_true(
    @moonphaserkit.TilePropertyMatcher::new("collides", "true").is_valid(),
  )
}

///|
test "tile object spawn points and scene graph options support reusable scenes" {
  let object = @moonphaserkit.TileObject::new(
    "door",
    "portal",
    @moonphaserkit.Point2::new(320.0, 128.0),
    @moonphaserkit.Size2::new(32, 48),
  )
  assert_true(object.is_valid())
  assert_eq(object.bounds().height, 48.0)
  let spawn = @moonphaserkit.TileSpawnPoint::new(
    "player-start",
    @moonphaserkit.Point2::new(64.0, 128.0),
  )
  assert_true(spawn.is_valid())
  let origin = @moonphaserkit.OriginPoint::custom(0.25, 0.75)
  assert_true(origin.is_valid())
  let display = @moonphaserkit.DisplayObjectOptions::new(
    origin=origin,
    scale_x=1.2,
    scale_y=1.2,
    depth=10,
  )
  assert_true(display.is_valid())
  assert_false(@moonphaserkit.DisplayObjectOptions::new(scale_x=0.0).is_valid())
}

///|
test "physics materials layers lifecycle and spawn specs capture game object contracts" {
  let platform = @moonphaserkit.PhysicsMaterial::platform()
  assert_true(platform.is_valid())
  assert_true(platform.immovable)
  let pickup = @moonphaserkit.PhysicsMaterial::pickup()
  assert_true(pickup.sensor)
  assert_eq(platform.to_sprite_options().immovable, true)
  assert_eq(@moonphaserkit.LayerUi.default_depth(), 1000)
  let layer = @moonphaserkit.SceneLayerConfig::new(@moonphaserkit.LayerEffects)
  assert_eq(layer.name, "effects")
  assert_true(layer.is_valid())
  assert_true(@moonphaserkit.ObjectActive.can_update())
  assert_false(@moonphaserkit.ObjectDestroyed.can_destroy())
  let spawn = @moonphaserkit.SpawnSpec::new(
    "player",
    @moonphaserkit.Point2::new(10.0, 20.0),
    physics=platform,
  )
  assert_true(spawn.is_valid())
  assert_true(spawn.with_layer(@moonphaserkit.LayerUi).layer == @moonphaserkit.LayerUi)
}

///|
test "scene transitions validate from and to scenes" {
  let transition = @moonphaserkit.SceneTransition::new(
    "menu",
    "level1",
    fade=@moonphaserkit.CameraFadeOptions::new(duration_ms=300),
  )
  assert_true(transition.is_valid())
  assert_false(@moonphaserkit.SceneTransition::new("", "level1").is_valid())
}

///|
test "diagnostics records feature support and ffi failures" {
  let issue = @moonphaserkit.ValidationIssue::new(
    @moonphaserkit.SeverityError,
    "invalid-config",
    "width must be positive",
  )
  assert_true(issue.is_valid())
  assert_true(issue.is_error())
  assert_eq(@moonphaserkit.FeatureAnimation.label(), "animation")
  let support = @moonphaserkit.FeatureSupport::new(
    @moonphaserkit.FeatureTilemap,
    true,
  )
  assert_true(support.is_complete())
  assert_eq(@moonphaserkit.FfiMissingPhaser.code(), "missing-phaser")
  let record = @moonphaserkit.FfiCallRecord::new(
    @moonphaserkit.FeatureAudio,
    "play",
    false,
    failure_code=@moonphaserkit.FfiRuntimeException.code(),
  )
  assert_true(record.is_valid())
  assert_true(record.failed())
}

///|
test "browser smoke scenarios describe desktop and mobile checks" {
  let desktop = @moonphaserkit.BrowserSmokeScenario::desktop_default()
  assert_true(desktop.is_valid())
  assert_true(desktop.viewport.kind == @moonphaserkit.ViewportDesktop)
  let mobile = @moonphaserkit.BrowserSmokeScenario::mobile_default()
  assert_true(mobile.is_valid())
  assert_eq(mobile.viewport.width, 390)
  assert_true(@moonphaserkit.CanvasExpectation::new().is_valid())
  assert_false(@moonphaserkit.CanvasExpectation::new(min_width=0).is_valid())
}

///|
test "interaction steps and error path expectations model e2e behavior" {
  let wait = @moonphaserkit.InteractionStep::wait(250)
  assert_true(wait.is_valid())
  let press = @moonphaserkit.InteractionStep::press_key("ArrowRight")
  assert_true(press.is_valid())
  assert_false(
    @moonphaserkit.InteractionStep::new(@moonphaserkit.StepPressKey).is_valid(),
  )
  let tap = @moonphaserkit.InteractionStep::tap(@moonphaserkit.Point2::new(40.0, 40.0))
  assert_true(tap.is_valid())
  assert_eq(@moonphaserkit.StepAssertCanvas.label(), "assert-canvas")
  let expectation = @moonphaserkit.ErrorPathExpectation::new(
    @moonphaserkit.ErrorMissingPhaser,
    "Game::create",
    "requires Phaser",
  )
  assert_true(expectation.is_valid())
  assert_eq(@moonphaserkit.ErrorBadAnimation.label(), "bad-animation")
}

///|
test "interaction scenario summaries score covered behavior areas" {
  let summary = @moonphaserkit.InteractionScenarioSummary::new(
    "collect-star",
    6,
    covers_keyboard=true,
    covers_pointer=true,
    covers_collision=true,
    covers_audio=true,
    covers_camera=false,
  )
  assert_true(summary.is_valid())
  assert_eq(summary.coverage_score(), 4)
  assert_false(@moonphaserkit.InteractionScenarioSummary::new("", 0).is_valid())
}
