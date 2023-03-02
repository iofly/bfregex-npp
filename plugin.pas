unit plugin;

interface

uses
  Winapi.Windows,  Winapi.Messages, System.SysUtils,
  System.Classes, Vcl.ComCtrls, SciSupport, Vcl.Forms,
  Vcl.Controls, NppPlugin, Vcl.Dialogs, Vcl.Graphics;

type
  TModalResultArray = array[False..True] of TModalResult;
  TMenuItemCheck = (miHidden,miShown);

  PDarkModeColors = ^TDarkModeColors;
  TDarkModeColors = record
      background: Longint;
      softerBackground: Longint;
      hotBackground: Longint;
      pureBackground: Longint;
      errorBackground: Longint;
      text: Longint;
      darkerText: Longint;
      disabledText: Longint;
      linkText: Longint;
      edge: Longint;
      hotEdge: Longint;
      disabledEdge: Longint;
  end;

  TDarkModeColorsDelphi = record
      background: TColor;
      softerBackground: TColor;
      hotBackground: TColor;
      pureBackground: TColor;
      errorBackground: TColor;
      text: TColor;
      darkerText: TColor;
      disabledText: TColor;
      linkText: TColor;
      edge: TColor;
      hotEdge: TColor;
      disabledEdge: TColor;
  end;





  TdsPlugin = class(TNppPlugin)
  private
    FForm: TForm;
    procedure LoadDarkModeColorsDelphi(nppDarkModeColors: TDarkModeColors; var delphiColors: TDarkModeColorsDelphi);
    procedure DoNppnDarkModeChanged;
  public
    constructor Create;
    function isUnicode: boolean;
    procedure DoNppnToolbarModification; override;
    procedure DoShowHide;
    procedure FuncAbout;
    procedure BeNotified(sn: PSCNotification); override;

  end;

const
   WM_USER_MESSAGE_FROM_THREAD =  WM_USER + 1;
   cnstMainDlgId = 0;

var
  NPlugin: TdsPlugin;



implementation

uses frmMainUnit;

procedure _FuncDoShowHide; cdecl;
begin
  NPlugin.DoShowHide;
end;


procedure _FuncAbout; cdecl;
begin
  NPlugin.FuncAbout;
end;

{ TdsPlugin }

constructor TdsPlugin.Create;
begin
  inherited;

   PluginName := 'BFRegex';
   AddFuncItem('Show BFRegex', _FuncDoShowHide);
   AddFuncItem('About BFRegex', _FuncAbout);
   Sci_Send(SCI_SETMODEVENTMASK,SC_MOD_INSERTTEXT or SC_MOD_DELETETEXT,0);
end;

procedure TdsPlugin.DoNppnToolbarModification;
var
  tb: TToolbarIcons;
  ico1: TtoolbarIconsWithDarkMode;
  //ico2: TtoolbarIconsWithDarkMode;
begin
  tb.ToolbarIcon := 0;

  tb.ToolbarBmp := LoadImage(Hinstance, 'BFREGEX', IMAGE_BITMAP, 0, 0, (LR_DEFAULTSIZE));
  tb.ToolbarIcon:= LoadImage(Hinstance, 'BFREGEXDARK', IMAGE_ICON, 0, 0, (LR_DEFAULTSIZE));

  ico1.hToolbarBmp:=tb.ToolbarBmp;
  ico1.hToolbarIcon:=tb.ToolbarIcon;
  ico1.hToolbarIconDarkMode:=tb.ToolbarIcon;



{  tb.ToolbarBmp := LoadImage(Hinstance, 'BFABOUT', IMAGE_BITMAP, 0, 0, (LR_DEFAULTSIZE));
  tb.ToolbarIcon:= LoadImage(Hinstance, 'BFABOUTDARK', IMAGE_ICON, 0, 0, (LR_DEFAULTSIZE));

  ico2.hToolbarBmp:=tb.ToolbarBmp;
  ico2.hToolbarIcon:=tb.ToolbarIcon;
  ico2.hToolbarIconDarkMode:=tb.ToolbarIcon; }


  tb.ToolbarBmp := LoadImage(Hinstance, 'BFREGEX', IMAGE_BITMAP, 0, 0, (LR_DEFAULTSIZE));
  Npp_Send(NPPM_ADDTOOLBARICON_FORDARKMODE, WPARAM(self.CmdIdFromDlgId(cnstMainDlgId)), LPARAM(@ico1));

{  tb.ToolbarBmp := LoadImage(Hinstance, 'BFABOUT', IMAGE_BITMAP, 0, 0, (LR_DEFAULTSIZE));
  Npp_Send(NPPM_ADDTOOLBARICON_FORDARKMODE, WPARAM(self.CmdIdFromDlgId(cnstMainDlgId+1)), LPARAM(@ico2));    }
end;

function TdsPlugin.isUnicode: boolean;
begin
  result:=true;
end;

procedure TdsPlugin.FuncAbout;
begin
  if not Assigned(FForm) then FForm := TfrmMain.Create(self, cnstMainDlgId);
  (FForm as TfrmMain).btnAboutClick(nil);
end;

procedure TdsPlugin.DoShowHide;
begin
  if not Assigned(FForm) then FForm := TfrmMain.Create(self, cnstMainDlgId);
  (FForm as TfrmMain).Carousel;
end;

procedure TdsPlugin.LoadDarkModeColorsDelphi(nppDarkModeColors: TDarkModeColors; var delphiColors: TDarkModeColorsDelphi);
begin
   delphiColors.background:=TColor(nppDarkModeColors.background);
   delphiColors.softerBackground:=TColor(nppDarkModeColors.softerBackground);
   delphiColors.hotBackground:=TColor(nppDarkModeColors.hotBackground);
   delphiColors.pureBackground:=TColor(nppDarkModeColors.pureBackground);
   delphiColors.errorBackground:=TColor(nppDarkModeColors.errorBackground);
   delphiColors.text:=TColor(nppDarkModeColors.text);
   delphiColors.darkerText:=TColor(nppDarkModeColors.darkerText);
   delphiColors.disabledText:=TColor(nppDarkModeColors.disabledText);
   delphiColors.linkText:=TColor(nppDarkModeColors.linkText);
   delphiColors.edge:=TColor(nppDarkModeColors.edge);
   delphiColors.hotEdge:=TColor(nppDarkModeColors.hotEdge);
   delphiColors.disabledEdge:=TColor(nppDarkModeColors.disabledEdge);
end;

procedure TdsPlugin.DoNppnDarkModeChanged;
var
   ui: NativeInt;
   dmc: TDarkModeColors;
   delphiColors: TDarkModeColorsDelphi;
   msg_param: PDarkModeColors;
  // dt: TDateTime;
   res: NativeInt;

begin

  ui:=Npp_Send(NPPM_ISDARKMODEENABLED,0,0);

  if(ui = 1) then begin
     //ShowMessage('darkmode enabled');
     msg_param:=@dmc;
     res:=Npp_Send(NPPM_GETDARKMODECOLORS, SizeOf(TDarkModeColors), LPARAM(msg_param));
     if(res = 0) then begin
         self.LoadDarkModeColorsDelphi(dmc, delphiColors);
     end;

     if not Assigned(FForm) then FForm := TfrmMain.Create(self, cnstMainDlgId);

     (FForm as TfrmMain).ApplyDarkColorScheme(true, delphiColors);

     {ShowMessage('res = ' + IntToStr(res));
     ShowMessage('background = ' + IntToStr(msg_param.background));
     ShowMessage('softerBackground = ' + IntToStr(msg_param.softerBackground));}

  end
  else begin
      (FForm as TfrmMain).ApplyDarkColorScheme(false, delphiColors);
  end;

end;


procedure TdsPlugin.BeNotified(sn: PSCNotification);
begin
   inherited;
  if (HWND(sn^.nmhdr.hwndFrom) = self.NppData.NppHandle) and (sn^.nmhdr.code = NPPN_DARKMODECHANGED) then begin
    DoNppnDarkModeChanged;
  end;

end;







end.
