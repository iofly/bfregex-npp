object frmBackupRestore: TfrmBackupRestore
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Backup & Restore'
  ClientHeight = 289
  ClientWidth = 526
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 168
    Height = 13
    Caption = 'Settings and Data File (SQLite file):'
  end
  object lblDBFile: TLabel
    Left = 16
    Top = 27
    Width = 111
    Height = 13
    Caption = '[DATAFILE LOCATION]'
  end
  object Button1: TButton
    Left = 232
    Top = 244
    Width = 75
    Height = 25
    Caption = 'Close'
    ModalResult = 1
    TabOrder = 0
  end
  object btnRegexBackup: TButton
    Left = 16
    Top = 59
    Width = 249
    Height = 25
    Hint = 'New Regular Expression'
    Caption = 'Backup Regex Database...'
    TabOrder = 1
    OnClick = btnRegexBackupClick
  end
  object btnRegexRestore: TButton
    Left = 16
    Top = 99
    Width = 250
    Height = 25
    Caption = 'Restore Regex Database...'
    TabOrder = 2
    OnClick = btnRegexRestoreClick
  end
  object Button2: TButton
    Left = 16
    Top = 139
    Width = 250
    Height = 25
    Caption = 'Restore Default Settings'
    TabOrder = 3
  end
  object Button3: TButton
    Left = 16
    Top = 179
    Width = 250
    Height = 25
    Caption = 'Wipe Regex Library'
    TabOrder = 4
  end
  object AbZipper1: TAbZipper
    AutoSave = False
    DOSMode = False
    Left = 368
    Top = 154
  end
  object AbUnZipper1: TAbUnZipper
    Left = 35
    Top = 218
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.bfrb.zip'
    Filter = 'BFRegex Backup File (*.bfrb.zip)|*.bfrb.zip'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Backup Regex Database'
    Left = 368
    Top = 106
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '.bfrb'
    Filter = 'BFRegex Backup File (*.bfrb.zip)|*.bfrb.zip'
    Left = 200
    Top = 226
  end
end
