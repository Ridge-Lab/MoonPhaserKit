///|
pub(all) enum SceneControlAction {
  SceneStart
  SceneLaunch
  ScenePause
  SceneResume
  SceneStop
  SceneSleep
  SceneWake
} derive(Eq, @debug.Debug)

///|
pub fn SceneControlAction::label(self : SceneControlAction) -> String {
  match self {
    SceneStart => "start"
    SceneLaunch => "launch"
    ScenePause => "pause"
    SceneResume => "resume"
    SceneStop => "stop"
    SceneSleep => "sleep"
    SceneWake => "wake"
  }
}

///|
pub fn SceneControlAction::keeps_current_scene(self : SceneControlAction) -> Bool {
  match self {
    SceneLaunch => true
    ScenePause => true
    SceneSleep => true
    _ => false
  }
}

///|
pub(all) struct SceneControlCommand {
  action : SceneControlAction
  target_scene : String
} derive(Eq, @debug.Debug)

///|
pub fn SceneControlCommand::new(
  action : SceneControlAction,
  target_scene : String,
) -> SceneControlCommand {
  { action, target_scene }
}

///|
pub fn SceneControlCommand::is_valid(self : SceneControlCommand) -> Bool {
  self.target_scene.length() > 0
}

///|
pub fn SceneControlCommand::is_transition(self : SceneControlCommand) -> Bool {
  match self.action {
    SceneStart => true
    SceneLaunch => true
    _ => false
  }
}
