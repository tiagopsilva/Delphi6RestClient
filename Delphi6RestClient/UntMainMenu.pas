unit UntMainMenu;

interface

uses
  Forms, Classes, Dialogs, Controls, StdCtrls, UntRestClient;

type
  TMainForm = class(TForm)
    btnLogin: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnLoginClick(Sender: TObject);
  private
    FRestClient: TRestClient;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FRestClient := TRestClient.Create;
  FRestClient.Username := 'theUserName';
  FRestClient.Password := 'thePassowrd';
  FRestClient.Host := 'http://localhost:49408/api';
  FRestClient.SigInPath := 'security/token';
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FRestClient.Free;
end;

procedure TMainForm.btnLoginClick(Sender: TObject);
begin
  if FRestClient.SigIn then
  begin
    showMessage('Login efetuado com sucesso!');
  end
  else
  begin
    showMessage('Usuário e senha inválida!');
  end;
end;

end.

