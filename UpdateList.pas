unit UpdateList;

interface

procedure UpdateApplicationsList;

implementation

uses MainForm, XMLIntf, XMLDoc, Functions, SYsUtils, ShlObj, xmldom, IdStack,
  Init,
  RegExpr, IdHTTP;

const
  ServerURL = 'http://xxx.xxx/';

const
  pathURL = 'tmp/';

procedure UpdateApplicationsList;
var
  doc: TXMLDocument;
  current_version, new_version: string;
begin
  with MainForm1 do
  begin
    AddToLogNL('Checking new applications list ...');
    CheckListBox1.Enabled := False;

    doc := TXMLDocument.Create(MainForm1);
    doc.LoadFromFile('applications.xml');
    current_version := doc.ChildNodes.Nodes['ApplicationsList'].Attributes
      ['version'];
    doc.Free;

    try
      DownloadFile(ServerURL + pathURL + 'applications.xml',
        IncludeTrailingPathDelimiter(GetTempDir) + 'applications.xml');
    except
      on E: EIdSocketError do
      begin
        AddToLogNL('Error connecting to update site');
        AddToLogNL('Try update later');
        CheckListBox1.Enabled := true;
        exit;
      end;
      on E: EIdHTTPProtocolException do
      begin
        AddToLogNL('Error getting the updated list');
        AddToLogNL('Try update later');
        CheckListBox1.Enabled := true;
        exit;

      end;
    end;

    doc := TXMLDocument.Create(MainForm1);
    try
      doc.LoadFromFile(IncludeTrailingPathDelimiter(GetTempDir) +
        'applications.xml');
    except
      on E: EDOMParseError do
      begin
        AddToLogNL('Error parsing new applications list');
        AddToLogNL('Try update later');
        doc.Free;
        CheckListBox1.Enabled := False;
        exit;
      end;
      else
      begin
        AddToLogNL('Error updating applications list');
        AddToLogNL('Try update later');
        doc.Free;
        CheckListBox1.Enabled := False;
        exit;
      end;
    end;
    new_version := doc.ChildNodes.Nodes['ApplicationsList'].Attributes
      ['version'];
    doc.Free;

    if (StrToInt(new_version) > StrToInt(current_version)) then
    begin
      AddToLogNL('New applications list found (Rev ' + new_version + ')');
      DeleteTree('applications.xml');
      CopyDir(IncludeTrailingPathDelimiter(GetTempDir) + 'applications.xml',
        MainForm1.appDir + 'applications.xml');
      MainForm1.clean;
      LoadApplications;
      LoadInfos(true);
      AddToLogNL('Applications list updated');
      Panel5.Visible := False;
      Panel2.Visible := true;
    end
    else
    begin
      AddToLogNL('You have the last applications list (Rev ' +
        current_version + ')');
    end;

    CheckListBox1.Enabled := true;
  end;
end;

end.
