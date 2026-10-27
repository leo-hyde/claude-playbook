#!/usr/bin/env node
// The measurable part of a design review, so screenshots are only needed for judgement.
//   node tools/page-check.js <page address or file> [output folder]
// At phone (375px) and desktop (1280px) width, in light and dark, it checks:
// nothing wider than the screen, tap targets at least 44px (24px on desktop), inputs at least 16px
// text (smaller makes iPhones zoom in), and runs axe-core (a free accessibility
// checker) in light and dark. It saves a screenshot of each, and the full results
// as report.json, in the output folder (default: ./page-check). It prints a short
// summary only.
// Needs Node.js and Playwright (cloud sessions have both; the Mac usually doesn't:
// then say the check was skipped). Each run loads the page 4 times: point it at a
// local preview with made-up data, not a page that uses a free service's daily limit.
const fs = require("fs");
const path = require("path");

// axe-core 4.13.0 (MPL-2.0 licence). Fetched with curl (which uses the session's
// proxy settings) from the first source that works, then kept in the temp folder.
const AXE_VERSION = "4.13.0";
const AXE_SOURCES = [
  "curl -sSfL https://cdnjs.cloudflare.com/ajax/libs/axe-core/" + AXE_VERSION + "/axe.min.js",
  "curl -sSfL https://cdn.jsdelivr.net/npm/axe-core@" + AXE_VERSION + "/axe.min.js",
  "curl -sSfL https://registry.npmjs.org/axe-core/-/axe-core-" + AXE_VERSION + ".tgz | tar -xzO package/axe.min.js",
];
const SIZES = [["phone", 375, 812], ["desktop", 1280, 900]];
const SCHEMES = ["light", "dark"];

async function main() {
  const target = process.argv[2];
  if (!target) {
    console.error("Usage: node tools/page-check.js <page address or file> [output folder]");
    process.exit(2);
  }
  const url = /^[a-z]+:\/\//i.test(target) ? target : "file://" + path.resolve(target);
  const out = path.resolve(process.argv[3] || "page-check");
  fs.mkdirSync(out, { recursive: true });
  let chromium;
  try {
    ({ chromium } = require("playwright"));
  } catch (e) {
    console.log("SKIPPED: Playwright isn't installed here (usual on the Mac). Say the page check was skipped.");
    return;
  }
  const browser = await chromium.launch();
  const report = { url, runs: [] };
  let problems = 0;
  for (const [name, width, height] of SIZES) {
    for (const scheme of SCHEMES) {
      const page = await browser.newPage({ viewport: { width, height }, colorScheme: scheme });
      const run = { size: name, width, scheme };
      let response = null;
      try {
        response = await page.goto(url, { waitUntil: "networkidle", timeout: 20000 });
      } catch (e) {
        // networkidle can time out on a page that keeps polling; it may still have loaded.
        run.load = "slow: " + e.message.split("\n")[0];
      }
      let measured = null;
      try {
        if (response && !response.ok()) throw new Error("the address answered " + response.status());
        measured = await page.evaluate(measure, name === "phone");
      } catch (e) {
        run.failed = e.message.split("\n")[0];
      }
      if (!measured) {
        report.runs.push(run);
        await page.close();
        continue;
      }
      Object.assign(run, measured);
      const shot = path.join(out, name + "-" + scheme + ".png");
      await page.screenshot({ path: shot, fullPage: true });
      run.screenshot = shot;
      if (name === "phone") run.axe = await axe(page);
      report.runs.push(run);
      await page.close();
    }
  }
  await browser.close();
  fs.writeFileSync(path.join(out, "report.json"), JSON.stringify(report, null, 2));

  console.log("Page check: " + url);
  if (report.runs.every((r) => r.failed)) {
    console.log("COULD NOT LOAD " + url + ": " + report.runs[0].failed);
    console.log("Nothing was measured. Say so in the review (a local copy may work where the address doesn't).");
    process.exitCode = 1;
    return;
  }
  for (const r of report.runs) {
    if (r.failed) { console.log("- " + r.size + " " + r.scheme + ": COULD NOT LOAD (" + r.failed + ")"); problems++; continue; }
    const lines = [];
    if (r.load) lines.push("page load " + r.load);
    if (r.overflow) lines.push("WIDER THAN THE SCREEN: " + r.scrollWidth + "px on a " + r.width + "px screen (widest: " + r.widest.join(", ") + ")");
    if (r.smallTargets.length) lines.push(r.smallTargets.length + " tap targets under " + (r.size === "phone" ? 44 : 24) + "px: " + r.smallTargets.slice(0, 4).join("; "));
    if (r.smallInputs.length) lines.push(r.smallInputs.length + " inputs under 16px text: " + r.smallInputs.slice(0, 3).join("; "));
    if (r.axe && r.axe.skipped) lines.push("accessibility check skipped: " + r.axe.skipped);
    if (r.axe && r.axe.violations) {
      for (const v of r.axe.violations) lines.push("accessibility (" + v.impact + "): " + v.help + " [" + v.id + ", " + v.count + "x, e.g. " + v.example + "]");
    }
    problems += lines.filter((l) => !l.startsWith("page load") && !l.startsWith("accessibility check skipped")).length;
    console.log("- " + r.size + " " + r.scheme + ": " + (lines.length ? "\n    " + lines.join("\n    ") : "OK"));
  }
  console.log("Accessibility (axe-core) runs at phone width only, light and dark.");
  console.log("Screenshots and report.json in " + out);
  console.log("PROBLEMS: " + problems);
}

// Runs inside the page.
function measure(isPhone) {
  const minTarget = isPhone ? 44 : 24;  // phones: Apple's 44pt; desktop: WCAG 2.2's 24px
  const doc = document.documentElement;
  const label = (el) => {
    const t = (el.innerText || el.value || el.getAttribute("aria-label") || "").trim().replace(/\s+/g, " ").slice(0, 30);
    return el.tagName.toLowerCase() + (el.id ? "#" + el.id : "") + (t ? ' "' + t + '"' : "");
  };
  const visible = (el) => {
    const r = el.getBoundingClientRect(), s = getComputedStyle(el);
    return r.width > 0 && r.height > 0 && s.visibility !== "hidden" && s.display !== "none";
  };
  const widest = [];
  if (doc.scrollWidth > window.innerWidth) {
    for (const el of document.body.querySelectorAll("*")) {
      if (el.getBoundingClientRect().right > window.innerWidth + 1) widest.push(label(el));
      if (widest.length >= 3) break;
    }
  }
  const smallTargets = [];
  for (const el of document.querySelectorAll("a[href], button, input, select, textarea, summary, [role=button], [onclick]")) {
    if (!visible(el) || el.type === "hidden") continue;
    // Links inside a sentence are exempt (WCAG 2.2 target size), and so is a box whose label is tappable.
    if (el.tagName === "A" && el.closest("p, li") && el.closest("p, li").innerText.trim() !== el.innerText.trim()) continue;
    if ((el.type === "checkbox" || el.type === "radio") && el.closest("label")) continue;
    const r = el.getBoundingClientRect();
    if (r.width < minTarget || r.height < minTarget) smallTargets.push(label(el) + " " + Math.round(r.width) + "x" + Math.round(r.height));
  }
  const smallInputs = [];
  if (isPhone) {
    for (const el of document.querySelectorAll("input, select, textarea")) {
      if (visible(el) && el.type !== "checkbox" && el.type !== "radio" && parseFloat(getComputedStyle(el).fontSize) < 16) {
        smallInputs.push(label(el) + " " + getComputedStyle(el).fontSize);
      }
    }
  }
  return { scrollWidth: doc.scrollWidth, overflow: doc.scrollWidth > window.innerWidth, widest, smallTargets, smallInputs };
}

function axeSource() {
  const cached = path.join(require("os").tmpdir(), "axe-core-" + AXE_VERSION + ".min.js");
  if (fs.existsSync(cached) && fs.statSync(cached).size > 100000) return fs.readFileSync(cached, "utf8");
  for (const cmd of AXE_SOURCES) {
    try {
      const js = require("child_process").execSync(cmd, { stdio: ["ignore", "pipe", "ignore"], maxBuffer: 1 << 24 }).toString();
      if (js.length > 100000 && js.includes("axe")) { fs.writeFileSync(cached, js); return js; }
    } catch (e) { /* try the next source */ }
  }
  return null;
}

async function axe(page) {
  const js = axeSource();
  if (!js) return { skipped: "couldn't download axe-core (no internet, or cdnjs, jsdelivr and npm are all blocked)" };
  try {
    await page.addScriptTag({ content: js });
  } catch (e) {
    return { skipped: "the page wouldn't run axe-core (" + e.message.split("\n")[0] + ")" };
  }
  const result = await page.evaluate(async () => {
    const r = await window.axe.run(document, { runOnly: { type: "tag", values: ["wcag2a", "wcag2aa", "wcag21a", "wcag21aa", "wcag22aa"] } });
    return r.violations.map((v) => ({ id: v.id, impact: v.impact, help: v.help, count: v.nodes.length, example: (v.nodes[0] && v.nodes[0].target.join(" ")) || "" }));
  });
  return { violations: result };
}

main().catch((e) => { console.error("Page check failed: " + e.message); process.exit(1); });
