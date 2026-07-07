import { existsSync } from "node:fs";
import { resolve } from "node:path";
import { spawn } from "node:child_process";
import { chromium } from "@playwright/test";

const viteCli = resolve("node_modules/vite/bin/vite.js");
const server = spawn(process.execPath, [viteCli, "--host", "127.0.0.1", "--port", "4173"], {
  stdio: "inherit",
});

const wait = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

function isHarmlessMissingResource(url) {
  return url.endsWith("/favicon.ico");
}

async function launchBrowser() {
  try {
    return await chromium.launch({ headless: true });
  } catch (error) {
    const edge = "C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe";
    if (process.platform === "win32" && existsSync(edge)) {
      return chromium.launch({ headless: true, executablePath: edge });
    }
    throw error;
  }
}

try {
  await wait(3000);
  const browser = await launchBrowser();
  for (const viewport of [
    { width: 1200, height: 780 },
    { width: 390, height: 844 },
  ]) {
    const page = await browser.newPage({ viewport });
    const browserErrors = [];
    page.on("pageerror", (error) => browserErrors.push(error.message));
    page.on("console", (message) => {
      const text = message.text();
      if (
        message.type() === "error" &&
        !text.includes("favicon.ico") &&
        !text.startsWith("Failed to load resource:")
      ) {
        browserErrors.push(message.text());
      }
    });
    page.on("response", (response) => {
      const status = response.status();
      const url = response.url();
      if (status >= 400 && !isHarmlessMissingResource(url)) {
        browserErrors.push(`${status} ${url}`);
      }
    });
    await page.goto("http://127.0.0.1:4173", { waitUntil: "load" });
    await page.waitForSelector("canvas", { timeout: 10000 });
    await wait(500);
    const box = await page.locator("canvas").boundingBox();
    if (!box || box.width < 300 || box.height < 160) {
      throw new Error(`Canvas did not render at a useful size for ${viewport.width}px`);
    }
    if (viewport.width < 500 && box.width > viewport.width) {
      throw new Error("Canvas overflows the mobile viewport");
    }
    if (browserErrors.length > 0) {
      throw new Error(browserErrors.join("\n"));
    }
    await page.keyboard.down("ArrowRight");
    await wait(250);
    await page.keyboard.up("ArrowRight");
    await page.keyboard.press("ArrowUp");
    await page.mouse.click(box.x + box.width / 2, box.y + box.height / 2);
    await wait(150);
    await page.close();
  }
  await browser.close();
  console.log("Moon Jumper smoke test passed");
} finally {
  server.kill();
}
