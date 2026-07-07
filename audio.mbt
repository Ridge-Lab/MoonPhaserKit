///|
pub(all) enum SoundLoopMode {
  SoundPlayOnce
  SoundLoop
} derive(Eq, @debug.Debug)

///|
pub fn SoundLoopMode::as_bool(self : SoundLoopMode) -> Bool {
  match self {
    SoundPlayOnce => false
    SoundLoop => true
  }
}

///|
pub(all) struct SoundOptions {
  volume : Double
  rate : Double
  detune : Int
  seek : Double
  delay_ms : Int
  loop_mode : SoundLoopMode
} derive(Eq, @debug.Debug)

///|
pub fn SoundOptions::new(
  volume? : Double = 1.0,
  rate? : Double = 1.0,
  detune? : Int = 0,
  seek? : Double = 0.0,
  delay_ms? : Int = 0,
  loop_mode? : SoundLoopMode = SoundPlayOnce,
) -> SoundOptions {
  { volume, rate, detune, seek, delay_ms, loop_mode }
}

///|
pub fn SoundOptions::is_valid(self : SoundOptions) -> Bool {
  self.volume >= 0.0 &&
  self.rate > 0.0 &&
  self.seek >= 0.0 &&
  self.delay_ms >= 0
}

///|
pub fn SoundOptions::should_loop(self : SoundOptions) -> Bool {
  self.loop_mode.as_bool()
}

///|
pub fn SoundOptions::muted() -> SoundOptions {
  { volume: 0.0, rate: 1.0, detune: 0, seek: 0.0, delay_ms: 0, loop_mode: SoundPlayOnce }
}

///|
pub(all) struct SoundMarker {
  name : String
  start : Double
  duration : Double
  config : SoundOptions
} derive(Eq, @debug.Debug)

///|
pub fn SoundMarker::new(
  name : String,
  start : Double,
  duration : Double,
  config? : SoundOptions = SoundOptions::new(),
) -> SoundMarker {
  { name, start, duration, config }
}

///|
pub fn SoundMarker::is_valid(self : SoundMarker) -> Bool {
  self.name.length() > 0 &&
  self.start >= 0.0 &&
  self.duration > 0.0 &&
  self.config.is_valid()
}

///|
pub(all) struct AudioFade {
  from_volume : Double
  to_volume : Double
  duration_ms : Int
} derive(Eq, @debug.Debug)

///|
pub fn AudioFade::new(
  from_volume : Double,
  to_volume : Double,
  duration_ms : Int,
) -> AudioFade {
  { from_volume, to_volume, duration_ms }
}

///|
pub fn AudioFade::is_valid(self : AudioFade) -> Bool {
  self.from_volume >= 0.0 &&
  self.to_volume >= 0.0 &&
  self.duration_ms >= 0
}

///|
pub(all) enum AudioBusKind {
  BusMaster
  BusMusic
  BusEffects
  BusUi
  BusVoice
} derive(Eq, @debug.Debug)

///|
pub fn AudioBusKind::label(self : AudioBusKind) -> String {
  match self {
    BusMaster => "master"
    BusMusic => "music"
    BusEffects => "effects"
    BusUi => "ui"
    BusVoice => "voice"
  }
}

///|
pub(all) struct AudioBusState {
  kind : AudioBusKind
  volume : Double
  muted : Bool
} derive(Eq, @debug.Debug)

///|
pub fn AudioBusState::new(
  kind : AudioBusKind,
  volume? : Double = 1.0,
  muted? : Bool = false,
) -> AudioBusState {
  { kind, volume, muted }
}

///|
pub fn AudioBusState::is_valid(self : AudioBusState) -> Bool {
  self.volume >= 0.0
}

///|
pub fn AudioBusState::effective_volume(self : AudioBusState) -> Double {
  if self.muted {
    0.0
  } else {
    self.volume
  }
}
