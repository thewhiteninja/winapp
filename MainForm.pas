unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ExtCtrls, OleCtrls, SHDocVw, ComCtrls,
  Menus, ToolWin, App, Jpeg, ShellApi, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, IdBaseComponent, IdAntiFreezeBase, IdAntiFreeze,
  GraphicEx;

type
  TMainForm = class(TForm)
    CheckListBox1: TCheckListBox;
    StatusBar1: TStatusBar;
    GroupBox1: TGroupBox;
    RichEdit1: TRichEdit;
    Panel1: TPanel;
    Panel4: TPanel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    SaveDialog1: TSaveDialog;
    Panel5: TPanel;
    Panel2: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Image1: TImage;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label25: TLabel;
    RichEdit2: TRichEdit;
    Label5: TLabel;
    Label4: TLabel;
    Label29: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure CheckListBox1Click(Sender: TObject);
    procedure Label18Click(Sender: TObject);
    procedure Label16Click(Sender: TObject);
    procedure Label20MouseEnter(Sender: TObject);
    procedure Label20MouseLeave(Sender: TObject);
    procedure Label24Click(Sender: TObject);
    procedure Label23Click(Sender: TObject);
    procedure Label22Click(Sender: TObject);
    procedure Label20Click(Sender: TObject);
    procedure Label26Click(Sender: TObject);
    procedure Label27Click(Sender: TObject);
    procedure IdHTTP1Work(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Integer);
    procedure IdHTTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Integer);
    procedure IdHTTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure Label5Click(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
    procedure Label4Click(Sender: TObject);
    procedure IdHTTP1Redirect(Sender: TObject; var dest: string;
      var NumRedirect: Integer; var Handled: Boolean; var VMethod: string);
    procedure RichEdit1Change(Sender: TObject);
  private
  public
    maxWork: Integer;
    tmpMsg: string;
    selIndex: Integer;
    applicationList: TList;
    appDir: string;
    redirect: Boolean;
    FRunning: Boolean;
    procedure clean;
  end;

var
  MainForm1: TMainForm;

implementation

{$R *.dfm}

uses Functions, Init, Installation, DownloadOnly, ISOCreation, UpdateList;

procedure TMainForm.clean;
begin
  CheckListBox1.Clear;
  Label3.Caption := '    State :';
  Label2.Caption := '    Description :';
  RichEdit1.Clear;
  selIndex := 0;
  CheckListBox1.MultiSelect := true;
  CheckListBox1.Sorted := true;
end;

procedure TMainForm.CheckListBox1Click(Sender: TObject);
var
  i: Integer;
begin
  if CheckListBox1.SelCount > 0 then
  begin
    for i := 0 to CheckListBox1.Count - 1 do
    begin
      if CheckListBox1.Selected[i] then
      begin
        selIndex := i;
        LoadInfos(true);
        Exit;
      end;
    end;
  end;
  selIndex := 0;
end;

procedure TMainForm.Label16Click(Sender: TObject);
var
  App: TApp;
begin
  App := TApp(applicationList.Items[selIndex]);
  ShellExecute(handle, 'Open', PChar(App.url), nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.Label18Click(Sender: TObject);
var
  App: TApp;
begin
  App := TApp(applicationList.Items[selIndex]);
  ShellExecute(handle, 'Open', PChar(App.downloadUrl), nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.Label20Click(Sender: TObject);
begin
  StartInstallation;
end;

procedure TMainForm.Label20MouseEnter(Sender: TObject);
begin
  TLabel(Sender).Color := clWhite;
end;

procedure TMainForm.Label20MouseLeave(Sender: TObject);
begin
  TLabel(Sender).Color := clBtnFace;
end;

procedure TMainForm.Label22Click(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to CheckListBox1.Count - 1 do
    CheckListBox1.Checked[i] := not CheckListBox1.Checked[i];
end;

procedure TMainForm.Label23Click(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to CheckListBox1.Count - 1 do
    CheckListBox1.Checked[i] := False;
end;

procedure TMainForm.Label24Click(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to CheckListBox1.Count - 1 do
    CheckListBox1.Checked[i] := true;
end;

procedure TMainForm.Label26Click(Sender: TObject);
begin
  if CheckListBox1.Enabled then
    StartDownload;
end;

procedure TMainForm.Label27Click(Sender: TObject);
begin
  if CheckListBox1.Enabled then
    StartIsoCreation;
end;

procedure TMainForm.Label4Click(Sender: TObject);
begin
  if CheckListBox1.Enabled then
    UpdateApplicationsList;
end;

procedure TMainForm.Label5Click(Sender: TObject);
begin
  ShellAbout(handle, PChar('WinApp Store'), nil, Application.Icon.handle);
end;

procedure TMainForm.RichEdit1Change(Sender: TObject);
begin
  SendMessage(RichEdit1.handle, WM_VSCROLL, SB_BOTTOM, 0);
end;

procedure TMainForm.FormCanResize(Sender: TObject;
  var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
  StatusBar1.Panels[0].Width := NewWidth - 229;
  Resize := true;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  LoadFont;
  applicationList := TList.Create;
  DoubleBuffered := true;

  appDir := IncludeTrailingPathDelimiter(ExtractFileDir(Application.ExeName));
  SetCurrentDir(appDir);
  Icon.handle := Application.Icon.handle;
  clean;

  StatusBar1.Panels[1].Text := 'Last list modification : ' +
    FormatDateTime('dd/mm/yyyy hh:nn',
    TimeModificationFichier('applications.xml'));

  if not FileExists('applications.xml') then
    CreateApplications;
  LoadApplications;
  AddToLogNL('Ready');
end;

procedure TMainForm.IdHTTP1Redirect(Sender: TObject; var dest: string;
  var NumRedirect: Integer; var Handled: Boolean; var VMethod: string);
begin
  redirect := true;
  RichEdit1.Lines[RichEdit1.Lines.Count - 1] := RichEdit1.Lines
    [RichEdit1.Lines.Count - 1] + #13 + #10;
end;

procedure TMainForm.IdHTTP1Work(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Integer);
begin
  if redirect then
    Exit;
  Application.ProcessMessages;
  RichEdit1.Lines[RichEdit1.Lines.Count - 1] := tmpMsg + '[' +
    IntToStr(AWorkCount) + '/' + IntToStr(maxWork) + ']';
end;

procedure TMainForm.IdHTTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Integer);
begin
  if redirect then
    Exit;
  tmpMsg := RichEdit1.Lines[RichEdit1.Lines.Count - 1];
  maxWork := AWorkCountMax;
  Application.ProcessMessages;
  if (AWorkMode = wmRead) then
    FRunning := true;
end;

procedure TMainForm.IdHTTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  if redirect then
    Exit;
  Application.ProcessMessages;
  FRunning := False;
  RichEdit1.Lines[RichEdit1.Lines.Count - 1] := tmpMsg + '[' + IntToStr(maxWork)
    + '/' + IntToStr(maxWork) + ']' + #13 + #10;
end;

end.
