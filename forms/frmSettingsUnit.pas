unit frmSettingsUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, nppplugin, plugin, NppForms, NppDockingForms,
  Vcl.ExtCtrls, Vcl.StdCtrls, AbBase, AbBrowse, AbZBrows, AbUnzper, JclSysInfo,
  AbZipper, DateUtils, Vcl.Samples.Spin, System.UITypes, JclFileUtils;

type
  TfrmSettings = class(TNppForm)
    btnCancel: TButton;
    btnOk: TButton;
    Panel1: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    cbAutoJumpToResult: TCheckBox;
    cbAdjustToDarkMode: TCheckBox;
    cbRememberState: TCheckBox;
    SpinEdit1: TSpinEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure FormShow(Sender: TObject);
  private

    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSettings: TfrmSettings;

implementation

uses frmMainUnit;


{$R *.dfm}

procedure TfrmSettings.FormShow(Sender: TObject);
begin
  inherited;
  self.Activate;
  cbAutoJumpToResult.SetFocus;
end;




end.
