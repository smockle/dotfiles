#!/usr/bin/env bash

# Global: Disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Global: Disable smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Global: Disable system sounds
defaults write com.apple.systemsound "com.apple.sound.uiaudio.enabled" -int 0

# Calendar: Clear time zone dropdown options
defaults delete ~/Library/Containers/com.apple.iCal/Data/Library/Preferences/com.apple.iCal.plist 'RecentlyUsedTimeZones'

# Dock: Disable bouncing
defaults write com.apple.dock no-bouncing -bool true

# Dock: Minimize windows into application icon
defaults write com.apple.dock minimize-to-application -bool true

# Dock: Size
defaults write com.apple.dock tilesize -int 42

# Finder: Sort folders before files
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Finder: Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: Hide desktop icons
defaults write com.apple.finder CreateDesktop -bool false

# Finder: Customize keyboard shortcuts
defaults write com.apple.finder NSUserKeyEquivalents "{ 'Go to Folder...' = '@\$o'; 'Hide Sidebar' = '@\\\\'; 'Hide Status Bar' = '@~s'; 'Show Sidebar' = '@\\\\'; 'Show Status Bar' = '@~s'; }"

# Firewall: Enable
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1

# Google Chrome: Use the system-native print preview dialog
defaults write com.google.Chrome DisablePrintPreview -bool true

# Mail: Only receive notifications from VIPs
defaults write ~/Library/Containers/com.apple.mail/Data/Library/Preferences/com.apple.mail.plist MailUserNotificationScope -int 2
# Create a new smart mailbox named "VIPs" with "Sender is VIP" AND "Message is unread"
# defaults write ~/Library/Containers/com.apple.mail/Data/Library/Preferences/com.apple.mail.plist MailDockBadgeMailbox smartmailbox://SOME-LETTERS-AND-NUMBERS

# Mail: View newest message in threads first
defaults write ~/Library/Containers/com.apple.mail/Data/Library/Preferences/com.apple.mail.plist ConversationViewSortDescending -bool true

# Safari: Press Tab to highlight each item on a web page
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari.plist WebKitTabToLinksPreferenceKey -bool true
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari.plist com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

# Safari: Show the full URL in the address bar
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari.plist ShowFullURLInSmartSearchField -bool true

# Safari: Enable the Develop menu and the Web Inspector
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari.plist IncludeDevelopMenu -bool true
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari.plist WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari.plist com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Safari: Enable “Do Not Track”
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari.plist SendDoNotTrackHTTPHeader -bool true

# Safari: Clear downloads on success
defaults write ~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari.plist DownloadsClearingPolicy -int 2

# Screen Capture: Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Screen Capture: Save screenshots to ~/Downloads
defaults write com.apple.screencapture location ~/Downloads

# Spotlight: Disable some categories
defaults write com.apple.spotlight orderedItems -array \
	'{"enabled" = 1;"name" = "APPLICATIONS";}' \
	'{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
	'{"enabled" = 1;"name" = "DIRECTORIES";}' \
	'{"enabled" = 1;"name" = "PDF";}' \
	'{"enabled" = 1;"name" = "FONTS";}' \
	'{"enabled" = 1;"name" = "DOCUMENTS";}' \
	'{"enabled" = 0;"name" = "MESSAGES";}' \
	'{"enabled" = 0;"name" = "CONTACT";}' \
	'{"enabled" = 0;"name" = "EVENT_TODO";}' \
	'{"enabled" = 1;"name" = "IMAGES";}' \
	'{"enabled" = 0;"name" = "BOOKMARKS";}' \
	'{"enabled" = 0;"name" = "MUSIC";}' \
	'{"enabled" = 0;"name" = "MOVIES";}' \
	'{"enabled" = 1;"name" = "PRESENTATIONS";}' \
	'{"enabled" = 1;"name" = "SPREADSHEETS";}' \
	'{"enabled" = 1;"name" = "SOURCE";}' \
	'{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
	'{"enabled" = 0;"name" = "MENU_OTHER";}' \
	'{"enabled" = 1;"name" = "MENU_CONVERSION";}' \
	'{"enabled" = 1;"name" = "MENU_EXPRESSION";}' \
	'{"enabled" = 1;"name" = "MENU_WEBSEARCH";}' \
	'{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'

# Spotlight:
# - Load new settings before rebuilding the index
# - Make sure indexing is enabled for the main volume
# - Rebuild the index from scratch
killall mds > /dev/null 2>&1
sudo mdutil -i on / > /dev/null
sudo mdutil -E / > /dev/null

# Restart other apps
for app in "Dock" "Finder" "SystemUIServer" "Mail"; do
    killall "$app" > /dev/null 2>&1
done

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
