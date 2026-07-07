import { copyFileSync, existsSync, mkdirSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { spawnSync } from "node:child_process";

const here = dirname(fileURLToPath(import.meta.url));
const demoRoot = resolve(here, "..");
const projectRoot = resolve(demoRoot, "..", "..");
const moonHome = process.env.MOON_HOME;
const moon = process.platform === "win32" ? "moon.exe" : "moon";

const env = {
  ...process.env,
  PATH: moonHome ? `${resolve(moonHome, "bin")}${process.platform === "win32" ? ";" : ":"}${process.env.PATH}` : process.env.PATH,
};

const result = spawnSync(moon, ["build", "--target", "js", "examples/moon-jumper"], {
  cwd: projectRoot,
  stdio: "inherit",
  env,
});

if (result.status !== 0) {
  process.exit(result.status ?? 1);
}

const built = resolve(
  projectRoot,
  "_build/js/debug/build/examples/moon-jumper/moon-jumper.js",
);
const builtMap = `${built}.map`;
const generated = resolve(demoRoot, "src/generated/moon-jumper.js");
const generatedMap = `${generated}.map`;
mkdirSync(dirname(generated), { recursive: true });

if (!existsSync(built)) {
  throw new Error(`MoonBit build output not found: ${built}`);
}

copyFileSync(built, generated);
if (existsSync(builtMap)) {
  copyFileSync(builtMap, generatedMap);
}
console.log(`Generated ${generated}`);
