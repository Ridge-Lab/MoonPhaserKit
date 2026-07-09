///|
fn main {
  let config = @moonphaserkit.GameConfig::new(
    parent="game",
    width=960,
    height=540,
    background="#182447",
    gravity_y=980,
  )
  let mut player : @moonphaserkit.Sprite? = None
  let mut cursors : @moonphaserkit.CursorKeys? = None
  let mut score_text : @moonphaserkit.Text? = None
  let mut score = 0
  let mut remaining = 0
  let preload = (scene : @moonphaserkit.Scene) => {
    scene.load_image(
      @moonphaserkit.ImageAsset::new("player", "/assets/player.svg"),
    )
    scene.load_image(
      @moonphaserkit.ImageAsset::new("platform", "/assets/platform.svg"),
    )
    scene.load_image(@moonphaserkit.ImageAsset::new("star", "/assets/star.svg"))
  }
  let create = (scene : @moonphaserkit.Scene) => {
    let ground = scene.add_static_sprite(480.0, 514.0, "platform")
    ground.set_scale(2.3)
    let ledge_left = scene.add_static_sprite(180.0, 390.0, "platform")
    let ledge_mid = scene.add_static_sprite(510.0, 300.0, "platform")
    let ledge_right = scene.add_static_sprite(760.0, 405.0, "platform")
    let p = scene.add_sprite(130.0, 315.0, "player")
    p.apply_options(
      @moonphaserkit.SpriteOptions::new(
        scale=0.9,
        collide_world_bounds=true,
        bounce_y=0.05,
      ),
    )
    scene
    .main_camera()
    .set_bounds(@moonphaserkit.CameraBounds::new(0.0, 0.0, 960.0, 540.0))
    scene
    .main_camera()
    .start_follow(
      p,
      options=@moonphaserkit.CameraFollowOptions::new(
        lerp_x=0.18,
        lerp_y=0.18,
        deadzone_width=140.0,
        deadzone_height=90.0,
      ),
    )
    let body = p.body()
    body.set_bounce(0.05, 0.05)
    ignore(scene.add_collider(p, ground))
    ignore(scene.add_collider(p, ledge_left))
    ignore(scene.add_collider(p, ledge_mid))
    ignore(scene.add_collider(p, ledge_right))
    cursors = Some(scene.cursor_keys())
    player = Some(p)
    scene.on_pointer_down((_pointer : @moonphaserkit.Pointer) => {
      match player {
        Some(hero) => hero.body().set_velocity_y(-520.0)
        None => ()
      }
    })
    score = 0
    remaining = 6
    score_text = Some(
      scene.add_text_styled(
        24.0,
        20.0,
        "Score: 0",
        style=@moonphaserkit.TextStyle::scoreboard(),
      ),
    )
    let star_positions = [
      (190.0, 340.0),
      (350.0, 460.0),
      (510.0, 250.0),
      (650.0, 450.0),
      (760.0, 355.0),
      (870.0, 460.0),
    ]
    star_positions.each(pos => {
      let (x, y) = pos
      let star = scene.add_sprite(x, y, "star")
      star.apply_options(
        @moonphaserkit.SpriteOptions::new(scale=0.72, gravity_y=-980.0),
      )
      ignore(
        scene.add_overlap(p, star, (
          _hero : @moonphaserkit.Sprite,
          item : @moonphaserkit.Sprite,
        ) => {
          item.set_visible(false)
          item.set_active(false)
          score = score + 10
          remaining = remaining - 1
          match score_text {
            Some(text) => text.set_text("Score: \{score}")
            None => ()
          }
          if remaining <= 0 {
            match score_text {
              Some(text) => text.set_text("Score: \{score} - clear!")
              None => ()
            }
          }
        }),
      )
    })
  }
  let update = (_scene : @moonphaserkit.Scene) => {
    match (player, cursors) {
      (Some(p), Some(keys)) => {
        let body = p.body()
        if keys.key(@moonphaserkit.Left).is_down() {
          body.set_velocity_x(-250.0)
        } else if keys.key(@moonphaserkit.Right).is_down() {
          body.set_velocity_x(250.0)
        } else {
          body.set_velocity_x(0.0)
        }
        if keys.key(@moonphaserkit.Up).is_down() && body.touching_down() {
          body.set_velocity_y(-520.0)
        }
      }
      _ => ()
    }
  }
  ignore(@moonphaserkit.Game::create(config, preload, create, update))
}
