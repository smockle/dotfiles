#!/usr/bin/env node
// @ts-check
const fs = require("fs");
const url = require("url");
const { URL } = url;
const json = require("comment-json");

function getSettings() {
  const path = new URL("settings.json", `file://${__dirname}`);
  const data = fs.readFileSync(path, { encoding: "utf-8" });
  if (!data) {
    return;
  }
  return json.parse(data, null, false);
}

function getThemeSettings(theme) {
  const path = new URL(`themes/${theme}.json`, `file://${__dirname}`);
  const data = fs.readFileSync(path, { encoding: "utf-8" });
  if (!data) {
    return;
  }
  return json.parse(data, null, false);
}

function setTheme(theme) {
  if (theme) {
    const settings = getSettings();
    if (settings["workbench.colorTheme"] !== theme) {
      const themeSettings =
        theme === "Default Light+"
          ? getThemeSettings("light+")
          : getThemeSettings("dark+");
      const nextSettings = { "workbench.colorTheme": theme, ...themeSettings };
      const data = json.stringify({ ...settings, ...nextSettings }, null, 2);
      const path = new URL("settings.json", `file://${__dirname}`);
      fs.writeFileSync(path, data, { encoding: "utf-8" });
    }
  }
}

setTheme(process.argv.slice(2)[0]);
