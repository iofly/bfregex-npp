object frmRegexTitle: TfrmRegexTitle
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Regex Title'
  ClientHeight = 121
  ClientWidth = 439
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 24
    Top = 32
    Width = 69
    Height = 16
    Caption = 'Regex Title:'
  end
  object edRegexTitle: TEdit
    Left = 128
    Top = 29
    Width = 289
    Height = 22
    Ctl3D = False
    MaxLength = 128
    ParentCtl3D = False
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 248
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 342
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
