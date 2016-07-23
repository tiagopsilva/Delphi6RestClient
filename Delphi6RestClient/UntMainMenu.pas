unit UntMainMenu;

interface

uses
  Forms, Classes, Dialogs, Controls, StdCtrls, UntRestClient;

type
  TMainForm = class(TForm)
    btnLogin: TButton;
    btnObterEscritorio: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnLoginClick(Sender: TObject);
    procedure btnObterEscritorioClick(Sender: TObject);
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
  FRestClient.Username := 'admin@intsys.com.br';
  FRestClient.Password := 'qkpm@1106';
  FRestClient.Host := 'http://localhost:60610/api';
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

procedure TMainForm.btnObterEscritorioClick(Sender: TObject);
var
  params: TStringList;
begin
  if not FRestClient.IsLogged then
  begin
    ShowMessage('Precisa efetuar login primeiro!');
    exit;
  end;

  params := TStringList.Create;
  try
    params.Values['cpfcnpj'] := '00000000000000';
    FRestClient.Get('escritorios')
  finally
    params.Free;
  end;
end;

end.

