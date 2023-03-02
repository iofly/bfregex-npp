inherited frmAbout: TfrmAbout
  Left = 440
  Top = 383
  Caption = 'About BFRegex'
  ClientHeight = 193
  ClientWidth = 515
  Font.Height = -13
  Font.Name = 'Verdana'
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  ExplicitWidth = 521
  ExplicitHeight = 222
  PixelsPerInch = 96
  TextHeight = 16
  object btnOk: TButton
    Left = 422
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Ok'
    ModalResult = 1
    TabOrder = 0
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 16
    Width = 481
    Height = 121
    Caption = 'Release Info'
    TabOrder = 1
    object Label1: TLabel
      Left = 24
      Top = 32
      Width = 305
      Height = 16
      Caption = 'BFRegex - Copyright '#169' 2022 Bernard Ford'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 24
      Top = 64
      Width = 50
      Height = 16
      Caption = 'Author:'
    end
    object Label3: TLabel
      Left = 24
      Top = 86
      Width = 53
      Height = 16
      Caption = 'Version:'
    end
    object Label5: TLabel
      Left = 104
      Top = 64
      Width = 84
      Height = 16
      Caption = 'Bernard Ford'
    end
    object Label6: TLabel
      Left = 104
      Top = 86
      Width = 21
      Height = 16
      Caption = '2.2'
    end
  end
end
