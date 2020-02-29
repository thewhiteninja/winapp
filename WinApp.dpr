program WinApp;

{$R *.dres}

uses
  Forms,
  MainForm in 'MainForm.pas' {MainForm} ,
  App in 'App.pas',
  Functions in 'Functions.pas',
  ISOCreation in 'ISOCreation.pas',
  Installation in 'Installation.pas',
  DownloadOnly in 'DownloadOnly.pas',
  Init in 'Init.pas',
  Command in 'Command.pas',
  UpdateList in 'UpdateList.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm1);
  Application.Run;

end.
