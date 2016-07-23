program Delphi6RestClient;

uses
  Forms,
  UntMainMenu in 'UntMainMenu.pas' {MainForm},
  UntRestClient in 'UntRestClient.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
