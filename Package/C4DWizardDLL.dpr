library C4DWizardDLL;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

{$R *.dres}

uses
  System.SysUtils,
  System.Classes,
  ToolsAPI,
  C4D.Wizard.Register in '..\Src\C4D.Wizard.Register.pas',
  C4D.Wizard.IDE.MainMenu in '..\Src\IDE\MainMenu\C4D.Wizard.IDE.MainMenu.pas',
  C4D.Wizard.Interfaces in '..\Src\Interfaces\C4D.Wizard.Interfaces.pas',
  C4D.Wizard.View.Memo in '..\Src\View\C4D.Wizard.View.Memo.pas' {C4DWizardViewMemo},
  C4D.Wizard.Types in '..\Src\Types\C4D.Wizard.Types.pas',
  C4D.Wizard.Consts in '..\Src\Consts\C4D.Wizard.Consts.pas',
  C4D.Wizard.View.About in '..\Src\View\C4D.Wizard.View.About.pas' {C4DWizardViewAbout},
  C4D.Wizard.Model.Files.Loop in '..\Src\Model\Files\C4D.Wizard.Model.Files.Loop.pas',
  C4D.Wizard.UsesOrganization.View in '..\Src\UsesOrganization\C4D.Wizard.UsesOrganization.View.pas' {C4DWizardUsesOrganizationView},
  C4D.Wizard.UsesOrganization in '..\Src\UsesOrganization\C4D.Wizard.UsesOrganization.pas',
  C4D.Wizard.UsesOrganization.Params in '..\Src\UsesOrganization\C4D.Wizard.UsesOrganization.Params.pas',
  C4D.Wizard.UsesOrganization.List in '..\Src\UsesOrganization\C4D.Wizard.UsesOrganization.List.pas',
  C4D.Wizard.Model.IniFile.Components in '..\Src\Model\IniFile\C4D.Wizard.Model.IniFile.Components.pas',
  C4D.Wizard.IDE.MainMenu.Register in '..\Src\IDE\MainMenu\C4D.Wizard.IDE.MainMenu.Register.pas',
  C4D.Wizard.Reopen.View in '..\Src\Reopen\C4D.Wizard.Reopen.View.pas' {C4DWizardReopenView},
  C4D.Wizard.Reopen.Model in '..\Src\Reopen\C4D.Wizard.Reopen.Model.pas',
  C4D.Wizard.Reopen.Interfaces in '..\Src\Reopen\C4D.Wizard.Reopen.Interfaces.pas',
  C4D.Wizard.IDE.MainMenu.Clicks in '..\Src\IDE\MainMenu\C4D.Wizard.IDE.MainMenu.Clicks.pas',
  C4D.Wizard.IDE.PopupMenu in '..\Src\IDE\PopupMenu\C4D.Wizard.IDE.PopupMenu.pas',
  C4D.Wizard.IDE.PopupMenu.Item in '..\Src\IDE\PopupMenu\C4D.Wizard.IDE.PopupMenu.Item.pas',
  C4D.Wizard.Reopen.View.Edit in '..\Src\Reopen\C4D.Wizard.Reopen.View.Edit.pas' {C4DWizardReopenViewEdit},
  C4D.Wizard.LogFile in '..\Src\LogFile\C4D.Wizard.LogFile.pas',
  C4D.Wizard.Settings.View in '..\Src\Settings\C4D.Wizard.Settings.View.pas' {C4DWizardSettingsView},
  C4D.Wizard.Settings.Model in '..\Src\Settings\C4D.Wizard.Settings.Model.pas',
  C4D.Wizard.ProcessDelphi in '..\Src\ProcessDelphi\C4D.Wizard.ProcessDelphi.pas',
  C4D.Wizard.dpipes in '..\Src\ProcessDelphi\C4D.Wizard.dpipes.pas',
  C4D.Wizard.dprocess in '..\Src\ProcessDelphi\C4D.Wizard.dprocess.pas',
  C4D.Wizard.Reopen.Controller in '..\Src\Reopen\C4D.Wizard.Reopen.Controller.pas',
  C4D.Wizard.Groups in '..\Src\Groups\C4D.Wizard.Groups.pas',
  C4D.Wizard.Groups.View in '..\Src\Groups\C4D.Wizard.Groups.View.pas' {C4DWizardGroupsView},
  C4D.Wizard.Groups.Model in '..\Src\Groups\C4D.Wizard.Groups.Model.pas',
  C4D.Wizard.Groups.Interfaces in '..\Src\Groups\C4D.Wizard.Groups.Interfaces.pas',
  C4D.Wizard.Groups.AddEdit.View in '..\Src\Groups\C4D.Wizard.Groups.AddEdit.View.pas' {C4DWizardGroupsAddEditView},
  C4D.Wizard.Translate.View in '..\Src\Translate\C4D.Wizard.Translate.View.pas' {C4DWizardTranslateView},
  C4D.Wizard.Indent in '..\Src\Indent\C4D.Wizard.Indent.pas',
  C4D.Wizard.IDE.MainMenu.OpenExternal in '..\Src\IDE\MainMenu\C4D.Wizard.IDE.MainMenu.OpenExternal.pas',
  C4D.Wizard.Types.ABMenuAction in '..\Src\Types\C4D.Wizard.Types.ABMenuAction.pas',
  C4D.Wizard.ReplaceFiles.View in '..\Src\ReplaceFiles\C4D.Wizard.ReplaceFiles.View.pas' {C4DWizardReplaceFilesView},
  C4D.Wizard.View.Dialog in '..\Src\View\C4D.Wizard.View.Dialog.pas' {C4DWizardViewMessages},
  C4D.Wizard.Messages.Simple in '..\Src\Messages\C4D.Wizard.Messages.Simple.pas',
  C4D.Wizard.ReplaceFiles.Model in '..\Src\ReplaceFiles\C4D.Wizard.ReplaceFiles.Model.pas',
  C4D.Wizard.ReplaceFiles.Interfaces in '..\Src\ReplaceFiles\C4D.Wizard.ReplaceFiles.Interfaces.pas',
  C4D.Wizard.Reopen.SaveAs in '..\Src\Reopen\C4D.Wizard.Reopen.SaveAs.pas',
  C4D.Wizard.Find.Interfaces in '..\Src\Find\C4D.Wizard.Find.Interfaces.pas',
  C4D.Wizard.Find.View in '..\Src\Find\C4D.Wizard.Find.View.pas' {C4DWizardFindView},
  C4D.Wizard.Find.Model in '..\Src\Find\C4D.Wizard.Find.Model.pas',
  C4D.Wizard.IDE.ImageListMain in '..\Src\IDE\ImageListMain\C4D.Wizard.IDE.ImageListMain.pas',
  C4D.Wizard.IDE.MainMenu.Backup in '..\Src\IDE\MainMenu\C4D.Wizard.IDE.MainMenu.Backup.pas',
  C4D.Wizard.Backup.Interfaces in '..\Src\Backup\C4D.Wizard.Backup.Interfaces.pas',
  C4D.Wizard.Messages.Custom.OTA in '..\Src\Messages\C4D.Wizard.Messages.Custom.OTA.pas',
  C4D.Wizard.Messages.Custom in '..\Src\Messages\C4D.Wizard.Messages.Custom.pas',
  C4D.Wizard.Messages.Custom.Interfaces in '..\Src\Messages\C4D.Wizard.Messages.Custom.Interfaces.pas',
  C4D.Wizard.Messages.Custom.Groups.OTA in '..\Src\Messages\C4D.Wizard.Messages.Custom.Groups.OTA.pas',
  C4D.Wizard.Backup.Export.View in '..\Src\Backup\C4D.Wizard.Backup.Export.View.pas' {C4DWizardBackupExportView},
  C4D.Wizard.Backup.Import.View in '..\Src\Backup\C4D.Wizard.Backup.Import.View.pas' {C4DWizardBackupImportView},
  C4D.Wizard.Backup.Import.SelectFiles.View in '..\Src\Backup\C4D.Wizard.Backup.Import.SelectFiles.View.pas' {C4DWizardBackupImportSelectFilesView},
  C4D.Wizard.IDE.Splash in '..\Src\IDE\Splash\C4D.Wizard.IDE.Splash.pas',
  C4D.Wizard.IDE.About in '..\Src\IDE\About\C4D.Wizard.IDE.About.pas',
  C4D.Wizard.IDE.ToolBars.Branch in '..\Src\IDE\ToolBars\C4D.Wizard.IDE.ToolBars.Branch.pas',
  C4D.Wizard.IDE.ToolBars.Notifier in '..\Src\IDE\ToolBars\C4D.Wizard.IDE.ToolBars.Notifier.pas',
  C4D.Wizard.DefaultFilesInOpeningProject.Model in '..\Src\DefaultFilesInOpeningProject\C4D.Wizard.DefaultFilesInOpeningProject.Model.pas',
  C4D.Wizard.DefaultFilesInOpeningProject.Interfaces in '..\Src\DefaultFilesInOpeningProject\C4D.Wizard.DefaultFilesInOpeningProject.Interfaces.pas',
  C4D.Wizard.DefaultFilesInOpeningProject in '..\Src\DefaultFilesInOpeningProject\C4D.Wizard.DefaultFilesInOpeningProject.pas',
  C4D.Wizard.View.ListFilesForSelection in '..\Src\View\C4D.Wizard.View.ListFilesForSelection.pas' {C4DWizardViewListFilesForSelection},
  C4D.Wizard.IDE.ToolBars.Build in '..\Src\IDE\ToolBars\C4D.Wizard.IDE.ToolBars.Build.pas',
  C4D.Wizard.IDE.ToolBars.Register in '..\Src\IDE\ToolBars\C4D.Wizard.IDE.ToolBars.Register.pas',
  C4D.Wizard.IDE.EditServicesNotifier in '..\Src\IDE\EditServicesNotifier\C4D.Wizard.IDE.EditServicesNotifier.pas',
  C4D.Wizard.Utils.CnWizard in '..\Src\Utils\C4D.Wizard.Utils.CnWizard.pas',
  C4D.Wizard.Utils.GetIniPositionStr in '..\Src\Utils\C4D.Wizard.Utils.GetIniPositionStr.pas',
  C4D.Wizard.Utils.Git in '..\Src\Utils\C4D.Wizard.Utils.Git.pas',
  C4D.Wizard.Utils.ListOfFilesInFolder in '..\Src\Utils\C4D.Wizard.Utils.ListOfFilesInFolder.pas',
  C4D.Wizard.Utils.ListView in '..\Src\Utils\C4D.Wizard.Utils.ListView.pas',
  C4D.Wizard.Utils.OTA.BinaryPath in '..\Src\Utils\C4D.Wizard.Utils.OTA.BinaryPath.pas',
  C4D.Wizard.Utils.OTA in '..\Src\Utils\C4D.Wizard.Utils.OTA.pas',
  C4D.Wizard.Utils in '..\Src\Utils\C4D.Wizard.Utils.pas',
  C4D.Wizard.Utils.StringList in '..\Src\Utils\C4D.Wizard.Utils.StringList.pas',
  C4D.Wizard.WaitingScreen in '..\Src\WaitingScreen\C4D.Wizard.WaitingScreen.pas',
  C4D.Wizard.WaitingScreen.View in '..\Src\WaitingScreen\C4D.Wizard.WaitingScreen.View.pas' {C4DWizardWaitingScreenView},
  C4D.Wizard.IDE.Shortcuts.BlockKeyInsert in '..\Src\IDE\Shortcuts\C4D.Wizard.IDE.Shortcuts.BlockKeyInsert.pas',
  C4D.Wizard.IDE.Shortcuts in '..\Src\IDE\Shortcuts\C4D.Wizard.IDE.Shortcuts.pas',
  C4D.Wizard.OpenExternal.AddEdit.View in '..\Src\OpenExternal\C4D.Wizard.OpenExternal.AddEdit.View.pas' {C4DWizardOpenExternalAddEditView},
  C4D.Wizard.OpenExternal.Interfaces in '..\Src\OpenExternal\C4D.Wizard.OpenExternal.Interfaces.pas',
  C4D.Wizard.OpenExternal.Model in '..\Src\OpenExternal\C4D.Wizard.OpenExternal.Model.pas',
  C4D.Wizard.OpenExternal in '..\Src\OpenExternal\C4D.Wizard.OpenExternal.pas',
  C4D.Wizard.OpenExternal.Utils in '..\Src\OpenExternal\C4D.Wizard.OpenExternal.Utils.pas',
  C4D.Wizard.OpenExternal.View in '..\Src\OpenExternal\C4D.Wizard.OpenExternal.View.pas' {C4DWizardOpenExternalView},
  C4D.Wizard.IDE.CompileNotifier in '..\Src\IDE\CompileNotifier\C4D.Wizard.IDE.CompileNotifier.pas',
  C4D.Wizard.IDE.FileNotification.Notifier in '..\Src\IDE\FileNotification\C4D.Wizard.IDE.FileNotification.Notifier.pas',
  C4D.Wizard.UsesOrganization.ListOfUses in '..\Src\UsesOrganization\C4D.Wizard.UsesOrganization.ListOfUses.pas',
  C4D.Wizard.FormatSource.View in '..\Src\FormatSource\C4D.Wizard.FormatSource.View.pas' {C4DWizardFormatSourceView},
  C4D.Wizard.IDE.ToolBars.Utilities in '..\Src\IDE\ToolBars\C4D.Wizard.IDE.ToolBars.Utilities.pas',
  C4D.Wizard.IDE.ShortCut.KeyboardBinding in '..\Src\IDE\ShortCut\C4D.Wizard.IDE.ShortCut.KeyboardBinding.pas',
  C4D.Wizard.IDE.PopupMenuDesigner.ComponentSel in '..\Src\IDE\PopupMenuDesigner\C4D.Wizard.IDE.PopupMenuDesigner.ComponentSel.pas',
  C4D.Wizard.IDE.PopupMenuDesigner in '..\Src\IDE\PopupMenuDesigner\C4D.Wizard.IDE.PopupMenuDesigner.pas';

exports
  C4D.Wizard.Register.RegisterDLL name WizardEntryPoint;

{$R *.res}

begin
end.