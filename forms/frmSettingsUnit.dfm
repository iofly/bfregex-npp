object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 296
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
  object ScrollBox1: TScrollBox
    Left = 8
    Top = 24
    Width = 553
    Height = 217
    BevelOuter = bvNone
    BorderStyle = bsNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 553
      Height = 193
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitWidth = 561
      object Label1: TLabel
        Left = 312
        Top = 144
        Width = 31
        Height = 13
        Caption = 'Label1'
      end
      object cbAutoJumpToResult: TCheckBox
        Left = 16
        Top = 8
        Width = 250
        Height = 17
        Caption = 'Auto Jump To First Result'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object cbAdjustToDarkMode: TCheckBox
        Left = 16
        Top = 31
        Width = 250
        Height = 17
        Caption = 'Adjust To Notepad++ Theme Change'
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
      object cbRememberState: TCheckBox
        Left = 16
        Top = 54
        Width = 250
        Height = 17
        Caption = 'Remember state'
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
      object CheckBox4: TCheckBox
        Left = 16
        Top = 77
        Width = 250
        Height = 17
        Caption = 'CheckBox1'
        TabOrder = 3
      end
      object CheckBox5: TCheckBox
        Left = 16
        Top = 100
        Width = 250
        Height = 17
        Caption = 'CheckBox1'
        TabOrder = 4
      end
      object CheckBox6: TCheckBox
        Left = 16
        Top = 123
        Width = 250
        Height = 17
        Caption = 'CheckBox1'
        TabOrder = 5
      end
      object CheckBox7: TCheckBox
        Left = 288
        Top = 8
        Width = 250
        Height = 17
        Caption = 'CheckBox1'
        TabOrder = 6
      end
      object CheckBox8: TCheckBox
        Left = 288
        Top = 31
        Width = 250
        Height = 17
        Caption = 'CheckBox1'
        TabOrder = 7
      end
      object CheckBox9: TCheckBox
        Left = 288
        Top = 54
        Width = 250
        Height = 17
        Caption = 'CheckBox1'
        TabOrder = 8
      end
      object CheckBox10: TCheckBox
        Left = 288
        Top = 77
        Width = 250
        Height = 17
        Caption = 'CheckBox1'
        TabOrder = 9
      end
      object CheckBox11: TCheckBox
        Left = 288
        Top = 100
        Width = 250
        Height = 17
        Caption = 'CheckBox1'
        TabOrder = 10
      end
    end
  end
  object btnOk: TButton
    Left = 185
    Top = 247
    Width = 105
    Height = 25
    Caption = 'Apply Changes'
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 296
    Top = 247
    Width = 105
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
