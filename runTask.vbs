Dim shell,command
command = "powershell.exe -WindowStyle Hidden -NoLogo -NonInteractive -NoProfile -File C:\Users\csoare\work\PRSNL\timesheets\get-ScreenShot.ps1"
Set shell = CreateObject("WScript.Shell")
shell.Run command,0