;##############################################
;               Quick Chart Tool
;##############################################
;
; version 1.0
; by BART [BlockchianChaos]
;
; https://twitter.com/BlockchainChaos
; https://www.buymeacoffee.com/blockchainchaos
;
;##############################################

#NoEnv
#KeyHistory 0
#MenuMaskKey vkFF

CoordMode       , Mouse, Screen
Process         , Priority, , A
SetKeyDelay     , -1, -1
SetControlDelay , -1
SetBatchLines   , -1
SetMouseDelay   , -1
SetWinDelay     , -1
SendMode Input
ListLines Off

Menu, Tray, NoStandard

Menu, Tray, Icon, %A_ScriptDir%/icon/bcc.ico
Menu, Tray, Add, ..:: Made by BART [ainydG 2024] ::.., trayMenu
Menu, Tray, Icon, ..:: Made by BART [ainydG 2024] ::.., %A_ScriptDir%/icon/bcc.ico
Menu, Tray, Add,
Menu, Tray, Add, ..:: My X ::.., trayMenu
Menu, Tray, Icon, ..:: My X ::.., %A_ScriptDir%/icon/x.ico
Menu, Tray, Add, ..:: Donation ::.., trayMenu
Menu, Tray, Icon, ..:: Donation ::.., %A_ScriptDir%/icon/bmc.ico
Menu, Tray, Add,
Menu, Tray, Add, Reload, trayMenu
Menu, Tray, Add, Quit, trayMenu


if !FileExist("config.ini")
{   IniWrite, binance, config.ini, Exchange, Exchange
    IniWrite, light, config.ini, Theme, Theme

_t := ["BTC","ETH","RUNE","OCEAN","DOT","DOGE","ATOM","OP","LTC","XRP"]
_i := ["3m","15m","1H","4H","1D","1W"]
_n := 1

Loop 10
{   IniWrite, % _t[_n], config.ini, Ticker, % "Ticker" _n
    if (_n <= 6) 
    {   IniWrite, % _i[_n], config.ini, Interval, % "Interval" _n
    }
    _n++
    }
}

IniRead, ex, config.ini, Exchange, Exchange
IniRead, theme, config.ini, Theme, Theme

_n := 1
Loop 10
{   IniRead, __t%_n%, config.ini, Ticker, % "Ticker" _n
    if (_n <= 6)
    {   IniRead, __i%_n%, config.ini, Interval, % "Interval" _n
    }
    _n++
}

distance := 50 ; How far holding pressed RButton mouse must be move to active mouse gesture [to activate mouse gestures you have to hold down the RMButton]
delay    := 400 ; How long RButton must be pressed to get Trading View Settings 
switcher := True

fCol := theme = "light" ? "c000000" : "cC6C6C6"
bgCol := theme = "light" ? "cFFFFFF" : "c131722"

ex := ex = "binance" ? "binance:" : "bybit:"

Gui, t:+AlwaysOnTop -SysMenu -Caption +ToolWindow +E0x8000000 +DPIScale
Gui, t:Font, % "q6" "s11" fCol, Consolas
Gui, t:Color, % bgCol
Gui, t:Margin, 0, 3

Gui, t:Add, Text, 0x201 Center +BackgroundTrans Section w55 h20 x0 y3 g_t, % __t1
_n := 2
Loop 9
    {   Gui, t:Add, Text, 0x201 Center +BackgroundTrans +Border w1 h10 x+0 ys+5,
        Gui, t:Add, Text, 0x201 Center +BackgroundTrans w55 h20 x+0 ys+0 g_t, % __t%_n%
        _n++
    }

Gui, i:+AlwaysOnTop -SysMenu -Caption +ToolWindow +E0x8000000 +DPIScale
Gui, i:Font, % "q6" "s11" fCol, Consolas
Gui, i:Color, % bgCol
Gui, i:Margin, 0, 3

Gui, i:Add, Text, 0x201 Center +BackgroundTrans Section w40 h20 x0 y3 g_i,% __i1
_n := 2
Loop 5
    {   Gui, i:Add, Text, 0x201 Center +BackgroundTrans +Border w1 h10 x+0 ys+5,
        Gui, i:Add, Text, 0x201 Center +BackgroundTrans w40 h20 x+0 ys+0 g_i,% __i%_n%
        _n++
    }

Gui, m:+AlwaysOnTop -SysMenu -Caption +ToolWindow +E0x8000000 +DPIScale 
Gui, m:Font, % "q5" "s8" "Bold" fCol, Consolas
Gui, m:Color, % bgCol
Gui, m:Margin, 0, 0

    Gui, m:Add, Text, 0x201 +BackgroundTrans Section x0 y0 w40 h26 g_menu vrChart, RESET ; Reset chart view
    Gui, m:Add, Text, 0x201 Center +BackgroundTrans +Border w1 h10 x+0 ys+8,
    Gui, m:Add, Text, 0x201 +BackgroundTrans x+0 y0 w40 h26 g_menu vsShot, SNAP ; Chart Snapshot [Copy img]
    Gui, m:Add, Text, 0x201 Center +BackgroundTrans +Border w1 h10 x+0 ys+8,
    Gui, m:Add, Text, 0x201 +BackgroundTrans x+0 y0 w40 h26 g_menu vhChart, HIDE ; Hide all drawing 35

GoSub, _init
Return 

#if WinActive("ahk_exe TradingView.exe")

~LButton::
SetBatchLines, 0
if (degre45)
{   while GetKeyState("LButton", "P")
    {   if (switcher)
        {   Sleep, 10
            SendInput, {ShiftDown}
            switcher := !switcher
        }
    }
    Click
    Sleep, 10
    SendInput, {ShiftUp}
    degre45 := !degre45
    switcher := True
}

if (unClick) 
{   while GetKeyState("LButton", "P")
    {   if (switcher)
        {   Sleep, 10
            switcher := !switcher
        }
    }
    Click
    unClick := !unClick
    switcher := True
}
SetBatchLines, -1
Return

MButton::
SetBatchLines, 0
while GetKeyState("MButton", "P") 
{   if (switcher) 
    {   MouseGetPos, _mX, _mY
        Gui, t:Show, % "x" _mX-_fW "y" cSpacingTop := ((_mY-iH)-iH)-5 "AutoSize" "NoActivate", fav ; 5 is min value
        Gui, i:Show, % "x" _mX-_iW "y" cSpacingBottom := (_mY+iH)+5 "AutoSize" "NoActivate", int ;5 is min value
        Gui, m:Show, % "x" intSpacing := ((_mX-_iW)+iW)+10 "y" cSpacingBottom "AutoSize" "NoActivate", rsh
        switcher := !switcher
    }
}
SendInput, {LButton}
Sleep, 10
Gui, t:Hide
Gui, i:Hide
Gui, m:Hide
switcher := True
SetBatchLines, -1
Return

RButton::
SendInput, {Esc}
MouseGetPos, oldX, oldY

while GetKeyState("RButton", "P") 
{   MouseGetPos, newX, newY
    Switch 
    {   case newY < oldY - distance: ; Mouse Gesture UP
        mouseRestore(oldX, oldY)       
        SendInput, !t
        degre45 := True
        Break
                
        case newX > oldX + distance: ; Mouse Gesture Right
        mouseRestore(oldX, oldY)
        SendInput, !t
        unClick := True
        Break

        case newY > oldY + distance: ; Mouse Gesture Down
        mouseRestore(oldX, oldY)
        Sleep, 80
        SendInput, {LButton}{Delete}
        Break

        case newX < oldX - distance: ; Mouse Gesture Left
        mouseRestore(oldX, oldY)
        SendInput, !j
        Break

        case A_TimeIdle >= delay: ; Mouse idle to RButton
        SendInput, {RButton}
        Break
    }
}
Sleep, 200
BlockInput, MouseMoveOff
Return

XButton1::SendInput, {ShiftDown}{LButton}{ShiftUp} ; Measure [if extra button on mouse] 
!q::SendInput, {LButton}{Delete} ; Erase [ALT+q]

_i:
StringCaseSense, On
SendInput, % __i := StrReplace(A_GuiControl, "m", "") "{Enter}"
StringCaseSense, Off
Return

_t:
__t := A_GuiControl
if (__t = "bonk" || __t = "pepe" || __t = "shib" || __t = "rats" || __t = "sats" || __t = "lunc" || __t = "floki" || __t = "xec") 
{   SendInput, % ex . "1000" . __t . "usdt.p"
    Sleep, 10
    SendInput, {Enter}
}
Else
{   SendInput, % ex . __t . "usdt.p"
    Sleep, 10
    SendInput, {Enter}
}
Return

_menu:
Sleep, 10
Switch A_GuiControl 
{   Case "rChart":SendInput, !r
    Case "sShot" :SendInput, ^+s
    Case "hChart":
    SendInput, ^!h
    if !(_h)
        {   GuiControl,, hChart, SHOW
            _h := True
        }
    Else
        {   GuiControl,, hChart, HIDE
            _h := !_h
        }
}
Return

_init:
Gui, t:Show, Hide x-30000 y-30000 AutoSize NoActivate, _fav
Gui, i:Show, Hide x-30000 y-30000 AutoSize NoActivate, _int

WinGetPos,,, fW, fH, _fav
WinGetPos,,, iW, iH, _int

_fW := fW / 2
_iW := (iW / 2) + 69
Return

mouseRestore(_x, _y) 
{   BlockInput, MouseMove
    MouseMove, _x, _y
    Sleep, 50
}
Return

trayMenu:
Switch 
{   case A_ThisMenuItem = "..:: My X ::..": Run, https://twitter.com/BlockchainChaos
    case A_ThisMenuItem = "..:: Donation ::..": Run, https://www.buymeacoffee.com/blockchainchaos
    case A_ThisMenuItem = "Reload": Reload
    case A_ThisMenuItem = "Quit": ExitApp
}
Return
