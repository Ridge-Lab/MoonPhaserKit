///|
pub(all) enum DisplayOrigin {
  OriginTopLeft
  OriginCenter
  OriginBottomCenter
  OriginCustom
} derive(Eq, @debug.Debug)

///|
pub fn DisplayOrigin::label(self : DisplayOrigin) -> String {
  match self {
    OriginTopLeft => "top-left"
    OriginCenter => "center"
    OriginBottomCenter => "bottom-center"
    OriginCustom => "custom"
  }
}

///|
pub(all) struct OriginPoint {
  kind : DisplayOrigin
  x : Double
  y : Double
} derive(Eq, @debug.Debug)

///|
pub fn OriginPoint::center() -> OriginPoint {
  { kind: OriginCenter, x: 0.5, y: 0.5 }
}

///|
pub fn OriginPoint::top_left() -> OriginPoint {
  { kind: OriginTopLeft, x: 0.0, y: 0.0 }
}

///|
pub fn OriginPoint::custom(x : Double, y : Double) -> OriginPoint {
  { kind: OriginCustom, x, y }
}

///|
pub fn OriginPoint::is_valid(self : OriginPoint) -> Bool {
  self.x >= 0.0 && self.x <= 1.0 && self.y >= 0.0 && self.y <= 1.0
}

///|
pub(all) struct DisplayObjectOptions {
  position : Point2
  origin : OriginPoint
  scale_x : Double
  scale_y : Double
  rotation : Double
  alpha : Double
  depth : Int
  visible : Bool
  active : Bool
} derive(Eq, @debug.Debug)

///|
pub fn DisplayObjectOptions::new(
  position? : Point2 = Point2::zero(),
  origin? : OriginPoint = OriginPoint::center(),
  scale_x? : Double = 1.0,
  scale_y? : Double = 1.0,
  rotation? : Double = 0.0,
  alpha? : Double = 1.0,
  depth? : Int = 0,
  visible? : Bool = true,
  active? : Bool = true,
) -> DisplayObjectOptions {
  {
    position,
    origin,
    scale_x,
    scale_y,
    rotation,
    alpha,
    depth,
    visible,
    active,
  }
}

///|
pub fn DisplayObjectOptions::is_valid(self : DisplayObjectOptions) -> Bool {
  self.origin.is_valid() &&
  self.scale_x > 0.0 &&
  self.scale_y > 0.0 &&
  self.alpha >= 0.0
}

///|
pub fn DisplayObjectOptions::hidden(
  self : DisplayObjectOptions,
) -> DisplayObjectOptions {
  {
    position: self.position,
    origin: self.origin,
    scale_x: self.scale_x,
    scale_y: self.scale_y,
    rotation: self.rotation,
    alpha: self.alpha,
    depth: self.depth,
    visible: false,
    active: self.active,
  }
}

///|
pub(all) enum PhysicsMaterialKind {
  MaterialDefault
  MaterialBouncy
  MaterialIce
  MaterialHeavy
  MaterialSensor
} derive(Eq, @debug.Debug)

///|
pub fn PhysicsMaterialKind::label(self : PhysicsMaterialKind) -> String {
  match self {
    MaterialDefault => "default"
    MaterialBouncy => "bouncy"
    MaterialIce => "ice"
    MaterialHeavy => "heavy"
    MaterialSensor => "sensor"
  }
}

///|
pub(all) struct PhysicsMaterial {
  kind : PhysicsMaterialKind
  bounce_x : Double
  bounce_y : Double
  gravity_y : Double
  immovable : Bool
  sensor : Bool
} derive(Eq, @debug.Debug)

///|
pub fn PhysicsMaterial::new(
  kind? : PhysicsMaterialKind = MaterialDefault,
  bounce_x? : Double = 0.0,
  bounce_y? : Double = 0.0,
  gravity_y? : Double = 0.0,
  immovable? : Bool = false,
  sensor? : Bool = false,
) -> PhysicsMaterial {
  { kind, bounce_x, bounce_y, gravity_y, immovable, sensor }
}

///|
pub fn PhysicsMaterial::platform() -> PhysicsMaterial {
  {
    kind: MaterialDefault,
    bounce_x: 0.0,
    bounce_y: 0.0,
    gravity_y: 0.0,
    immovable: true,
    sensor: false,
  }
}

///|
pub fn PhysicsMaterial::pickup() -> PhysicsMaterial {
  {
    kind: MaterialSensor,
    bounce_x: 0.0,
    bounce_y: 0.0,
    gravity_y: 0.0,
    immovable: false,
    sensor: true,
  }
}

///|
pub fn PhysicsMaterial::is_valid(self : PhysicsMaterial) -> Bool {
  self.bounce_x >= 0.0 && self.bounce_y >= 0.0
}

///|
pub fn PhysicsMaterial::to_sprite_options(
  self : PhysicsMaterial,
) -> SpriteOptions {
  SpriteOptions::new(
    immovable=self.immovable,
    bounce_x=self.bounce_x,
    bounce_y=self.bounce_y,
    gravity_y=self.gravity_y,
  )
}

///|
pub(all) enum SceneLayerKind {
  LayerBackground
  LayerWorld
  LayerActors
  LayerEffects
  LayerUi
} derive(Eq, @debug.Debug)

///|
pub fn SceneLayerKind::default_depth(self : SceneLayerKind) -> Int {
  match self {
    LayerBackground => -100
    LayerWorld => 0
    LayerActors => 100
    LayerEffects => 500
    LayerUi => 1000
  }
}

///|
pub fn SceneLayerKind::label(self : SceneLayerKind) -> String {
  match self {
    LayerBackground => "background"
    LayerWorld => "world"
    LayerActors => "actors"
    LayerEffects => "effects"
    LayerUi => "ui"
  }
}

///|
pub(all) struct SceneLayerConfig {
  kind : SceneLayerKind
  name : String
  depth : Int
  scroll_factor_x : Double
  scroll_factor_y : Double
  visible : Bool
} derive(Eq, @debug.Debug)

///|
pub fn SceneLayerConfig::new(
  kind : SceneLayerKind,
  name? : String = "",
  depth? : Int = 0,
  scroll_factor_x? : Double = 1.0,
  scroll_factor_y? : Double = 1.0,
  visible? : Bool = true,
) -> SceneLayerConfig {
  let final_name = if name.length() > 0 { name } else { kind.label() }
  let final_depth = if depth == 0 { kind.default_depth() } else { depth }
  {
    kind,
    name: final_name,
    depth: final_depth,
    scroll_factor_x,
    scroll_factor_y,
    visible,
  }
}

///|
pub fn SceneLayerConfig::is_valid(self : SceneLayerConfig) -> Bool {
  self.name.length() > 0 &&
  self.scroll_factor_x >= 0.0 &&
  self.scroll_factor_y >= 0.0
}

///|
pub(all) enum ObjectLifecycleState {
  ObjectCreated
  ObjectActive
  ObjectPaused
  ObjectDestroyed
} derive(Eq, @debug.Debug)

///|
pub fn ObjectLifecycleState::can_update(self : ObjectLifecycleState) -> Bool {
  match self {
    ObjectActive => true
    _ => false
  }
}

///|
pub fn ObjectLifecycleState::can_destroy(self : ObjectLifecycleState) -> Bool {
  match self {
    ObjectDestroyed => false
    _ => true
  }
}

///|
pub(all) struct SpawnSpec {
  key : String
  position : Point2
  display : DisplayObjectOptions
  physics : PhysicsMaterial
  layer : SceneLayerKind
} derive(Eq, @debug.Debug)

///|
pub fn SpawnSpec::new(
  key : String,
  position : Point2,
  display? : DisplayObjectOptions = DisplayObjectOptions::new(),
  physics? : PhysicsMaterial = PhysicsMaterial::new(),
  layer? : SceneLayerKind = LayerActors,
) -> SpawnSpec {
  { key, position, display, physics, layer }
}

///|
pub fn SpawnSpec::is_valid(self : SpawnSpec) -> Bool {
  self.key.length() > 0 && self.display.is_valid() && self.physics.is_valid()
}

///|
pub fn SpawnSpec::with_layer(
  self : SpawnSpec,
  layer : SceneLayerKind,
) -> SpawnSpec {
  {
    key: self.key,
    position: self.position,
    display: self.display,
    physics: self.physics,
    layer,
  }
}

///|
pub(all) struct SceneTransition {
  from_scene : String
  to_scene : String
  fade : CameraFadeOptions
  restart_current : Bool
} derive(Eq, @debug.Debug)

///|
pub fn SceneTransition::new(
  from_scene : String,
  to_scene : String,
  fade? : CameraFadeOptions = CameraFadeOptions::new(),
  restart_current? : Bool = false,
) -> SceneTransition {
  { from_scene, to_scene, fade, restart_current }
}

///|
pub fn SceneTransition::is_valid(self : SceneTransition) -> Bool {
  self.from_scene.length() > 0 &&
  self.to_scene.length() > 0 &&
  self.fade.is_valid()
}
