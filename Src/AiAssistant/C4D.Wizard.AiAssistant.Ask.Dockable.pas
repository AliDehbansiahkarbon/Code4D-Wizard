{*******************************************************}
{                                                       }
{   This is the dockable form of the plugin.            }
{   It is a singleton class which means there will      }
{   be just one instance as long as the IDE is alive!   }
{   Could be activate/deactive in main menu.            }
{                                                       }
{*******************************************************}
unit C4D.Wizard.AiAssistant.Ask.Dockable;

interface
uses
  System.Classes, Vcl.Forms, DockForm, System.SysUtils,

  C4D.Wizard.AiAssistant.Setting.View,
  C4D.Wizard.AiAssistant.Ask.Frame;

type
  TChatGPTDockForm = class(TDockableForm)
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
   private
    FDockFormClassListObj: TClassList;
  public
    Fram_Question: TFram_Question;
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;

    property DockFormClassListObj: TClassList read FDockFormClassListObj write FDockFormClassListObj;
  end;

  var
    FChatGPTDockForm: TChatGPTDockForm;

    procedure UnregisterSelf;

implementation

{ TChatGPTDockForm }
procedure UnregisterSelf;
begin
  if Assigned(FChatGPTDockForm) then
  begin
    FChatGPTDockForm.Close;
    FreeAndNil(FChatGPTDockForm);
  end;
end;

constructor TChatGPTDockForm.Create(AOwner: TComponent);
begin
  inherited;
  DeskSection := 'ChatGPTPlugin';
  AutoSave := True;
  SaveStateNecessary := True;
  FDockFormClassListObj := TClassList.Create;

  with Self do
  begin
    Caption := 'ChatGPT';
    ClientHeight := 557;
    ClientWidth := 420;
    Position := poMainFormCenter;
  end;

  Fram_Question := TFram_Question.Create(Self);
  with Fram_Question do
  begin
    Name := 'Fram_Question';
    Parent := Self;
    InitialFrame;
    InitialClassViewMenueItems(FDockFormClassListObj);
    Show;
    BringToFront;
  end;

  with TSingletonSettingObj.Instance do
  begin
    if (not HistoryEnabled) and (not ShouldReloadHistory) and (FileExists(GetHistoryFullPath)) then
      ShouldReloadHistory := True;
  end;

  Self.OnKeyDown := FormKeyDown;
  Self.OnClose := FormClose;
  Self.OnShow := FormShow;
  Self.KeyPreview := True;
end;

destructor TChatGPTDockForm.Destroy;
begin
  SaveStateNecessary := True;
  FDockFormClassListObj.Free;
  inherited;
  FChatGPTDockForm := nil;
end;

procedure TChatGPTDockForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Fram_Question.Edt_Search.Clear;
  Fram_Question.TerminateAll;
end;

procedure TChatGPTDockForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Ord(Key) = 27 then
    Close;
end;

initialization

finalization
  UnregisterSelf;

end.
