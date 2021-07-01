#NoEnv
#SingleInstance Force
;____________________________________________________________
;____________________________________________________________
;//////////////[variables]///////////////
SetWorkingDir %A_ScriptDir%
LGHUBfolder_f = C:\Users\%A_UserName%\AppData\Local\LGHUB
ScriptName = LogitechBackupProfiles
appfoldername = LogitechBackupProfilesAhk
appfolder_f = %A_AppData%\%appfoldername%
backupfolder_f = %A_AppData%\%appfoldername%\Backups
settingsfolder_f = %A_AppData%\%appfoldername%\Settings
settingsini_ini = %settingsfolder_f%\Settings.ini
update_temp_file = %A_AppData%\%appfoldername%\temp\OldFile.ahk
;Backups
Backup_current = 1
Backups_max = 2
version = 0.51
;set global variables
global LGHUBfolder_f
global appfoldername
global appfolder_f
global backupfolder_f
global settingsfolder_f
global settingsini_ini
global Backup_current
global Backups_max
global update_temp_file
IfExist %update_temp_file% 
{
    FileDelete, %update_temp_file% ;delete old file after update
} 
IfExist %A_AppData%\%appfoldername%\temp\LogitechBackupProfilesAhkOld.ahk 
{
    FileDelete, %A_AppData%\%appfoldername%\temp\LogitechBackupProfilesAhkOld.ahk ;check for before 0.5 file
}
IfExist %A_AppData%\%appfoldername%\LogitechBackupProfiles.ahk 
{
    FileDelete, %A_AppData%\%appfoldername%\LogitechBackupProfiles.ahk ;check for before 0.5 file
}
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
IfExist, %settingsini_ini%
{
    IniRead, t_checkup, %settingsini_ini%, Settings, Updates
	GuiControl,,checkup,%t_checkup%
}
Gui Add, GroupBox, x6 y134 w176 h95, Delete
Gui Add, Button, x16 y200 w154 h23 gDeleteAllFiles, Delete all files
Gui Add, Button, x16 y176 w154 h23 gDeleteBackups, Delete backups
Gui Add, Button, x16 y152 w155 h23 gDeleteAppSettings, Delete app settings
Gui Add, Text, x192 y208 w205 h23 +0x200, Version = %version%
Gui Add, Button, x197 y152 w90 h38 gOpenBackupFolder, Open backup folder ; open
Gui Add, Button, x288 y152 w90 h38 gOpenLGHUBFolder, Open Logitech folder
;Backup settings
Gui Add, GroupBox, x7 y50 w170 h80, Backup settings
Gui Add, Text, x15 y71 w75 h23 +0x200, Max Backups:
Gui Add, DropDownList, +Disabled x94 y70 w60,  1||2
Gui Add, Button, x280 y25 w120 h40 gShortcut_to_desktop , Create shortcut to desktop
Gui Font, s11
Gui Add, Button, x197 y99 w181 h51 gRestoreLast, Restore old GHUB files(accidentally pressed load)

Gui Show, w406 h237, LogitechBackupProfilesAhk
;____________________________________________________________
;//////////////[Check for updates]///////////////
IfExist, %settingsini_ini%
{
    IniRead, t_checkup, %settingsini_ini%, Settings, Updates
    if(t_checkup == 1)
    {
        goto checkForupdates
    }
}
;____________________________________________________________
;//////////////[check for old version files (used by this script before 0.49)]///////////////
IfExist %A_ScriptDir%\%appfoldername%
{
    FileMoveDir, %A_ScriptDir%\%appfoldername% , %appfolder_f%  ;move all settings and backups to appdata
}
IfExist %backupfolder_f%\LGHUB
{
    FileMoveDir, %backupfolder_f%\LGHUB , %backupfolder_f%\LGHUB_Backup1 ;rename old backup file
}
Return
;____________________________________________________________
;//////////////[Gui escape]///////////////
GuiEscape:
GuiClose:
    ExitApp
;____________________________________________________________
;____________________________________________________________
;//////////////[Backup and load]///////////////
backup:
    Backup(Backup_current)
return
load:
    Load(Backup_current)
return
;____________________________________________________________
;//////////////[Restore]///////////////
RestoreLast:
    Restore(Backup_current)
return
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
    FileRemoveDir, %appfolder_f%,1
    FileRemoveDir, %A_ScriptDir%\%appfoldername%,1 ;check for old files
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
    FileRemoveDir, %settingsfolder_f%,1
    FileRemoveDir, %A_ScriptDir%\%appfoldername%\Settings,1 ;check for old files
    ;Reset all settings when settings files are removed
    GuiControl,,checkup,0
}
return
DeleteBackups:
MsgBox, 1,Are you sure?,All Backups will be deleted!, 15
IfMsgBox, Cancel
{
	return
}
else
{
    FileRemoveDir, %backupfolder_f%,1
    FileRemoveDir, %A_ScriptDir%\%appfoldername%\Backups,1 ;check for old files
    ;Reset all settings when settings files are removed
    GuiControl,,checkup,0
}
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
    if(newversion > version)
    {
        MsgBox, 1,Update,New version is  %newversion% `nOld is %version% `nUpdate now?
        IfMsgBox, Cancel
        {
            ;temp stuff
        }
        else
        {
            ;Download update
            FileCreateDir, %appfolder_f%
            FileMove, %A_ScriptFullPath%, %update_temp_file%, 1
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
FileCreateDir, %settingsfolder_f%
IniWrite, %checkup%, %settingsini_ini%, Settings, Updates
return
;Shortcut
Shortcut_to_desktop:
FileCreateShortcut,"%A_ScriptFullPath%", %A_Desktop%\LogitechBackupProfiles.lnk
return
;open backup folder
OpenBackupFolder:
IfExist %backupfolder_f%
{
    run, %backupfolder_f%
}
return
OpenLGHUBFolder:
IfExist %LGHUBfolder_f%
{
    run, %LGHUBfolder_f%
}
return
;____________________________________________________________
;____________________________________________________________
;//////////////[Functions]///////////////
Backup(BackupNumber)
{
    IfExist %LGHUBfolder_f%
    {
        FileCreateDir, %appfolder_f%
        IfNotExist %appfolder_f%
        {
            MsgBox,, Backup Failed,Can't create folder,10
            return
        }
        FileCreateDir, %backupfolder_f%
        IfNotExist %backupfolder_f%
        {
            MsgBox,, Backup Failed,Can't create folder,10 
            return
        }
        IfExist %backupfolder_f%\LGHUB_Backup%BackupNumber%
        {
            FileRemoveDir %backupfolder_f%\LGHUB_Backup%BackupNumber%,1
        }
        FileCopyDir, %LGHUBfolder_f%, %backupfolder_f%\LGHUB_Backup%BackupNumber%, 1
        if ErrorLevel
        {
            MsgBox,,Backup failed,Failed to copy files,10
        }
        else
        {
            MsgBox,,Backed up,Backed up to %backupfolder_f%,10
        }
    }
    else
    {
        MsgBox, LGHUB files not found %LGHUBfolder_f% dasd
    }
    return
}
Load(BackupNumber)
{
    IfExist %backupfolder_f%
    {
        ;make restore file
        IfExist %backupfolder_f%\LGHUB_BackupRestore
        {
            FileRemoveDir %backupfolder_f%\LGHUB_BackupRestore,1
        }
        FileCopyDir, %LGHUBfolder_f%, %backupfolder_f%\LGHUB_BackupRestore, 1
        ;move backup to LGHUB folder
        FileCopyDir, %backupfolder_f%\LGHUB_Backup%BackupNumber%, %LGHUBfolder_f%, 1
        if ErrorLevel
        {
            MsgBox,,Backup failed,Something went wrong,10
        }
        else
        {
            MsgBox,,Backup loaded,Backup loaded,10
        }
    }
    else
    {
        MsgBox,,Error,Backup not found,10
    }
    return
}
Restore(Backup_current)
{
    IfExist %backupfolder_f%
    {
        IfNotExist %backupfolder_f%\LGHUB_BackupRestore
        {
            MsgBox,, Restore Failed,Nothing to restore,10
            return
        }
        ;IfNotExist %backupfolder_f%\LGHUB_BackupRestore{MsgBox,, Restore Failed,Nothing to restore,10 return}
        FileCopyDir, %backupfolder_f%\LGHUB_BackupRestore, %backupfolder_f%\LGHUB_Backup%BackupNumber%, 1
        if ErrorLevel
        {
            MsgBox,,Restore failed,Something went wrong,10
        }
        else
        {
            MsgBox,,Restore loaded,Restore loaded,10
        }
    }
}