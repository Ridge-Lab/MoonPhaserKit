///|
pub(all) struct CameraBounds {
  x : Double
  y : Double
  width : Double
  height : Double
} derive(Eq, @debug.Debug)

///|
pub fn CameraBounds::new(
  x : Double,
  y : Double,
  width : Double,
  height : Double,
) -> CameraBounds {
  { x, y, width, height }
}

///|
pub fn CameraBounds::from_rect(rect : Rect) -> CameraBounds {
  { x: rect.x, y: rect.y, width: rect.width, height: rect.height }
}

///|
pub fn CameraBounds::is_valid(self : CameraBounds) -> Bool {
  self.width > 0.0 && self.height > 0.0
}

///|
pub fn CameraBounds::as_rect(self : CameraBounds) -> Rect {
  { x: self.x, y: self.y, width: self.width, height: self.height }
}

///|
pub(all) struct CameraFollowOptions {
  lerp_x : Double
  lerp_y : Double
  offset_x : Double
  offset_y : Double
  deadzone_width : Double
  deadzone_height : Double
} derive(Eq, @debug.Debug)

///|
pub fn CameraFollowOptions::new(
  lerp_x? : Double = 1.0,
  lerp_y? : Double = 1.0,
  offset_x? : Double = 0.0,
  offset_y? : Double = 0.0,
  deadzone_width? : Double = 0.0,
  deadzone_height? : Double = 0.0,
) -> CameraFollowOptions {
  { lerp_x, lerp_y, offset_x, offset_y, deadzone_width, deadzone_height }
}

///|
pub fn CameraFollowOptions::is_valid(self : CameraFollowOptions) -> Bool {
  self.lerp_x >= 0.0 &&
  self.lerp_y >= 0.0 &&
  self.deadzone_width >= 0.0 &&
  self.deadzone_height >= 0.0
}

///|
pub(all) struct CameraFadeOptions {
  duration_ms : Int
  red : Int
  green : Int
  blue : Int
  force : Bool
} derive(Eq, @debug.Debug)

///|
pub fn CameraFadeOptions::new(
  duration_ms? : Int = 250,
  red? : Int = 0,
  green? : Int = 0,
  blue? : Int = 0,
  force? : Bool = false,
) -> CameraFadeOptions {
  { duration_ms, red, green, blue, force }
}

///|
pub fn CameraFadeOptions::is_valid(self : CameraFadeOptions) -> Bool {
  self.duration_ms >= 0 &&
  self.red >= 0 &&
  self.red <= 255 &&
  self.green >= 0 &&
  self.green <= 255 &&
  self.blue >= 0 &&
  self.blue <= 255
}

///|
pub(all) struct CameraShakeOptions {
  duration_ms : Int
  intensity : Double
  force : Bool
} derive(Eq, @debug.Debug)

///|
pub fn CameraShakeOptions::new(
  duration_ms? : Int = 180,
  intensity? : Double = 0.008,
  force? : Bool = false,
) -> CameraShakeOptions {
  { duration_ms, intensity, force }
}

///|
pub fn CameraShakeOptions::is_valid(self : CameraShakeOptions) -> Bool {
  self.duration_ms >= 0 && self.intensity >= 0.0
}

///|
pub(all) struct CameraPanOptions {
  target : Point2
  duration_ms : Int
  ease : EaseKind
  force : Bool
} derive(Eq, @debug.Debug)

///|
pub fn CameraPanOptions::new(
  target : Point2,
  duration_ms? : Int = 250,
  ease? : EaseKind = EaseSineInOut,
  force? : Bool = false,
) -> CameraPanOptions {
  { target, duration_ms, ease, force }
}

///|
pub fn CameraPanOptions::is_valid(self : CameraPanOptions) -> Bool {
  self.duration_ms >= 0
}

///|
pub(all) struct CameraZoomOptions {
  zoom : Double
  duration_ms : Int
  ease : EaseKind
} derive(Eq, @debug.Debug)

///|
pub fn CameraZoomOptions::new(
  zoom : Double,
  duration_ms? : Int = 250,
  ease? : EaseKind = EaseSineInOut,
) -> CameraZoomOptions {
  { zoom, duration_ms, ease }
}

///|
pub fn CameraZoomOptions::is_valid(self : CameraZoomOptions) -> Bool {
  self.zoom > 0.0 && self.duration_ms >= 0
}

///|
pub(all) struct CameraViewport {
  x : Int
  y : Int
  width : Int
  height : Int
} derive(Eq, @debug.Debug)

///|
pub fn CameraViewport::new(
  x : Int,
  y : Int,
  width : Int,
  height : Int,
) -> CameraViewport {
  { x, y, width, height }
}

///|
pub fn CameraViewport::is_valid(self : CameraViewport) -> Bool {
  self.width > 0 && self.height > 0
}

///|
pub fn CameraViewport::size(self : CameraViewport) -> Size2 {
  { width: self.width, height: self.height }
}

