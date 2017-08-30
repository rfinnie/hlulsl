; hlulsl.nsi
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

SetCompressor /FINAL /SOLID lzma

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "HL!UL!SL - Half-Life: Uplink for Steam"
!define PRODUCT_VERSION "2.0"
!define PRODUCT_PUBLISHER "Ryan Finnie"
!define PRODUCT_WEB_SITE "https://www.halflifeuplink.com/hlulsl"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKCU"
!DEFINE MODNAME "hlulsl"

!include "MUI2.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "header.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP "welcomefinish.bmp"

!define MUI_WELCOMEPAGE_TEXT "Version ${PRODUCT_VERSION}$\r$\n${PRODUCT_WEB_SITE}$\r$\n$\r$\nThis wizard will guide you through the installation of ${PRODUCT_NAME}.$\r$\n$\r$\n${PRODUCT_NAME} requires Steam, and Half-Life to be installed and run at least once.  This setup will automatically determine the correct folder to install into for your Steam profile.$\r$\n$\r$\nClick Next to continue."
!define MUI_FINISHPAGE_TEXT "${PRODUCT_NAME} has been installed on your computer.$\r$\n$\r$\nSteam must be restarted for Half-Life: Uplink to show on the games list.$\r$\n$\r$\nClick Finish to close this wizard."
!define MUI_DIRECTORYPAGE_TEXT_DESTINATION "Steam Half-Life Mods Folder"
!define MUI_DIRECTORYPAGE_TEXT_TOP "Setup will install ${PRODUCT_NAME} in the ${MODNAME} subdirectory of the following folder.$\r$\n$\r$\nThis folder has been detected as the proper folder for Half-Life mods for your current Steam profile.  To install in a different folder, click Browse and select another folder.$\r$\n$\r$\nClick Install to start the installation."

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

; MUI end ------

Name "${PRODUCT_NAME}"
OutFile "${MODNAME}-setup.exe"
; Should always be overwritten by the user's Steam directory (or the installer will exit).
InstallDir "$DESKTOP\${PRODUCT_NAME}"
ShowInstDetails show
ShowUnInstDetails show

; Nothing needs admin-level privileges
RequestExecutionLevel user

Section "MainSection" SEC01
  SetOutPath "$INSTDIR\${MODNAME}"
  SetOverwrite try
  File "src\icon.tga"
  File "src\liblist.gam"
  SetOutPath "$INSTDIR\${MODNAME}\maps\graphs"
  File "src\maps\graphs\hldemo1.nod"
  File "src\maps\graphs\hldemo2.nod"
  File "src\maps\graphs\hldemo3.nod"
  SetOutPath "$INSTDIR\${MODNAME}\maps"
  File "src\maps\hldemo1.bsp"
  File "src\maps\hldemo2.bsp"
  File "src\maps\hldemo3.bsp"
  SetOutPath "$INSTDIR\${MODNAME}\resource\background"
  File "src\resource\background\320_1_a_loading.tga"
  File "src\resource\background\320_1_b_loading.tga"
  File "src\resource\background\640_1_a_splash.tga"
  File "src\resource\background\640_1_b_splash.tga"
  File "src\resource\background\640_1_c_splash.tga"
  File "src\resource\background\640_2_a_splash.tga"
  File "src\resource\background\640_2_b_splash.tga"
  File "src\resource\background\640_2_c_splash.tga"
  SetOutPath "$INSTDIR\${MODNAME}\resource"
  File "src\resource\BackgroundLayout.txt"
  File "src\resource\BackgroundLoadingLayout.txt"
  File "src\resource\GameMenu.res"
  File "src\resource\game_menu.tga"
  File "src\resource\game_menu_mouseover.tga"
  SetOutPath "$INSTDIR\${MODNAME}\sound\scientist"
  File "src\sound\scientist\c1a4_dying.wav"
  File "src\sound\scientist\c1a4_sci_rocket.wav"
  SetOutPath "$INSTDIR\${MODNAME}\sound"
  File "src\sound\sentences.txt"
  SetOutPath "$INSTDIR\${MODNAME}"
  File "src\titles.txt"
SectionEnd

Section -AdditionalIcons
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  SetOutPath "$INSTDIR"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Half-Life Uplink.lnk" "$INSTDIR\hl.exe" "-game ${MODNAME}"
  SetOutPath "$INSTDIR\${MODNAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall ${PRODUCT_NAME}.lnk" "$INSTDIR\${MODNAME}\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\${MODNAME}\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\${MODNAME}\uninst.exe"
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
  Delete "$INSTDIR\${MODNAME}\uninst.exe"
  Delete "$INSTDIR\${MODNAME}\titles.txt"
  Delete "$INSTDIR\${MODNAME}\sound\sentences.txt"
  Delete "$INSTDIR\${MODNAME}\sound\scientist\c1a4_sci_rocket.wav"
  Delete "$INSTDIR\${MODNAME}\sound\scientist\c1a4_dying.wav"
  Delete "$INSTDIR\${MODNAME}\resource\game_menu_mouseover.tga"
  Delete "$INSTDIR\${MODNAME}\resource\game_menu.tga"
  Delete "$INSTDIR\${MODNAME}\resource\GameMenu.res"
  Delete "$INSTDIR\${MODNAME}\resource\BackgroundLoadingLayout.txt"
  Delete "$INSTDIR\${MODNAME}\resource\BackgroundLayout.txt"
  Delete "$INSTDIR\${MODNAME}\resource\background\640_2_c_splash.tga"
  Delete "$INSTDIR\${MODNAME}\resource\background\640_2_b_splash.tga"
  Delete "$INSTDIR\${MODNAME}\resource\background\640_2_a_splash.tga"
  Delete "$INSTDIR\${MODNAME}\resource\background\640_1_c_splash.tga"
  Delete "$INSTDIR\${MODNAME}\resource\background\640_1_b_splash.tga"
  Delete "$INSTDIR\${MODNAME}\resource\background\640_1_a_splash.tga"
  Delete "$INSTDIR\${MODNAME}\resource\background\320_1_b_loading.tga"
  Delete "$INSTDIR\${MODNAME}\resource\background\320_1_a_loading.tga"
  Delete "$INSTDIR\${MODNAME}\maps\hldemo3.bsp"
  Delete "$INSTDIR\${MODNAME}\maps\hldemo2.bsp"
  Delete "$INSTDIR\${MODNAME}\maps\hldemo1.bsp"
  Delete "$INSTDIR\${MODNAME}\maps\graphs\hldemo3.nod"
  Delete "$INSTDIR\${MODNAME}\maps\graphs\hldemo2.nod"
  Delete "$INSTDIR\${MODNAME}\maps\graphs\hldemo1.nod"
  Delete "$INSTDIR\${MODNAME}\liblist.gam"
  Delete "$INSTDIR\${MODNAME}\icon.tga"

  Delete "$SMPROGRAMS\${PRODUCT_NAME}\Half-Life Uplink.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall ${PRODUCT_NAME}.lnk"

  RMDir "$SMPROGRAMS\${PRODUCT_NAME}"
  RMDir "$INSTDIR\${MODNAME}\sound\scientist"
  RMDir "$INSTDIR\${MODNAME}\sound"
  RMDir "$INSTDIR\${MODNAME}\resource\background"
  RMDir "$INSTDIR\${MODNAME}\resource"
  RMDir "$INSTDIR\${MODNAME}\maps\graphs"
  RMDir "$INSTDIR\${MODNAME}\maps"
  RMDir "$INSTDIR\${MODNAME}"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  SetAutoClose true
SectionEnd

LangString SteamNotInstalled ${LANG_ENGLISH} "Steam is not detected!  Please install Steam and sign in to a Steam profile before starting ${PRODUCT_NAME} Setup.$\r$\n$\r$\nThis setup will now exit."

Function .onInit
  ReadRegStr $R0 HKCU "Software\Valve\Steam" "ModInstallPath"
  StrCmp $R0 "" noSteam
  Goto +3

  noSteam:
    MessageBox MB_OK|MB_ICONSTOP $(SteamNotInstalled)
    Abort

  StrCpy $INSTDIR "$R0"
FunctionEnd
