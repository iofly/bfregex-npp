unit frmMainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, System.Math, Winapi.ShellApi, System.UITypes, System.Generics.Collections,
  Vcl.StdCtrls, System.RegularExpressions, System.RegularExpressionsCore, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Dialogs, System.ImageList, Vcl.ImgList, Vcl.Menus, Vcl.Samples.Spin,
  DateUtils,

  JclSysInfo, JclFileUtils, PngBitBtn, PngImageList,

  nppplugin, plugin, NppDockingForms,

  Data.DbxSqlite, Data.FMTBcd, Data.DB, Data.SqlExpr,
  FireDAC.UI.Intf, FireDAC.ConsoleUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI,
  FDSqliteTypes, FDSqliteManger, FireDAC.Stan.Def, FireDAC.DApt,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Stan.Async;

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
    pnlRegexToolbar: TPanel;
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
    btnNewPng: TPngBitBtn;
    btnSavePng: TPngBitBtn;
    btnSaveAsPng: TPngBitBtn;
    btnAboutPng: TPngBitBtn;
    btnClearPng: TPngBitBtn;
    btnRunPng: TPngBitBtn;
    imglToolBar: TPngImageList;
    imglTabs: TPngImageList;
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
    pnlTBJankySpacer: TPanel;
    Splitter2: TSplitter;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    SynEdit1: TMemo;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    SpeedButton1: TSpeedButton;
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
  procedure OnWM_NOTIFY(var msg: TWMNotify);
    procedure SynEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure SynEdit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Splitter1Moved(Sender: TObject);
  private

    FMenuItemCheck: TMenuItemCheck;
   // const MaxTabIndex = 10;
    globalSelStart: Integer;
    defaultDBFileName: string;
    currentRegexID: Integer;
    currentRegexTitle: string;
    currentRegexIsDirty: boolean;
    selectSingleList: TList<TAppRegex>;
    sqlMan: TFDSqliteManager;
    ProcessingChanges: boolean;
    darkModeColors: TDarkModeColorsDelphi;

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
  Vcl.Clipbrd,
  frmRegexTitleUnit, frmAboutUnit, RegexUtils, SciSupport;


{$R *.dfm}

//todo ability to back up database file
//todo status display if unable to create database file
//todo restore previous state between runtimes , settings, tab index and text, load last regex, isdirty etc.
//todo auto scroll to first result
//todo ignore duplicates for list full match doesn't work
//todo detect and adapt to darkmode
//make text highlighers darker for dark mode because the textitself is bright making bright highlighters confuses and hard to see text.
procedure TfrmMain.OnWM_NOTIFY(var msg: TWMNotify);
begin
  inherited;

 { if(msg.Msg = NPPN_SHUTDOWN) then begin
     ShowMessage('NPPN_SHUTDOWN received');
  end
  else if (msg.Msg = WM_CLOSE) then begin
     ShowMessage('WCLOSE received');
  end
  else if (msg.Msg = WM_QUIT ) then begin
     ShowMessage('WM_QUIT  received');
  end
  else if (msg.Msg = WM_DESTROY ) then begin
     ShowMessage('WM_DESTROY  received');
  end;}
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
   ProcessingChanges:=false;
   NppDefaultDockingMask := DWS_DF_FLOATING;
   FMenuItemCheck := miHidden;
   self.defaultDBFileName:=GetAppdataFolder + '\BFStuff\BFRegexNPP\regex.db';
   selectSingleList:=TList<TAppRegex>.Create;
   sqlMan:=TFDSqliteManager.Create(self.defaultDBFileName, true);
   self.DoSearch('');
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  inherited;

  selectSingleList.Free;
  sqlMan.Free;
end;

procedure TfrmMain.FormHide(Sender: TObject);
begin
  MenuItemCheck := miHidden;
end;

procedure TfrmMain.btnAboutClick(Sender: TObject);
var
  frmAbout: TfrmAbout;
begin
  inherited;
  frmAbout:=TfrmAbout.Create(Npp);
  try
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
   lblCurrentRegex.Caption:='(Untitled)';
   SynEdit1.Text:='';

   cbroIgnoreCase.Checked:=true;
   cbroSingleLine.Checked:=false;
   cbroMultiline.Checked:=false;
   cbroIgnoreWhitespace.Checked:=false;
   cbroExplicitCapture.Checked:=false;
   cbroNotEmpty.Checked:=false;

    selectSingleList.Clear;
    currentRegexID:=0;
    currentRegexTitle:='';
    currentRegexIsDirty:=false;
end;

procedure TfrmMain.SetUpHighlighters;
begin
    NPlugin.Sci_Send(SCI_INDICSETSTYLE, 1, INDIC_ROUNDBOX);
    NPlugin.Sci_Send(SCI_INDICSETFORE, 1, $00FF00);//$FFAAFF);
    NPlugin.Sci_Send(SCI_INDICSETALPHA, 1, 127 );
    NPlugin.Sci_Send(SCI_INDICSETOUTLINEALPHA, 1, 255 );
    NPlugin.Sci_Send(SCI_INDICSETUNDER, 1, 1);

    NPlugin.Sci_Send(SCI_INDICSETSTYLE, 2, INDIC_ROUNDBOX);
    NPlugin.Sci_Send(SCI_INDICSETFORE, 2, $00FFFF); //$FF8888);
    NPlugin.Sci_Send(SCI_INDICSETALPHA, 2, 255);
    NPlugin.Sci_Send(SCI_INDICSETOUTLINEALPHA, 2, 255 );
    NPlugin.Sci_Send(SCI_INDICSETUNDER, 2, 1);

    NPlugin.Sci_Send(SCI_INDICSETSTYLE, 3, INDIC_ROUNDBOX);
    NPlugin.Sci_Send(SCI_INDICSETFORE, 3, $444444);//$AAFFAA);
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
     self.btnSavePng.Enabled := istext;
     self.btnSaveAsPng.Enabled := istext;
     self.btnRunPng.Enabled := istext;
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
begin
  inherited;

  if(Length(SynEdit1.Text)=0) then begin
     exit;
  end;

  globalSelStart:=0;
  resultsAsText:=TStringList.Create;
  resultsAsTextSortedShadow:=nil;

  if(cbIgnoreDuplicates.Checked) then begin
     resultsAsTextSortedShadow:=TStringList.Create;
     resultsAsTextSortedShadow.Sorted:=true;
     resultsAsTextSortedShadow.Duplicates:=dupIgnore;
  end;

  self.mmoResults.Lines.BeginUpdate;
  TreeView1.Items.BeginUpdate;
  try

    isvalid:= IsValidRegex(SynEdit1.Text);

    if(not isvalid) then begin
      //lblStatus.Caption:='Regex is not valid';
      exit;
    end;

    selLength:= 0;// NPlugin.GetSelLength;

   // if(selLength<=0) then
      useText:=NPlugin.GetText;
   // else
   //   useText:=NPlugin.SelectedText;

    ClearHighlighters;
    SetUpHighlighters;
    NPlugin.Sci_Send(SCI_SETINDICATORCURRENT, 1, 0);

    //<(�[^�]*�|'[^�]*�|[^'�>])*>
    //<a\s+href=(?:"([^"]+)"|'([^']+)').*?>(.*?)</a>
    //<a [^>]*href=['"](.*?)['"].*?>(.*?)</a>

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
    globalSelStart:=0;//selStart;

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

              if (not matches[i].Groups[g].Success) then continue;

              if(Length(matches[i].Groups[g].Value) = 0) then continue;

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

        if(rbListMatchTypeGroup.Checked) then begin
           for i := 0 to matches.Count-1 do begin
              if(matches[i].Groups.Count >= spinGroupToList.Value) then begin
                  if (cbIgnoreEmptyGroups.Checked) and (Length(matches[i].Groups[spinGroupToList.Value].Value) = 0) then continue;

                  if(cbIgnoreDuplicates.Checked) then begin
                     if(resultsAsTextSortedShadow.Find(matches[i].Groups[spinGroupToList.Value].Value, tmp)) then
                       continue;
                     resultsAsTextSortedShadow.Add(matches[i].Groups[spinGroupToList.Value].Value);
                   end
                   else begin
                      resultsAsText.Add(matches[i].Groups[spinGroupToList.Value].Value);
                   end;
              end;
           end;
        end
        else if(rbListMatchTypeFull.Checked) then begin
           for i := 0 to matches.Count-1 do begin
              resultsAsText.Add(matches[i].Value);
           end;
        end;



          {  if (g=spinGroupToList.Value) then begin


                if(cbIgnoreDuplicates.Checked) then begin
                  if(resultsAsTextSortedShadow.Find(matches[i].Groups[g].Value, tmp)) then
                    continue;
                  resultsAsTextSortedShadow.Add(matches[i].Groups[g].Value);
                end;

               resultsAsText.Add(matches[i].Groups[g].Value);
            end;}



    end;

  finally

      if(rbListMatchTypeGroup.Checked) then begin
          self.mmoResults.Text := resultsAsTextSortedShadow.Text;
      end
      else begin
          self.mmoResults.Text := resultsAsText.Text;
      end;


    if(resultsAsTextSortedShadow <> nil) then
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
     self.btnSavePng.Enabled := istext;
     self.btnSaveAsPng.Enabled := istext;
     self.btnRunPng.Enabled := istext;




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
     self.btnSavePng.Enabled := istext;
     self.btnSaveAsPng.Enabled := istext;
     self.btnRunPng.Enabled := istext;
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





  //NPlugin.Sci_Send(SCI_SETSELECTIONSTART, globalSelStart + rng.Start - 1, 0);
  //NPlugin.Sci_Send(SCI_SETSELECTIONEND, globalSelStart + rng.Start - 1, 0);
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
var
   drkCl: TColor;
begin
exit;

   if(not isDarkMode) then begin
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








   end
   else begin
      drkCl:= $00414141;

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





      self.pnlEditor.Color:=delphiColors.softerBackground;// drkCl;
      self.pnlCfg.Color:=delphiColors.softerBackground;//drkCl;
      self.pnlRegexCfg.Color:=delphiColors.softerBackground;//drkCl;
      self.pnlLog.Color:=delphiColors.softerBackground;//drkCl;
      self.pnlRegexToolbar.Color:=delphiColors.softerBackground;//drkCl;
      self.pnlRegexOptions.Color:=delphiColors.softerBackground;//drkCl;
      self.pnlTBJankySpacer.Color:=delphiColors.softerBackground;//drkCl;
      self.Panel7.Color:=delphiColors.softerBackground;//drkCl;
      self.Panel8.Color:=delphiColors.softerBackground;//drkCl;


      self.lblEdit.Font.Color:=delphiColors.text;//clWhite;
      self.lblCurrentRegex.Font.Color:=delphiColors.text;//clWhite;
      self.label2.Font.Color:=delphiColors.text;//clWhite;

      self.cbroIgnoreCase.Font.Color:=delphiColors.text;//clWhite;
      self.cbroMultiline.Font.Color:=delphiColors.text;//clWhite;
      self.cbroExplicitCapture.Font.Color:=delphiColors.text;//clWhite;
      self.cbroSingleLine.Font.Color:=delphiColors.text;//clWhite;
      self.cbroIgnoreWhitespace.Font.Color:=delphiColors.text;//clWhite;
      self.cbroNotEmpty.Font.Color:=delphiColors.text;//clWhite;
      self.cbIgnoreEmptyGroups.Font.Color:=delphiColors.text;//clWhite;
      self.cbIgnoreDuplicates.Font.Color:=delphiColors.text;//clWhite;



       exit;




      self.darkModeColors:=delphiColors;

      self.SynEdit1.Color := drkCl;//delphiColors.pureBackground;
      self.SynEdit1.Font.Color:=clWhite;

      self.lvRegexLib.Color:=drkCl;//delphiColors.pureBackground;
      self.lvRegexLib.Font.Color:=clWhite;

      self.ListBox1.Color:=drkCl;//delphiColors.pureBackground;
      self.ListBox1.Font.Color:=clWhite;

      self.edSearchRegexLib.Color:=drkCl;//delphiColors.pureBackground;
      self.edSearchRegexLib.Font.Color:=clWhite;

      self.TreeView1.Color:=drkCl;//delphiColors.pureBackground;
      self.TreeView1.Font.Color:=clWhite;

      self.mmoResults.Color:=drkCl;//delphiColors.pureBackground;
      self.mmoResults.Font.Color:=clWhite;

      self.pnlEditor.Color:=drkCl;
      self.pnlCfg.Color:=drkCl;
      self.pnlRegexCfg.Color:=drkCl;
      self.pnlLog.Color:=drkCl;
      self.pnlRegexToolbar.Color:=drkCl;
      self.pnlRegexOptions.Color:=drkCl;
      self.pnlTBJankySpacer.Color:=drkCl;
      self.Panel7.Color:=drkCl;
      self.Panel8.Color:=drkCl;


      self.lblEdit.Font.Color:=clWhite;
      self.lblCurrentRegex.Font.Color:=clWhite;
      self.label2.Font.Color:=clWhite;

      self.cbroIgnoreCase.Font.Color:=clWhite;
      self.cbroMultiline.Font.Color:=clWhite;
      self.cbroExplicitCapture.Font.Color:=clWhite;
      self.cbroSingleLine.Font.Color:=clWhite;
      self.cbroIgnoreWhitespace.Font.Color:=clWhite;
      self.cbroNotEmpty.Font.Color:=clWhite;
      self.cbIgnoreEmptyGroups.Font.Color:=clWhite;
      self.cbIgnoreDuplicates.Font.Color:=clWhite;




   end;




end;

end.