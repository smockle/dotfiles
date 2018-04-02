#!/usr/bin/env osascript
on run {theme}
  tell application "Terminal"
    set default settings to (first settings set whose name is theme)
    repeat with w from 1 to count windows
      repeat with t from 1 to count tabs of window w
        set current settings of tab t of window w to (first settings set whose name is theme)
      end repeat
    end repeat
  end tell
end run
