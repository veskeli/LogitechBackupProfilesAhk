#NoEnv
#SingleInstance Force
;____________________________________________________________
;____________________________________________________________
;//////////////[variables]///////////////
SetWorkingDir %A_ScriptDir%
appfoldername = LogitechBackupProfilesAhk
version = 0.1
;____________________________________________________________
;____________________________________________________________
;//////////////[Gui]///////////////
Gui -MaximizeBox
Gui Add, Tab3, x0 y0 w408 h241, Home|Settings
Gui Tab, 1
Gui Font, s13
Gui Add, Button, x0 y32 w405 h41, Backup logitech GHub profiles
Gui Font
Gui Font, s14
Gui Add, Button, x0 y80 w404 h49, Load Backed up Profiles
Gui Font
Gui Tab, 2
Gui Add, CheckBox, x8 y32 w156 h23, Check updates on startup
Gui Add, GroupBox, x6 y134 w176 h95, Delete
Gui Add, Button, x16 y200 w154 h23, Delete all files
Gui Add, Button, x16 y176 w154 h23, Delete backup
Gui Add, Button, x16 y152 w155 h23, Delete app settings

Gui Show, w406 h237, LogitechBackupProfilesAhk
Return
;____________________________________________________________
;____________________________________________________________
;//////////////[Gui escape]///////////////
GuiEscape:
GuiClose:
    ExitApp
;____________________________________________________________
;____________________________________________________________
;//////////////[checkForupdates]///////////////
checkForupdates:
whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
whr.Open("GET", "https://raw.githubusercontent.com/veskeli/LogitechBackupProfilesAhk/master/Version.txt", False)
whr.Send()
whr.WaitForResponse()
newversion := whr.ResponseText
if(newversion != "")
{
    if(newversion != version)
    {
        MsgBox, 1,Update,New version is  %newversion% `nOld is %version% `nUpdate now?
        IfMsgBox, Cancel
        {
            ;temp stuff
        }
        else
        {
            ;Download update
            FileMove, %A_ScriptFullPath%, %A_ScriptDir%\%appfoldername%\%A_ScriptName%, 1
            sleep 1000
            UrlDownloadToFile, "https://raw.githubusercontent.com/veskeli/LogitechBackupProfilesAhk/master/LogitechBackupProfiles.ahk", %A_ScriptFullPath%
            Sleep 1000
			Run, %A_ScriptFullPath%
			ExitApp
        }
    }
}
btn_pressed_update = 0
return
;Check updates on start
AutoUpdates:
Gui, Submit, Nohide
FileCreateDir, %A_ScriptDir%\%appfoldername%\Settings
IniWrite, %checkup%, %A_ScriptDir%\%appfoldername%\Settings\Settings.ini, Settings, Updates
return