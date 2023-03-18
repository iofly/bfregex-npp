library bfregex;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  Windows,
  Messages,
  System.SysUtils,
  System.Classes,
  plugin in 'plugin.pas',
  NppDockingForms in 'lib\npp\NppDockingForms.pas' {NppDockingForm},
  NppForms in 'lib\npp\NppForms.pas' {NppForm},
  nppplugin in 'lib\npp\nppplugin.pas',
  SciSupport in 'lib\npp\SciSupport.pas',
  FDSqliteManger in 'lib\dal\FDSqliteManger.pas',
  FDSqliteTypes in 'lib\dal\FDSqliteTypes.pas',
  frmAboutUnit in 'forms\frmAboutUnit.pas' {frmAbout},
  frmMainUnit in 'forms\frmMainUnit.pas' {frmMain},
  frmRegexTitleUnit in 'forms\frmRegexTitleUnit.pas' {frmRegexTitle},
  RegexUtils in 'lib\RegexUtils.pas',
  frmSettingsUnit in 'forms\frmSettingsUnit.pas' {frmSettings},
  frmBackupRestoreUnit in 'forms\frmBackupRestoreUnit.pas' {Form1};

{$R *.res}
{$R bfres.RES}

{$Include 'lib\npp\NppPluginInclude.pas'}


begin
  { First, assign the procedure to the DLLProc variable }
  DllProc := @DLLEntryPoint;
  { Now invoke the procedure to reflect that the DLL is attaching to the process }
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.
