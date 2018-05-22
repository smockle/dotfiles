#!/usr/bin/env bash

# Global: Disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Global: Disable smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Global: Disable system sounds
defaults write com.apple.systemsound "com.apple.sound.uiaudio.enabled" -int 0

# Dock: Disable bouncing
defaults write com.apple.dock no-bouncing -bool true

# Dock: Minimize windows into application icon
defaults write com.apple.dock minimize-to-application -bool true

# Finder: Sort folders before files
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Finder: Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# then `killall Finder`

# Finder: Hide desktop icons
defaults write com.apple.finder CreateDesktop -bool false

# Finder: Customize keyboard shortcuts
defaults write com.apple.finder NSUserKeyEquivalents "{ 'Go to Folder...' = '@\$o'; 'Hide Sidebar' = '@\\\\'; 'Hide Status Bar' = '@~s'; 'Show Sidebar' = '@\\\\'; 'Show Status Bar' = '@~s'; }"

# Google Chrome: Use the system-native print preview dialog
defaults write com.google.Chrome DisablePrintPreview -bool true

# Safari: Press Tab to highlight each item on a web page
defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true
defaults write com.apple.SafariTechnologyPreview WebKitTabToLinksPreferenceKey -bool true
defaults write com.apple.SafariTechnologyPreview com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

# Safari: Show the full URL in the address bar
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
defaults write com.apple.SafariTechnologyPreview ShowFullURLInSmartSearchField -bool true

# Safari: Enable the Develop menu and the Web Inspector
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
defaults write com.apple.SafariTechnologyPreview IncludeDevelopMenu -bool true
defaults write com.apple.SafariTechnologyPreview WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.SafariTechnologyPreview com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Safari: Enable “Do Not Track”
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true
defaults write com.apple.SafariTechnologyPreview SendDoNotTrackHTTPHeader -bool true

# Screen Capture: Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Screen Capture: Save screenshots to ~/Downloads
defaults write com.apple.screencapture location ~/Downloads
# then run `killall SystemUIServer`

# Keyboard shortcuts:
# Command @
# Control ^
# Option  ~
# Shift   $
# Tab     \\U21e5

# General pattern:
# run `defaults write <x> NSUserKeyEquivalents "{ 'a' = 'b'; }"`
# then run `defaults read com.apple.universalaccess com.apple.custommenu.apps`
# if `<x>` is not present, run `defaults write com.apple.universalaccess com.apple.custommenu.apps -array-add "<x>"`

# Calendar: Clear time zone dropdown options
# defaults delete com.apple.iCal 'RecentlyUsedTimeZones'
