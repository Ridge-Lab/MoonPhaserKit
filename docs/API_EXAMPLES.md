# API Examples

本页给出可直接参考的 MoonPhaserKit API 组合示例。示例默认运行在 `Game::create` 的 `create` 或 `update` 回调中。

## 平台角色

```moonbit
let player = scene.add_sprite(120.0, 260.0, "player")
player.apply_options(
  SpriteOptions::new(
    scale=0.9,
    collide_world_bounds=true,
    bounce_y=0.05,
  ),
)
scene.main_camera().start_follow(player)
```

## 键盘移动

```moonbit
let cursors = scene.cursor_keys()
let body = player.body()

if cursors.key(Left).is_down() {
  body.set_velocity_x(-240.0)
} else if cursors.key(Right).is_down() {
  body.set_velocity_x(240.0)
} else {
  body.set_velocity_x(0.0)
}

if cursors.key(Up).is_down() && body.touching_down() {
  body.set_velocity_y(-520.0)
}
```

## 动画与皮肤切换

```moonbit
scene.create_animation(
  AnimationConfig::new(
    "hero-run",
    "hero-sheet",
    FrameRange::new(0, 7),
    frame_rate=14,
    repeat_mode=AnimRepeatForever,
  ),
)
player.play_animation("hero-run")
player.set_texture("hero-powered")
player.set_tint(0xffcc00)
```

## 分数文字

```moonbit
let score_text = scene.add_text_styled(
  24.0,
  20.0,
  "Score: 0",
  style=TextStyle::scoreboard(),
)
score_text.set_scroll_factor(0.0, 0.0)
score_text.set_depth(1000)
score_text.set_text("Score: 10")
```

## 拾取物碰撞

```moonbit
ignore(scene.add_overlap(player, star, (_hero, item) => {
  item.set_visible(false)
  item.set_active(false)
  score_text.set_text("Score: 10")
}))
```

## 定时事件

```moonbit
ignore(scene.delayed_call(DurationMs::seconds(1), () => {
  player.set_tint(0xffcc00)
}))

ignore(scene.add_timer_event(TimerEventConfig::repeat(500, 3), () => {
  score_text.set_text("Combo!")
}))
```

## 暂停菜单

```moonbit
scene.launch_scene("pause-menu")
scene.pause_scene("level-1")

scene.resume_scene("level-1")
scene.stop_scene("pause-menu")
```

## Tilemap 碰撞层

```moonbit
scene.load_tilemap_json(TilemapJsonAsset::new("level1", "/maps/level1.json"))
let map = scene.make_tilemap(TilemapConfig::new("level1", 16, 16))
ignore(map.add_tileset(TilesetConfig::new("terrain", "terrain", 16, 16)))
let ground = map.create_layer(TileLayerConfig::new("ground", "terrain"))
ground.set_collision_between(TileCollisionRange::new(1, 200))
```
