#NoEnv
#SingleInstance Force
;____________________________________________________________
;____________________________________________________________
;//////////////[variables]///////////////
SetWorkingDir %A_ScriptDir%
appfoldername = LogitechBackupProfilesAhk
version = 0.31
;____________________________________________________________
;____________________________________________________________
;//////////////[Gui]///////////////
Gui -MaximizeBox
Gui Add, Tab3, x0 y0 w408 h241, Home|Settings
Gui Tab, 1
Gui Font, s13
Gui Add, Button, x0 y32 w405 h41 gbackup, Backup logitech GHub profiles
Gui Font
Gui Font, s14
Gui Add, Button, x0 y80 w404 h49 gload, Load Backed up Profiles
Gui Font
;____________________________________________________
;settings
Gui Tab, 2
Gui Add, CheckBox, x8 y32 w156 h23 vcheckup gAutoUpdates, Check updates on startup
IfExist, %A_ScriptDir%\%appfoldername%\Settings\Settings.ini
{
    IniRead, t_checkup, %A_ScriptDir%\%appfoldername%\Settings\Settings.ini, Settings, Updates
	GuiControl,,checkup,%t_checkup%
}
Gui Add, GroupBox, x6 y134 w176 h95, Delete
Gui Add, Button, x16 y200 w154 h23 gDeleteAllFiles, Delete all files
Gui Add, Button, x16 y176 w154 h23 gDeleteBackups, Delete backups
Gui Add, Button, x16 y152 w155 h23 gDeleteAppSettings, Delete app settings

Gui Show, w406 h237, LogitechBackupProfilesAhk
;____________________________________________________________
;//////////////[Check for updates]///////////////
IfExist, %A_ScriptDir%\%appfoldername%\Settings\Settings.ini
{
    IniRead, t_checkup, %A_ScriptDir%\%appfoldername%\Settings\Settings.ini, Settings, Updates
    if(t_checkup == 1)
    {
        goto checkForupdates
    }
}
Return
;____________________________________________________________
;____________________________________________________________
;//////////////[Gui escape]///////////////
GuiEscape:
GuiClose:
    ExitApp
;____________________________________________________________
;____________________________________________________________
;//////////////[Backup and load]///////////////
backup:
MsgBox, not working yet
return
load:
MsgBox, backup not found
return
;____________________________________________________________
;____________________________________________________________
;//////////////[Delete files]///////////////
DeleteAllFiles:
MsgBox, 1,Are you sure?,All files will be deleted!, 15
IfMsgBox, Cancel
{
	return
}
else
{
    FileRemoveDir, %A_AppData%\%appfoldername%,1
    FileRemoveDir, %A_ScriptDir%\%appfoldername%,1
    ;Reset all settings when settings files are removed
    GuiControl,,checkup,0
}
return
DeleteAppSettings:
MsgBox, 1,Are you sure?,All files will be deleted!, 15
IfMsgBox, Cancel
{
	return
}
else
{
    FileRemoveDir, %A_AppData%\%appfoldername%\Settings,1
    FileRemoveDir, %A_ScriptDir%\%appfoldername%\Settings,1
    ;Reset all settings when settings files are removed
    GuiControl,,checkup,0
}
return
DeleteBackups:
MsgBox, There are no backups
return
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
            UrlDownloadToFile, https://raw.githubusercontent.com/veskeli/LogitechBackupProfilesAhk/master/LogitechBackupProfiles.ahk, %A_ScriptFullPath%
            Sleep 1000
            loop
            {
                IfExist %A_ScriptFullPath%
                {
                    Run, %A_ScriptFullPath%
                }
            }
			ExitApp
        }
    }
}
return
;Check updates on start
AutoUpdates:
Gui, Submit, Nohide
FileCreateDir, %A_ScriptDir%\%appfoldername%\Settings
IniWrite, %checkup%, %A_ScriptDir%\%appfoldername%\Settings\Settings.ini, Settings, Updates
return