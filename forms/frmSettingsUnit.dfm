object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 237
  ClientWidth = 575
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btnCancel: TButton
    Left = 287
    Top = 199
    Width = 105
    Height = 25
    Caption = 'Close'
    ModalResult = 2
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 171
    Top = 199
    Width = 110
    Height = 25
    Caption = 'Apply Changes'
    ModalResult = 1
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 575
    Height = 193
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Label2: TLabel
      Left = 304
      Top = 9
      Width = 172
      Height = 13
      Caption = 'Run regular expressions on the first'
    end
    object Label1: TLabel
      Left = 304
      Top = 56
      Width = 207
      Height = 52
      Caption = 
        'characters. Zero = entire document.'#13#10#13#10' (Running the regex on a ' +
        'very large '#13#10'document can lead to an unresponsive UI.)'
    end
    object Label3: TLabel
      Left = 32
      Top = 77
      Width = 163
      Height = 13
      Caption = '(Some elements cannot be styled)'
    end
    object cbAutoJumpToResult: TCheckBox
      Left = 16
      Top = 8
      Width = 250
      Height = 17
      Caption = 'Auto Jump To First Result'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 0
      StyleElements = []
    end
    object cbAdjustToDarkMode: TCheckBox
      Left = 16
      Top = 54
      Width = 250
      Height = 17
      Caption = 'Adjust To Notepad++ Theme Change'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 1
      StyleElements = []
    end
    object cbRememberState: TCheckBox
      Left = 16
      Top = 31
      Width = 250
      Height = 17
      Caption = 'Remember state'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 2
      StyleElements = []
    end
    object GroupBox1: TGroupBox
      Left = 16
      Top = 114
      Width = 537
      Height = 69
      Caption = 'Backup and Restore'
      TabOrder = 3
      object btnRegexBackup: TButton
        Left = 16
        Top = 24
        Width = 249
        Height = 25
        Hint = 'New Regular Expression'
        Caption = 'Backup Regex Database...'
        TabOrder = 0
        OnClick = btnRegexBackupClick
      end
      object btnRegexRestore: TButton
        Left = 271
        Top = 23
        Width = 250
        Height = 25
        Caption = 'Restore Regex Database...'
        TabOrder = 1
      end
    end
    object SpinEdit1: TSpinEdit
      Left = 304
      Top = 28
      Width = 105
      Height = 22
      Ctl3D = True
      MaxValue = 0
      MinValue = 0
      ParentCtl3D = False
      TabOrder = 4
      Value = 0
    end
  end
  object AbUnZipper1: TAbUnZipper
    Left = 419
    Top = 252
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.zip'
    Filter = 'Zip File (*.zip)|*.zip'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Backup Regex Database'
    Left = 528
    Top = 248
  end
  object AbZipper1: TAbZipper
    AutoSave = False
    DOSMode = False
    Left = 472
    Top = 252
  end
end
