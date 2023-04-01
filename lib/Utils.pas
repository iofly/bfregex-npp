unit Utils;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
      Generics.Collections, Math, System.RegularExpressions, System.RegularExpressionsCore,
      JclSysInfo, StrUtils;

function PadInt(i: Integer; width: Integer): string;
function GetProcCount: Integer;

implementation


function PadInt(i: Integer; width: Integer): string;
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


function GetProcCount: Integer;
var
   procs: TStringList;
   i: Integer;
   count: Integer;
begin
   count:=0;
   procs:=TStringList.Create;

   try

      RunningProcessesList(procs, false);
      for i := 0 to procs.Count-1 do begin
        if(Lowercase(procs[i]).EndsWith('notepad++.exe')) then
         count:=count+1;
      end;

   finally
      procs.Free;
   end;

   result:=count;
end;


end.
