///|
pub(all) enum PointerButton {
  PointerPrimary
  PointerMiddle
  PointerSecondary
  PointerBack
  PointerForward
} derive(Eq, @debug.Debug)

///|
pub fn PointerButton::button_index(self : PointerButton) -> Int {
  match self {
    PointerPrimary => 0
    PointerMiddle => 1
    PointerSecondary => 2
    PointerBack => 3
    PointerForward => 4
  }
}

///|
pub(all) struct PointerSnapshot {
  id : Int
  position : Point2
  world_position : Point2
  is_down : Bool
  just_down : Bool
  button : PointerButton
} derive(Eq, @debug.Debug)

///|
pub fn PointerSnapshot::new(
  id : Int,
  position : Point2,
  world_position : Point2,
  is_down : Bool,
  just_down : Bool,
  button? : PointerButton = PointerPrimary,
) -> PointerSnapshot {
  { id, position, world_position, is_down, just_down, button }
}

///|
pub fn PointerSnapshot::is_valid(self : PointerSnapshot) -> Bool {
  self.id >= 0
}

///|
pub fn PointerSnapshot::screen_x(self : PointerSnapshot) -> Double {
  self.position.x
}

///|
pub fn PointerSnapshot::screen_y(self : PointerSnapshot) -> Double {
  self.position.y
}

///|
pub(all) struct TouchZone {
  name : String
  rect : Rect
  enabled : Bool
} derive(Eq, @debug.Debug)

///|
pub fn TouchZone::new(name : String, rect : Rect, enabled? : Bool = true) -> TouchZone {
  { name, rect, enabled }
}

///|
pub fn TouchZone::is_valid(self : TouchZone) -> Bool {
  self.name.length() > 0 && self.rect.is_valid()
}

///|
pub fn TouchZone::contains(self : TouchZone, snapshot : PointerSnapshot) -> Bool {
  self.enabled && self.rect.contains(snapshot.position)
}

///|
pub fn TouchZone::disable(self : TouchZone) -> TouchZone {
  { name: self.name, rect: self.rect, enabled: false }
}

///|
pub fn TouchZone::enable(self : TouchZone) -> TouchZone {
  { name: self.name, rect: self.rect, enabled: true }
}

///|
pub(all) enum SwipeDirection {
  SwipeLeft
  SwipeRight
  SwipeUp
  SwipeDown
  SwipeNone
} derive(Eq, @debug.Debug)

///|
pub fn SwipeDirection::to_key_name(self : SwipeDirection) -> String {
  match self {
    SwipeLeft => "left"
    SwipeRight => "right"
    SwipeUp => "up"
    SwipeDown => "down"
    SwipeNone => "none"
  }
}

///|
pub(all) struct SwipeConfig {
  threshold : Double
  max_duration_ms : Int
} derive(Eq, @debug.Debug)

///|
pub fn SwipeConfig::new(
  threshold? : Double = 24.0,
  max_duration_ms? : Int = 400,
) -> SwipeConfig {
  { threshold, max_duration_ms }
}

///|
pub fn SwipeConfig::is_valid(self : SwipeConfig) -> Bool {
  self.threshold > 0.0 && self.max_duration_ms > 0
}

///|
pub(all) struct SwipeSnapshot {
  start : Point2
  current : Point2
  elapsed_ms : Int
  config : SwipeConfig
} derive(Eq, @debug.Debug)

///|
pub fn SwipeSnapshot::new(
  start : Point2,
  current : Point2,
  elapsed_ms : Int,
  config? : SwipeConfig = SwipeConfig::new(),
) -> SwipeSnapshot {
  { start, current, elapsed_ms, config }
}

///|
pub fn SwipeSnapshot::is_valid(self : SwipeSnapshot) -> Bool {
  self.elapsed_ms >= 0 && self.config.is_valid()
}

///|
pub fn SwipeSnapshot::delta(self : SwipeSnapshot) -> Point2 {
  { x: self.current.x - self.start.x, y: self.current.y - self.start.y }
}

///|
pub fn SwipeSnapshot::is_fast_enough(self : SwipeSnapshot) -> Bool {
  self.elapsed_ms <= self.config.max_duration_ms
}

///|
pub fn SwipeSnapshot::direction(self : SwipeSnapshot) -> SwipeDirection {
  let delta = self.delta()
  if !self.is_fast_enough() {
    SwipeNone
  } else if delta.x >= self.config.threshold {
    SwipeRight
  } else if delta.x <= 0.0 - self.config.threshold {
    SwipeLeft
  } else if delta.y >= self.config.threshold {
    SwipeDown
  } else if delta.y <= 0.0 - self.config.threshold {
    SwipeUp
  } else {
    SwipeNone
  }
}

///|
pub(all) enum GameAction {
  ActionMoveLeft
  ActionMoveRight
  ActionJump
  ActionInteract
  ActionPause
  ActionRestart
} derive(Eq, @debug.Debug)

///|
pub fn GameAction::label(self : GameAction) -> String {
  match self {
    ActionMoveLeft => "move-left"
    ActionMoveRight => "move-right"
    ActionJump => "jump"
    ActionInteract => "interact"
    ActionPause => "pause"
    ActionRestart => "restart"
  }
}

///|
pub(all) struct KeyBinding {
  action : GameAction
  key_code : String
} derive(Eq, @debug.Debug)

///|
pub fn KeyBinding::new(action : GameAction, key_code : String) -> KeyBinding {
  { action, key_code }
}

///|
pub fn KeyBinding::is_valid(self : KeyBinding) -> Bool {
  self.key_code.length() > 0
}

