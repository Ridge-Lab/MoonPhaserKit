///|
pub(all) enum TimerRepeatMode {
  TimerOnce
  TimerRepeat
  TimerLoop
} derive(Eq, @debug.Debug)

///|
pub fn TimerRepeatMode::label(self : TimerRepeatMode) -> String {
  match self {
    TimerOnce => "once"
    TimerRepeat => "repeat"
    TimerLoop => "loop"
  }
}

///|
pub fn TimerRepeatMode::should_loop(self : TimerRepeatMode) -> Bool {
  match self {
    TimerLoop => true
    _ => false
  }
}

///|
pub fn TimerRepeatMode::to_repeat_count(
  self : TimerRepeatMode,
  repeat_count? : Int = 0,
) -> Int {
  match self {
    TimerOnce => 0
    TimerRepeat => repeat_count
    TimerLoop => 0
  }
}

///|
pub(all) struct TimerEventConfig {
  delay_ms : Int
  repeat_mode : TimerRepeatMode
  repeat_count : Int
  start_at_ms : Int
  time_scale : Double
  paused : Bool
} derive(Eq, @debug.Debug)

///|
pub fn TimerEventConfig::new(
  delay_ms? : Int = 1000,
  repeat_mode? : TimerRepeatMode = TimerOnce,
  repeat_count? : Int = 0,
  start_at_ms? : Int = 0,
  time_scale? : Double = 1.0,
  paused? : Bool = false,
) -> TimerEventConfig {
  { delay_ms, repeat_mode, repeat_count, start_at_ms, time_scale, paused }
}

///|
pub fn TimerEventConfig::once(delay_ms : Int) -> TimerEventConfig {
  TimerEventConfig::new(delay_ms~)
}

///|
pub fn TimerEventConfig::repeat(
  delay_ms : Int,
  repeat_count : Int,
) -> TimerEventConfig {
  TimerEventConfig::new(delay_ms~, repeat_mode=TimerRepeat, repeat_count~)
}

///|
pub fn TimerEventConfig::looping(delay_ms : Int) -> TimerEventConfig {
  TimerEventConfig::new(delay_ms~, repeat_mode=TimerLoop)
}

///|
pub fn TimerEventConfig::is_valid(self : TimerEventConfig) -> Bool {
  let repeat_ok = match self.repeat_mode {
    TimerRepeat => self.repeat_count > 0
    _ => self.repeat_count >= 0
  }
  self.delay_ms >= 0 &&
  self.start_at_ms >= 0 &&
  self.time_scale > 0.0 &&
  repeat_ok
}

///|
pub fn TimerEventConfig::phaser_repeat(self : TimerEventConfig) -> Int {
  self.repeat_mode.to_repeat_count(repeat_count=self.repeat_count)
}

///|
pub fn TimerEventConfig::loops_forever(self : TimerEventConfig) -> Bool {
  self.repeat_mode.should_loop()
}

///|
pub fn TimerEventConfig::fires_once(self : TimerEventConfig) -> Bool {
  self.repeat_mode == TimerOnce
}
