;; Quake-Windows-Terminal AutoHotkey.

;; Inspired from https://github.com/ehpc/quake-windows-bash
;; and https://github.com/rengler33/dotfiles/blob/master/C/Users/Rub/wt-quake-like.ahk


#SingleInstance force

WindowsTerminal = C:\Users\%A_UserName%\AppData\Local\Microsoft\WindowsApps\wt.exe

GetActiveMonitor()
{
	Coordmode, Mouse, Screen
	MouseGetPos, MouseX, MouseY
	SysGet, numberOfMonitors, MonitorCount
	Loop, %numberOfMonitors%
	{
		SysGet, monitor%A_Index%, Monitor, %A_Index%

		if ( MouseX >= monitor%A_Index%left ) && ( MouseX < monitor%A_Index%right ) && ( MouseY >= monitor%A_Index%top ) && ( MouseY < monitor%A_Index%bottom )
		{
			ActiveMonitor := A_Index
			break
		}
	}
	ActiveMonitor--
	return ActiveMonitor
}

GetTerminalMonitor()
{
    WinActivate, ahk_exe Terminal
    WinGetPos, WindowXpos, WindowYpos
    SysGet, farLeftMonitorX, 76
    
    if ( WindowXpos >= farLeftMonitorX + 2 * A_ScreenWidth)
    {
        position := 2
    }
    else if ( WindowXpos >= farLeftMonitorX + A_ScreenWidth)
    {
        position := 1
    }
    else if ( WindowXpos <= (farLeftMonitorX + A_ScreenWidth))
    {
        position := 0
    }
    return position
}

CalcNewXPosition(activeMonitor, terminalMonitor, window)
{
    WinActivate, ahk_exe Terminal
    WinGetPos, WindowXpos, WindowYpos
    distance := A_ScreenWidth * (activeMonitor - terminalMonitor)
    moveToX := WindowXpos + distance
    return moveToX
}

^^::  ; On CTRL+^ press

    WinGet, windows, List,
    SetTitleMatchMode RegEx

    if WinExist("ahk_exe Terminal")
        if WinActive("ahk_exe Terminal")
            {
                WinMinimize, ahk_exe Terminal
            }
        else
            {
                moveToX := CalcNewXPosition(GetActiveMonitor(), GetTerminalMonitor(), ahk_exe Terminal)
                WinMove %moveToX%, %Ypos%
            }
    else
        Run, %WindowsTerminal%

Return