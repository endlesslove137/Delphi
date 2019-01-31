program UPXShell;
{
                                 .___             __            _____
         _____________  ____   __| _/_ __   _____/  |_    _____/ ____\
         \____ \_  __ \/  _ \ / __ |  |  \_/ ___\   __\  /  _ \   __\
         |  |_> >  | \(  <_> ) /_/ |  |  /\  \___|  |   (  <_> )  |
         |   __/|__|   \____/\____ |____/  \___  >__|    \____/|__|
         |__|                     \/           \/
               .___________    _______    ___________     __
               |   \_____  \   \      \   \__    ___/___ |  | __
               |   |/   |   \  /   |   \    |    |_/ __ \|  |/ /
               |   /    |    \/    |    \   |    |\  ___/|    <
               |___\_______  /\____|__  /   |____| \___  >__|_ \
                           \/         \/               \/     \/
}
{%ToDo 'UPXShell.todo'}
{%File 'News.txt'}
uses
  Forms,
  MainFrm in 'MainFrm.pas' {MainForm},
  Translator in 'Translator.pas',
  Globals in 'Globals.pas',
  Compression in 'Compression.pas',
  SetupFrm in 'SetupFrm.pas' {SetupForm},
  Shared in 'Shared.pas',
  MultiFrm in 'MultiFrm.pas' {MultiForm},
  CommandsFrm in 'CommandsFrm.pas' {CommandsForm},
  UPXScrambler in 'UPXScrambler.pas';

{$R *.res}
begin
  Application.Initialize;
  Application.Title := 'UPX Shell';
  Application.HelpFile := 'UPXShell.chm';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TSetupForm, SetupForm);
  Application.Run;
end.

