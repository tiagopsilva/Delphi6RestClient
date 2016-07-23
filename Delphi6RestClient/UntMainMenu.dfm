object MainForm: TMainForm
  Left = 572
  Top = 322
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'REST Client Test'
  ClientHeight = 318
  ClientWidth = 529
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Calibri'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object btnLogin: TButton
    Left = 20
    Top = 16
    Width = 137
    Height = 25
    Caption = 'Request Token / Login'
    TabOrder = 0
    OnClick = btnLoginClick
  end
end
