; TapestryLogin.ahk
; Replicates two bookmarklet behaviors as a native AutoHotkey tool:
;   1) Ctrl+L  -> types the username/password into the currently focused
;                 fields (e.g. tab through a login form) instead of running JS.
;   2) Ctrl+S  -> prompts for a Tapestry Store IP and types the resulting
;                 URL (https://IP:4443) into the focused field (e.g. an
;                 empty browser address bar) and presses Enter.
;
; NOTE: Storing a plaintext password in a script/exe is easy to recover
; (e.g. via `strings`). Consider pulling this from a protected local file
; instead of hardcoding it if that matters for your environment.

#SingleInstance Force
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

MsgBox, Tapestry Login Script is now running!`n`n`nHit Ctrl+L while a login form's username field is focused (or a page is loaded) to auto-fill credentials.`n`nHit Ctrl+S to enter a Store IP and navigate to it (works in an empty, focused browser address bar).

; ---- CONFIG ----
Username := "admin"
Password := "Vo113yb@11!"
Port := "4443"

; Ctrl+L: fill username, tab to password field, fill password, then submit
^l::
    SendInput {Raw}%Username%
    Send {Tab}
    SendInput {Raw}%Password%
    Send {Enter}
return

; Ctrl+S: prompt for an IP, navigate to https://IP:4443
^s::
    InputBox, UserInput, Enter Tapestry Store IP, Enter Tapestry Store IP:, , 300, 130
    if ErrorLevel  ; user cancelled
        return
    UserInput := Trim(UserInput)
    ; strip any accidental scheme/path, mirroring the bookmarklet's regex cleanup
    UserInput := RegExReplace(UserInput, "^(https?://)?", "")
    UserInput := RegExReplace(UserInput, "/.*$", "")
    if (UserInput = "")
        return
    Send ^a           ; select-all in address bar
    Send {BackSpace}  ; clear it
    SendInput {Raw}https://%UserInput%:%Port%
    Send {Enter}
return
