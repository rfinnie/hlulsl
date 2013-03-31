; steamlink.nsi
; Copyright (C) 2013 Ryan Finnie
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License along
; with this program; if not, write to the Free Software Foundation, Inc.,
; 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "SteamLink"
!define PRODUCT_VERSION "1.4"
!define PRODUCT_PUBLISHER "Ryan Finnie"
!define PRODUCT_WEB_SITE "http://www.halflifeuplink.com/steamlink"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKCU"

!include "MUI2.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "header.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP "welcomefinish.bmp"

!define MUI_WELCOMEPAGE_TEXT "Version ${PRODUCT_VERSION}$\r$\nhttp://www.halflifeuplink.com/steamlink$\r$\n$\r$\nThis wizard will guide you through the installation of SteamLink.$\r$\n$\r$\nSteamLink requires Steam, and Half-Life to be installed and run at least once.  SteamLink Setup will automatically determine the correct folder to install into for your Steam profile.$\r$\n$\r$\nClick Next to continue."
!define MUI_FINISHPAGE_TEXT "SteamLink has been installed on your computer.$\r$\n$\r$\nSteam must be restarted for SteamLink to show on the games list.$\r$\n$\r$\nClick Finish to close this wizard."
!define MUI_DIRECTORYPAGE_TEXT_DESTINATION "Steam Half-Life Mods Folder"
!define MUI_DIRECTORYPAGE_TEXT_TOP "Setup will install SteamLink in the following folder.$\r$\n$\r$\nThis folder has been detected as the proper folder for Half-Life mods for your current Steam profile.  To install in a different folder, click Browse and select another folder.$\r$\n$\r$\nClick Install to start the installation."

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

Var MODDIR

; MUI end ------

Name "${PRODUCT_NAME}"
OutFile "${PRODUCT_NAME}.exe"
; Should always be overwritten by the user's Steam directory (or the installer will exit).
InstallDir "$DESKTOP\SteamLink"
ShowInstDetails show
ShowUnInstDetails show

; Nothing needs admin-level privileges
RequestExecutionLevel user

Section "MainSection" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite try
  File "src\icon.tga"
  File "src\liblist.gam"
  SetOutPath "$INSTDIR\maps\graphs"
  File "src\maps\graphs\hldemo1.nod"
  File "src\maps\graphs\hldemo2.nod"
  File "src\maps\graphs\hldemo3.nod"
  SetOutPath "$INSTDIR\maps"
  File "src\maps\hldemo1.bsp"
  File "src\maps\hldemo2.bsp"
  File "src\maps\hldemo3.bsp"
  SetOutPath "$INSTDIR\resource\background"
  File "src\resource\background\320_1_a_loading.tga"
  File "src\resource\background\320_1_b_loading.tga"
  File "src\resource\background\640_1_a_splash.tga"
  File "src\resource\background\640_1_b_splash.tga"
  File "src\resource\background\640_1_c_splash.tga"
  File "src\resource\background\640_2_a_splash.tga"
  File "src\resource\background\640_2_b_splash.tga"
  File "src\resource\background\640_2_c_splash.tga"
  SetOutPath "$INSTDIR\resource"
  File "src\resource\BackgroundLayout.txt"
  File "src\resource\BackgroundLoadingLayout.txt"
  File "src\resource\GameMenu.res"
  File "src\resource\game_menu.tga"
  File "src\resource\game_menu_mouseover.tga"
  SetOutPath "$INSTDIR\sound\scientist"
  File "src\sound\scientist\c1a4_dying.wav"
  File "src\sound\scientist\c1a4_sci_rocket.wav"
  SetOutPath "$INSTDIR\sound"
  File "src\sound\sentences.txt"
  SetOutPath "$INSTDIR"
  File "src\titles.txt"
SectionEnd

Section -AdditionalIcons
  SetOutPath $INSTDIR
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateDirectory "$SMPROGRAMS\SteamLink"
  SetOutPath "$MODDIR"
  CreateShortCut "$SMPROGRAMS\SteamLink\Half-Life Uplink.lnk" "$MODDIR\hl.exe" "-game steamlink"
  SetOutPath "$INSTDIR"
  CreateShortCut "$SMPROGRAMS\SteamLink\${PRODUCT_NAME} Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\SteamLink\Uninstall ${PRODUCT_NAME}.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd


Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\titles.txt"
  Delete "$INSTDIR\sound\sentences.txt"
  Delete "$INSTDIR\sound\scientist\c1a4_sci_rocket.wav"
  Delete "$INSTDIR\sound\scientist\c1a4_dying.wav"
  Delete "$INSTDIR\resource\game_menu_mouseover.tga"
  Delete "$INSTDIR\resource\game_menu.tga"
  Delete "$INSTDIR\resource\GameMenu.res"
  Delete "$INSTDIR\resource\BackgroundLoadingLayout.txt"
  Delete "$INSTDIR\resource\BackgroundLayout.txt"
  Delete "$INSTDIR\resource\background\640_2_c_splash.tga"
  Delete "$INSTDIR\resource\background\640_2_b_splash.tga"
  Delete "$INSTDIR\resource\background\640_2_a_splash.tga"
  Delete "$INSTDIR\resource\background\640_1_c_splash.tga"
  Delete "$INSTDIR\resource\background\640_1_b_splash.tga"
  Delete "$INSTDIR\resource\background\640_1_a_splash.tga"
  Delete "$INSTDIR\resource\background\320_1_b_loading.tga"
  Delete "$INSTDIR\resource\background\320_1_a_loading.tga"
  Delete "$INSTDIR\maps\hldemo3.bsp"
  Delete "$INSTDIR\maps\hldemo2.bsp"
  Delete "$INSTDIR\maps\hldemo1.bsp"
  Delete "$INSTDIR\maps\graphs\hldemo3.nod"
  Delete "$INSTDIR\maps\graphs\hldemo2.nod"
  Delete "$INSTDIR\maps\graphs\hldemo1.nod"
  Delete "$INSTDIR\liblist.gam"
  Delete "$INSTDIR\icon.tga"

  Delete "$SMPROGRAMS\SteamLink\Half-Life Uplink.lnk"
  Delete "$SMPROGRAMS\SteamLink\Uninstall ${PRODUCT_NAME}.lnk"
  Delete "$SMPROGRAMS\SteamLink\${PRODUCT_NAME} Website.lnk"

  RMDir "$SMPROGRAMS\SteamLink"
  RMDir "$INSTDIR\sound\scientist"
  RMDir "$INSTDIR\sound"
  RMDir "$INSTDIR\resource\background"
  RMDir "$INSTDIR\resource"
  RMDir "$INSTDIR\maps\graphs"
  RMDir "$INSTDIR\maps"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  SetAutoClose true
SectionEnd

LangString SteamNotInstalled ${LANG_ENGLISH} "Steam is not detected!  Please install Steam and sign in to a Steam profile before starting SteamLink Setup.$\r$\n$\r$\nSteamLink Setup will now exit."

Function .onInit
  ReadRegStr $R0 HKCU "Software\Valve\Steam" "ModInstallPath"
  StrCmp $R0 "" noSteam
  Goto +3

  noSteam:
    MessageBox MB_OK|MB_ICONSTOP $(SteamNotInstalled)
    Abort

  StrCpy $MODDIR "$R0"
  StrCpy $INSTDIR "$R0\steamlink"
FunctionEnd
