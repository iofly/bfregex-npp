unit FDSqliteTypes;

interface

uses
  System.SysUtils, Classes, System.DateUtils, System.Generics.Collections;



type
   TListItemDataRegexReference = class
      public
         RegexID: Integer;
   end;

type
  TRegexsOrderBy = (robTitleAsc,
                    robTitleDesc,
                    robDateCreatedAsc,
                    robDateCreatedDesc,
                    robModifiedAsc,
                    robModifiedDesc,
                    robOpenCountAsc,
                    robOpenCoundDesc,
                    robSaveCountAsc,
                    robSaveCountDesc,
                    robRunCountAsc,
                    robRunCountDesc);

type
  TAppRegex = class
    Title: string;
    Expression: string;
    Flag_IgnoreCase: boolean;
    Flag_SingeLine: boolean;
    Flag_MultiLine: boolean;
    Flag_IgnorePatternSpace: boolean;
    Flag_ExplicitCapture: boolean;
    Flag_NotEmpty: boolean;
    DBExpressionID: Integer;

    Count_Open: Integer;
    Count_Save: Integer;
    Count_Run: Integer;

    DateCreated: Int64;
    DateModified: Int64;

  public
    Constructor Create;

  end;

type
  TAppSettingType = (astInteger, astString, astBool, astDateTime);

  TAppSetting = class
     SettingName: string;
     SettingValue: string;
     SettingType: TAppSettingType;
     SettingID: Int64;
  public
    function AsInt(Default: Int64 = 0): Int64;
    function AsString: string;
    function AsBool(Default: Boolean = false): Boolean;
    function AsDateTime: TDateTime;
    constructor Create(NewSettingName: string) overload;
  end;

type
   TSettingsContainer = class(TDictionary<string, TAppSetting>)
   public
      procedure SetBool(SettingName: string; val: boolean);
      procedure SetString(SettingName: string; val: string);
      procedure SetInt64(SettingName: string; val: Int64);
      procedure SetDateTime(SettingName: string; val: TDateTime);

      function AsBool(SettingName: string; default: boolean): boolean;
      function AsString(SettingName: string; default: string): string;
      function AsInt64(SettingName: string; default: Int64): Int64;
      function AsDateTime(SettingName: string; default: TDateTime): TDateTime;
   end;

type
  TDBSearchField = (sfDBProcessID, sfProcessPath);


implementation


constructor TAppRegex.Create;
begin
  self.DBExpressionID:=0;
end;

constructor TAppSetting.Create(NewSettingName: string);
begin

  SettingName:= NewSettingName;
  SettingType:=astInteger;
end;

function TAppSetting.AsInt(Default: Int64 = 0): Int64;
begin
   result:=StrToIntDef(self.SettingValue, Default);
end;

function TAppSetting.AsString: string;
begin
   result:=self.SettingValue;
end;

function TAppSetting.AsBool(Default: Boolean = false): Boolean;
begin
   if(Lowercase(self.SettingValue)='true') then
      result:=true
   else if(Lowercase(self.SettingValue)='false') then
      result:=false
   else
      result:=Default;
end;

function TAppSetting.AsDateTime: TDateTime;
begin
   result:=UnixToDateTime(self.AsInt(0), true);
end;





function TSettingsContainer.AsBool(SettingName: string; default: boolean): boolean;
begin
   if(self.ContainsKey(SettingName)) then begin
      result:=self[SettingName].AsBool(default);
   end
   else begin
      result:=default;
   end;
end;

function TSettingsContainer.AsString(SettingName: string; default: string): string;
begin
   if(self.ContainsKey(SettingName)) then begin
      result:=self[SettingName].AsString;
   end
   else begin
      result:=default;
   end;
end;

function TSettingsContainer.AsInt64(SettingName: string; default: Int64): Int64;
begin
   if(self.ContainsKey(SettingName)) then begin
      result:=self[SettingName].AsInt(default);
   end
   else begin
      result:=default;
   end;
end;


function TSettingsContainer.AsDateTime(SettingName: string; default: TDateTime): TDateTime;
begin
   if(self.ContainsKey(SettingName)) then begin
      result:=self[SettingName].AsDateTime;
   end
   else begin
      result:=default;
   end;
end;


procedure TSettingsContainer.SetBool(SettingName: string; val: boolean);
begin
   if not(self.ContainsKey(SettingName)) then
      self.Add(SettingName, TAppSetting.Create(SettingName));

   self[SettingName].SettingValue := Lowercase(BoolToStr(val, true));
   self[SettingName].SettingType:=astBool;
end;

procedure TSettingsContainer.SetString(SettingName: string; val: string);
begin
   if not(self.ContainsKey(SettingName)) then
      self.Add(SettingName, TAppSetting.Create(SettingName));

   self[SettingName].SettingValue := val;
   self[SettingName].SettingType:=astString;
end;

procedure TSettingsContainer.SetInt64(SettingName: string; val: Int64);
begin
   if not(self.ContainsKey(SettingName)) then
      self.Add(SettingName, TAppSetting.Create(SettingName));

   self[SettingName].SettingValue := IntToStr(val);
   self[SettingName].SettingType:=astInteger;
end;

procedure TSettingsContainer.SetDateTime(SettingName: string; val: TDateTime);
begin
   if not(self.ContainsKey(SettingName)) then
      self.Add(SettingName, TAppSetting.Create(SettingName));

   self[SettingName].SettingValue := IntToStr(DateTimeToUnix(val, true));
   self[SettingName].SettingType:=astInteger;
end;


end.
