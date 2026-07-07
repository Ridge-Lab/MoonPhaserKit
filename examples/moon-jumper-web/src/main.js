import Phaser from "phaser";
import "./styles.css";

globalThis.Phaser = Phaser;
window.Phaser = Phaser;

await import("./generated/moon-jumper.js");
