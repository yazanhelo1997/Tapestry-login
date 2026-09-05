; TapestryLogin.ahk
;
; Hotkeys:
;   Ctrl+R -> Auto-fills the currently focused login form with the
;             configured username/password (fills username, tabs to
;             password, submits).
;   Ctrl+S -> Prompts for a Tapestry Store IP and navigates to
;             https://IP:4443 (works in an empty, focused browser
;             address bar).
;   Ctrl+Q -> Navigates straight to the Kate Spade FortiManager console
;             (https://10.55.20.143/ui/dvm/main/cfg/366593/root/network/interface).
;   Ctrl+E -> Navigates straight to the Coach / Stuart Weitzman
;             FortiManager dashboard (https://172.30.230.65/ui/fmg_dashboard).
;
; NOTE: Storing a plaintext password in a script/exe is easy to recover
; (e.g. via `strings`). Consider pulling this from a protected local file
; instead of hardcoding it if that matters for your environment.

#SingleInstance Force
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

MsgBox, Tapestry Login Script is now running!`n`n`nHit Ctrl+R while a login form is focused to auto-fill credentials.`n`nHit Ctrl+S to enter a Store IP and navigate to it (https://IP:4443).`n`nHit Ctrl+Q to go straight to the Kate Spade FortiManager console.`n`nHit Ctrl+E to go straight to the Coach / Stuart Weitzman FortiManager dashboard.

; ---- CONFIG ----
Username := "admin"
Password := "Vo113yb@11!"
Port := "4443"
KateSpadeFortiManagerURL := "https://10.55.20.143/ui/dvm/main/cfg/366593/root/network/interface"
CoachSWFortiManagerURL := "https://172.30.230.65/ui/fmg_dashboard"

; Ctrl+R: fill username, tab to password field, fill password, then submit
^r::
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

; Ctrl+Q: go to the Kate Spade FortiManager console (network interface config page)
^q::
    Send ^a
    Send {BackSpace}
    SendInput {Raw}%KateSpadeFortiManagerURL%
    Send {Enter}
return

; Ctrl+E: go to the Coach / Stuart Weitzman FortiManager dashboard
^e::
    Send ^a
    Send {BackSpace}
    SendInput {Raw}%CoachSWFortiManagerURL%
    Send {Enter}
return
