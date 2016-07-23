unit UntRestClient;

interface

uses
  Classes, SysUtils, uLkJSON,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

type
  TRestClient = class
  private
    FUsername: string;
    FPassword: string;
    FToken: string;
    FHttp: TIdHTTP;
    FHost: string;
    FSigInPath: string;
    procedure SetHost(value: string);
    procedure SetSigInPath(value: string);
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  public
    property Username: string read FUsername write FUsername;
    property Password: string read FPassword write FPassword;
    property Host: string read FHost write SetHost;
    property SigInPath: string read FSigInPath write SetSigInPath;
  private
    function FormatUrl(APath: string): string;
    procedure FormatHeaders;
  public
    function Post(APath: string; AParams: TStringList): TStringStream;
    function Get(APath: string): TStringStream;
    function SigIn: boolean;
    function IsLogged: boolean;
  end;

  ERestClientException = class(Exception);

implementation

uses
  StrUtils, Dialogs;

{ TRestClient }

constructor TRestClient.Create;
begin
  inherited;
  FHttp := TIdHTTP.Create(nil);
end;

destructor TRestClient.Destroy;
begin
  if FHttp.Connected then
    FHttp.Disconnect;
  FHttp.Free;
  inherited;
end;

procedure TRestClient.SetHost(value: string);
var
  protocol: string;
begin
  while LeftStr(value, 1) = '/' do
    Delete(value, 1, 1);

  protocol := LowerCase(LeftStr(value, 8));
  if (LeftStr(protocol, 7) <> 'http://') and (protocol <> 'https://') then
    value := 'http://' + value;

  if RightStr(value, 1) <> '/' then
    value := value + '/';

  FHost := value;
end;

procedure TRestClient.SetSigInPath(value: string);
begin
  while LeftStr(value, 1) = '/' do
    Delete(value, 1, 1);
  FSigInPath := value;
end;

function TRestClient.FormatUrl(APath: string): string;
begin
  while LeftStr(APath, 1) = '/' do
    Delete(APath, 1, 1);
  result := FHost + APath;
end;

procedure TRestClient.FormatHeaders;
begin
  if Trim(FToken) <> '' then
    FHttp.Request.ExtraHeaders.Values['Authentication'] := 'bearer ' + FToken;

  FHttp.Request.ExtraHeaders.Values['Cache-Control'] := 'no-cache';
  FHttp.Request.ExtraHeaders.Values['Pragma'] := 'no-cache';
  FHttp.Request.ExtraHeaders.Values['Connection'] := 'keep-alive';

  FHttp.Request.ExtraHeaders.Values['Content-Type'] := 'application/x-www-form-urlencoded';
  //FHttp.Request.ExtraHeaders.Values['Content-Type'] := 'text/html; charset=utf-8';
  //FHttp.Request.ExtraHeaders.Values['Content-Type'] := 'text/html; charset=utf-8; application/x-www-form-urlencoded';

  FHttp.Request.ExtraHeaders.Values['Accept-Language'] := 'pt-BR,pt;q=0.8,en-US;q=0.6,en;q=0.4';
  FHttp.Request.ExtraHeaders.Values['Date'] := 'Mon, 29 Apr 2018 21:44:55 GMT';
  //FHttp.Request.ExtraHeaders.Values['User-Agent'] := 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36';

  Fhttp.HandleRedirects := True;
end;

function TRestClient.Post(APath: string; AParams: TStringList): TStringStream;
var
  url: string;
begin
  url := FormatUrl(APath);
  result := TStringStream.Create('');
  try
    FormatHeaders;
    FHttp.Post(url, AParams, result);
  except
    on e: Exception do
    begin
      result.Free;
      result := nil;
      raise Exception.Create(e.Message);
    end;
  end;
end;

function TRestClient.Get(APath: string): TStringStream;
var
  url: string;
begin
  url := FormatUrl(APath);
  result := TStringStream.Create('');
  try
    FormatHeaders;
    FHttp.Get(url, result);
  except
    on e: Exception do
    begin
      result.Free;
    end;
  end;
end;

function TRestClient.SigIn: boolean;
var
  params: TStringList;
  response: TStringStream;
  json: TlkJSONobject;
  field: TlkJSONbase;
begin
  result := false;

  if Trim(FHost) = '' then
    raise ERestClientException.Create('Informe a Url da API REST!');

  if Trim(FSigInPath) = '' then
    raise ERestClientException.Create('Informe a rota para o Login!');

  if Trim(FUsername) = '' then
    raise ERestClientException.Create('Informe o username!');

  if Trim(FPassword) = '' then
    raise ERestClientException.Create('Informe a senha do usuário!');

  params := TStringList.Create;
  try
    params.Values['grant_type'] := 'password';
    params.Values['username'] := FUsername;
    params.Values['password'] := FPassword;
    try
      response := Post(FSigInPath, params);
      response.Position := 0;
      json := TlkJSON.ParseText(response.DataString) as TlkJSONobject;
      try
        field := json.Field['access_token'];      
        if field <> nil then
        begin
          FToken := field.Value;
          result := Trim(FToken) <> '';
        end;
      finally
        response.Free;
        json.Free;
      end;
    except
      on e: Exception do
      begin
        ShowMessage('Falha ao efetuar o login!');
      end;
    end;
  finally
    params.Free;
  end;
end;

function TRestClient.IsLogged: boolean;
begin
  Result := Trim(FToken) <> '';
end;

end.

