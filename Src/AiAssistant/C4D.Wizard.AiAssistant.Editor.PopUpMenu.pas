unit C4D.Wizard.AiAssistant.Editor.PopUpMenu;

interface

uses
  System.Classes, System.SysUtils, Vcl.Controls, Vcl.Menus, Vcl.Dialogs, Winapi.Windows,
  {$IFNDEF NEXTGEN}System.StrUtils{$ELSE}AnsiStrings{$ENDIF !NEXTGEN}, ToolsAPI, StructureViewAPI,
  DockForm, System.Generics.Collections, Vcl.Forms,

  C4D.Wizard.IDE.ImageListMain,
  C4D.Wizard.AiAssistant.MenuHook,
  C4D.Wizard.AiAssistant.Setting.View,
  C4D.Wizard.AiAssistant.Ask.Frame,
  C4D.Wizard.AiAssistant.Ask.Dockable,
  C4D.Wizard.AiAssistant.Editor.Helper,
  C4D.Wizard.AiAssistant.Progress,
  C4D.Wizard.Consts;

type

{************************************************************************************************}
{                                                                                                }
{   The editor is not immediately available upon startup of the IDE,                             }
{   therefore we can’t get access to the editor in the plugin initialization code.               }
{   What we needed is to register a class that implements the INTAEditServicesNotifier interface.}
{   The IDE calls this interface when the editor is activated in the IDE.                        }
{                                                                                                }
{************************************************************************************************}

  TChatGPTOnCliskType = procedure(Sender: TObject) of Object;

  TMsgType = (mtNone, mtNormalQuestion, mtAddTest, mtFindBugs, mtAddComment,
              mtOptimize, mtCompleteCode, mtExplain, mtRefactor, mtASM);

 TEditNotifierHelper = class(TNotifierObject, IOTANotifier, INTAEditServicesNotifier)
    procedure OnChatGPTSubMenuClick(Sender: TObject; MenuItem: TMenuItem);
    procedure OnChatGPTContextMenuFixedQuestionClick(Sender: TObject);
  private
    FMenuHook: TCpMenuHook;
    class function GetQuestion(AStr: string): string;
    class function CreateMsg(AType: TMsgType): string;
    class procedure FormatSource;
    function GetCurrentUnitPath: string;
    class function GetSelectedText: string;
    class procedure RunInlineQuestion(AQuestion: string; AMsgType: TMsgType);
    class procedure DoAskSubMenu;
    class procedure DoAddTest;
    class procedure DoFindBugs;
    class procedure DoOptimize;
    class procedure DoAddComments;
    class procedure DoCompleteCode;
    class procedure DoExplain;
    class procedure DoRefactor;
    class procedure DoConvertToAssembly;
    class function RefineText(AInput: TStringList; AMsgType: TMsgType = mtNone): string;
    class procedure WriteIntoEditor(AText: string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure WindowShow(const EditWindow: INTAEditWindow; Show, LoadedFromDesktop: Boolean);
    procedure WindowNotification(const EditWindow: INTAEditWindow; Operation: TOperation);
    procedure WindowActivated(const EditWindow: INTAEditWindow);
    procedure WindowCommand(const EditWindow: INTAEditWindow; Command, Param: Integer; var Handled: Boolean);
    procedure EditorViewActivated(const EditWindow: INTAEditWindow; const EditView: IOTAEditView);
    procedure EditorViewModified(const EditWindow: INTAEditWindow; const EditView: IOTAEditView);
    procedure DockFormVisibleChanged(const EditWindow: INTAEditWindow; DockForm: TDockableForm);
    procedure DockFormUpdated(const EditWindow: INTAEditWindow; DockForm: TDockableForm);
    procedure DockFormRefresh(const EditWindow: INTAEditWindow; DockForm: TDockableForm);
    procedure AddEditorContextMenu;
    function AddMenuItem(AParentMenu: TMenuItem; AName, ACaption: string; AOnClick: TChatGPTOnCliskType; AShortCut: string; ATag: NativeInt): TMenuItem;
  end;

  var
    FChatGPTSubMenu: TCpMenuItemDef;
    FNotifierIndex: Integer = -1;

    procedure RegisterSelf;
    procedure UnregisterSelf;

implementation

{ TEditNotifierHelper }

procedure RegisterSelf;
begin
  FNotifierIndex := (BorlandIDEServices as IOTAEditorServices).AddNotifier(TEditNotifierHelper.Create);
end;

procedure UnregisterSelf;
begin
  if FNotifierIndex <> -1 then
    (BorlandIDEServices as IOTAEditorServices).RemoveNotifier(FNotifierIndex);
end;

procedure TEditNotifierHelper.AddEditorContextMenu;
var
  LvEditorPopUpMenu: TPopupMenu;
begin
  LvEditorPopUpMenu := TPopupMenu((BorlandIDEServices as IOTAEditorServices).TopView.GetEditWindow.Form.FindComponent('EditorLocalMenu'));
  FMenuHook.HookMenu(LvEditorPopUpMenu);
  if FMenuHook.IsHooked(LvEditorPopUpMenu) then
  begin
    FChatGPTSubMenu := TCpMenuItemDef.Create('ChatGPTSubMenu', 'AI Assistant', nil, ipAfter, 'ChatGPTSubMenu');
    FChatGPTSubMenu.OnCreated := OnChatGPTSubMenuClick;
    FMenuHook.AddMenuItemDef(FChatGPTSubMenu);
  end;
end;

function TEditNotifierHelper.AddMenuItem(AParentMenu: TMenuItem; AName, ACaption: string; AOnClick: TChatGPTOnCliskType; AShortCut: string; ATag: NativeInt): TMenuItem;
var
  LvItem: TMenuItem;
begin
  LvItem := TMenuItem.Create(nil);
  LvItem.Name := AName;
  LvItem.Tag := ATag;
  LvItem.Caption := ACaption + IfThen(AShortCut.IsEmpty, '', '  (' + AShortCut + ')');
  LvItem.OnClick := AOnClick;
  AParentMenu.Add(LvItem);
  Result := LvItem;
end;

constructor TEditNotifierHelper.Create;
begin
  inherited Create;
  FMenuHook := TCpMenuHook.Create(nil);
end;

class function TEditNotifierHelper.CreateMsg(AType: TMsgType): string;
var
  LeftIdentifier: string;
  RightIdentifier: string;
begin
  case AType of
    mtNormalQuestion:
    begin
      Cs.Enter;
      LeftIdentifier := TSingletonSettingObj.Instance.LeftIdentifier;
      RightIdentifier := TSingletonSettingObj.Instance.RightIdentifier;
      Cs.Leave;

      Result := 'There is no selected text with the ChatGPT Plug-in''s desired format, follow the below sample, please.' +
                   #13 + LeftIdentifier + ' Any Question... ' + RightIdentifier;
    end;

    mtAddTest,
    mtFindBugs,
    mtOptimize,
    mtCompleteCode,
    mtExplain, mtASM: Result := 'There is no selected text.';
  end;
end;

destructor TEditNotifierHelper.Destroy;
begin
  FMenuHook.Free;
  inherited;
end;

class procedure TEditNotifierHelper.DoAddComments;
var
  LvSelectedText: string;
begin
  LvSelectedText := GetSelectedText;
  if not LvSelectedText.IsEmpty then
    RunInlineQuestion(TC4DConsts.AI_ASSISTANT_CM_ADDCOMMENTS + #13 + LvSelectedText, mtAddComment)
  else
    ShowMessage(CreateMsg(mtAddTest));
end;

class procedure TEditNotifierHelper.DoAddTest;
var
  LvSelectedText: string;
begin
  LvSelectedText := GetSelectedText;
  if not LvSelectedText.IsEmpty then
    RunInlineQuestion(TC4DConsts.AI_ASSISTANT_CM_ADDTEST + #13 + LvSelectedText, mtAddTest)
  else
    ShowMessage(CreateMsg(mtAddTest));
end;

class procedure TEditNotifierHelper.DoAskSubMenu;
var
  LvSelectedText: string;
begin
  LvSelectedText := GetSelectedText;
  if not LvSelectedText.IsEmpty then
  begin
    //If it is a ChatGPT question
    if (SameStr(LeftStr(LvSelectedText, 4).ToLower, TSingletonSettingObj.Instance.LeftIdentifier)) and (SameStr(RightStr(LvSelectedText, 4).ToLower, TSingletonSettingObj.Instance.RightIdentifier)) then
      RunInlineQuestion(GetQuestion(LvSelectedText), mtNormalQuestion)
    else
      ShowMessage(CreateMsg(mtNormalQuestion));
  end
  else
    ShowMessage(CreateMsg(mtNormalQuestion));
end;

procedure TEditNotifierHelper.DockFormRefresh(const EditWindow: INTAEditWindow;
  DockForm: TDockableForm);
begin

end;

procedure TEditNotifierHelper.DockFormUpdated(const EditWindow: INTAEditWindow;
  DockForm: TDockableForm);
begin

end;

procedure TEditNotifierHelper.DockFormVisibleChanged(
  const EditWindow: INTAEditWindow; DockForm: TDockableForm);
begin

end;

class procedure TEditNotifierHelper.DoCompleteCode;
var
  LvSelectedText: string;
begin
  LvSelectedText := GetSelectedText;
  if not LvSelectedText.IsEmpty then
    RunInlineQuestion(TC4DConsts.AI_ASSISTANT_CM_COMPLETE_CODE + #13 + LvSelectedText, mtCompleteCode)
  else
    ShowMessage(CreateMsg(mtCompleteCode));
end;

class procedure TEditNotifierHelper.DoConvertToAssembly;
var
  LvSelectedText: string;
begin
  LvSelectedText := GetSelectedText;
  if not LvSelectedText.IsEmpty then
    RunInlineQuestion(TC4DConsts.AI_ASSISTANT_CM_CONVERT_TO_ASM + #13 + LvSelectedText, mtASM)
  else
    ShowMessage(CreateMsg(mtASM));
end;

class procedure TEditNotifierHelper.DoExplain;
var
  LvSelectedText: string;
begin
  LvSelectedText := GetSelectedText;
  if not LvSelectedText.IsEmpty then
    RunInlineQuestion(TC4DConsts.AI_ASSISTANT_CM_EXPLAIN + #13 + LvSelectedText, mtExplain)
  else
    ShowMessage(CreateMsg(mtExplain));
end;

class procedure TEditNotifierHelper.DoFindBugs;
var
  LvSelectedText: string;
begin
  LvSelectedText := GetSelectedText;
  if not LvSelectedText.IsEmpty then
    RunInlineQuestion(TC4DConsts.AI_ASSISTANT_CM_FINDBUGS + #13 + LvSelectedText, mtFindBugs)
  else
    ShowMessage(CreateMsg(mtFindBugs));
end;

class procedure TEditNotifierHelper.DoOptimize;
var
  LvSelectedText: string;
begin
  LvSelectedText := GetSelectedText;
  if not LvSelectedText.IsEmpty then
    RunInlineQuestion(TC4DConsts.AI_ASSISTANT_CM_OPTIMIZE + #13 + LvSelectedText, mtOptimize)
  else
    ShowMessage(CreateMsg(mtOptimize));
end;

class procedure TEditNotifierHelper.DoRefactor;
var
  LvSelectedText: string;
begin
  LvSelectedText := GetSelectedText;
  if not LvSelectedText.IsEmpty then
    RunInlineQuestion(TC4DConsts.AI_ASSISTANT_CM_REFACTOR + #13 + LvSelectedText, mtRefactor)
  else
    ShowMessage(CreateMsg(mtOptimize));
end;

procedure TEditNotifierHelper.EditorViewActivated(const EditWindow: INTAEditWindow; const EditView: IOTAEditView);
var
  LvCurrentUnitName: string;
begin
  if not Assigned(FChatGPTSubMenu) then
    AddEditorContextMenu;

  LvCurrentUnitName := GetCurrentUnitPath;

  Cs.Enter;
  if Assigned(FChatGPTDockForm) and (FChatGPTDockForm.Showing) and (FChatGPTDockForm.Fram_Question.pgcMain.ActivePageIndex = 1) and
    (not LvCurrentUnitName.Equals(TSingletonSettingObj.Instance.CurrentActiveViewName)) then
  begin
    TSingletonSettingObj.Instance.CurrentActiveViewName := LvCurrentUnitName;
    Cs.Leave;

    if Assigned(FChatGPTDockForm) then
    begin
      with FChatGPTDockForm.Fram_Question do
      begin
        if (pgcMain.ActivePage = tsClassView) and (not ClassViewIsBusy) then
          ReloadClassList(FChatGPTDockForm.DockFormClassListObj);
      end;
    end;
  end;
end;

procedure TEditNotifierHelper.EditorViewModified(
  const EditWindow: INTAEditWindow; const EditView: IOTAEditView);
begin

end;

class procedure TEditNotifierHelper.FormatSource;
var
  LvEditorPopUpMenu: TPopupMenu;
begin
  LvEditorPopUpMenu := TPopupMenu((BorlandIDEServices as IOTAEditorServices).TopView.GetEditWindow.Form.FindComponent('EditorLocalMenu'));
  if LvEditorPopUpMenu <> nil then
    LvEditorPopUpMenu.Items.Find('Format Source').Click;
end;

function TEditNotifierHelper.GetCurrentUnitPath: string;
var
  ModuleServices: IOTAModuleServices;
  CurrentModule: IOTAModule;
begin
  Result := '';
  if Supports(BorlandIDEServices, IOTAModuleServices) then
  begin
    try
      ModuleServices := BorlandIDEServices as IOTAModuleServices;
      CurrentModule := ModuleServices.CurrentModule;
      Result := ExtractFileName(CurrentModule.CurrentEditor.FileName);
    except
      Result := '';
    end;
  end;
end;

class function TEditNotifierHelper.GetQuestion(AStr: string): string;
var
  LvTmpStr: string;
begin
  LvTmpStr := AStr.Trim;
  if LeftStr(AStr, 2) = '//' then
    LvTmpStr := RightStr(AStr.Trim, AStr.Length - 2);

  LvTmpStr := RightStr(AStr.Trim, AStr.Length - 4);
  Result := LeftStr(LvTmpStr, LvTmpStr.Length - 4);
end;

class function TEditNotifierHelper.GetSelectedText: string;
var
  LvEditView: IOTAEditView;
  LvEditBlock: IOTAEditBlock;
begin
  Result := '';
  if TSingletonSettingObj.Instance.ApiKey = '' then
  begin
    if TSingletonSettingObj.Instance.GetSetting.Trim.IsEmpty then
      Exit;
  end;

  if Supports(BorlandIDEServices, IOTAEditorServices) then
  begin
    LvEditView := (BorlandIDEServices as IOTAEditorServices).TopView;

    // Get the selected text in the edit view
    LvEditBlock := LvEditView.GetBlock;

    if (LvEditBlock.StartingColumn <> LvEditBlock.EndingColumn) or (LvEditBlock.StartingRow <> LvEditBlock.EndingRow) then
      Result := LvEditBlock.Text;
  end;
end;

procedure TEditNotifierHelper.OnChatGPTContextMenuFixedQuestionClick(Sender: TObject);
begin
  if Sender is TMenuItem then
  begin
    case TMenuItem(Sender).Tag of
      0: DoAskSubMenu;
      1: DoAddTest;
      2: DoFindBugs;
      3: DoOptimize;
      4: DoAddComments;
      5: DoCompleteCode;
      6: DoExplain;
      7: DoRefactor;
      8: DoConvertToAssembly;
    end;
  end;
end;

procedure TEditNotifierHelper.OnChatGPTSubMenuClick(Sender: TObject; MenuItem: TMenuItem);
begin
  TSingletonSettingObj.Instance.ReadRegistry;
  if not Assigned(MenuItem.Find('Ask')) then
  begin
    AddMenuItem(MenuItem, 'ChatGPTAskSubMenu', 'Ask', OnChatGPTContextMenuFixedQuestionClick, 'Ctrl+Alt+Shift+A', 0);
    AddMenuItem(MenuItem, 'ChatGPTAddTest', 'Add Test', OnChatGPTContextMenuFixedQuestionClick, 'Ctrl+Alt+Shift+C', 1);
    AddMenuItem(MenuItem, 'ChatGPTFindBugs', 'Find Bugs', OnChatGPTContextMenuFixedQuestionClick, 'Ctrl+Alt+Shift+B', 2);
    AddMenuItem(MenuItem, 'ChatGPTOptimize', 'Optimize', OnChatGPTContextMenuFixedQuestionClick, 'Ctrl+Alt+Shift+O', 3);
    AddMenuItem(MenuItem, 'ChatGPTAddComments', 'Add Comments', OnChatGPTContextMenuFixedQuestionClick, 'Ctrl+Alt+Shift+M', 4);
    AddMenuItem(MenuItem, 'ChatGPTCompleteCode', 'Complete Code', OnChatGPTContextMenuFixedQuestionClick, 'Ctrl+Alt+Shift+k', 5);
    AddMenuItem(MenuItem, 'ChatGPTExplain', 'Explain Code', OnChatGPTContextMenuFixedQuestionClick, 'Ctrl+Alt+Shift+E', 6);
    AddMenuItem(MenuItem, 'ChatGPTRefactor', 'Refactor Code', OnChatGPTContextMenuFixedQuestionClick, 'Ctrl+Alt+Shift+R', 7);
    AddMenuItem(MenuItem, 'ChatGPTAsm', 'Convert to Assembly', OnChatGPTContextMenuFixedQuestionClick, 'Ctrl+Alt+Shift+S', 8);
  end;
end;

class function TEditNotifierHelper.RefineText(AInput: TStringList; AMsgType: TMsgType): string;
  const LcLeftComment = '//************ '; LcRightComment = ' ***************';
var
  LvComment: string;
begin
  case AMsgType of
    mtNone:
      LvComment := '';
    mtNormalQuestion:
      LvComment := '';
    mtAddTest:
      LvComment := 'Add Test';
    mtFindBugs:
      LvComment := 'Find Bugs';
    mtAddComment:
      LvComment := 'Add Comment';
    mtOptimize:
      LvComment := 'Optimize Code';
    mtCompleteCode:
      LvComment := 'Complete Code';
    mtExplain:
      LvComment := 'Explanation';
    mtRefactor:
      LvComment := 'Refactor';
    mtASM:
      LvComment := 'Convert to Assembly'
  end;

  Result :=  TC4DConsts.AI_ASSISTANT_CRLF + '{' + LcLeftComment + LvComment + LcRightComment + TC4DConsts.AI_ASSISTANT_CRLF + AInput.Text + '}';
end;

class procedure TEditNotifierHelper.RunInlineQuestion(AQuestion: string; AMsgType: TMsgType);
begin
  if not TSingletonSettingObj.Instance.ApiKey.Trim.IsEmpty then
  begin
    Frm_Progress := TFrm_Progress.Create(nil);
    try
      Frm_Progress.SelectedText := AQuestion;
      TSingletonSettingObj.RegisterFormClassForTheming(TFrm_Progress, Frm_Progress); //Apply Theme
      Frm_Progress.ShowModal;
      if not Frm_Progress.Answer.Text.Trim.IsEmpty then
      begin
        WriteIntoEditor(RefineText(Frm_Progress.Answer, AMsgType));

        if not (Frm_Progress.HasError) and (TSingletonSettingObj.Instance.CodeFormatter) then
          TEditNotifierHelper.FormatSource;
      end;
    finally
      FreeAndNil(Frm_Progress);
    end;
  end;
end;

procedure TEditNotifierHelper.WindowActivated(const EditWindow: INTAEditWindow);
begin

end;

procedure TEditNotifierHelper.WindowCommand(const EditWindow: INTAEditWindow;
  Command, Param: Integer; var Handled: Boolean);
begin

end;

procedure TEditNotifierHelper.WindowNotification(
  const EditWindow: INTAEditWindow; Operation: TOperation);
begin

end;

procedure TEditNotifierHelper.WindowShow(const EditWindow: INTAEditWindow; Show,
  LoadedFromDesktop: Boolean);
begin

end;

class procedure TEditNotifierHelper.WriteIntoEditor(AText: string);
var
  LvEditView: IOTAEditView;
  LvTextLen: Integer;
  LvStartPos: Integer;
  LvEndPos: Integer;
  LvLineNo: Integer;
  LvCharIndex: Integer;
  LvLineText: String;
begin
  LvEditView := GetTopMostEditView;
  if IsEditControl(Screen.ActiveControl) and Assigned(LvEditView) then
  begin
    if LvEditView.Block.IsValid then
    begin
      LvStartPos := EditPosToLinePos(OTAEditPos(LvEditView.Block.StartingColumn, LvEditView.Block.StartingRow), LvEditView);
      LvEndPos := EditPosToLinePos(OTAEditPos(LvEditView.Block.EndingColumn, LvEditView.Block.EndingRow), LvEditView);
      LvTextLen := LvEditView.Block.Size;

      InsertTextIntoEditorAtPos(AText , LvEndPos, LvEditView.Buffer);
      LvEditView.CursorPos := LinePosToEditPos(LvStartPos + LvTextLen);
      LvEditView.Block.BeginBlock;
      LvEditView.CursorPos := LinePosToEditPos(LvEndPos + LvTextLen);
      LvEditView.Block.EndBlock;

      LvEditView.Paint;
    end
    else
    begin
      GetCurrLineText(LvLineText, LvLineNo, LvCharIndex);
      Inc(LvLineNo);
      InsertSingleLine(LvLineNo, LvLineText, LvEditView);
    end;
  end;
end;

initialization

finalization
  UnRegisterSelf;

end.
