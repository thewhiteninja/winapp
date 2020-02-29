unit Installation;

interface

uses Command;

procedure StartInstallation;
procedure Execute(Command: TCommand; appToInstDir: string);

implementation

uses MainForm, App, Functions, SysUtils, StrUtils, ShellApi, Windows, ShlObj,
  IdHTTP, IdStack;

const
  Commands: array [0 .. 5] of string = ('Print', 'Registry', 'Execute',
    'RemoveFromDesktop', 'Uninstall', 'RemoveFromStartMenu');

procedure Execute(Command: TCommand; appToInstDir: string);
var
  uninstall: string;
begin
  case AnsiIndexStr(Command.name, Commands) of
    0:
      AddToLogNL(Command.argument);
    1:
      begin
        AddToLogNL('Writing ' + ExtractFileName(Command.argument) +
          ' in registry ...');
        if FileExists(Command.argument) then
        begin
          if (Command.visible) then
            myShellExecute('regedit.exe "' + Command.argument + '"', false)
          else
            myShellExecute('regedit.exe /s "' + Command.argument + '"', false);
          AddToLogNL(ExtractFileName(Command.argument) + ' writed');
        end
        else
          AddToLogNL(ExtractFileName(Command.argument) + ' not found');
      end;
    2:
      begin
        AddToLogNL('Executing ' + ExtractFileName(Command.argument) + ' ...');
        myShellExecute(Command.argument + ' ' + Command.param, Command.visible);
        AddToLogNL(ExtractFileName(Command.argument) + ' terminated');
      end;
    3:
      begin
        AddToLogNL('Removing from desktop ' + ExtractFileName(Command.argument)
          + ' ...');
        DeleteTree(IncludeTrailingPathDelimiter
          (SpecialFolder(CSIDL_COMMON_DESKTOPDIRECTORY)) + Command.argument);
        DeleteTree(IncludeTrailingPathDelimiter
          (SpecialFolder(CSIDL_DESKTOPDIRECTORY)) + Command.argument);
        AddToLogNL(ExtractFileName(Command.argument) + ' removed');
      end;
    4:
      begin
        AddToLogNL('Uninstalling ' + Command.argument + ' ...');
        uninstall := getUninstallString(Command.nameInAddRemoveSoftware);
        uninstall := StringReplace(uninstall, 'MsiExec.exe /I',
          'MsiExec.exe /x', [rfReplaceAll, rfIgnoreCase]);
        if (uninstall <> '') then
          myShellExecute(uninstall + ' ' + Command.param, false);
        AddToLogNL(Command.argument + ' uninstalled');
      end;
    5:
      begin
        AddToLogNL('Removing from Start menu ' +
          ExtractFileName(Command.argument) + ' ...');
        DeleteTree(IncludeTrailingPathDelimiter
          (SpecialFolder(CSIDL_COMMON_STARTMENU)) + Command.argument);
        DeleteTree(IncludeTrailingPathDelimiter(SpecialFolder(CSIDL_STARTMENU))
          + Command.argument);
        AddToLogNL(ExtractFileName(Command.argument) + ' removed');
      end;
  end;
end;

procedure StartInstallation;
var
  i, o, instCount: integer;
  App: TApp;
  filename, appToInstDir, tmpDir: string;
  err: Boolean;
begin
  with MainForm1 do
  begin
    CheckListBox1.Enabled := false;
    instCount := 0;
    for i := 0 to CheckListBox1.Count - 1 do
    begin
      if CheckListBox1.Checked[i] then
        Inc(instCount);
    end;
    AddToLogNL(IntToStr(instCount) + ' software(s) selected to install');
    for i := 0 to CheckListBox1.Count - 1 do
    begin
      if CheckListBox1.Checked[i] then
      begin
        App := TApp(applicationList.Items[i]);
        appToInstDir := IncludeTrailingPathDelimiter
          (StringReplace(App.name, ' ', '', [rfReplaceAll, rfIgnoreCase]));
        AddToLogNL('Installing ' + App.name + ' ...');

        tmpDir := GetCurrentDir;
        SetCurrentDir(appToInstDir);
        for o := 0 to App.BeforeCommands.Count - 1 do
        begin
          Execute(App.BeforeCommands[o], appToInstDir);
        end;
        SetCurrentDir(tmpDir);

        err := false;
        App.files.Insert(0, App.downloadUrl);
        for o := 0 to App.files.Count - 1 do
        begin
          filename := ExtractFileName(StringReplace(App.files[o], '/', '\',
            [rfReplaceAll, rfIgnoreCase]));
          if not FileExists(appDir + 'cache\' + appToInstDir + filename) then
          begin
            AddToLogNL(ExtractFileName(filename) + ' is missing');
            try
              DownloadFile(App.files[o], appDir + 'cache\' + appToInstDir + filename);
            except
              on E: EIdSocketError do
              begin
                err := True;
                AddToLogNL('Unable to download ' + ExtractFileName(filename) +
                  ' (socket errror)');
              end;
              on E: EIdHTTPProtocolException do
              begin
                err := True;
                AddToLogNL('Unable to download ' + ExtractFileName(filename) +
                  ' (http errror)');
              end;

            end;
          end;
        end;
        App.files.Delete(0);
        if err then
          Continue;

        tmpDir := GetCurrentDir;
        SetCurrentDir('cache\' + appToInstDir);
        for o := 0 to App.Commands.Count - 1 do
        begin
          Execute(App.Commands[o], 'cache\' + appToInstDir);
        end;
        SetCurrentDir(tmpDir);

        tmpDir := GetCurrentDir;
        SetCurrentDir('cache\' + appToInstDir);
        for o := 0 to App.AfterCommands.Count - 1 do
        begin
          Execute(App.AfterCommands[o], 'cache\' + appToInstDir);
        end;
        SetCurrentDir(tmpDir);

        AddToLogNL(App.name + ' installed');
      end;
    end;
    CheckListBox1.Enabled := True;
  end;
end;

end.
