unit Init;

interface

procedure CreateApplications;
procedure LoadInfos(all: boolean);
procedure LoadApplications;
procedure LoadFont;

implementation

uses MainForm, Functions, App, SysUtils, xmldom, XMLIntf, msxmldom, XMLDoc,
  Windows, Messages, Classes, ShlObj;

procedure LoadFont;
var
  res: TResourceStream;
  fontDir: string;
begin
  fontDir := IncludeTrailingPathDelimiter(GetTempDir);
  try
    if not FileExists(fontDir + 'CALIBRI.TTF') then
    begin
      res := TResourceStream.Create(HInstance, 'CALIBRI', RT_RCDATA);
      res.SaveToFile(fontDir + 'CALIBRI.TTF');
      res.Free;
    end;
    if not FileExists(fontDir + 'CALIBRIB.TTF') then
    begin
      res := TResourceStream.Create(HInstance, 'CALIBRIB', RT_RCDATA);
      res.SaveToFile(fontDir + 'CALIBRIB.TTF');
      res.Free;
    end;
    if not FileExists(fontDir + 'CALIBRIZ.TTF') then
    begin
      res := TResourceStream.Create(HInstance, 'CALIBRIZ', RT_RCDATA);
      res.SaveToFile(fontDir + 'CALIBRIZ.TTF');
      res.Free;
    end;
    if not FileExists(fontDir + 'CALIBRII.TTF') then
    begin
      res := TResourceStream.Create(HInstance, 'CALIBRII', RT_RCDATA);
      res.SaveToFile(fontDir + 'CALIBRII.TTF');
      res.Free;
    end;
  except
    on E: EFCreateError do;
  end;
  AddFontResource(PChar(fontDir + 'CALIBRI.TTF'));
  AddFontResource(PChar(fontDir + 'CALIBRII.TTF'));
  AddFontResource(PChar(fontDir + 'CALIBRIB.TTF'));
  AddFontResource(PChar(fontDir + 'CALIBRIZ.TTF'));
  SendMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
end;

procedure CreateApplications;
begin
  with MainForm1 do
  begin
    AddToLogNL('No applications list found, creating new list ...');

    with TXMLDocument.Create(MainForm1) do
    begin
      Active := true;
      ChildNodes.Clear;
      Version := '1.0';
      Encoding := 'ISO-8859-1';
      AddChild('ApplicationsList');
      ChildNodes[1].Attributes['version'] := '0';
      SaveToFile('applications.xml');
      Free;
    end;
  end;
end;

procedure LoadInfos(all: boolean);
var
  App: TApp;
  i, miss: integer;
  appToInstDir: string;
begin
  with MainForm1 do
  begin
    App := TApp(applicationList.Items[selIndex]);

    if (all) then
    begin
      LoadImg(App.image);
      Label13.Caption := App.Name;
      Label14.Caption := App.Version;
      Label15.Caption := App.author;
      Label17.Caption := App.size;
      Label19.Caption := App.plat;
      RichEdit2.Lines.Text := App.description;
    end;

    appToInstDir := IncludeTrailingPathDelimiter(StringReplace(App.Name, ' ',
      '', [rfReplaceAll, rfIgnoreCase]));

    App.files.Insert(0, App.downloadUrl);

    miss := 0;
    for i := 0 to App.files.Count - 1 do
    begin
      if not FileExists(appDir + 'cache\' + appToInstDir +
        ExtractFileName(StringReplace(App.files[i], '/', '\',
        [rfReplaceAll, rfIgnoreCase]))) then
        Inc(miss);
    end;

    App.files.Delete(0);

    if App.files.Count > 0 then
      Label25.Caption := '( + ' + IntToStr(App.files.Count) + ' files)'
    else
      Label25.Caption := '';

    if miss = 0 then
      Label3.Caption := '    State : ' + 'Ready to install'
    else
      Label3.Caption := '    State : ' + IntToStr(miss) +
        ' file(s) need to be downloaded';
  end;
end;

procedure LoadApplications;
var
  i, Count: integer;
  XMLDocument1: TXMLDocument;
begin
  with MainForm1 do
  begin
    AddToLog('Loading applications list ... ');
    XMLDocument1 := TXMLDocument.Create(MainForm1);
    XMLDocument1.LoadFromFile('applications.xml');

    Count := XMLDocument1.ChildNodes.Nodes['ApplicationsList'].ChildNodes.Count;
    for i := 0 to Count - 1 do
    begin
      with XMLDocument1.ChildNodes.Nodes['ApplicationsList'].ChildNodes do
      begin

        applicationList.Add(TApp.Create(Get(i)));
        CheckListBox1.Items.Add(TApp(applicationList.Items[i]).Name);

      end;
    end;

    applicationList.Sort(@CompareNames);

    RichEdit1.Text := RichEdit1.Text + IntToStr(Count) + ' loaded' + #13 + #10;
    XMLDocument1.Free;

    if Count > 0 then
    begin
      CheckListBox1.Selected[0] := true;
      selIndex := 0;
      LoadInfos(true);
    end
    else
    begin
      Panel2.Visible := false;
      Panel5.Visible := true;
    end;
  end;
end;

end.
