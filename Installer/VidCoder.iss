; Setup for VidCoder. NOTE: To build this installer you must first build
;  VidCoder.sln in Release mode.

[Setup]
AppName=VidCoder
AppVerName=VidCoder 0.6.1

DefaultDirName={pf}\VidCoder
DisableProgramGroupPage=yes
;DisableReadyPage=yes
UninstallDisplayIcon={app}\VidCoder.exe
Compression=lzma
SolidCompression=yes

OutputDir=BuiltInstallers
OutputBaseFilename=VidCoder-0.6.1

AppId=VidCoder
UsePreviousAppDir=yes

; "ArchitecturesInstallIn64BitMode=x64" requests that the install be
; done in "64-bit mode" on x64, meaning it should use the native
; 64-bit Program Files directory and the 64-bit view of the registry.
; On all other architectures it will install in "32-bit mode".
;ArchitecturesInstallIn64BitMode=x64
; Note: We don't set ProcessorsAllowed because we want this
; installation to run on all architectures (including Itanium,
; since it's capable of running 32-bit code too).

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "..\VidCoder\bin\Release\VidCoder.exe"; DestDir: "{app}"
Source: "..\VidCoder\bin\Release\VidCoder.pdb"; DestDir: "{app}"
Source: "..\VidCoder\bin\Release\VidCoder.exe.config"; DestDir: "{app}"
Source: "..\VidCoder\bin\Release\Ookii.Dialogs.Wpf.dll"; DestDir: "{app}"
Source: "..\VidCoder\bin\Release\Ookii.Dialogs.Wpf.pdb"; DestDir: "{app}"
Source: "..\Lib\Microsoft.Practices.Unity.dll"; DestDir: "{app}"
Source: "..\Lib\Microsoft.Practices.Unity.Configuration.dll"; DestDir: "{app}"
Source: "..\VidCoder\BuiltInPresets.xml"; DestDir: "{app}"
Source: "..\Lib\hb.dll"; DestDir: "{app}"
Source: "..\Lib\libgcc_s_sjlj-1.dll"; DestDir: "{app}"
Source: "..\Lib\HandBrakeInterop.dll"; DestDir: "{app}"
Source: "..\Lib\HandBrakeInterop.pdb"; DestDir: "{app}"
Source: "..\License.txt"; DestDir: "{app}"

[Messages]
WelcomeLabel2=This will install [name/ver] on your computer.

[Icons]
Name: "{commonprograms}\VidCoder"; Filename: "{app}\VidCoder.exe"; WorkingDir: "{app}"

[Run]
Filename: "{app}\VidCoder.exe"; Description: "Run VidCoder"; Flags: postinstall shellexec

[UninstallDelete]
Type: filesandordirs; Name: "{userappdata}\VidCoder\Updates"

[CustomMessages]
dotnetmissing=VidCoder requires Microsoft .NET Framework 4, which is not installed. Would you like to download it now?

[Code]

function InitializeSetup(): Boolean;
var
  Version: TWindowsVersion;
  netFrameWorkInstalled : Boolean;
  isInstalled: Cardinal;
  ErrorCode: Integer;
begin
	GetWindowsVersionEx(Version);
	
	if (Version.Major < 5) or ((Version.Major = 5) and (Version.Minor < 1)) or ((Version.Major = 5) and (Version.Minor = 1) and (Version.ServicePackMajor < 2)) then
	begin
    MsgBox('VidCoder cannot install on your operating system.', mbError, MB_OK);
    exit;
	end;
	
  result := true;

  isInstalled := 0;
  netFrameworkInstalled := RegQueryDWordValue(HKLM, 'Software\Microsoft\NET Framework Setup\NDP\v4\Client', 'Install', isInstalled);
  if ((netFrameworkInstalled)  and (isInstalled <> 1)) then netFrameworkInstalled := false;

  if netFrameworkInstalled = false then
  begin
    if (MsgBox(ExpandConstant('{cm:dotnetmissing}'),
        mbConfirmation, MB_YESNO) = idYes) then
    begin
      ShellExec('open',
      'http://www.microsoft.com/downloads/details.aspx?FamilyID=e5ad0459-cbcc-4b4f-97b6-fb17111cf544',
      '','',SW_SHOWNORMAL,ewNoWait,ErrorCode);
    end;
    result := false;
  end;
end;

















