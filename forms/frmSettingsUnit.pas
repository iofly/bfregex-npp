unit frmSettingsUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, nppplugin, plugin, NppForms, NppDockingForms,
  Vcl.ExtCtrls, Vcl.StdCtrls, AbBase, AbBrowse, AbZBrows, AbUnzper, JclSysInfo,
  AbZipper, DateUtils, Vcl.Samples.Spin;

type
  TfrmSettings = class(TNppForm)
    btnCancel: TButton;
    AbUnZipper1: TAbUnZipper;
    SaveDialog1: TSaveDialog;
    AbZipper1: TAbZipper;
    btnOk: TButton;
    Panel1: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    cbAutoJumpToResult: TCheckBox;
    cbAdjustToDarkMode: TCheckBox;
    cbRememberState: TCheckBox;
    GroupBox1: TGroupBox;
    btnRegexBackup: TButton;
    btnRegexRestore: TButton;
    SpinEdit1: TSpinEdit;
    Label3: TLabel;
    procedure btnRegexBackupClick(Sender: TObject);
  private
    function PadInt(i: Integer; width: Integer): string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSettings: TfrmSettings;

implementation

{$R *.dfm}

function TfrmSettings.PadInt(i: Integer; width: Integer): string;
var
   s: string;
   diff: Integer;
   res: string;
   n: Integer;
begin
   s:=IntToStr(i);

   if(Length(s) > width) then begin
      result:=s;
      exit;
   end;


   diff:=width - Length(s);
   res:='';

   for n := 0 to diff - 1 do begin
      res:=res+'0';
   end;

   result:=res + s;
end;


procedure TfrmSettings.btnRegexBackupClick(Sender: TObject);
var
   dbfile: string;
   zipfile: string;
   fs: TFileStream;
   year, month, day, hour, minute, second, ms: Word;
   zipfilename: string;
begin
  inherited;

   DecodeDateTime(now, year, month, day, hour, minute, second, ms);

   dbfile := GetAppdataFolder + '\BFStuff\BFRegexNPP\regex.db';
   zipfilename := 'bfregex_backup_' + PadInt(year, 4) + '-' + PadInt(month, 2) + '-' + PadInt(day, 2) +
               '_' + PadInt(hour, 2) + '-' + PadInt(minute, 2) + '-' + PadInt(second, 2) + '.zip';

   self.SaveDialog1.FileName:=zipfilename;
   if(self.SaveDialog1.Execute(self.Handle)) then begin
      zipfile:=self.SaveDialog1.FileName;

      fs:=TFileStream.Create(dbfile, fmOpenRead, fmShareDenyNone);

      try

         AbZipper1.AutoSave := True;
         AbZipper1.BaseDirectory := ExtractFileDir(zipfile);
         AbZipper1.FileName := zipfile;
         AbZipper1.ZipfileComment := 'BFRegex Notepad++ Plugin Database Backup [V1]';
         fs.Seek(0, soFromBeginning);
         AbZipper1.AddFromStream(ExtractFileName(dbfile), fs);

         AbZipper1.FileName := '';
      finally
         fs.Free;
      end;


   end;

end;

end.
