unit FDSqliteTypes;

interface




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

    DateCreated: Integer;
    DateModified: Integer;

  public
    Constructor Create;

  end;

type
  TDBSearchField = (sfDBProcessID, sfProcessPath);









implementation


constructor TAppRegex.Create;
begin
  self.DBExpressionID:=0;
end;


end.
