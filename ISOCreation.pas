unit ISOCreation;

interface

procedure StartIsoCreation;
procedure CopyLauncher(dir: string);
procedure GenerateAutorun(dir: string);
procedure CopyApplication(dir: string);
procedure MakeIso(dir: string);
procedure DownloadIfNeeded(dir: string);

implementation

uses MainForm, Functions, SysUtils, Classes, Windows, App, Init;

procedure DownloadIfNeeded(dir: string);
var
  i, o: integer;
  App: TApp;
  filename, appToInstDir: string;
begin
  with MainForm1 do
  begin
    for i := 0 to CheckListBox1.Count - 1 do
    begin
      if CheckListBox1.Checked[i] then
      begin
        App := TApp(applicationList.Items[i]);
        appToInstDir := IncludeTrailingPathDelimiter
          (StringReplace(App.Name, ' ', '', [rfReplaceAll, rfIgnoreCase]));
        AddToLogNL('downloading ' + App.Name + ' ...');

        App.files.Insert(0, App.downloadUrl);

        for o := 0 to App.files.Count - 1 do
        begin
          filename := ExtractFileName(StringReplace(App.files[o], '/', '\',
            [rfReplaceAll, rfIgnoreCase]));
          if not FileExists(appDir + 'cache\' +  appToInstDir + filename) then
          begin
            DownloadFile(App.files[o], appDir + 'cache\' + appToInstDir + filename);
          end;
        end;

        App.files.Delete(0);
      end;
    end;

    for i := 0 to CheckListBox1.Count - 1 do
    begin
      if CheckListBox1.Selected[i] then
      begin
        selIndex := i;
        LoadInfos(false);
      end;
    end;
  end;
end;

procedure StartIsoCreation;
var
  isoFilename: string;
  dirName: string;
begin
  with MainForm1 do
  begin
    CheckListBox1.Enabled := false;
    if SaveDialog1.Execute then
    begin
      AddToLogNL('Creating installation ISO ' +
        ExtractFileName(SaveDialog1.filename) + ' ...');
      isoFilename := SaveDialog1.filename;
      dirName := IncludeTrailingPathDelimiter
        (GetTempDir + FormatDateTime('ddmmyyhhnnss', Now));
      ForceDirectories(dirName);

      // CopyLauncher(dirName);
      GenerateAutorun(dirName);
      DownloadIfNeeded(dirName);
      CopyApplication(dirName);
      MakeIso(dirName);

      DeleteTree(ExcludeTrailingPathDelimiter(dirName));
      AddToLogNL('Creation of ' + ExtractFileName(SaveDialog1.filename) +
        ' finished.');
    end;
    CheckListBox1.Enabled := True;
  end;
end;

procedure CopyLauncher(dir: string);
var
  Res: TResourceStream;
begin
  AddToLogNL('Adding Launcher.exe');
  Res := TResourceStream.Create(HInstance, 'Launcher', RT_RCDATA);
  Res.SaveToFile(dir + 'Launcher.exe');
  Res.Free;
end;

procedure GenerateAutorun(dir: string);
var
  f: TextFile;
begin
  AddToLogNL('Adding Autorun.ini');
  AssignFile(f, dir + 'Autorun.ini');
  Rewrite(f);
  Writeln(f, '[autorun]');
  Writeln(f, 'open=Launcher.exe');
  Writeln(f, 'icon=Launcher.exe,0');
  Writeln(f, 'label=WinApp Store');
  CloseFile(f);
end;

procedure CopyApplication(dir: string);
var
  appToInstDir: string;
  App: TApp;
  i: integer;
begin
  with MainForm1 do
  begin
    CheckListBox1.Enabled := false;

    for i := 0 to CheckListBox1.Count - 1 do
    begin
      if CheckListBox1.Checked[i] then
      begin
        App := TApp(applicationList.Items[selIndex]);
        appToInstDir := IncludeTrailingPathDelimiter
          (StringReplace(App.Name, ' ', '', [rfReplaceAll, rfIgnoreCase]));
        AddToLogNL('Copying ' + App.Name + ' files ...');
        CopyDir(ExcludeTrailingPathDelimiter(MainForm1.appDir + 'cache\' +
          appToInstDir), dir);
      end;
    end;

    CheckListBox1.Enabled := True;
  end;
end;

procedure MakeIso(dir: string);
begin
  AddToLogNL('Writing ' + ExtractFileName(MainForm1.SaveDialog1.filename));

  myShellExecute('mkisofs\mkisofs.exe -quiet -V L0InstallCD -o "' +
    MainForm1.SaveDialog1.filename + '" "' + ExcludeTrailingPathDelimiter(dir) +
    '"', True);
end;

end.
