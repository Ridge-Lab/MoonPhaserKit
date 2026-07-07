///|
pub(all) enum AnimationRepeatMode {
  AnimRepeatOnce
  AnimRepeatForever
  AnimRepeatFixed
} derive(Eq, @debug.Debug)

///|
pub fn AnimationRepeatMode::to_repeat_count(
  self : AnimationRepeatMode,
  fixed_count? : Int = 0,
) -> Int {
  match self {
    AnimRepeatOnce => 0
    AnimRepeatForever => -1
    AnimRepeatFixed => fixed_count
  }
}

///|
pub(all) enum AnimationDirection {
  AnimForward
  AnimReverse
} derive(Eq, @debug.Debug)

///|
pub fn AnimationDirection::is_reverse(self : AnimationDirection) -> Bool {
  match self {
    AnimReverse => true
    AnimForward => false
  }
}

///|
pub(all) enum EaseKind {
  EaseLinear
  EaseQuadIn
  EaseQuadOut
  EaseQuadInOut
  EaseCubicIn
  EaseCubicOut
  EaseSineInOut
  EaseBackOut
  EaseBounceOut
} derive(Eq, @debug.Debug)

///|
pub fn EaseKind::to_phaser_name(self : EaseKind) -> String {
  match self {
    EaseLinear => "Linear"
    EaseQuadIn => "Quad.easeIn"
    EaseQuadOut => "Quad.easeOut"
    EaseQuadInOut => "Quad.easeInOut"
    EaseCubicIn => "Cubic.easeIn"
    EaseCubicOut => "Cubic.easeOut"
    EaseSineInOut => "Sine.easeInOut"
    EaseBackOut => "Back.easeOut"
    EaseBounceOut => "Bounce.easeOut"
  }
}

///|
pub(all) struct FrameRange {
  start : Int
  end : Int
} derive(Eq, @debug.Debug)

///|
pub fn FrameRange::new(start : Int, end : Int) -> FrameRange {
  { start, end }
}

///|
pub fn FrameRange::single(index : Int) -> FrameRange {
  { start: index, end: index }
}

///|
pub fn FrameRange::is_valid(self : FrameRange) -> Bool {
  self.start >= 0 && self.end >= self.start
}

///|
pub fn FrameRange::count(self : FrameRange) -> Int {
  self.end - self.start + 1
}

///|
pub(all) struct AnimationConfig {
  key : String
  texture_key : String
  frames : FrameRange
  frame_rate : Int
  repeat_mode : AnimationRepeatMode
  repeat_count : Int
  yoyo : Bool
  delay_ms : Int
} derive(Eq, @debug.Debug)

///|
pub fn AnimationConfig::new(
  key : String,
  texture_key : String,
  frames : FrameRange,
  frame_rate? : Int = 12,
  repeat_mode? : AnimationRepeatMode = AnimRepeatOnce,
  repeat_count? : Int = 0,
  yoyo? : Bool = false,
  delay_ms? : Int = 0,
) -> AnimationConfig {
  { key, texture_key, frames, frame_rate, repeat_mode, repeat_count, yoyo, delay_ms }
}

///|
pub fn AnimationConfig::is_valid(self : AnimationConfig) -> Bool {
  self.key.length() > 0 &&
  self.texture_key.length() > 0 &&
  self.frames.is_valid() &&
  self.frame_rate > 0 &&
  self.repeat_count >= 0 &&
  self.delay_ms >= 0
}

///|
pub fn AnimationConfig::phaser_repeat(self : AnimationConfig) -> Int {
  self.repeat_mode.to_repeat_count(fixed_count=self.repeat_count)
}

///|
pub fn AnimationConfig::plays_once(self : AnimationConfig) -> Bool {
  self.repeat_mode == AnimRepeatOnce
}

///|
pub fn AnimationConfig::loops_forever(self : AnimationConfig) -> Bool {
  self.repeat_mode == AnimRepeatForever
}

///|
pub(all) struct AnimationPlayOptions {
  ignore_if_playing : Bool
  start_frame : Int
  delay_ms : Int
  repeat_override : Int
} derive(Eq, @debug.Debug)

///|
pub fn AnimationPlayOptions::new(
  ignore_if_playing? : Bool = true,
  start_frame? : Int = 0,
  delay_ms? : Int = 0,
  repeat_override? : Int = 0,
) -> AnimationPlayOptions {
  { ignore_if_playing, start_frame, delay_ms, repeat_override }
}

///|
pub fn AnimationPlayOptions::is_valid(self : AnimationPlayOptions) -> Bool {
  self.start_frame >= 0 && self.delay_ms >= 0 && self.repeat_override >= 0
}

///|
pub(all) struct TweenConfig {
  duration_ms : Int
  delay_ms : Int
  ease : EaseKind
  yoyo : Bool
  repeat_count : Int
} derive(Eq, @debug.Debug)

///|
pub fn TweenConfig::new(
  duration_ms? : Int = 250,
  delay_ms? : Int = 0,
  ease? : EaseKind = EaseLinear,
  yoyo? : Bool = false,
  repeat_count? : Int = 0,
) -> TweenConfig {
  { duration_ms, delay_ms, ease, yoyo, repeat_count }
}

///|
pub fn TweenConfig::is_valid(self : TweenConfig) -> Bool {
  self.duration_ms >= 0 && self.delay_ms >= 0 && self.repeat_count >= 0
}

///|
pub(all) struct SpriteTween {
  from : Point2
  to : Point2
  alpha_from : Double
  alpha_to : Double
  scale_from : Double
  scale_to : Double
  config : TweenConfig
} derive(Eq, @debug.Debug)

///|
pub fn SpriteTween::new(
  from : Point2,
  to : Point2,
  alpha_from? : Double = 1.0,
  alpha_to? : Double = 1.0,
  scale_from? : Double = 1.0,
  scale_to? : Double = 1.0,
  config? : TweenConfig = TweenConfig::new(),
) -> SpriteTween {
  { from, to, alpha_from, alpha_to, scale_from, scale_to, config }
}

///|
pub fn SpriteTween::is_valid(self : SpriteTween) -> Bool {
  self.alpha_from >= 0.0 &&
  self.alpha_to >= 0.0 &&
  self.scale_from > 0.0 &&
  self.scale_to > 0.0 &&
  self.config.is_valid()
}

///|
pub(all) struct AnimationStateSnapshot {
  key : String
  is_playing : Bool
  progress : Double
  frame_index : Int
} derive(Eq, @debug.Debug)

///|
pub fn AnimationStateSnapshot::new(
  key : String,
  is_playing : Bool,
  progress : Double,
  frame_index : Int,
) -> AnimationStateSnapshot {
  { key, is_playing, progress, frame_index }
}

///|
pub fn AnimationStateSnapshot::is_valid(self : AnimationStateSnapshot) -> Bool {
  self.progress >= 0.0 && self.progress <= 1.0 && self.frame_index >= 0
}

