; --------------------------------------------------------------
; NOTES
; --------------------------------------------------------------
; ! = ALT
; ^ = CTRL
; + = SHIFT
; # = WIN
;
; Debug action snippet: MsgBox You pressed Control-A while Notepad is active.

#InstallKeybdHook
#SingleInstance force
SetTitleMatchMode 2
SendMode Input

; --------------------------------------------------------------
; Mac keyboard to Windows Key Mappings
; --------------------------------------------------------------

; New
#n::^n

; New Tab
#t::^t

; Open
#o::^o

; Refresh
#r::^r

; Close
#w::Send ^{F4}

; Quit
#q::Send !{F4}

; Tab Navigation
#[::^[
#]::^]
#+[::Send +^{Tab}
#+]::Send ^{Tab}

; Cursor Navigation
#Left::Send {Home}
#Right::Send {End}
#Up::Send ^{Home}
#Down::Send ^{End}

; Select
#+Left::Send +{Home}
#+Right::Send +{End}
#+Up::Send +^{Home}
#+Down::Send +^{End}

; Select All
#a::^a

; Cut
#x::^x

; Copy
#c::^c

; Paste
#v::^v

; Undo
#z::^z

; Redo
#y::^y

; Find
#f::Send {LCtrl down}{f}{LCtrl up}

; Find In Project
+#f::Send {LCtrl down}{LShift down}{f}{LShift up}{LCtrl up}

; Print
#p::^p

; Save
#s::^s

; Comment
#/::^/

; Uncomment
+#/::+^/

; Hide Sidebar
#\::^\

; Search (Spotlight)
#Space::Send {Lwin}s

; Task Manager
^!Delete::Send ^!{Delete}

; --------------------------------------------------------------
; Reverse Scrolling
; --------------------------------------------------------------

WheelUp::
Send {WheelDown}
Return

WheelDown::
Send {WheelUp}
Return

WheelLeft::
Send {WheelRight}
Return

WheelRight::
Send {WheelLeft}
Return

; --------------------------------------------------------------
; Application specific
; --------------------------------------------------------------

; Google Chrome
#IfWinActive, ahk_class Chrome_WidgetWin_1

; Show Web Developer Tools with cmd + alt + i
#!i::Send {F12}

#IfWinActive
