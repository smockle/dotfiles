-- applyrules.scpt
-- Applies Mail.app mail rules to all messages in the inbox, then restores previous windows and selections.

-- Remember the frontmost app
tell application "System Events" to set frontmostApplication to name of first process where it is frontmost

tell application "Mail"
  -- Launch and bring-to-front Mail.app, if necessary
  activate
  
  -- Create a Mail.app window, if necessary
  try
    id of first message viewer
  on error number -1719
    make new message viewer
    -- Remember windows created by this script, for later clean-up
    set tempMessageViewer to id of first message viewer
  end try
  
  -- Remember the previously-selected mailbox, for later clean-up
  set {selectedMailbox} to selected mailboxes of first message viewer
  
  -- Select the "Inbox" mailbox
  set selected mailboxes of first message viewer to inbox
end tell

tell application "System Events"
  tell process "Mail"
    tell menu bar 1
      -- Select all messages in the selected mailbox ("Inbox")
      tell menu bar item "Edit" to tell menu 1 to click menu item "Select All"
      
      -- Apply rules to selected messages (all)
      tell menu bar item "Message" to tell menu 1 to click menu item "Apply Rules"
    end tell
  end tell
end tell

tell application "Mail"
  -- Restore previously-selected mailbox
  set selected mailboxes of first message viewer to {selectedMailbox}
  
  -- Close windows created by this script
  try
    close (window of message viewer id tempMessageViewer)
  end try
end tell


tell application "System Events"
  -- Restore previous frontmost app
  try
    set frontmost of process frontmostApplication to true
  on error
    keystroke tab using command down
  end try
end tell