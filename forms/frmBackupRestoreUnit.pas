unit frmBackupRestoreUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, nppplugin, plugin, NppForms, NppDockingForms,
  Vcl.ExtCtrls, Vcl.StdCtrls, AbBase, AbBrowse, AbZBrows, AbUnzper, JclSysInfo,
  AbZipper, DateUtils, Vcl.Samples.Spin, System.UITypes, JclFileUtils, Utils;

type
  TfrmBackupRestore = class(TNppForm)
    Button1: TButton;
    btnRegexBackup: TButton;
    btnRegexRestore: TButton;
    AbZipper1: TAbZipper;
    AbUnZipper1: TAbUnZipper;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    Button2: TButton;
    Button3: TButton;
    lblDBFile: TLabel;
    procedure btnRegexBackupClick(Sender: TObject);
    procedure btnRegexRestoreClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBackupRestore: TfrmBackupRestore;

implementation

{$R *.dfm}

procedure TfrmBackupRestore.btnRegexBackupClick(Sender: TObject);
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
               '_' + PadInt(hour, 2) + '-' + PadInt(minute, 2) + '-' + PadInt(second, 2) + '.bfrb.zip';

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

procedure TfrmBackupRestore.btnRegexRestoreClick(Sender: TObject);
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

procedure TfrmBackupRestore.FormCreate(Sender: TObject);
begin
  inherited;
  self.lblDBFile.Caption:=GetAppdataFolder + '\BFStuff\BFRegexNPP\bfregex.db';
end;



end.
