unit DownloadOnly;

interface

procedure StartDownload;

implementation

uses MainForm, App, Functions, SysUtils, Init;

procedure StartDownload;
var
  i, o, instCount: integer;
  App: TApp;
  filename, appToInstDir: string;
begin
  with MainForm1 do
  begin
    CheckListBox1.Enabled := False;
    instCount := 0;
    for i := 0 to CheckListBox1.Count - 1 do
    begin
      if CheckListBox1.Checked[i] then
        Inc(instCount);
    end;
    AddToLogNL(IntToStr(instCount) + ' software(s) selected to download');
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
          if not FileExists(appDir + 'cache\' + appToInstDir + filename) then
          begin
            DownloadFile(App.files[o], appDir + 'cache\' + appToInstDir + filename);
          end;
        end;

        App.files.Delete(0);

        AddToLogNL(App.Name + ' downloaded');
      end;
    end;

    for i := 0 to CheckListBox1.Count - 1 do
    begin
      if CheckListBox1.Selected[i] then
      begin
        selIndex := i;
        LoadInfos(False);
      end;
    end;

    CheckListBox1.Enabled := True;
  end;
end;

end.
