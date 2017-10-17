// Future versions of Hyper may add additional config options,
// which will not automatically be merged into this file.
// See https://hyper.is#cfg for all currently supported options.

module.exports = {
  config: {
    // Choose either "stable" for receiving highly polished,
    // or "canary" for less polished but more frequent updates
    updateChannel: "stable",

    // The default size in pixels for the terminal
    fontSize: 11,

    // The font family to use with optional fallbacks
    fontFamily:
      '"Operator Mono", Menlo, "DejaVu Sans Mono", Consolas, "Lucida Console", monospace',

    // The font family to use for the UI with optional fallbacks
    // uiFontFamily: "-apple-system, BlinkMacSystemFont, Segoe UI, Roboto",

    // The color of the caret in the terminal
    cursorColor: "#D4D4D4",

    // The shape of the caret in the terminal. Available options are: 'BEAM', 'UNDERLINE', 'BLOCK'
    cursorShape: "BEAM",

    // If true, cursor will blink
    cursorBlink: true,

    // The color of the main text of the terminal
    foregroundColor: "#D4D4D4",

    // The color and opacity of the window and main terminal background
    backgroundColor: "#252B2E",

    // The color of the main window border and tab bar
    borderColor: "#333",

    // Custom CSS to include in the main window
    css: "",

    // Custom CSS to include in the terminal window
    termCSS:
      ".xterm {line-height: 15px} .xterm-rows > div {display: block; line-height: 13px}",

    // CSS padding values for the space around each term
    padding: "6px 8px",

    // A list of overrides for the color palette. The names of the keys represent the "ANSI 16", which can all be seen in the default config.
    colors: {
      black: "#7F7F7F",
      red: "#E15A60",
      green: "#99C794",
      yellow: "#FAC863",
      blue: "#6699CC",
      magenta: "#C594C5",
      cyan: "#5FB3B3",
      white: "#D4D4D4",
      lightBlack: "#7F7F7F",
      lightRed: "#E15A60",
      lightGreen: "#99C794",
      lightYellow: "#FAC863",
      lightBlue: "#6699CC",
      lightMagenta: "#C594C5",
      lightCyan: "#5FB3B3",
      lightWhite: "#FFFFFF"
    },

    // A path to a custom shell to run when Hyper starts a new session
    shell: "",

    // Override the npm registry URL to use when installing plugins
    // npmRegistry: "",

    // The default width/height in pixels of a new window e.g. [540, 380]
    // windowSize: null,

    // If true, selected text will automatically be copied to the clipboard
    // copyOnSelect: false,

    // System bell configuration. Available options are: "SOUND", false
    bell: false

    // The URL of the bell sound to use, used only if "bell" is set to "SOUND"
    // bellSoundURL: "lib-resource:hterm/audio/bell",

    // Change the behaviour of modifier keys to act as meta key
    // modifierKeys: { cmdIsMeta: false, altIsMeta: false },

    // Change the visibility of the hamburger menu. Available options are: true, false
    // showHamburgerMenu: "",

    // Change the position/visibility of the window controls. Available options are: true, false, "left"
    // showWindowControls: ""
  },

  // a list of plugins to fetch and install from npm
  // format: [@org/]project[#version]
  // examples:
  //   `hyperpower`
  //   `@company/project`
  //   `project#1.0.1`
  plugins: ["hyperterm-paste", "hyperlinks"],

  // in development, you can create a directory under
  // `~/.hyper_plugins/local/` and include it here
  // to load it and avoid it being `npm install`ed
  localPlugins: [],

  keymaps: {
    // Example
    // 'window:devtools': 'cmd+alt+o',
  }
};
