///|
test "phaser version compatibility documents the supported runtime window" {
  let pinned = @moonphaserkit.PhaserVersion::pinned()
  assert_eq(pinned.to_string(), "3.90.0")
  assert_true(pinned.is_supported())
  assert_true(pinned.is_phaser3())
  assert_false(@moonphaserkit.PhaserVersion::new(4, 0, 0).is_supported())
  assert_false(@moonphaserkit.PhaserVersion::new(3, 40, 0).is_supported())
}

///|
test "moonbit backend compatibility is intentionally js only" {
  assert_true(@moonphaserkit.BackendJavaScript.is_supported())
  assert_false(@moonphaserkit.BackendWasm.is_supported())
  assert_false(@moonphaserkit.BackendNative.is_supported())
  assert_eq(@moonphaserkit.BackendJavaScript.label(), "javascript")
}

///|
test "runtime compatibility summarizes host requirements" {
  let runtime = @moonphaserkit.RuntimeCompatibility::new()
  assert_true(runtime.is_supported())
  assert_eq(runtime.support_summary(), "javascript + Phaser 3.90.0 + chromium")
  let unsupported = @moonphaserkit.RuntimeCompatibility::new(
    backend=@moonphaserkit.BackendWasm,
  )
  assert_false(unsupported.is_supported())
}

///|
test "browser targets model audio unlock expectations" {
  assert_true(@moonphaserkit.BrowserChromium.supports_audio_unlock())
  assert_true(@moonphaserkit.BrowserSafari.supports_audio_unlock())
  assert_false(@moonphaserkit.BrowserUnknown.supports_audio_unlock())
  assert_eq(@moonphaserkit.BrowserEdge.label(), "edge")
}

///|
test "integration steps and checklist describe project integration" {
  let install = @moonphaserkit.IntegrationStep::new(
    @moonphaserkit.IntegrationInstallPhaser,
    "Install phaser@3.90.0",
  )
  assert_true(install.is_valid())
  assert_true(install.required_for_demo)
  let publish = @moonphaserkit.IntegrationStep::for_package_publish()
  assert_true(publish.required_for_package)
  assert_false(publish.required_for_demo)
  assert_eq(@moonphaserkit.IntegrationRunSmokeTest.label(), "run-smoke-test")
}

///|
test "integration checklist separates demo readiness from release readiness" {
  let checklist = @moonphaserkit.IntegrationChecklist::new(
    has_moonbit=true,
    has_node=true,
    has_phaser=true,
    exposes_global_phaser=true,
    builds_generated_js=true,
    imports_generated_js=true,
    smoke_test_passes=false,
  )
  assert_true(checklist.is_demo_ready())
  assert_false(checklist.is_release_ready())
  assert_true(
    @moonphaserkit.IntegrationChecklist::complete().is_release_ready(),
  )
}

///|
test "publication state labels keep README wording explicit" {
  assert_eq(@moonphaserkit.PackageUnpublished.label(), "unpublished")
  assert_eq(@moonphaserkit.PackagePendingAccount.label(), "pending-account")
  assert_eq(@moonphaserkit.PackagePublished.label(), "published")
  assert_true(@moonphaserkit.PackagePublished.matches_readme())
}
