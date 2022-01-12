classname = ""
keystate = ""

*Capslock::
  WinGetClass, classname, A
  if (classname = "Vim")
  {
    SetCapsLockState, Off
    Send, {ESC}
  }
  else if (classname = "WindowsTerminal")
  {
    SetCapsLockState, Off
    Send, {ESC}
  }
  else
  {
    GetKeyState, keystate, CapsLock, T
    if (keystate = "D")
      SetCapsLockState, Off
    else
      SetCapsLockState, On
    return
  }
  return