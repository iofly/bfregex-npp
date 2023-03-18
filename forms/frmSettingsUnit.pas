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
    OpenDialog1: TOpenDialog;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure btnRegexBackupClick(Sender: TObject);
    procedure btnRegexRestoreClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    function PadInt(i: Integer; width: Integer): string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSettings: TfrmSettings;

implementation

uses frmMainUnit;


{$R *.dfm}

procedure TfrmSettings.btnRegexRestoreClick(Sender: TObject);
var
   dbfile: string;
   zipfilename: string;
   mstr: TMemoryStream;
   deleted: boolean;
begin
  inherited;
  dbfile := GetAppdataFolder + '\BFStuff\BFRegexNPP\bfregex.db';

  if(self.OpenDialog1.Execute(self.Handle)) then begin
   mstr:=TMemoryStream.Create;

   try
      try
         zipfilename:=self.OpenDialog1.FileName;
         self.AbUnZipper1.FileName:=zipfilename;
         self.AbUnZipper1.ExtractToStream('bfregex.db', mstr);

         mstr.Seek(0, soFromBeginning);
         if(FileExists(dbfile)) then begin
            deleted:=FileDelete(dbfile, false)
         end
         else begin
            deleted:=true;
         end;

         if(deleted) then begin
            mstr.SaveToFile(dbfile);
         end
         else begin
            MessageDlg('Could not overwrite current database with restore file. '+#13+#10+'Please try again', mtError, [mbOK], 0);
         end;

      except
         Vcl.Dialogs.MessageDlg('Failed to restore database,', mtError, [mbOK], 0);
      end;
   finally
      mstr.Free;
   end;

  end;

end;



procedure TfrmSettings.FormShow(Sender: TObject);
begin
  inherited;
  self.Activate;
  cbAutoJumpToResult.SetFocus;

end;

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

   dbfile := GetAppdataFolder + '\BFStuff\BFRegexNPP\bfregex.db';
   zipfilename := 'bfregex_backup_' + PadInt(year, 4) + '-' + PadInt(month, 2) + '-' + PadInt(day, 2) +
               '_' + PadInt(hour, 2) + '-' + PadInt(minute, 2) + '-' + PadInt(second, 2) + '.bfrb';

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
