# MoonPhaserKit API

## Configuration

`GameConfig::new` creates a Phaser game setup for the JS backend. Width, height, parent element id, background color, Arcade gravity, and debug mode are intentionally the only supported options in v1.

`SpriteOptions::new` captures the common setup used after creating a sprite: scale, immovable flag, world-bound collision, bounce, and body-specific gravity.

## Scene Lifecycle

`Game::create(config, preload, create, update)` maps MoonBit callbacks onto Phaser's scene lifecycle:

- `preload`: load image assets.
- `create`: create sprites, text, input, colliders, and overlaps.
- `update`: run per-frame gameplay logic.

## Physics And Input

`Scene::add_sprite` creates an Arcade Physics sprite. `Scene::add_static_sprite` creates static terrain. `Scene::add_collider` handles physical collision and `Scene::add_overlap` handles collection or trigger logic.

`Scene::cursor_keys` exposes arrow-key input. Use `keys.key(Left).is_down()` and similar calls in `update`.

## Host Requirement

MoonPhaserKit expects Phaser to be available as `globalThis.Phaser`:

```js
import Phaser from "phaser";
globalThis.Phaser = Phaser;
await import("./generated/moon-jumper.js");
```
