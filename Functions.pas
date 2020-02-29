unit Functions;

interface

uses ShellApi, Windows, SysUtils, Classes, jpeg, Graphics, IdTCPClient, IdHTTP,
  IdBaseComponent, IdComponent, Messages, IdTCPConnection, Forms, Shlobj,
  IdStack, Registry, URLMon;

function DeleteTree(const APath: string): boolean;
function GetTempDir: string;
procedure DownloadFile(urls: string; destination: string;
  donotlog: boolean = False);
procedure AddToLogNL(msg: string);
procedure AddToLog(msg: string);
procedure LoadImg(URL: string);
procedure myShellExecute(command: string; silent: boolean);
function CopyDir(const fromDir, toDir: string): boolean;
function FileTimeToDateTime(FileTime: TFileTime): TDateTime;
function TimeModificationFichier(fichier: string): TDateTime;
function SpecialFolder(Folder: Integer): string;
function getUninstallString(name: string): string;
function CompareNames(Item1, Item2: Pointer): Integer;

implementation

uses MainForm, Masks, App;

function CompareNames(Item1, Item2: Pointer): Integer;
begin
  Result := CompareText(TApp(Item1).name, TApp(Item2).name);
end;

function getUninstallString(name: string): string;
var
  rootKey, appKey: HKey;
  keyName: PChar;
  i: cardinal;
  keyList: TStringList;
  displayName: PChar;
  res: PChar;
  cb: LongInt;
  regsz: dword;
  tmp: Integer;
const
  uninstallKey = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
begin
  Result := '';

  if RegOpenKey(HKEY_LOCAL_MACHINE, PChar(uninstallKey), rootKey) = ERROR_SUCCESS
  then
  begin
    i := 0;
    cb := 1024;
    regsz := REG_SZ;
    keyList := TStringList.Create;
    keyName := StrAlloc(1024);
    displayName := StrAlloc(1024);
    res := StrAlloc(1024);
    while (RegEnumKey(rootKey, i, keyName, 1024) = ERROR_SUCCESS) do
    begin
      if RegOpenKey(HKEY_LOCAL_MACHINE,
        PChar(uninstallKey + '\' + StrPas(keyName)), appKey) = ERROR_SUCCESS
      then
      begin
        cb := 1024;
        tmp := RegQueryValueEx(appKey, PChar('DisplayName'), nil, @regsz,
          Pbyte(displayName), @cb);
        if (tmp = ERROR_SUCCESS) then
        begin
          if MatchesMask(StrPas(displayName), name) then
          begin
            cb := 1024;
            RegQueryValueEx(appKey, PChar('UninstallString'), nil, @regsz,
              Pbyte(res), @cb);
            Result := StrPas(res);
            exit;
          end;
        end;
      end;
      Inc(i);
    end;
    keyList.Free;
  end;
end;

function FileTimeToDateTime(FileTime: TFileTime): TDateTime;
var
  LocalFileTime: TFileTime;
  SystemTime: TSystemTime;
begin
  FileTimeToLocalFileTime(FileTime, LocalFileTime);
  FileTimeToSystemTime(LocalFileTime, SystemTime);
  Result := SystemTimeToDateTime(SystemTime);
end;

function SpecialFolder(Folder: Integer): string;
var
  SFolder: pItemIDList;
  SpecialPath: array [0 .. MAX_PATH] of Char;

begin
  SHGetSpecialFolderLocation(MainForm1.Handle, Folder, SFolder);
  SHGetPathFromIDList(SFolder, SpecialPath);
  Result := StrPas(SpecialPath);
end;

function TimeModificationFichier(fichier: string): TDateTime;
var
  SearchRec: TSearchRec;
  Resultat: LongInt;
begin
  Result := 0;
  Resultat := FindFirst(fichier, FaAnyFile, SearchRec);
  if Resultat = 0 then
    Result := FileDateToDateTime(SearchRec.Time);
  FindClose(SearchRec);
end;

function CopyDir(const fromDir, toDir: string): boolean;
var
  fos: TSHFileOpStruct;
begin
  ZeroMemory(@fos, SizeOf(fos));
  with fos do
  begin
    wFunc := FO_COPY;
    fFlags := FOF_SILENT or FOF_NOCONFIRMMKDIR or FOF_NOCONFIRMATION;
    pFrom := PChar(fromDir + #0);
    pTo := PChar(toDir)
  end;
  Result := (0 = ShFileOperation(fos));
end;

procedure AddToLog(msg: string);
begin
  MainForm1.RichEdit1.Text := MainForm1.RichEdit1.Text +
    FormatDateTime('[hh:nn:ss] - ', Now) + msg;
  MainForm1.RichEdit1.SelStart := MaxInt;
  SendMessage(MainForm1.RichEdit1.Handle, EM_SCROLLCARET, 0, 0);
  Application.ProcessMessages;
end;

procedure AddToLogNL(msg: string);
begin
  AddToLog(msg + #13 + #10);
end;

procedure myShellExecute(command: string; silent: boolean);
var
  StartInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  Fin: boolean;
begin
  FillChar(StartInfo, SizeOf(StartInfo), #0);
  StartInfo.cb := SizeOf(StartInfo);

  if (silent) then
    StartInfo.wShowWindow := SW_HIDE;
  if CreateProcess(nil, PChar(command), nil, nil, False, 0, nil, nil, StartInfo,
    ProcessInfo) then
  begin
    Fin := False;
    repeat
      case WaitForSingleObject(ProcessInfo.hProcess, 200) of
        WAIT_OBJECT_0:
          Fin := True;
        WAIT_TIMEOUT:
          ;
      end;
      Application.ProcessMessages;
    until Fin;
  end
  else
    RaiseLastOSError;
end;

procedure DownloadFile(urls: string; destination: string;
  donotlog: boolean = False);
var
  buf: TFileStream;
begin
  MainForm1.redirect := False;
  if (not donotlog) then
    AddToLogNL('Downloading ' + ExtractFileName(destination) + ' ... ');
  Application.ProcessMessages;
  ForceDirectories(ExtractFileDir(destination));
  buf := TFileStream.Create(destination, fmCreate);
  if (Assigned(buf)) then
  begin
    with TIdHTTP.Create(MainForm1) do
      try
        try
          HandleRedirects := True;
          Get(urls, TStream(buf));
        except
          on E: EIdSocketError do
          begin
            MainForm1.RichEdit1.Text := MainForm1.RichEdit1.Text + #13 + #10;
            buf.Free;
            if (FileExists(destination)) then
              DeleteTree(destination);
            raise;
          end;
          on E: EIdHTTPProtocolException do
          begin
            MainForm1.RichEdit1.Text := MainForm1.RichEdit1.Text + #13 + #10;
            buf.Free;
            if (FileExists(destination)) then
              DeleteTree(destination);
            raise;
          end;
        end;
      finally
        Free;
      end;
  end;
  if (buf.Size > 0) then
    if (not donotlog) then
      AddToLogNL(ExtractFileName(destination) + ' downloaded')
    else if (not donotlog) then
      AddToLogNL('Error downloading ' + ExtractFileName(destination));
  buf.Free;
end;

function DeleteTree(const APath: string): boolean;
var
  FileOpStruct: TSHFileOpStruct;
begin
  FileOpStruct.Wnd := 0;
  FileOpStruct.wFunc := FO_DELETE;
  FileOpStruct.pFrom := PChar(APath + #0);
  FileOpStruct.pTo := nil;
  FileOpStruct.fFlags := FOF_NOCONFIRMATION or FOF_SILENT;
  FileOpStruct.lpszProgressTitle := nil;
  Result := (ShFileOperation(FileOpStruct) = 0);
end;

function GetTempDir: string;
var
  Buffer: array [0 .. MAX_PATH] of AnsiChar;
begin
  GetTempPathA(SizeOf(Buffer) - 1, Buffer);
  Result := IncludeTrailingPathDelimiter(AnsiString(Buffer));
end;

procedure LoadImg(URL: string);
var
  filename: string;
begin
  ForceDirectories(MainForm1.appDir + 'cache\');
  filename := MainForm1.appDir + 'cache\' +
    ExtractFileName(StringReplace(URL, '/', '\', [rfReplaceAll]));
  if not FileExists(filename) then
    DownloadFile(URL, filename, True);
  try
    MainForm1.Image1.Picture.LoadFromFile(filename);
  except
    MainForm1.Image1.Picture.Bitmap := nil;
  end;
end;

end.
