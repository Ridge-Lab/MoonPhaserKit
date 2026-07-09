///|
pub(all) struct PhaserVersion {
  major : Int
  minor : Int
  patch : Int
} derive(Eq, @debug.Debug)

///|
pub fn PhaserVersion::new(
  major : Int,
  minor : Int,
  patch : Int,
) -> PhaserVersion {
  { major, minor, patch }
}

///|
pub fn PhaserVersion::pinned() -> PhaserVersion {
  { major: 3, minor: 90, patch: 0 }
}

///|
pub fn PhaserVersion::is_valid(self : PhaserVersion) -> Bool {
  self.major >= 0 && self.minor >= 0 && self.patch >= 0
}

///|
pub fn PhaserVersion::is_phaser3(self : PhaserVersion) -> Bool {
  self.major == 3
}

///|
pub fn PhaserVersion::is_supported(self : PhaserVersion) -> Bool {
  self.is_valid() && self.major == 3 && self.minor >= 60
}

///|
pub fn PhaserVersion::to_string(self : PhaserVersion) -> String {
  "\{self.major}.\{self.minor}.\{self.patch}"
}

///|
pub(all) enum MoonBitBackend {
  BackendJavaScript
  BackendWasm
  BackendNative
} derive(Eq, @debug.Debug)

///|
pub fn MoonBitBackend::label(self : MoonBitBackend) -> String {
  match self {
    BackendJavaScript => "javascript"
    BackendWasm => "wasm"
    BackendNative => "native"
  }
}

///|
pub fn MoonBitBackend::is_supported(self : MoonBitBackend) -> Bool {
  match self {
    BackendJavaScript => true
    _ => false
  }
}

///|
pub(all) enum BrowserTarget {
  BrowserChromium
  BrowserFirefox
  BrowserSafari
  BrowserEdge
  BrowserUnknown
} derive(Eq, @debug.Debug)

///|
pub fn BrowserTarget::label(self : BrowserTarget) -> String {
  match self {
    BrowserChromium => "chromium"
    BrowserFirefox => "firefox"
    BrowserSafari => "safari"
    BrowserEdge => "edge"
    BrowserUnknown => "unknown"
  }
}

///|
pub fn BrowserTarget::supports_audio_unlock(self : BrowserTarget) -> Bool {
  match self {
    BrowserUnknown => false
    _ => true
  }
}

///|
pub(all) struct RuntimeCompatibility {
  backend : MoonBitBackend
  phaser : PhaserVersion
  browser : BrowserTarget
  requires_global_phaser : Bool
} derive(Eq, @debug.Debug)

///|
pub fn RuntimeCompatibility::new(
  backend? : MoonBitBackend = BackendJavaScript,
  phaser? : PhaserVersion = PhaserVersion::pinned(),
  browser? : BrowserTarget = BrowserChromium,
  requires_global_phaser? : Bool = true,
) -> RuntimeCompatibility {
  { backend, phaser, browser, requires_global_phaser }
}

///|
pub fn RuntimeCompatibility::is_supported(self : RuntimeCompatibility) -> Bool {
  self.backend.is_supported() &&
  self.phaser.is_supported() &&
  self.browser.supports_audio_unlock() &&
  self.requires_global_phaser
}

///|
pub fn RuntimeCompatibility::support_summary(
  self : RuntimeCompatibility,
) -> String {
  "\{self.backend.label()} + Phaser \{self.phaser.to_string()} + \{self.browser.label()}"
}

///|
pub(all) enum IntegrationStepKind {
  IntegrationInstallMoonBit
  IntegrationInstallNode
  IntegrationInstallPhaser
  IntegrationExposeGlobalPhaser
  IntegrationBuildMoonBitJs
  IntegrationImportGeneratedJs
  IntegrationRunSmokeTest
  IntegrationPublishMooncakes
} derive(Eq, @debug.Debug)

///|
pub fn IntegrationStepKind::label(self : IntegrationStepKind) -> String {
  match self {
    IntegrationInstallMoonBit => "install-moonbit"
    IntegrationInstallNode => "install-node"
    IntegrationInstallPhaser => "install-phaser"
    IntegrationExposeGlobalPhaser => "expose-global-phaser"
    IntegrationBuildMoonBitJs => "build-moonbit-js"
    IntegrationImportGeneratedJs => "import-generated-js"
    IntegrationRunSmokeTest => "run-smoke-test"
    IntegrationPublishMooncakes => "publish-mooncakes"
  }
}

///|
pub(all) struct IntegrationStep {
  kind : IntegrationStepKind
  title : String
  required_for_demo : Bool
  required_for_package : Bool
} derive(Eq, @debug.Debug)

///|
pub fn IntegrationStep::new(
  kind : IntegrationStepKind,
  title : String,
  required_for_demo? : Bool = true,
  required_for_package? : Bool = false,
) -> IntegrationStep {
  { kind, title, required_for_demo, required_for_package }
}

///|
pub fn IntegrationStep::is_valid(self : IntegrationStep) -> Bool {
  self.title.length() > 0
}

///|
pub fn IntegrationStep::for_package_publish() -> IntegrationStep {
  IntegrationStep::new(
    IntegrationPublishMooncakes,
    "Publish the package after Mooncakes account confirmation",
    required_for_demo=false,
    required_for_package=true,
  )
}

///|
pub(all) struct IntegrationChecklist {
  has_moonbit : Bool
  has_node : Bool
  has_phaser : Bool
  exposes_global_phaser : Bool
  builds_generated_js : Bool
  imports_generated_js : Bool
  smoke_test_passes : Bool
} derive(Eq, @debug.Debug)

///|
pub fn IntegrationChecklist::new(
  has_moonbit? : Bool = false,
  has_node? : Bool = false,
  has_phaser? : Bool = false,
  exposes_global_phaser? : Bool = false,
  builds_generated_js? : Bool = false,
  imports_generated_js? : Bool = false,
  smoke_test_passes? : Bool = false,
) -> IntegrationChecklist {
  {
    has_moonbit,
    has_node,
    has_phaser,
    exposes_global_phaser,
    builds_generated_js,
    imports_generated_js,
    smoke_test_passes,
  }
}

///|
pub fn IntegrationChecklist::complete() -> IntegrationChecklist {
  {
    has_moonbit: true,
    has_node: true,
    has_phaser: true,
    exposes_global_phaser: true,
    builds_generated_js: true,
    imports_generated_js: true,
    smoke_test_passes: true,
  }
}

///|
pub fn IntegrationChecklist::is_demo_ready(self : IntegrationChecklist) -> Bool {
  self.has_moonbit &&
  self.has_node &&
  self.has_phaser &&
  self.exposes_global_phaser &&
  self.builds_generated_js &&
  self.imports_generated_js
}

///|
pub fn IntegrationChecklist::is_release_ready(
  self : IntegrationChecklist,
) -> Bool {
  self.is_demo_ready() && self.smoke_test_passes
}

///|
pub(all) enum PackagePublicationState {
  PackageUnpublished
  PackagePendingAccount
  PackagePublished
} derive(Eq, @debug.Debug)

///|
pub fn PackagePublicationState::label(self : PackagePublicationState) -> String {
  match self {
    PackageUnpublished => "unpublished"
    PackagePendingAccount => "pending-account"
    PackagePublished => "published"
  }
}

///|
pub fn PackagePublicationState::matches_readme(
  self : PackagePublicationState,
) -> Bool {
  match self {
    PackagePublished => true
    PackagePendingAccount => true
    PackageUnpublished => true
  }
}
