unit C4D.Wizard.IDE.MainMenu.AiAssistant;

interface

uses
  System.SysUtils,
  System.Classes,
  VCL.Menus,
  C4D.Wizard.AiAssistant.Interfaces;

type
  TC4DWizardIDEMainMenuAiAssitant = class(TInterfacedObject, IC4DWizardIDEMainMenuAiAssistant)
  private
    FMenuItemC4D: TMenuItem;
    FMenuItemAiAssistant: TMenuItem;
    procedure AddMenuAiAssistant;
    procedure AddMenuItemAsk;
    procedure AddMenuItemAiSetting;
  protected
    function Process: IC4DWizardIDEMainMenuAiAssistant;
  public
    class function New(AMenuItemParent: TMenuItem): IC4DWizardIDEMainMenuAiAssistant;
    constructor Create(AMenuItemParent: TMenuItem);
  end;

implementation

uses
  C4D.Wizard.Consts,
  C4D.Wizard.IDE.ImageListMain,
  C4D.Wizard.IDE.MainMenu.Clicks;

{ TC4DWizardIDEMainMenuAiAssitant }

procedure TC4DWizardIDEMainMenuAiAssitant.AddMenuAiAssistant;
begin
  FMenuItemAiAssistant := TMenuItem.Create(FMenuItemC4D);
  FMenuItemAiAssistant.Name := TC4DConsts.MENU_IDE_AI_ASSISTANT_NAME;
  FMenuItemAiAssistant.Caption := TC4DConsts.MENU_IDE_AI_ASSISTANT_CAPTION;
  FMenuItemAiAssistant.ImageIndex := TC4DWizardIDEImageListMain.GetInstance.ImageIndexAiAssistant;
  FMenuItemC4D.Add(FMenuItemAiAssistant);
end;

procedure TC4DWizardIDEMainMenuAiAssitant.AddMenuItemAiSetting;
var
  LItemAiSetting: TMenuItem;
begin
  LItemAiSetting := TMenuItem.Create(FMenuItemAiAssistant);
  LItemAiSetting.Name := TC4DConsts.MENU_IDE_AI_SETTING_NAME;
  LItemAiSetting.Caption := TC4DConsts.MENU_IDE_AI_SETTING_CAPTION;
  LItemAiSetting.ImageIndex := TC4DWizardIDEImageListMain.GetInstance.ImgIndexAiSetting;
  LItemAiSetting.OnClick := TC4DWizardIDEMainMenuClicks.AiSettingClick;
  FMenuItemAiAssistant.Add(LItemAiSetting);
end;

procedure TC4DWizardIDEMainMenuAiAssitant.AddMenuItemAsk;
var
  LItemAiAsk: TMenuItem;
begin
  LItemAiAsk := TMenuItem.Create(FMenuItemAiAssistant);
  LItemAiAsk.Name := TC4DConsts.MENU_IDE_AI_ASK_NAME;
  LItemAiAsk.Caption := TC4DConsts.MENU_IDE_AI_ASK_CAPTION;
  LItemAiAsk.ImageIndex := TC4DWizardIDEImageListMain.GetInstance.ImgIndexAiAsk;
  LItemAiAsk.OnClick := TC4DWizardIDEMainMenuClicks.AiAskClick;
  FMenuItemAiAssistant.Add(LItemAiAsk);
end;

constructor TC4DWizardIDEMainMenuAiAssitant.Create(AMenuItemParent: TMenuItem);
begin
  FMenuItemC4D := AMenuItemParent;
end;

class function TC4DWizardIDEMainMenuAiAssitant.New(AMenuItemParent: TMenuItem): IC4DWizardIDEMainMenuAiAssistant;
begin
  Result := Self.Create(AMenuItemParent)
end;

function TC4DWizardIDEMainMenuAiAssitant.Process: IC4DWizardIDEMainMenuAiAssistant;
begin
  Self.AddMenuAiAssistant;
  Self.AddMenuItemAsk;
  Self.AddMenuItemAiSetting;
end;

end.
