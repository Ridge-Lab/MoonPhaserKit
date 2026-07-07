///|
pub(all) enum BrowserViewportKind {
  ViewportDesktop
  ViewportTablet
  ViewportMobile
} derive(Eq, @debug.Debug)

///|
pub fn BrowserViewportKind::label(self : BrowserViewportKind) -> String {
  match self {
    ViewportDesktop => "desktop"
    ViewportTablet => "tablet"
    ViewportMobile => "mobile"
  }
}

///|
pub(all) struct BrowserViewport {
  kind : BrowserViewportKind
  width : Int
  height : Int
} derive(Eq, @debug.Debug)

///|
pub fn BrowserViewport::new(
  kind : BrowserViewportKind,
  width : Int,
  height : Int,
) -> BrowserViewport {
  { kind, width, height }
}

///|
pub fn BrowserViewport::desktop() -> BrowserViewport {
  { kind: ViewportDesktop, width: 1200, height: 780 }
}

///|
pub fn BrowserViewport::mobile() -> BrowserViewport {
  { kind: ViewportMobile, width: 390, height: 844 }
}

///|
pub fn BrowserViewport::is_valid(self : BrowserViewport) -> Bool {
  self.width > 0 && self.height > 0
}

///|
pub(all) enum InteractionStepKind {
  StepWait
  StepPressKey
  StepReleaseKey
  StepTap
  StepDrag
  StepAssertCanvas
  StepAssertText
  StepAssertNoErrors
} derive(Eq, @debug.Debug)

///|
pub fn InteractionStepKind::label(self : InteractionStepKind) -> String {
  match self {
    StepWait => "wait"
    StepPressKey => "press-key"
    StepReleaseKey => "release-key"
    StepTap => "tap"
    StepDrag => "drag"
    StepAssertCanvas => "assert-canvas"
    StepAssertText => "assert-text"
    StepAssertNoErrors => "assert-no-errors"
  }
}

///|
pub(all) struct InteractionStep {
  kind : InteractionStepKind
  value : String
  point : Point2
  duration_ms : Int
} derive(Eq, @debug.Debug)

///|
pub fn InteractionStep::new(
  kind : InteractionStepKind,
  value? : String = "",
  point? : Point2 = Point2::zero(),
  duration_ms? : Int = 0,
) -> InteractionStep {
  { kind, value, point, duration_ms }
}

///|
pub fn InteractionStep::wait(duration_ms : Int) -> InteractionStep {
  { kind: StepWait, value: "", point: Point2::zero(), duration_ms }
}

///|
pub fn InteractionStep::press_key(key : String) -> InteractionStep {
  { kind: StepPressKey, value: key, point: Point2::zero(), duration_ms: 0 }
}

///|
pub fn InteractionStep::tap(point : Point2) -> InteractionStep {
  { kind: StepTap, value: "", point, duration_ms: 0 }
}

///|
pub fn InteractionStep::is_valid(self : InteractionStep) -> Bool {
  let value_is_valid = match self.kind {
    StepPressKey => self.value.length() > 0
    StepReleaseKey => self.value.length() > 0
    StepAssertText => self.value.length() > 0
    _ => true
  }
  self.duration_ms >= 0 && value_is_valid
}

///|
pub(all) struct CanvasExpectation {
  min_width : Int
  min_height : Int
  allow_mobile_fit : Bool
  require_non_blank : Bool
} derive(Eq, @debug.Debug)

///|
pub fn CanvasExpectation::new(
  min_width? : Int = 300,
  min_height? : Int = 160,
  allow_mobile_fit? : Bool = true,
  require_non_blank? : Bool = true,
) -> CanvasExpectation {
  { min_width, min_height, allow_mobile_fit, require_non_blank }
}

///|
pub fn CanvasExpectation::is_valid(self : CanvasExpectation) -> Bool {
  self.min_width > 0 && self.min_height > 0
}

///|
pub(all) struct BrowserSmokeScenario {
  name : String
  viewport : BrowserViewport
  canvas : CanvasExpectation
  initial_wait_ms : Int
  fail_on_console_error : Bool
  fail_on_http_error : Bool
} derive(Eq, @debug.Debug)

///|
pub fn BrowserSmokeScenario::new(
  name : String,
  viewport : BrowserViewport,
  canvas? : CanvasExpectation = CanvasExpectation::new(),
  initial_wait_ms? : Int = 500,
  fail_on_console_error? : Bool = true,
  fail_on_http_error? : Bool = true,
) -> BrowserSmokeScenario {
  { name, viewport, canvas, initial_wait_ms, fail_on_console_error, fail_on_http_error }
}

///|
pub fn BrowserSmokeScenario::desktop_default() -> BrowserSmokeScenario {
  BrowserSmokeScenario::new("desktop-canvas", BrowserViewport::desktop())
}

///|
pub fn BrowserSmokeScenario::mobile_default() -> BrowserSmokeScenario {
  BrowserSmokeScenario::new("mobile-canvas", BrowserViewport::mobile())
}

///|
pub fn BrowserSmokeScenario::is_valid(self : BrowserSmokeScenario) -> Bool {
  self.name.length() > 0 &&
  self.viewport.is_valid() &&
  self.canvas.is_valid() &&
  self.initial_wait_ms >= 0
}

///|
pub(all) enum ErrorPathKind {
  ErrorMissingPhaser
  ErrorInvalidConfig
  ErrorMissingAsset
  ErrorBadAnimation
  ErrorAudioNotUnlocked
  ErrorTilemapLayerMissing
} derive(Eq, @debug.Debug)

///|
pub fn ErrorPathKind::label(self : ErrorPathKind) -> String {
  match self {
    ErrorMissingPhaser => "missing-phaser"
    ErrorInvalidConfig => "invalid-config"
    ErrorMissingAsset => "missing-asset"
    ErrorBadAnimation => "bad-animation"
    ErrorAudioNotUnlocked => "audio-not-unlocked"
    ErrorTilemapLayerMissing => "tilemap-layer-missing"
  }
}

///|
pub(all) struct ErrorPathExpectation {
  kind : ErrorPathKind
  operation : String
  expected_message : String
} derive(Eq, @debug.Debug)

///|
pub fn ErrorPathExpectation::new(
  kind : ErrorPathKind,
  operation : String,
  expected_message : String,
) -> ErrorPathExpectation {
  { kind, operation, expected_message }
}

///|
pub fn ErrorPathExpectation::is_valid(self : ErrorPathExpectation) -> Bool {
  self.operation.length() > 0 && self.expected_message.length() > 0
}

///|
pub(all) struct InteractionScenarioSummary {
  name : String
  step_count : Int
  covers_keyboard : Bool
  covers_pointer : Bool
  covers_collision : Bool
  covers_audio : Bool
  covers_camera : Bool
} derive(Eq, @debug.Debug)

///|
pub fn InteractionScenarioSummary::new(
  name : String,
  step_count : Int,
  covers_keyboard? : Bool = false,
  covers_pointer? : Bool = false,
  covers_collision? : Bool = false,
  covers_audio? : Bool = false,
  covers_camera? : Bool = false,
) -> InteractionScenarioSummary {
  { name, step_count, covers_keyboard, covers_pointer, covers_collision, covers_audio, covers_camera }
}

///|
pub fn InteractionScenarioSummary::is_valid(self : InteractionScenarioSummary) -> Bool {
  self.name.length() > 0 && self.step_count > 0
}

///|
pub fn InteractionScenarioSummary::coverage_score(self : InteractionScenarioSummary) -> Int {
  let mut score = 0
  if self.covers_keyboard { score = score + 1 }
  if self.covers_pointer { score = score + 1 }
  if self.covers_collision { score = score + 1 }
  if self.covers_audio { score = score + 1 }
  if self.covers_camera { score = score + 1 }
  score
}
