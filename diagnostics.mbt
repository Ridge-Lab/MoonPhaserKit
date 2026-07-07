///|
pub(all) enum ValidationSeverity {
  SeverityInfo
  SeverityWarning
  SeverityError
} derive(Eq, @debug.Debug)

///|
pub fn ValidationSeverity::label(self : ValidationSeverity) -> String {
  match self {
    SeverityInfo => "info"
    SeverityWarning => "warning"
    SeverityError => "error"
  }
}

///|
pub fn ValidationSeverity::is_blocking(self : ValidationSeverity) -> Bool {
  match self {
    SeverityError => true
    _ => false
  }
}

///|
pub(all) struct ValidationIssue {
  severity : ValidationSeverity
  code : String
  message : String
} derive(Eq, @debug.Debug)

///|
pub fn ValidationIssue::new(
  severity : ValidationSeverity,
  code : String,
  message : String,
) -> ValidationIssue {
  { severity, code, message }
}

///|
pub fn ValidationIssue::is_valid(self : ValidationIssue) -> Bool {
  self.code.length() > 0 && self.message.length() > 0
}

///|
pub fn ValidationIssue::is_error(self : ValidationIssue) -> Bool {
  self.severity.is_blocking()
}

///|
pub(all) enum RuntimeFeature {
  FeatureGame
  FeatureScene
  FeatureSprite
  FeaturePhysics
  FeatureAnimation
  FeatureAudio
  FeatureCamera
  FeatureTilemap
  FeaturePointer
} derive(Eq, @debug.Debug)

///|
pub fn RuntimeFeature::label(self : RuntimeFeature) -> String {
  match self {
    FeatureGame => "game"
    FeatureScene => "scene"
    FeatureSprite => "sprite"
    FeaturePhysics => "arcade-physics"
    FeatureAnimation => "animation"
    FeatureAudio => "audio"
    FeatureCamera => "camera"
    FeatureTilemap => "tilemap"
    FeaturePointer => "pointer"
  }
}

///|
pub(all) struct FeatureSupport {
  feature : RuntimeFeature
  supported : Bool
  notes : String
} derive(Eq, @debug.Debug)

///|
pub fn FeatureSupport::new(
  feature : RuntimeFeature,
  supported : Bool,
  notes? : String = "",
) -> FeatureSupport {
  { feature, supported, notes }
}

///|
pub fn FeatureSupport::is_complete(self : FeatureSupport) -> Bool {
  self.supported || self.notes.length() > 0
}

///|
pub(all) enum FfiFailureKind {
  FfiMissingPhaser
  FfiMissingPlugin
  FfiInvalidAsset
  FfiInvalidConfig
  FfiRuntimeException
} derive(Eq, @debug.Debug)

///|
pub fn FfiFailureKind::code(self : FfiFailureKind) -> String {
  match self {
    FfiMissingPhaser => "missing-phaser"
    FfiMissingPlugin => "missing-plugin"
    FfiInvalidAsset => "invalid-asset"
    FfiInvalidConfig => "invalid-config"
    FfiRuntimeException => "runtime-exception"
  }
}

///|
pub(all) struct FfiCallRecord {
  feature : RuntimeFeature
  operation : String
  success : Bool
  failure_code : String
} derive(Eq, @debug.Debug)

///|
pub fn FfiCallRecord::new(
  feature : RuntimeFeature,
  operation : String,
  success : Bool,
  failure_code? : String = "",
) -> FfiCallRecord {
  { feature, operation, success, failure_code }
}

///|
pub fn FfiCallRecord::is_valid(self : FfiCallRecord) -> Bool {
  self.operation.length() > 0 &&
  (self.success || self.failure_code.length() > 0)
}

///|
pub fn FfiCallRecord::failed(self : FfiCallRecord) -> Bool {
  !self.success
}

