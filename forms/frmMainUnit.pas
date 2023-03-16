unit frmMainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, System.Math, Winapi.ShellApi, System.UITypes, System.Generics.Collections,
  Vcl.StdCtrls, System.RegularExpressions, System.RegularExpressionsCore, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Dialogs, System.ImageList, Vcl.ImgList, Vcl.Menus, Vcl.Samples.Spin,
  DateUtils,

  JclSysInfo, JclFileUtils,

  nppplugin, plugin, NppDockingForms,

  Data.DbxSqlite, Data.FMTBcd, Data.DB, Data.SqlExpr,
  FireDAC.UI.Intf, FireDAC.ConsoleUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI,
  FDSqliteTypes, FDSqliteManger, FireDAC.Stan.Def, FireDAC.DApt,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Stan.Async, Vcl.ToolWin;

type
  TfrmMain = class(TNppDockingForm)
    Splitter1: TSplitter;
    pnlEditor: TPanel;
    pnlCfg: TPanel;
    pcResults: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    pnlRegexCfg: TPanel;
    pnlLog: TPanel;
    ListBox1: TListBox;
    imglResultsTree: TImageList;
    mnuRegexLibraryList: TPopupMenu;
    mnuRegexDelete: TMenuItem;
    mnuRegexEdit: TMenuItem;
    N2: TMenuItem;
    pnlRegexOptions: TPanel;
    lblCurrentRegex: TLabel;
    lblEdit: TLabel;
    cbroIgnoreCase: TCheckBox;
    cbroMultiline: TCheckBox;
    cbroExplicitCapture: TCheckBox;
    cbroSingleLine: TCheckBox;
    cbroIgnoreWhitespace: TCheckBox;
    cbroNotEmpty: TCheckBox;
    mnuLog: TPopupMenu;
    mnuClearLog: TMenuItem;
    mnuSaveLog: TMenuItem;
    TabSheet5: TTabSheet;
    Panel7: TPanel;
    Label2: TLabel;
    edSearchRegexLib: TEdit;
    btnSearch: TButton;
    lvRegexLib: TListView;
    Panel8: TPanel;
    rbListMatchTypeFull: TRadioButton;
    rbListMatchTypeGroup: TRadioButton;
    spinGroupToList: TSpinEdit;
    cbIgnoreEmptyGroups: TCheckBox;
    cbIgnoreDuplicates: TCheckBox;
    mmoResults: TMemo;
    TreeView1: TTreeView;
    Splitter2: TSplitter;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    SynEdit1: TMemo;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    ImageList1: TImageList;
    pnlRegexToolbar: TPanel;
    btnAbout: TSpeedButton;
    btnRun: TSpeedButton;
    btnClear: TSpeedButton;
    btnSaveAs: TSpeedButton;
    btnSave: TSpeedButton;
    btnNew: TSpeedButton;
    pnlTBJankySpacer: TPanel;
    btnSettings: TSpeedButton;
    imglResultsPageControl: TImageList;
    pnlTabSwitchButtons: TPanel;
    btnTab2: TSpeedButton;
    btnTab1: TSpeedButton;
    btnTab0: TSpeedButton;
    pnlDBAccessWarning: TPanel;
    lblDBAccessWarning: TLabel;
    lblDBFileName: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
    procedure TreeView1Deletion(Sender: TObject; Node: TTreeNode);
    procedure btnAboutClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure mnuRegexLibraryListPopup(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure lvRegexLibDeletion(Sender: TObject; Item: TListItem);
    procedure btnSaveClick(Sender: TObject);
    procedure mnuRegexDeleteClick(Sender: TObject);
    procedure mnuRegexEditClick(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure SynEdit1cChange(Sender: TObject);
    procedure cbroIgnoreCaseClick(Sender: TObject);
    procedure mnuClearLogClick(Sender: TObject);
    procedure SynEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure SynEdit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Splitter1Moved(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure btnTab0Click(Sender: TObject);
    procedure pcResultsChange(Sender: TObject);
  private

    FMenuItemCheck: TMenuItemCheck;
    globalSelStart: Integer;
    defaultDBFileName: string;
    currentRegexID: Integer;
    currentRegexTitle: string;
    currentRegexIsDirty: boolean;
    selectSingleList: TList<TAppRegex>;
    sqlMan: TFDSqliteManager;
    ProcessingChanges: boolean;
    darkModeColors: TDarkModeColorsDelphi;
    settings: TSettingsContainer;

    procedure RefreshSettings;
    procedure InsertStringAtcaret(MyMemo: TMemo; const MyString: string);
    procedure SetUpHighlighters;
    procedure SetMenuItemCheck(const Value: TMenuItemCheck);
    procedure LogItem(str: string);
    procedure ClearHighlighters;
    procedure DoSearch(searchTerm: string);
    procedure SaveRegex(isSaveAs: boolean; out errormessage: string; out success: boolean);
    function IfThenStr(b: boolean; trueStr, falseStr: string): string;
  protected

  public
    procedure Carousel;
    procedure ApplyDarkColorScheme(isDarkMode: boolean; delphiColors: TDarkModeColorsDelphi);
    property MenuItemCheck: TMenuItemCheck read FMenuItemCheck write SetMenuItemCheck;
  end;


implementation

uses
  Vcl.Clipbrd, frmRegexTitleUnit, frmAboutUnit, RegexUtils, SciSupport, frmSettingsUnit;


{$R *.dfm}


//todo status display if unable to create database file
//todo restore previous state between runtimes , settings, tab index and text, load last regex, isdirty etc.

//DONE ability to back up database file
//DONE auto scroll to first result
//DONE ignore duplicates for list full match doesn't work
//DONE todo detect and adapt to darkmode
//DONE make text highlighers darker for dark mode because the textitself is bright making bright highlighters confuses and hard to see text.
procedure TfrmMain.pcResultsChange(Sender: TObject);
begin
  inherited;
//

   case self.pcResults.ActivePageIndex of
      0: begin
         self.btnTab0.Down:=true;
      end;
      1: begin
        self.btnTab1.Down:=true;
      end;
      2: begin
         self.btnTab2.Down:=true;
      end;
   end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
   i: Integer;
begin
   ProcessingChanges:=false;
   NppDefaultDockingMask := DWS_DF_FLOATING;
   FMenuItemCheck := miHidden;
   self.defaultDBFileName:=GetAppdataFolder + '\BFStuff\BFRegexNPP\bfregex.db';
   selectSingleList:=TList<TAppRegex>.Create;
   sqlMan:=TFDSqliteManager.Create(self.defaultDBFileName, true);

   settings:=TSettingsContainer.Create;
   self.RefreshSettings;
   self.DoSearch('');

   for i := 0 to self.pcResults.PageCount-1 do begin
      self.pcResults.Pages[i].TabVisible:=false;
   end;
   self.pcResults.ActivePageIndex:=0;
   self.btnTab0.Down:=true;

   if not (sqlMan.DBIsAccessible) then begin
      btnSave.Enabled:=false;
      btnSaveAs.Enabled:=false;
      self.btnTab2.Visible:=false;
      lblDBFileName.Caption:=GetAppdataFolder + '\BFStuff\BFRegexNPP\bfregex.db';
      self.pnlDBAccessWarning.Visible:=true;
   end;


end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  inherited;

  settings.Free;
  selectSingleList.Free;
  sqlMan.Free;
end;

procedure TfrmMain.RefreshSettings;
var
   errormessage: string;
   success: boolean;
begin
   settings.Clear;
   sqlMan.GetSettings(settings, errormessage, success);
end;

procedure TfrmMain.FormHide(Sender: TObject);
begin
  MenuItemCheck := miHidden;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
   dmc: TDarkModeColors;
   msg_param: PDarkModeColors;
  // dt: TDateTime;
   res: NativeInt;
begin
   inherited;



  if(NPlugin.IsDarkMode) and (settings.AsBool('AdjustToDarkMode', true)) then begin
     //ShowMessage('darkmode enabled');
     msg_param:=@dmc;
     res:=NPLugin.Npp_Send(NPPM_GETDARKMODECOLORS, SizeOf(TDarkModeColors), LPARAM(msg_param));
     if(res = 1) then begin
         darkModeColors:=NPLugin.GetDarkModeColorsDelphi(dmc);
     end;

     self.ApplyDarkColorScheme(true, darkModeColors);
  end
  else begin
      self.ApplyDarkColorScheme(false, darkModeColors);
  end;

end;

procedure TfrmMain.btnAboutClick(Sender: TObject);
var
  frmAbout: TfrmAbout;
begin
  inherited;

  frmAbout:=TfrmAbout.Create(Npp);
  try

      if(NPlugin.IsDarkMode) and (settings.AsBool('AdjustToDarkMode', true)) then begin
         frmAbout.Color:=self.darkModeColors.softerBackground;
         frmAbout.GroupBox1.Font.Color:=self.darkModeColors.text;
         frmAbout.Label1.Font.Color:=self.darkModeColors.text;
         frmAbout.Label2.Font.Color:=self.darkModeColors.text;
         frmAbout.Label3.Font.Color:=self.darkModeColors.text;
         frmAbout.btnOk.Font.Color:=self.darkModeColors.text;
      end;
    frmAbout.ShowModal;
  finally
    frmAbout.Free;
  end;
end;

procedure TfrmMain.btnClearClick(Sender: TObject);
begin
  inherited;

  self.ClearHighlighters;
end;

procedure TfrmMain.btnNewClick(Sender: TObject);
begin
  inherited;
   currentRegexID:=0;
   currentRegexTitle:='';
   currentRegexIsDirty:=false;

   lblCurrentRegex.Caption:='(Untitled)';
   SynEdit1.Text:='';

   cbroIgnoreCase.Checked:=true;
   cbroSingleLine.Checked:=false;
   cbroMultiline.Checked:=false;
   cbroIgnoreWhitespace.Checked:=false;
   cbroExplicitCapture.Checked:=false;
   cbroNotEmpty.Checked:=false;

   selectSingleList.Clear;
end;

procedure TfrmMain.SetUpHighlighters;
var
   isdarkmode: boolean;
begin

   isdarkmode:=NPlugin.IsDarkMode and (settings.AsBool('AdjustToDarkMode', true));

    NPlugin.Sci_Send(SCI_INDICSETSTYLE, 1, INDIC_ROUNDBOX);
    if(isdarkmode) then
       NPlugin.Sci_Send(SCI_INDICSETFORE, 1, $006600)
    else
       NPlugin.Sci_Send(SCI_INDICSETFORE, 1, $00FF00);//$FFAAFF);

    NPlugin.Sci_Send(SCI_INDICSETALPHA, 1, 127 );
    NPlugin.Sci_Send(SCI_INDICSETOUTLINEALPHA, 1, 255 );
    NPlugin.Sci_Send(SCI_INDICSETUNDER, 1, 1);

    NPlugin.Sci_Send(SCI_INDICSETSTYLE, 2, INDIC_ROUNDBOX);
    if(isdarkmode) then
       NPlugin.Sci_Send(SCI_INDICSETFORE, 2, $880000)
    else
       NPlugin.Sci_Send(SCI_INDICSETFORE, 2, $00FFFF);
    NPlugin.Sci_Send(SCI_INDICSETALPHA, 2, 255);
    NPlugin.Sci_Send(SCI_INDICSETOUTLINEALPHA, 2, 255 );
    NPlugin.Sci_Send(SCI_INDICSETUNDER, 2, 1);

    NPlugin.Sci_Send(SCI_INDICSETSTYLE, 3, INDIC_ROUNDBOX);
    if(isdarkmode) then
       NPlugin.Sci_Send(SCI_INDICSETFORE, 3, $ffffff)
    else
       NPlugin.Sci_Send(SCI_INDICSETFORE, 3, $444444);
    NPlugin.Sci_Send(SCI_INDICSETALPHA, 3, 24);
    NPlugin.Sci_Send(SCI_INDICSETOUTLINEALPHA, 3, 255 );
    NPlugin.Sci_Send(SCI_INDICSETUNDER, 3, 1);
end;


procedure TfrmMain.Splitter1Moved(Sender: TObject);
begin
  inherited;
  lblCurrentRegex.Width:= pnlRegexOptions.Width - 81;
end;

procedure TfrmMain.SynEdit1cChange(Sender: TObject);
begin
  inherited;

  currentRegexIsDirty:=true;
  lblEdit.Caption:='Editing *:'
end;

procedure TfrmMain.SynEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  inherited;

  if(Ord(Key) = 13) then begin

     InsertStringAtcaret(SynEdit1, chr(10) + chr(13));


    { self.SynEdit1.Text := self.SynEdit1.Text + chr(10) + chr(13);
     SynEdit1.SelLength := 0;
      SynEdit1.SelText := chr(10) + chr(13);
             }


     //SynEdit1.SelLength := 0;
     // SynEdit1.SelStart := Length(SynEdit1.Text);
  end;
 // self.LogItem('KeyPress: Key = ' + IntToStr(Ord(Key)));// Integer(Key));


end;

procedure TfrmMain.SynEdit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
   istext: boolean;
begin
  inherited;

  if (ProcessingChanges) then exit;

  ProcessingChanges:=true;

  try
     istext := Length(self.SynEdit1.Text) > 0;


     self.btnSave.Enabled := istext and sqlMan.DBIsAccessible;
     self.btnSaveAs.Enabled := istext and sqlMan.DBIsAccessible;


     self.btnRun.Enabled := istext;
     lblEdit.Caption:='Editing *:';

     if currentRegexID > 0 then begin
         currentRegexIsDirty:=true;
     end;
  finally
    ProcessingChanges:=false;
  end;
end;




procedure TfrmMain.InsertStringAtcaret(MyMemo: TMemo; const MyString: string);
begin
  MyMemo.Text :=
  // copy the text before the caret
    Copy(MyMemo.Text, 1, MyMemo.SelStart) +
  // then add your string
    MyString +
  // and now ad the text from the memo that cames after the caret
  // Note: if you did have selected text, this text will be replaced, in other words, we copy here the text from the memo that cames after the selection
    Copy(MyMemo.Text, MyMemo.SelStart + MyMemo.SelLength + 1, length(MyMemo.Text));

  // clear text selection
  MyMemo.SelLength := 0;
  // set the caret after the inserted string
  MyMemo.SelStart := MyMemo.SelStart + length(MyString) + 1;
end;

procedure TfrmMain.btnRunClick(Sender: TObject);
var
  matches: TMatchCollection;
  useText: String;
  selLength: Integer;
  i: Integer;
  isvalid: boolean;
  node, cnode: TTreeNode;
  g: Integer;
  hilitegroups: boolean;
  global_group_index: Integer;
  rng: TMyTextRange;
  opts: TRegexOptions;
  success: boolean;
  errormessage: string;
  selstart: Integer;
  resultsAsText: TStringList;
  resultsAsTextSortedShadow: TStringList;
  tmp: Integer;
  groupIndex: Integer;

   maxChars: Integer;
begin
  inherited;

  if(Length(SynEdit1.Text)=0) then begin
     exit;
  end;

  globalSelStart:=0;
  resultsAsText:=TStringList.Create;
  resultsAsTextSortedShadow:=TStringList.Create;
  resultsAsTextSortedShadow.Sorted:=true;
  resultsAsTextSortedShadow.Duplicates:=dupIgnore;


  self.mmoResults.Lines.BeginUpdate;
  TreeView1.Items.BeginUpdate;
  try

    isvalid:= IsValidRegex(SynEdit1.Text);

    if(not isvalid) then begin
      //lblStatus.Caption:='Regex is not valid';
      exit;
    end;

    selLength:= 0;

    maxChars:=settings.AsInt64('MaxRegexTestTextChars', 0);

    useText:=NPlugin.GetSubText(maxChars);//GetText;
   

    ClearHighlighters;
    SetUpHighlighters;
    NPlugin.Sci_Send(SCI_SETINDICATORCURRENT, 1, 0);

    global_group_index:=0;
    hilitegroups:=true;

    opts:=[];
    if(self.cbroIgnoreCase.Checked) then Include(opts, roIgnoreCase);
    if(self.cbroSingleLine.Checked) then Include(opts, roSingleLine);
    if(self.cbroMultiline.Checked) then Include(opts, roMultiline);
    if(self.cbroIgnoreWhitespace.Checked) then Include(opts, roIgnorePatternSpace);
    if(self.cbroExplicitCapture.Checked) then Include(opts, roExplicitCapture);
    if(self.cbroNotEmpty.Checked) then Include(opts, roNotEmpty);

    matches:=GetMatches(SynEdit1.Text, useText, success, errormessage, opts);
    selstart:=NPlugin.GetSelStart;
    globalSelStart:=0;

    if(selLength = 0) then
      selstart:=0;

    if not success then begin
        LogItem(errormessage);
    end
    else begin

        NPlugin.Sci_Send(SCI_SETINDICATORCURRENT, 1, 0);
        NPlugin.Sci_Send(SCI_INDICATORCLEARRANGE, 0, Length(NPlugin.GetText) - 1);
        NPlugin.Sci_Send(SCI_SETINDICATORCURRENT, 2, 0);
        NPlugin.Sci_Send(SCI_INDICATORCLEARRANGE, 0, Length(NPlugin.GetText) - 1);
        LogItem(IntTostr(matches.Count) + ' matches');

        for i := 0 to matches.Count-1 do begin

          if ((matches[i].Groups.Count>1) and (hilitegroups = true)) then begin
            for g := 1 to matches[i].Groups.Count-1 do begin

              if (not matches[i].Groups[g].Success) then
              continue;

              if(Length(matches[i].Groups[g].Value) = 0) then
              continue;

              if(global_group_index mod 2 = 0) then
                 NPlugin.Sci_Send(SCI_SETINDICATORCURRENT, 1, 0)
              else
                 NPlugin.Sci_Send(SCI_SETINDICATORCURRENT, 2, 0);

              NPlugin.Sci_Send(SCI_INDICATORFILLRANGE, matches[i].Groups[g].Index - 1 + selstart, matches[i].Groups[g].Length);

              global_group_index:=global_group_index+1;
              NPlugin.Sci_Send(SCI_SETINDICATORCURRENT, 3, 0);
              NPlugin.Sci_Send(SCI_INDICATORFILLRANGE, matches[i].Index - 1 + selstart , matches[i].Length);
            end;
          end
          else begin
            if(i mod 2 = 0) then
               NPlugin.Sci_Send(SCI_SETINDICATORCURRENT, 1, 0)
            else
               NPlugin.Sci_Send(SCI_SETINDICATORCURRENT, 2, 0);

            NPlugin.Sci_Send(SCI_INDICATORFILLRANGE, matches[i].Index -1 + selstart , matches[i].Length);
          end;

          node:=TreeView1.Items.Add(nil, matches[i].Value);
          rng:=TMyTextRange.Create;
          rng.Start:=matches[i].Index;
          rng.Length:=matches[i].Length;
          node.Data:=rng;
          node.ImageIndex:=0;

          if(matches[i].Groups.Count>1) then begin
            for g := 1 to matches[i].Groups.Count-1 do begin
                if(matches[i].Groups[g].Success) then begin
                   cnode:=TreeView1.Items.AddChild(node, 'Group ' + IntToStr(g) + ': index=' + IntToStr(matches[i].Groups[g].Index) + ' length=' + IntToStr(matches[i].Groups[g].Length) + ' value=' + matches[i].Groups[g].Value);
                   rng:=TMyTextRange.Create;
                   rng.Start:=matches[i].Groups[g].Index;
                   rng.Length:=matches[i].Groups[g].Length;
                   cnode.Data:=rng;
                   cnode.ImageIndex:=1;
                end;
            end;
          end;


        end;


        {try
           for i := 0 to matches.Count-1 do begin
            self.LogItem('match[' + IntToStr(i) + ']');
            self.LogItem('    value = ' + matches[i].Value);
            for g := 0 to matches[i].Groups.Count-1 do begin
                self.LogItem('        group['+IntToStr(g)+'].Value = ' + matches[i].Groups[g].Value);
            end;
           end;
        except
            mt:=matches[i];
           self.LogItem('err match:=' + matches[i].Value);
        end; }


        if(rbListMatchTypeGroup.Checked) then begin
           groupIndex:=spinGroupToList.Value;
           for i := 0 to matches.Count-1 do begin
               if(matches[i].Groups.Count > groupIndex) then begin
                  if (cbIgnoreEmptyGroups.Checked) and (Length(matches[i].Groups[groupIndex].Value) = 0) then
                     continue;

                  if(cbIgnoreDuplicates.Checked) then begin
                        if(resultsAsTextSortedShadow.Find(matches[i].Groups[groupIndex].Value, tmp)) then
                          continue;
                        resultsAsTextSortedShadow.Add(matches[i].Groups[groupIndex].Value);
                        resultsAsText.Add(matches[i].Groups[groupIndex].Value);
                   end
                   else begin
                      resultsAsText.Add(matches[i].Groups[groupIndex].Value);
                   end;
               end;
           end;

        end
        else if(rbListMatchTypeFull.Checked) then begin
           for i := 0 to matches.Count-1 do begin
              resultsAsText.Add(matches[i].Value);
           end;
        end;

    end;

    //If on lib page go to results page
    if(resultsAsText.Count>0) then begin
       if(self.pcResults.ActivePageIndex = 2) then begin
          self.pcResults.ActivePageIndex := 0;
          self.btnTab0.Down:=true;

          if(settings['AutoJumpToFirstResult'].AsBool(true)) then begin
             if(self.TreeView1.Items.Count>0) then begin
               self.TreeView1.SetFocus;
               self.TreeView1.Selected:=self.TreeView1.Items[0];
               TreeView1DblClick(nil);
             end;
          end;


       end;
    end;

  finally
      self.mmoResults.Text := resultsAsText.Text;
      resultsAsTextSortedShadow.Free;
      resultsAsText.Free;
      self.mmoResults.Lines.EndUpdate;
      TreeView1.Items.EndUpdate;
  end;

end;

procedure TfrmMain.DoSearch(searchTerm: string);
var
  res: TList<TAppRegex>;
  errormessage: string;
  success: boolean;
 // dt: TDateTime;
  i: Integer;
  li: TListItem;
  ritem: TAppRegex;
  r: TListItemDataRegexReference;
  regexid: Integer;
  ob: TRegexsOrderBy;
begin

   try
      self.lvRegexLib.Items.BeginUpdate;
      self.lvRegexLib.Items.Clear;
   finally
      self.lvRegexLib.Items.EndUpdate;
   end;

   res := TList<TAppRegex>.Create();
   regexid := 0;
   ob := TRegexsOrderBy.robTitleAsc;

   sqlman.GetRegexs(res, errormessage, success, regexid, searchTerm, ob);
   if(res<>nil) then begin
     if(res.Count>0) then begin

      self.lvRegexLib.Items.BeginUpdate;

      try
        self.lvRegexLib.Items.Clear;

        for i := 0 to res.Count-1 do begin
           ritem:=res[i];

           r:=TListItemDataRegexReference.Create;
           r.RegexID:=ritem.DBExpressionID;

           li:=self.lvRegexLib.Items.Add;
           li.Data:=r;
           li.Caption:=ritem.Title;
           li.SubItems.Add(IfThenStr(ritem.Flag_IgnoreCase, 'Y', 'N'));
           li.SubItems.Add(IfThenStr(ritem.Flag_SingeLine, 'Y', 'N'));
           li.SubItems.Add(IfThenStr(ritem.Flag_MultiLine, 'Y', 'N'));
           li.SubItems.Add(IfThenStr(ritem.Flag_IgnorePatternSpace, 'Y', 'N'));
           li.SubItems.Add(IfThenStr(ritem.Flag_ExplicitCapture, 'Y', 'N'));
           li.SubItems.Add(IfThenStr(ritem.Flag_NotEmpty, 'Y', 'N'));
        end;

      finally
        self.lvRegexLib.Items.EndUpdate;
      end;
     end;
   end;
end;


procedure TfrmMain.SaveRegex(isSaveAs: boolean;out errormessage: string; out success: boolean);
var
  item: TAppRegex;
  frmRegexTitle: TfrmRegexTitle;
  regexTitle: string;
  modalresult: TModalResult;
  res: TList<TAppRegex>;
begin

  inherited;

  if (currentRegexID = 0) or (isSaveAs=true) then begin

    isSaveAs:=true;

    frmRegexTitle:=TfrmRegexTitle.Create(Npp);
    try

      if(NPlugin.IsDarkMode) and (settings.AsBool('AdjustToDarkMode', true)) then begin
         frmRegexTitle.Color:=self.darkModeColors.softerBackground;
         frmRegexTitle.edRegexTitle.Color:=self.darkModeColors.softerBackground;
         frmRegexTitle.edRegexTitle.Font.Color:=self.darkModeColors.text;
         frmRegexTitle.Label1.Font.Color:=self.darkModeColors.Text;
      end;

       modalresult:=frmRegexTitle.ShowModal;
       if(modalresult <> mrOk) then begin
         exit;
       end;
       regexTitle:=frmRegexTitle.edRegexTitle.Text;
    finally
       frmRegexTitle.Free;
    end;

    //Get new title as it is Save As...
  end
  else begin
    regexTitle:= currentRegexTitle;
  end;


  if(isSaveAs) then begin

    item:=TAppRegex.Create;

    try
       item.Title:=Trim(regexTitle);
       item.Expression:=SynEdit1.Text;
       item.Flag_IgnoreCase:=self.cbroIgnoreCase.Checked;
       item.Flag_SingeLine:=self.cbroSingleLine.Checked;
       item.Flag_MultiLine:=self.cbroMultiline.Checked;
       item.Flag_IgnorePatternSpace:=self.cbroIgnoreWhitespace.Checked;
       item.Flag_ExplicitCapture:=self.cbroExplicitCapture.Checked;
       item.Flag_NotEmpty:=self.cbroNotEmpty.Checked;
       item.Count_Open:=1;
       item.Count_Save:=1;

       item.DateCreated:=DateTimeToUnix(TTimeZone.Local.ToUniversalTime(Now), true);
       item.DateModified:=DateTimeToUnix(TTimeZone.Local.ToUniversalTime(Now), true);
       sqlMan.InsertRegex(item, errorMessage, success);

       if(success) then begin
         currentRegexID:=item.DBExpressionID;
         currentRegexTitle:=regexTitle;
         currentRegexIsDirty:=false;
         self.lblEdit.Caption:='Edit:';
       end;

    finally
       item.Free;
    end;

  end
  else begin
     item:=TAppRegex.Create;
     res:=TList<TAppRegex>.Create;

     try
        sqlMan.GetRegexs(res, errormessage, success, currentRegexID, '');

        if(success) then begin
           item.Title:=Trim(regexTitle);
           item.Expression:=SynEdit1.Text;
           item.Flag_IgnoreCase:=self.cbroIgnoreCase.Checked;
           item.Flag_SingeLine:=self.cbroSingleLine.Checked;
           item.Flag_MultiLine:=self.cbroMultiline.Checked;
           item.Flag_IgnorePatternSpace:=self.cbroIgnoreWhitespace.Checked;
           item.Flag_ExplicitCapture:=self.cbroExplicitCapture.Checked;
           item.Flag_NotEmpty:=self.cbroNotEmpty.Checked;
           item.DBExpressionID := currentRegexID;

           //item.DateCreated:= DateTimeToUnix(TTimeZone.Local.ToUniversalTime(Now), true);
           item.DateModified:=DateTimeToUnix(TTimeZone.Local.ToUniversalTime(Now), true);
           sqlMan.UpdateRegex(item, errorMessage, success);

           if(success) then begin
             //currentRegexID:=item.DBExpressionID;
             currentRegexTitle:=regexTitle;
             currentRegexIsDirty:=false;
             self.lblEdit.Caption:='Edit:';
           end;

        end;
     finally
        item.Free;
     end;

  end;

  self.DoSearch('');
end;

procedure TfrmMain.btnSaveAsClick(Sender: TObject);
var
  errormessage: string;
  success: boolean;
begin
  inherited;

  SaveRegex(true, errormessage, success);
end;

procedure TfrmMain.btnSaveClick(Sender: TObject);
var
  errorMessage: string;
  success: boolean;
begin
  inherited;

  SaveRegex(false, errormessage, success);
end;

procedure TfrmMain.btnSearchClick(Sender: TObject);
begin
  inherited;

  self.DoSearch(edSearchRegexLib.Text);
end;

procedure TfrmMain.btnSettingsClick(Sender: TObject);
var
   frmSettings: TfrmSettings;
   mr: TModalResult;
   errormessage: string;
   success: boolean;
begin
  inherited;

   frmSettings:=TfrmSettings.Create(Npp);
   try

     self.RefreshSettings;

     frmSettings.cbAutoJumpToResult.Enabled:=sqlMan.DBIsAccessible;
     frmSettings.cbAdjustToDarkMode.Enabled:=sqlMan.DBIsAccessible;
     frmSettings.cbRememberState.Enabled:=sqlMan.DBIsAccessible;
     frmSettings.btnRegexBackup.Enabled:=sqlMan.DBIsAccessible;
     frmSettings.btnRegexRestore.Enabled:=sqlMan.DBIsAccessible;

     frmSettings.cbAutoJumpToResult.Checked:=settings.AsBool('AutoJumpToFirstResult', true);
     frmSettings.cbAdjustToDarkMode.Checked:=settings.AsBool('AdjustToDarkMode', true);
     frmSettings.cbRememberState.Checked:=settings.AsBool('RememberState', true);
     frmSettings.SpinEdit1.Value := settings.AsInt64('MaxRegexTestTextChars', 0);

     if(NPlugin.IsDarkMode) and (settings.AsBool('AdjustToDarkMode', true)) then begin
       frmSettings.Color:=self.darkModeColors.softerBackground;
       frmSettings.SpinEdit1.Color:=self.darkModeColors.softerBackground;
       frmSettings.SpinEdit1.Font.Color:=self.darkModeColors.text;
       frmSettings.Label1.Font.Color:=self.darkModeColors.text;
       frmSettings.Label2.Font.Color:=self.darkModeColors.text;
       frmSettings.Label3.Font.Color:=self.darkModeColors.text;
       frmSettings.Label4.Font.Color:=self.darkModeColors.text;
     end;

     self.sqlMan.Disconnect;
     self.sqlMan.Free;
     mr:=frmSettings.ShowModal;

     if(mr = mrOk) then begin
         settings.SetBool('AutoJumpToFirstResult', frmSettings.cbAutoJumpToResult.Checked);
         settings.SetBool('AdjustToDarkMode', frmSettings.cbAdjustToDarkMode.Checked);
         settings.SetBool('RememberState', frmSettings.cbRememberState.Checked);
         settings.SetInt64('MaxRegexTestTextChars', frmSettings.SpinEdit1.Value);
         NPlugin.DoNppnDarkModeChanged;
         //self.Refresh;
     end;
   finally
       sqlMan:=TFDSqliteManager.Create(self.defaultDBFileName, true);
       sqlman.UpdateSettings(settings, errormessage, success);

     frmSettings.Free;

   end;

   self.RefreshSettings;
end;

procedure TfrmMain.btnTab0Click(Sender: TObject);
begin
  inherited;
  self.pcResults.ActivePageIndex:=(sender as TSpeedButton).Tag;
  (sender as TSpeedButton).Down:=true;
end;

procedure TfrmMain.LogItem(str: string);
begin
    self.ListBox1.Items.Add(str);
    self.ListBox1.ItemIndex:=self.ListBox1.Items.Count-1;
end;

procedure TfrmMain.lvRegexLibDeletion(Sender: TObject; Item: TListItem);
{var
  lf: TListItemDataRegexReference; }
begin
  inherited;

  if(Item.Data = nil) then exit;

  //lf:=TListItemDataRegexReference(Item.Data);
  TListItemDataRegexReference(Item.Data).Free;

end;

procedure TfrmMain.mnuClearLogClick(Sender: TObject);
begin
  inherited;
   self.ListBox1.Items.BeginUpdate;
   try
      self.ListBox1.Clear;
   finally
      self.ListBox1.Items.EndUpdate;
   end;

end;

procedure TfrmMain.mnuRegexDeleteClick(Sender: TObject);
var
  i: Integer;
  id: TListItemDataRegexReference;
  errormessage: string;
  success: boolean;
  index: Integer;
begin
inherited;

  self.lvRegexLib.Items.BeginUpdate;
  index:=self.lvRegexLib.ItemIndex;


  try
       if(index<0) then
         exit;

       for i := self.lvRegexLib.Items.Count-1 downto 0 do begin
         if(self.lvRegexLib.Items[i].Selected) then begin
             id := TListItemDataRegexReference(self.lvRegexLib.Items[i].Data);

             sqlMan.DeleteRegex(id.RegexID, errormessage, success);

             if(success) then begin
                 self.lvRegexLib.Items.Delete(i);
                 self.DoSearch('');
             end;
         end;
       end;

  finally
    self.lvRegexLib.Items.EndUpdate;
    if(success) then begin
         if(self.lvRegexLib.Items.Count > index) then begin
            if(index>0) then begin
               self.lvRegexLib.SetFocus;
               lvRegexLib.Selected := lvRegexLib.Items[index-1];
            end
            else begin
               self.lvRegexLib.SetFocus;
               lvRegexLib.Selected := lvRegexLib.Items[0];
            end;
         end;
         self.SynEdit1.Clear;
    end;
  end;

end;

procedure TfrmMain.mnuRegexEditClick(Sender: TObject);
var
  id: TListItemDataRegexReference;
   istext: boolean;
  errormessage: string;
  success: boolean;
begin
 inherited;

  if(self.lvRegexLib.SelCount<>1) then
    exit;

   if(currentRegexIsDirty=true) or ((self.currentRegexID=0) and (Length(Trim(self.SynEdit1.Text))>0)) then begin
      case MessageDlg('The regular expression has changed. Would you like to save the changes?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
          mrYes: begin
             btnSaveClick(nil);
          end;
          mrNo: begin

          end;
          mrCancel: begin
             exit;
          end;
      end;
   end;


  id:=TListItemDataRegexReference(self.lvRegexLib.Selected.Data);
  if(id = nil) then begin
     self.LogItem('Could not retrieve selected regex from store');
     exit;
  end;

  selectSingleList.Clear;
  try

    sqlMan.GetRegexs(selectSingleList, errormessage, success, id.RegexID, '');

     if(selectSingleList = nil) then begin
        self.LogItem('Could not retrieve selected regex from datastore');
        exit;
     end;
     if(selectSingleList.Count = 0) then begin
        self.LogItem('Could not retrieve selected regex from database');
        exit;
     end;

    if(success) then begin

      self.currentRegexID:=selectSingleList[0].DBExpressionID;
      self.currentRegexTitle:=selectSingleList[0].Title;
      self.lblCurrentRegex.Caption:=selectSingleList[0].Title;
      currentRegexIsDirty:=false;
      self.lblEdit.Caption:='Edit:';

      self.SynEdit1.Text:=Trim(selectSingleList[0].Expression);
      self.cbroIgnoreCase.Checked:=selectSingleList[0].Flag_IgnoreCase;
      self.cbroSingleLine.Checked:=selectSingleList[0].Flag_SingeLine;
      self.cbroMultiline.Checked:=selectSingleList[0].Flag_MultiLine;
      self.cbroIgnoreWhitespace.Checked:=selectSingleList[0].Flag_IgnorePatternSpace;
      self.cbroExplicitCapture.Checked:=selectSingleList[0].Flag_ExplicitCapture;
      self.cbroNotEmpty.Checked:=selectSingleList[0].Flag_NotEmpty;

      self.currentRegexIsDirty:=false;
      self.lblEdit.Caption:='Edit:';





     istext := Length(self.SynEdit1.Text) > 0;
     self.btnSave.Enabled := istext and sqlMan.DBIsAccessible;
     self.btnSaveAs.Enabled := istext and sqlMan.DBIsAccessible;
     self.btnRun.Enabled := istext;




    end;
  finally

  end;
end;

procedure TfrmMain.mnuRegexLibraryListPopup(Sender: TObject);
begin
  inherited;
  self.mnuRegexDelete.Enabled:=  lvRegexLib.SelCount>0;
    self.mnuRegexEdit.Enabled:=  lvRegexLib.SelCount=1;
end;

procedure TfrmMain.Carousel;
begin
  if MenuItemCheck  = miShown then begin
    Hide;
  end
  else
  begin
    Show;
    MenuItemCheck := miShown;
  end;
end;

procedure TfrmMain.cbroIgnoreCaseClick(Sender: TObject);
var
   istext: boolean;
begin
  inherited;

  if (ProcessingChanges) then exit;

  ProcessingChanges:=true;
  try
     istext := Length(self.SynEdit1.Text) > 0;
     self.btnSave.Enabled := istext and sqlMan.DBIsAccessible;
     self.btnSaveAs.Enabled := istext and sqlMan.DBIsAccessible;
     self.btnRun.Enabled := istext;
     lblEdit.Caption:='Editing *:';

     if currentRegexID > 0 then begin
         currentRegexIsDirty:=true;
     end;
  finally
    ProcessingChanges:=false;
  end;


  
end;

procedure TfrmMain.SetMenuItemCheck(const Value: TMenuItemCheck);
begin
  if Value <> FMenuItemCheck then
  begin
    SendMessage(Npp.NppData.NppHandle, NPPM_SETMENUITEMCHECK, CmdId, LPARAM(Value));
    FMenuItemCheck := Value;
  end;
end;

procedure TfrmMain.ClearHighlighters;
var
  selstart: Integer;
  selLength: Integer;
   useText: String;
  len: Integer;
begin
    selLength:= NPlugin.GetSelLength;

    if(selLength<=0) then begin
      useText:=NPlugin.GetText;
      selstart:=0;
      len:=Length(useText);
    end
    else begin
      selstart:=NPlugin.GetSelStart;
      useText:=NPlugin.SelectedText;
      len:=Length(useText);
    end;

    NPlugin.Sci_Send(SCI_SETINDICATORCURRENT, 1, 0);
    NPlugin.Sci_Send(SCI_INDICATORCLEARRANGE, selstart, len-1 );
    NPlugin.Sci_Send(SCI_SETINDICATORCURRENT, 2, 0);
    NPlugin.Sci_Send(SCI_INDICATORCLEARRANGE, selstart, len-1 );
    NPlugin.Sci_Send(SCI_SETINDICATORCURRENT, 3, 0);
    NPlugin.Sci_Send(SCI_INDICATORCLEARRANGE, selstart, len-1 );

    TreeView1.Items.BeginUpdate;
    mmoResults.Lines.BeginUpdate;
    try
      TreeView1.Items.Clear;
      mmoResults.Clear;
    finally
      TreeView1.Items.EndUpdate;
      mmoResults.Lines.EndUpdate;
    end;

end;


procedure TfrmMain.TreeView1DblClick(Sender: TObject);
var
  node: TTreeNode;
  rng: TMyTextRange;
begin
  inherited;
  node:=self.TreeView1.Selected;

  if(node=nil) then
    exit;
  if(node.Data = nil) then
    exit;

  rng:=TMyTextRange(node.Data);
  NPlugin.Sci_Send(SCI_SCROLLRANGE, globalSelStart + rng.Start + rng.Length, rng.Start);
  NPlugin.Sci_Send(SCI_GOTOPOS, globalSelStart + rng.Start, 0);
  NPlugin.Sci_Send(SCI_SETSELECTIONSTART, globalSelStart + rng.Start - 1, 0);
  NPlugin.Sci_Send(SCI_SETSELECTIONEND, globalSelStart + rng.Start + rng.Length - 1 , 0);

  NPlugin.Sci_Send(SCI_GOTOPOS, globalSelStart + rng.Start + rng.Length - 1, 0);
  NPlugin.Sci_Send(SCI_GOTOPOS, globalSelStart + rng.Start, 0);
end;

procedure TfrmMain.TreeView1Deletion(Sender: TObject; Node: TTreeNode);
begin
  inherited;
  if(Node.Data = nil) then exit;

  TMyTextRange(Node.Data).Free;
end;

function TfrmMain.IfThenStr(b: boolean; trueStr, falseStr: string): string;
begin
   if(b) then result:=trueStr
   else result:=falseStr;
end;

procedure TfrmMain.ApplyDarkColorScheme(isDarkMode: boolean; delphiColors: TDarkModeColorsDelphi);
begin

   if(not isDarkMode) or (not settings.AsBool('AdjustToDarkMode', true)) then begin
      self.SynEdit1.Color := clWindow;
      self.lvRegexLib.Color:=clWindow;
      self.ListBox1.Color:=clWindow;
      self.edSearchRegexLib.Color:=clWindow;
      self.TreeView1.Color:=clWindow;
      self.mmoResults.Color:=clWindow;

      self.SynEdit1.Font.Color := clWindowText;
      self.lvRegexLib.Font.Color:=clWindowText;
      self.ListBox1.Font.Color:=clWindowText;
      self.edSearchRegexLib.Font.Color:=clWindowText;
      self.TreeView1.Font.Color:=clWindowText;
      self.mmoResults.Font.Color:=clWindowText;

      self.pnlEditor.Color:=clBtnFace;
      self.pnlCfg.Color:=clBtnFace;
      self.pnlRegexCfg.Color:=clBtnFace;
      self.pnlLog.Color:=clBtnFace;
      self.pnlRegexToolbar.Color:=clBtnFace;
      self.pnlRegexOptions.Color:=clBtnFace;
      self.pnlTBJankySpacer.Color:=clBtnFace;
      self.Panel7.Color:=clBtnFace;
      self.Panel8.Color:=clBtnFace;

      self.lblEdit.Font.Color:=clWindowText;
      self.lblCurrentRegex.Font.Color:=clWindowText;
      self.label2.Font.Color:=clWindowText;

      self.cbroIgnoreCase.Font.Color:=clWindowText;
      self.cbroMultiline.Font.Color:=clWindowText;
      self.cbroExplicitCapture.Font.Color:=clWindowText;
      self.cbroSingleLine.Font.Color:=clWindowText;
      self.cbroIgnoreWhitespace.Font.Color:=clWindowText;
      self.cbroNotEmpty.Font.Color:=clWindowText;
      self.cbIgnoreEmptyGroups.Font.Color:=clWindowText;
      self.cbIgnoreDuplicates.Font.Color:=clWindowText;

      self.Splitter1.Color:=clBtnFace;
      self.Splitter2.Color:=clBtnFace;
      self.Splitter1.Invalidate;
      self.Splitter2.Invalidate;

      spinGroupToList.Color:=clWindow;
      spinGroupToList.Font.Color:=clWindowText;

      self.pnlEditor.Color:=clBtnFace;
      self.pnlTabSwitchButtons.Color:=clBtnFace;

      self.btnTab0.Font.Color:=clWindowText;
      self.btnTab1.Font.Color:=clWindowText;
      self.btnTab2.Font.Color:=clWindowText;

      self.btnTab0.Transparent:=false;
      self.btnTab1.Transparent:=false;
      self.btnTab2.Transparent:=false;

      self.Invalidate;

      self.btnTab0.Transparent:=true;
      self.btnTab1.Transparent:=true;
      self.btnTab2.Transparent:=true;

      self.pnlDBAccessWarning.Color:=clBtnFace;
      self.lblDBAccessWarning.Font.Color:=clWindowText;
      self.lblDBFileName.Font.Color:=clWindowText;
   end
   else begin

      self.darkModeColors:=delphiColors;

      self.SynEdit1.Color := delphiColors.softerBackground;
      self.SynEdit1.Font.Color:=delphiColors.text;// clWhite;

      self.lvRegexLib.Color:=delphiColors.softerBackground;
      self.lvRegexLib.Font.Color:=delphiColors.text;//clWhite;

      self.ListBox1.Color:=delphiColors.softerBackground;
      self.ListBox1.Font.Color:=delphiColors.text;//clWhite;

      self.edSearchRegexLib.Color:=delphiColors.softerBackground;
      self.edSearchRegexLib.Font.Color:=delphiColors.text;//clWhite;

      self.TreeView1.Color:=delphiColors.softerBackground;
      self.TreeView1.Font.Color:=delphiColors.text;//clWhite;

      self.mmoResults.Color:=delphiColors.softerBackground;
      self.mmoResults.Font.Color:=delphiColors.text;//clWhite;


      self.pnlEditor.Color:=delphiColors.softerBackground;
      self.pnlCfg.Color:=delphiColors.softerBackground;
      self.pnlRegexCfg.Color:=delphiColors.softerBackground;
      self.pnlLog.Color:=delphiColors.softerBackground;
      self.pnlRegexToolbar.Color:=delphiColors.softerBackground;
      self.pnlRegexOptions.Color:=delphiColors.softerBackground;
      self.pnlTBJankySpacer.Color:=delphiColors.softerBackground;
      self.Panel7.Color:=delphiColors.softerBackground;
      self.Panel8.Color:=delphiColors.softerBackground;

      self.lblEdit.Font.Color:=delphiColors.text;
      self.lblCurrentRegex.Font.Color:=delphiColors.text;
      self.label2.Font.Color:=delphiColors.text;

      self.cbroIgnoreCase.Font.Color:=clWhite;//delphiColors.text;//clWhite;
      self.cbroMultiline.Font.Color:=clWhite;//delphiColors.text;//clWhite;
      self.cbroExplicitCapture.Font.Color:=clWhite;//delphiColors.text;//clWhite;
      self.cbroSingleLine.Font.Color:=clWhite;//delphiColors.text;//clWhite;
      self.cbroIgnoreWhitespace.Font.Color:=clWhite;//delphiColors.text;//clWhite;
      self.cbroNotEmpty.Font.Color:=clWhite;//delphiColors.text;//clWhite;
      self.cbIgnoreEmptyGroups.Font.Color:=clWhite;//delphiColors.text;//clWhite;
      self.cbIgnoreDuplicates.Font.Color:=clWhite;//delphiColors.text;//clWhite;

      self.Splitter1.Color := delphiColors.softerBackground;
      self.Splitter2.Color := delphiColors.softerBackground;
      self.Splitter1.Invalidate;
      self.Splitter2.Invalidate;

      spinGroupToList.Color:=delphiColors.softerBackground;
      spinGroupToList.Font.Color:=delphiColors.text;

      self.pnlEditor.Color:=delphiColors.softerBackground;


      //show hide speed buttons to correct Down-background color on theme switch

      self.pnlTabSwitchButtons.Color:=delphiColors.softerBackground;

      self.btnTab0.Font.Color:=delphiColors.text;
      self.btnTab1.Font.Color:=delphiColors.text;
      self.btnTab2.Font.Color:=delphiColors.text;

      self.btnTab0.Transparent:=true;
      self.btnTab1.Transparent:=true;
      self.btnTab2.Transparent:=true;

      self.pnlDBAccessWarning.Color:=delphiColors.softerBackground;
      self.lblDBAccessWarning.Font.Color:=delphiColors.text;
      self.lblDBFileName.Font.Color:=delphiColors.text;


   end;

end;

end.
