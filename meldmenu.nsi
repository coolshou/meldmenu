; Script generated with the Venis Install Wizard
!include "FileFunc.nsh"

; Define your application name
!define APPNAME "meldmenu"
!define PRODUCT_VERSION "1.0.0.0"
!define VERSION "1.2022.05.13"
!define APPNAMEANDVERSION "meldmenu ${PRODUCT_VERSION}"
!define ARP "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
!define PUBLISH "coolshou.idv.tw"
!define URL "https://github.com/coolshou/meldmenu"

VIProductVersion "${PRODUCT_VERSION}"
VIFileVersion "${VERSION}"
VIAddVersionKey "ProductName" "${APPNAME}"
VIAddVersionKey "ProductVersion" "${PRODUCT_VERSION}"
VIAddVersionKey "FileVersion" "${VERSION}"
VIAddVersionKey "LegalCopyright" "(C) ${PUBLISH}"
VIAddVersionKey "FileDescription" "meld right click menu"

; Main Install settings
Name "${APPNAMEANDVERSION}"
InstallDir "$PROGRAMFILES\meldmenu"
InstallDirRegKey HKLM "Software\${APPNAME}" ""
OutFile "meldmenu-setup-${PRODUCT_VERSION}.exe"

; Use compression
SetCompressor LZMA

; Modern interface settings
!include "MUI.nsh"

!define MUI_ABORTWARNING
!define MUI_ICON "meld.ico"
!define MUI_UNICON "meld.ico"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Set languages (first is default language)
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_RESERVEFILE_LANGDLL

Var MELDEXE
Var MELDSIZE

Section "meldmenu" Section1

	; Set Section properties
	SetOverwrite on

	; Set Section Files and Shortcuts
	SetOutPath "$INSTDIR\"
	File "singleinstance.exe"
	File "meld.ico"
	CreateDirectory "$SMPROGRAMS\meldmenu"
	CreateShortCut "$SMPROGRAMS\meldmenu\Uninstall.lnk" "$INSTDIR\uninstall.exe"

SectionEnd

Section "Install"
 ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
 IntFmt $MELDSIZE "0x%08X" $0

SectionEnd

Section -FinishSection

	WriteRegStr HKLM "Software\${APPNAME}" "" "$INSTDIR"
	WriteRegStr HKLM "${ARP}" "DisplayName" "${APPNAME}"
	WriteRegStr HKLM "${ARP}" "Publisher" "${PUBLISH}"
	WriteRegStr HKLM "${ARP}" "DisplayVersion" "${PRODUCT_VERSION}"
	WriteRegStr HKLM "${ARP}" "UninstallString" "$INSTDIR\uninstall.exe"
	WriteRegStr HKLM "${ARP}" "DisplayIcon" "$INSTDIR\meld.ico,0"
	WriteRegStr HKLM "${ARP}" "HelpLink" "${URL}"
	WriteRegDWORD HKLM "${ARP}" "EstimatedSize" "$MELDSIZE"
	WriteUninstaller "$INSTDIR\uninstall.exe"

SectionEnd

; Modern install component descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	!insertmacro MUI_DESCRIPTION_TEXT ${Section1} ""
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;Uninstall section
Section Uninstall

	;Remove from registry...
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
	DeleteRegKey HKLM "SOFTWARE\${APPNAME}"
	
	DeleteRegKey HKCR "*\shell\${APPNAME}"
	DeleteRegKey HKCR "Folder\shell\${APPNAME}"
	
	; Delete self
	Delete "$INSTDIR\uninstall.exe"

	; Delete Shortcuts
	Delete "$SMPROGRAMS\meldmenu\Uninstall.lnk"

	; Clean up meldmenu
	Delete "$INSTDIR\singleinstance.exe"
	Delete "$INSTDIR\meld.ico"

	; Remove remaining directories
	RMDir "$SMPROGRAMS\meldmenu"
	RMDir "$INSTDIR\"

SectionEnd

BrandingText "Meld Right Click Menu"



Function .onInit
	ClearErrors
	#read x86 in x64 system
	ReadRegStr $0 HKLM "SOFTWARE\WOW6432Node\Meld" "Executable"
${If} ${Errors}
  ReadRegStr $0 HKLM "SOFTWARE\Meld" "Executable"
${EndIf}

${IF} $0 == ""
    #MESSAGEBOX MB_OK "meld not exists"
${ELSE}
    #MESSAGEBOX MB_OK "meld install at $0"
		StrCpy $MELDEXE $0
${ENDIF}

FunctionEnd

Function .onInstSuccess
	WriteRegStr HKCR "*\shell\${APPNAME}" "" "Compare it!"
	WriteRegStr HKCR "*\shell\${APPNAME}" "Icon" $MELDEXE
	WriteRegStr HKCR "*\shell\${APPNAME}\command" "" '"$INSTDIR\singleinstance.exe" "%1" "$MELDEXE" $$files --si-timeout 400'
	WriteRegStr HKCR "Folder\shell\${APPNAME}" "" "Compare it!"
	WriteRegStr HKCR "Folder\shell\${APPNAME}" "Icon" $MELDEXE
	WriteRegStr HKCR "Folder\shell\${APPNAME}\command" "" '"$INSTDIR\singleinstance.exe" "%1" "$MELDEXE" $$files --si-timeout 400'
	
FunctionEnd


; eof