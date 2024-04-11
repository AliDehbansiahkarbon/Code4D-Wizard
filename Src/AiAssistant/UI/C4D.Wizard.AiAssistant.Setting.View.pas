{ ***************************************************}
{                                                    }
{   This is the setting form of the AI Assistant.    }
{   Auhtor: Ali Dehbansiahkarbon(adehban@gmail.com)  }
{                                                    }
{ ***************************************************}
unit C4D.Wizard.AiAssistant.Setting.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, System.Win.Registry, System.SyncObjs,
  ToolsAPI, System.StrUtils, System.Generics.Collections, Vcl.Mask,
  Vcl.ComCtrls, DockForm, System.JSON, C4D.Wizard.Consts;

type
  TQuestionPair = class;
  TQuestionPairs = TObjectDictionary<Integer, TQuestionPair>;
  TProxySetting = class
  private
    FActive: Boolean;
    FProxyHost: string;
    FProxyPort: Integer;
    FProxyUsername: string;
    FProxyPassword: string;
  public
    property Active: Boolean read FActive write FActive;
    property ProxyHost: string read FProxyHost write FProxyHost;
    property ProxyPort: Integer read FProxyPort write FProxyPort;
    property ProxyUsername: string read FProxyUsername write FProxyUsername;
    property ProxyPassword: string read FProxyPassword write FProxyPassword;
  end;  

  TQuestionPair = class
  private
    FCaption: string;
    FQuestion: string;
  public
    constructor Create(ACaption, AQuestion: string);
    property Caption: string read FCaption write FCaption;
    property Question: string read FQuestion write FQuestion;
  end;

  // Note: This class is thread-safe, since accessing the class variable is done in a critical section!
  TSingletonSettingObj = class(TObject)
  private
    FApiKey: string;
    FURL: string;
    FModel: string;
    FMaxToken: Integer;
    FTemperature: Integer;
    FIdentifier: string;
    FCodeFormatter: Boolean;
    FRightToLeft: Boolean;
    FRootMenuIndex: Integer;
    FProxySetting: TProxySetting;
    FCurrentActiveViewName: string;
    FHistoryEnabled: Boolean;
    FHistoryPath: string;
    FShouldReloadHistory: Boolean;
    FHighlightColor: TColor;
    FPredefinedQuestions: TQuestionPairs;
    FAnimatedLetters: Boolean;
    FTimeOut: Integer;
    FMainFormLastQuestion: string;
    FIsOffline: Boolean;
    FTaskList: TList<string>;

    class var FInstance: TSingletonSettingObj;
    class function GetInstance: TSingletonSettingObj; static;
    constructor Create;
    destructor Destroy; override;

    function GetLeftIdentifier: string;
    function GetRightIdentifier: string;
    procedure LoadDefaults;
    procedure LoadDefaultQuestions;

  public
    procedure ReadRegistry;
    procedure WriteToRegistry;
    function GetSetting: string;
    function GetHistoryFullPath: string;
    function TryFindQuestion(ACaption: string; var AQuestion: string): Integer;
    class Procedure RegisterFormClassForTheming(Const AFormClass: TCustomFormClass; Const Component: TComponent = Nil);
    class function IsValidJson(const AJsonString: string): Boolean;
    class property Instance: TSingletonSettingObj read GetInstance;

    property ApiKey: string read FApiKey write FApiKey;
    property URL: string read FURL write FURL;
    property Model: string read FModel write FModel;
    property MaxToken: Integer read FMaxToken write FMaxToken;
    property Temperature: Integer read FTemperature write FTemperature;
    property CodeFormatter: Boolean read FCodeFormatter write FCodeFormatter;
    property Identifier: string read FIdentifier write FIdentifier;
    property LeftIdentifier: string read GetLeftIdentifier;
    property RightIdentifier: string read GetRightIdentifier;
    property RighToLeft: Boolean read FRightToLeft write FRightToLeft;
    property RootMenuIndex: Integer read FRootMenuIndex write FRootMenuIndex;
    property ProxySetting: TProxySetting read FProxySetting write FProxySetting;
    property CurrentActiveViewName: string read FCurrentActiveViewName write FCurrentActiveViewName;
    property HistoryEnabled: Boolean read FHistoryEnabled write FHistoryEnabled;
    property HistoryPath: string read FHistoryPath write FHistoryPath;
    property ShouldReloadHistory: Boolean read FShouldReloadHistory write FShouldReloadHistory;
    property HighlightColor: TColor read FHighlightColor write FHighlightColor;
    property PredefinedQuestions: TQuestionPairs read FPredefinedQuestions write FPredefinedQuestions;
    property AnimatedLetters: Boolean read FAnimatedLetters write FAnimatedLetters;
    property TimeOut: Integer read FTimeOut write FTimeOut;
    property MainFormLastQuestion: string read FMainFormLastQuestion write FMainFormLastQuestion;
    property IsOffline: Boolean read FIsOffline write FIsOffline;
    property TaskList: TList<string> read FTaskList write FTaskList;
  end;

  TFrm_AI_Setting = class(TForm)
    pnlMain: TPanel;
    grp_OpenAI: TGroupBox;
    pnlOpenAI: TPanel;
    lbl_1: TLabel;
    lbl_2: TLabel;
    lbl_3: TLabel;
    lbl_4: TLabel;
    lbl_5: TLabel;
    edt_Url: TEdit;
    edt_ApiKey: TEdit;
    edt_MaxToken: TEdit;
    edt_Temperature: TEdit;
    cbbModel: TComboBox;
    pnlOther: TPanel;
    pnlBottom: TPanel;
    Btn_Default: TButton;
    Btn_Save: TButton;
    grp_History: TGroupBox;
    pnlHistory: TPanel;
    chk_History: TCheckBox;
    lbEdt_History: TLabeledEdit;
    grp_Proxy: TGroupBox;
    pnlProxy: TPanel;
    lbEdt_ProxyHost: TLabeledEdit;
    lbEdt_ProxyPort: TLabeledEdit;
    chk_ProxyActive: TCheckBox;
    lbEdt_ProxyUserName: TLabeledEdit;
    lbEdt_ProxyPassword: TLabeledEdit;
    grp_Other: TGroupBox;
    pnlIDE: TPanel;
    lbl_6: TLabel;
    Edt_SourceIdentifier: TEdit;
    chk_CodeFormatter: TCheckBox;
    chk_Rtl: TCheckBox;
    Btn_HistoryPathBuilder: TButton;
    ColorBox_Highlight: TColorBox;
    lbl_ColorPicker: TLabel;
    pgcSetting: TPageControl;
    tsMainSetting: TTabSheet;
    tsPreDefinedQuestions: TTabSheet;
    Btn_AddQuestion: TButton;
    ScrollBox: TScrollBox;
    GridPanelPredefinedQs: TGridPanel;
    Btn_RemoveQuestion: TButton;
    lbEdt_Timeout: TLabeledEdit;
    pnlPredefinedQ: TPanel;
    chk_AnimatedLetters: TCheckBox;
    chk_Offline: TCheckBox;
    edt_OfflineModel: TEdit;
    procedure Btn_SaveClick(Sender: TObject);
    procedure Btn_DefaultClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Btn_HistoryPathBuilderClick(Sender: TObject);
    procedure chk_HistoryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Btn_RemoveQuestionClick(Sender: TObject);
    procedure Btn_AddQuestionClick(Sender: TObject);
    procedure edt_UrlChange(Sender: TObject);
    procedure cbbModelChange(Sender: TObject);
    procedure chk_AnimatedLettersClick(Sender: TObject);
    procedure ColorBox_HighlightChange(Sender: TObject);
    procedure chk_ProxyActiveClick(Sender: TObject);
    procedure pgcSettingChange(Sender: TObject);
    procedure chk_OfflineClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure AddQuestion(AQuestionpair: TQuestionPair = nil);
    procedure RemoveLatestQuestion;
    procedure ClearGridPanel;
    function ValidateInputs: Boolean;
  public
    HasChanges: Boolean;
    procedure AddAllDefinedQuestions;
  end;

var
  Frm_Setting: TFrm_AI_Setting;
  Cs: TCriticalSection;

  procedure UnregisterSelf;
implementation
{$R *.dfm}

procedure UnregisterSelf;
begin
  if Assigned(Frm_Setting) then
  begin
    Frm_Setting.Close;
    FreeAndNil(Frm_Setting);
  end;
end;

{ TSingletonSettingObj }
constructor TSingletonSettingObj.Create;
begin
  inherited;
  FProxySetting := TProxySetting.Create;
  FPredefinedQuestions := TObjectDictionary<Integer, TQuestionPair>.Create;
  CurrentActiveViewName := '';
  FTaskList := TList<string>.Create;
  LoadDefaults;
end;

destructor TSingletonSettingObj.Destroy;
begin
  FProxySetting.Free;
  FPredefinedQuestions.Free;
  FTaskList.Free;
  inherited;
end;

function TSingletonSettingObj.GetHistoryFullPath: string;
begin
  Result := FHistoryPath + '\History.sdb';
end;

class function TSingletonSettingObj.GetInstance: TSingletonSettingObj;
begin
  if not Assigned(FInstance) then
    FInstance := TSingletonSettingObj.Create;
  Result := FInstance;
end;

function TSingletonSettingObj.GetLeftIdentifier: string;
begin
  Result := FIdentifier + ':';
end;

function TSingletonSettingObj.GetRightIdentifier: string;
begin
  Result := ':' + FIdentifier;
end;

function TSingletonSettingObj.GetSetting: string;
begin
  Result := EmptyStr;
  ShowMessage('You need an API key, please fill the setting parameters in setting form.');
  Frm_Setting := TFrm_AI_Setting.Create(nil);
  try
    TSingletonSettingObj.RegisterFormClassForTheming(TFrm_AI_Setting, Frm_Setting);
    // Apply Theme
    Frm_Setting.ShowModal;
  finally
    FreeAndNil(Frm_Setting);
  end;

  if FIsOffline then
    Result := 'N\A'
  else
    Result := TSingletonSettingObj.Instance.ApiKey;
end;

class function TSingletonSettingObj.IsValidJson(const AJsonString: string): Boolean;
var
  LvJsonObj: TJSONObject;
begin
  Result := False;
  try
    LvJsonObj := TJSONObject.ParseJSONValue(AJsonString) as TJSONObject;
    Result := Assigned(LvJsonObj); // If parsing succeeds, JSON is valid
    LvJsonObj.Free;
  except
    Result := False;
  end;
end;

procedure TSingletonSettingObj.LoadDefaultQuestions;
begin
  with FPredefinedQuestions do
  begin
    Clear;
    Add(1, TQuestionPair.Create('Create Test Unit', 'Create a Test Unit for the following class in Delphi:'));
    Add(2, TQuestionPair.Create('Convert to Singleton', 'Convert this class to singleton in Delphi:'));
    Add(3, TQuestionPair.Create('Find possible problems', 'What is wrong with this class in Delphi?'));
    Add(4, TQuestionPair.Create('Improve Naming', 'Improve naming of the members of this class in Delphi:'));
    Add(5, TQuestionPair.Create('Rewrite in modern coding style', 'Rewrite this class with modern coding style in Delphi:'));
    Add(6, TQuestionPair.Create('Create Interface','Create necessary interfaces for this Class in Delphi:'));
    Add(7, TQuestionPair.Create('Convert to Generic Type', 'Convert this class to generic class in Delphi:'));
    Add(8, TQuestionPair.Create('Write XML doc', 'Write Documentation using inline XML based comments for this class in Delphi:'));
  end;
end;

procedure TSingletonSettingObj.LoadDefaults;
begin
  FApiKey := '';
  FURL := TC4DConsts.AI_ASSISTANT_DEFAULT_URL;
  FModel := TC4DConsts.AI_ASSISTANT_DEFAULT_MODEL;
  FMaxToken := TC4DConsts.AI_ASSISTANT_DEFAULT_MAXTOKEN;
  FTemperature := TC4DConsts.AI_ASSISTANT_DEFAULT_TEMPERATURE;
  FIdentifier := TC4DConsts.AI_ASSISTANT_DEFAULT_IDENTIFIER;
  FCodeFormatter := TC4DConsts.AI_ASSISTANT_DEFAULT_CODEFORMATTER;
  FRightToLeft := TC4DConsts.AI_ASSISTANT_DEFAULT_RTL;
  FProxySetting.ProxyHost := '';
  FProxySetting.ProxyPort := 0;
  FProxySetting.ProxyUsername := '';
  FProxySetting.ProxyPassword := '';
  FProxySetting.Active := False;
  FHistoryEnabled := False;
  FShouldReloadHistory := False;
  FHistoryPath := '';
  FHighlightColor := clRed;
  FAnimatedLetters := True;
  FTimeOut := 20;
  FMainFormLastQuestion := 'Create a class to make a Zip file in Delphi.';
  FIsOffline := False;

  LoadDefaultQuestions;
end;

procedure TSingletonSettingObj.ReadRegistry;
var
  LvRegKey: TRegistry;
  I: Integer;
begin
  FApiKey := '';

  LvRegKey := TRegistry.Create;
  try
    try
      with LvRegKey do
      begin
        CloseKey;
        RootKey := HKEY_CURRENT_USER;

        if OpenKey('\SOFTWARE\ChatGPTWizard', False) then
        begin
          if ValueExists('ChatGPTApiKey') then
            FApiKey := ReadString('ChatGPTApiKey');

          if ValueExists('ChatGPTURL') then
            FURL := IfThen(ReadString('ChatGPTURL').IsEmpty, TC4DConsts.AI_ASSISTANT_DEFAULT_URL, ReadString('ChatGPTURL'))
          else
            FURL := TC4DConsts.AI_ASSISTANT_DEFAULT_URL;

          if ValueExists('ChatGPTModel') then
            FModel := IfThen(ReadString('ChatGPTModel').IsEmpty, TC4DConsts.AI_ASSISTANT_DEFAULT_MODEL, ReadString('ChatGPTModel'))
          else
            FModel := TC4DConsts.AI_ASSISTANT_DEFAULT_MODEL;

          if ValueExists('ChatGPTMaxToken') then
          begin
            FMaxToken := ReadInteger('ChatGPTMaxToken');
            if FMaxToken <= 0 then
              FMaxToken := TC4DConsts.AI_ASSISTANT_DEFAULT_MAXTOKEN;
          end
          else
            FMaxToken := TC4DConsts.AI_ASSISTANT_DEFAULT_MAXTOKEN;

          if ValueExists('ChatGPTTemperature') then
          begin
            FTemperature := ReadInteger('ChatGPTTemperature');
            if FTemperature <= -1 then
              FTemperature := TC4DConsts.AI_ASSISTANT_DEFAULT_TEMPERATURE;
          end
          else
            FTemperature := TC4DConsts.AI_ASSISTANT_DEFAULT_TEMPERATURE;

          if ValueExists('ChatGPTSourceIdentifier') then
            FIdentifier := IfThen(ReadString('ChatGPTSourceIdentifier').IsEmpty, TC4DConsts.AI_ASSISTANT_DEFAULT_IDENTIFIER, ReadString('ChatGPTSourceIdentifier'))
          else
            FIdentifier := TC4DConsts.AI_ASSISTANT_DEFAULT_IDENTIFIER;

          if ValueExists('ChatGPTCodeFormatter') then
            FCodeFormatter := ReadBool('ChatGPTCodeFormatter')
          else
            FCodeFormatter := TC4DConsts.AI_ASSISTANT_DEFAULT_CODEFORMATTER;

          if ValueExists('ChatGPTRTL') then
            FRightToLeft := ReadBool('ChatGPTRTL')
          else
            FRightToLeft := TC4DConsts.AI_ASSISTANT_DEFAULT_RTL;

          if ValueExists('ChatGPTProxyActive') then
            FProxySetting.Active := ReadBool('ChatGPTProxyActive')
          else
            FProxySetting.Active := False;

          if ValueExists('ChatGPTProxyHost') then
            FProxySetting.ProxyHost := ReadString('ChatGPTProxyHost')
          else
            FProxySetting.ProxyHost := '';

          if ValueExists('ChatGPTProxyPort') then
            FProxySetting.ProxyPort := ReadInteger('ChatGPTProxyPort')
          else
            FProxySetting.ProxyPort := 0;

          if ValueExists('ChatGPTProxyUsername') then
            FProxySetting.ProxyUsername := ReadString('ChatGPTProxyUsername')
          else
            FProxySetting.ProxyUsername := '';

          if ValueExists('ChatGPTProxyPassword') then
            FProxySetting.ProxyPassword := ReadString('ChatGPTProxyPassword')
          else
            FProxySetting.ProxyPassword := '';

          if ValueExists('ChatGPTHistoryEnabled') then
          begin
            FHistoryEnabled := ReadBool('ChatGPTHistoryEnabled');
            FShouldReloadHistory := FHistoryEnabled;
          end;

          if ValueExists('ChatGPTHistoryPath') then
            FHistoryPath := ReadString('ChatGPTHistoryPath')
          else
            FHistoryPath := '';

          if ValueExists('ChatGPTHistoryPath') then
            FHighlightColor := ReadInteger('ChatGPTHighlightColor')
          else
            FHighlightColor := clRed;

          if ValueExists('ChatGPTAnimatedLetters') then
            FAnimatedLetters := ReadBool('ChatGPTAnimatedLetters')
          else
            FAnimatedLetters := True;

          if ValueExists('ChatGPTTimeOut') then
            FTimeOut := ReadInteger('ChatGPTTimeOut')
          else
            FTimeOut := 20;

          if ValueExists('ChatGPTMainFormLastQuestion') then
            FMainFormLastQuestion := ReadString('ChatGPTMainFormLastQuestion').Trim
          else
            FMainFormLastQuestion := 'Create a class to make a Zip file in Delphi.';


          //=======================Ollama(Offline)=======================begin
          if ValueExists('ChatGPTIsOffline') then
            FIsOffline := ReadBool('ChatGPTIsOffline')
          else
            FIsOffline := False;
          //=======================Ollama(Offline)========================end
        end;

        if OpenKey('\SOFTWARE\ChatGPTWizard\PredefinedQuestions', False) then
        begin
          FPredefinedQuestions.Clear;
          for I := 1 to 100 do
          begin
            if (ValueExists('Caption' + I.ToString)) and (ValueExists('Question' + I.ToString)) then
              FPredefinedQuestions.Add(I, TQuestionPair.Create(ReadString('Caption' + I.ToString), ReadString('Question' + I.ToString)));
          end;

          if FPredefinedQuestions.Count = 0 then
            LoadDefaultQuestions;
        end
        else
          LoadDefaultQuestions;
      end;
    except
      LoadDefaults;
    end;
  finally
    LvRegKey.Free;
  end;
end;

class procedure TSingletonSettingObj.RegisterFormClassForTheming(const AFormClass: TCustomFormClass; const Component: TComponent);
{$IF CompilerVersion >= 32.0}
Var
{$IF CompilerVersion > 33.0} // Breaking change to the Open Tools API - They fixed the wrongly defined interface
  ITS: IOTAIDEThemingServices;
{$ELSE}
  ITS: IOTAIDEThemingServices250;
{$IFEND}
{$IFEND}
begin
{$IF CompilerVersion >= 32.0}
{$IF CompilerVersion > 33.0}
  If Supports(BorlandIDEServices, IOTAIDEThemingServices, ITS) Then
{$ELSE}
  If Supports(BorlandIDEServices, IOTAIDEThemingServices250, ITS) Then
{$IFEND}
    If ITS.IDEThemingEnabled Then
    begin
      ITS.RegisterFormClass(AFormClass);
      If Assigned(Component) Then
        ITS.ApplyTheme(Component);
    end;
{$IFEND}
end;

function TSingletonSettingObj.TryFindQuestion(ACaption: string; var AQuestion: string): Integer;
var
  LvKey: Integer;
begin
  AQuestion := '';
  Result := -1;

  for LvKey in FPredefinedQuestions.Keys do
  begin
    if FPredefinedQuestions.Items[LvKey].Caption.ToLower.Trim = ACaption.ToLower.Trim then
    begin
      AQuestion := FPredefinedQuestions.Items[LvKey].Question;
      Result := LvKey;
      Break;
    end;
  end;
end;

procedure TSingletonSettingObj.WriteToRegistry;
var
  LvRegKey: TRegistry;
  LvKey: Integer;
  I: Integer;
begin
  LvRegKey := TRegistry.Create;
  try
    with LvRegKey do
    begin
      CloseKey;
      RootKey := HKEY_CURRENT_USER;
      if OpenKey('\SOFTWARE\ChatGPTWizard', True) then
      begin
        WriteString('ChatGPTApiKey', FApiKey);
        WriteString('ChatGPTURL', FURL);
        WriteString('ChatGPTModel', FModel);
        WriteInteger('ChatGPTMaxToken', FMaxToken);
        WriteInteger('ChatGPTTemperature', FTemperature);
        WriteString('ChatGPTSourceIdentifier', FIdentifier);
        WriteBool('ChatGPTCodeFormatter', FCodeFormatter);
        WriteBool('ChatGPTRTL', FRightToLeft);
        WriteBool('ChatGPTProxyActive', FProxySetting.Active);
        WriteString('ChatGPTProxyHost', FProxySetting.ProxyHost);
        WriteInteger('ChatGPTProxyPort', FProxySetting.ProxyPort);
        WriteString('ChatGPTProxyUsername', FProxySetting.ProxyUsername);
        WriteString('ChatGPTProxyChatGPTProxyPassword', FProxySetting.ProxyPassword);
        WriteBool('ChatGPTHistoryEnabled', FHistoryEnabled);
        WriteString('ChatGPTHistoryPath', FHistoryPath);
        WriteInteger('ChatGPTHighlightColor', FHighlightColor);
        WriteBool('ChatGPTAnimatedLetters', FAnimatedLetters);
        WriteInteger('ChatGPTTimeOut', FTimeOut);
        WriteString('ChatGPTMainFormLastQuestion', FMainFormLastQuestion.Trim);
        WriteBool('ChatGPTIsOffline', FIsOffline);


        if OpenKey('\SOFTWARE\ChatGPTWizard\PredefinedQuestions', True) then
        begin
          for I:= 0  to 100 do // Limited to maximum 100 menuitems.
          begin
            if ValueExists('Caption' + I.ToString) then
              DeleteValue('Caption' + I.ToString);

            if ValueExists('Question' + I.ToString) then
              DeleteValue('Question' + I.ToString);
          end;

          for LvKey in FPredefinedQuestions.Keys do
          begin
            WriteString('Caption' + LvKey.ToString, FPredefinedQuestions.Items[LvKey].Caption);
            WriteString('Question' + LvKey.ToString, FPredefinedQuestions.Items[LvKey].Question);
          end;
        end;
      end;
    end;
  finally
    LvRegKey.Free;
  end;
end;

{TFrm_AI_Setting}

procedure TFrm_AI_Setting.Btn_AddQuestionClick(Sender: TObject);
begin
  HasChanges := True;
  AddQuestion;
end;

procedure TFrm_AI_Setting.Btn_DefaultClick(Sender: TObject);
begin
  edt_ApiKey.Text := '';
  edt_Url.Text := TC4DConsts.AI_ASSISTANT_DEFAULT_URL;
  cbbModel.ItemIndex := 0;
  edt_MaxToken.Text := IntToStr(TC4DConsts.AI_ASSISTANT_DEFAULT_MAXTOKEN);
  edt_Temperature.Text := IntToStr(TC4DConsts.AI_ASSISTANT_DEFAULT_TEMPERATURE);
  chk_CodeFormatter.Checked := TC4DConsts.AI_ASSISTANT_DEFAULT_CODEFORMATTER;
  chk_Rtl.Checked := TC4DConsts.AI_ASSISTANT_DEFAULT_RTL;
  lbEdt_ProxyHost.Text := '';
  lbEdt_ProxyPort.Text := '';
  lbEdt_ProxyUserName.Text := '';
  lbEdt_ProxyPassword.Text := '';
  chk_History.Checked := False;
  lbEdt_History.Text := '';
  ColorBox_Highlight.Selected := clRed;
  chk_AnimatedLetters.Checked := True;
  chk_Offline.Checked := False;
end;

procedure TFrm_AI_Setting.Btn_HistoryPathBuilderClick(Sender: TObject);
begin
  with TFileOpenDialog.Create(nil) do
  begin
    try
      Options := [fdoPickFolders];
      if Execute then
        lbEdt_History.Text := FileName;
    finally
      Free;
    end;
  end;
end;

procedure TFrm_AI_Setting.Btn_SaveClick(Sender: TObject);
var
  I: Integer;
  LvSettingObj: TSingletonSettingObj;
  LvCaption, LvQuestion: string;
  LvLabeledEdit: TControl;
  Lvpanel: TControl;
begin
  if not ValidateInputs then
    Exit;

  LvSettingObj := TSingletonSettingObj.Instance;
  LvSettingObj.ApiKey := Trim(edt_ApiKey.Text);
  LvSettingObj.URL := Trim(edt_Url.Text);
  if chk_Offline.Checked then
    LvSettingObj.Model := Trim(edt_OfflineModel.Text)
  else
    LvSettingObj.Model := Trim(cbbModel.Text);

  LvSettingObj.MaxToken := StrToInt(edt_MaxToken.Text);
  LvSettingObj.Temperature := StrToInt(edt_Temperature.Text);
  LvSettingObj.RighToLeft := chk_Rtl.Checked;
  LvSettingObj.CodeFormatter := chk_CodeFormatter.Checked;
  LvSettingObj.Identifier := Edt_SourceIdentifier.Text;
  LvSettingObj.ProxySetting.ProxyHost := lbEdt_ProxyHost.Text;
  LvSettingObj.ProxySetting.ProxyPort := StrToIntDef(lbEdt_ProxyPort.Text, 0);
  LvSettingObj.ProxySetting.Active := chk_ProxyActive.Checked;
  LvSettingObj.ProxySetting.ProxyUsername := lbEdt_ProxyUserName.Text;
  LvSettingObj.ProxySetting.ProxyPassword := lbEdt_ProxyPassword.Text;
  if (chk_History.Checked) and (not LvSettingObj.HistoryEnabled) then
    LvSettingObj.ShouldReloadHistory := True;

  LvSettingObj.HistoryEnabled := chk_History.Checked;
  LvSettingObj.HistoryPath := lbEdt_History.Text;
  LvSettingObj.HighlightColor := ColorBox_Highlight.Selected;
  LvSettingObj.AnimatedLetters := chk_AnimatedLetters.Checked;
  LvSettingObj.TimeOut := StrToInt(Frm_Setting.lbEdt_Timeout.Text);
  LvSettingObj.IsOffline := chk_Offline.Checked;
  lbEdt_History.Enabled := chk_History.Checked;
  Btn_HistoryPathBuilder.Enabled := chk_History.Checked;

  LvSettingObj.PredefinedQuestions.Clear;
  for I := 1 to 100 do
  begin
    LvLabeledEdit := nil;
    Lvpanel := nil;

    Lvpanel := GridPanelPredefinedQs.FindChildControl('panel' + I.ToString);
    if Lvpanel <> nil then
    begin  
      LvLabeledEdit := TPanel(Lvpanel).FindChildControl('CustomLbl' + I.ToString);
      if LvLabeledEdit <> nil then
      begin
        LvCaption := TLabeledEdit(LvLabeledEdit).Text;
        LvQuestion := TMemo(TPanel(Lvpanel).FindChildControl('CustomLblQ' + I.ToString)).Lines.Text;
        if (not LvCaption.IsEmpty) and (not LvQuestion.IsEmpty) then
          LvSettingObj.PredefinedQuestions.Add(I, TQuestionPair.Create(LvCaption, LvQuestion));
      end;
    end;      
  end;
  LvSettingObj.WriteToRegistry;
  Close;
end;

procedure TFrm_AI_Setting.Btn_RemoveQuestionClick(Sender: TObject);
begin
  HasChanges := True;
  RemoveLatestQuestion;
end;

procedure TFrm_AI_Setting.cbbModelChange(Sender: TObject);
begin
  HasChanges := True;
end;

procedure TFrm_AI_Setting.chk_AnimatedLettersClick(Sender: TObject);
begin
  HasChanges := True;
end;

procedure TFrm_AI_Setting.chk_HistoryClick(Sender: TObject);
begin
  lbEdt_History.Enabled := chk_History.Checked;
  Btn_HistoryPathBuilder.Enabled := chk_History.Checked;
  HasChanges := True;
end;

procedure TFrm_AI_Setting.chk_OfflineClick(Sender: TObject);
begin
  cbbModel.Enabled := not chk_Offline.Checked;
  edt_MaxToken.Enabled := not chk_Offline.Checked;
  edt_OfflineModel.Enabled := chk_Offline.Checked;
end;

procedure TFrm_AI_Setting.chk_ProxyActiveClick(Sender: TObject);
begin
  HasChanges := True;
end;

procedure TFrm_AI_Setting.ClearGridPanel;
var
  I: Integer;
begin
  for I:= GridPanelPredefinedQs.RowCollection.Count downto 1 do
    RemoveLatestQuestion;
end;

procedure TFrm_AI_Setting.ColorBox_HighlightChange(Sender: TObject);
begin
  HasChanges := True;
end;

procedure TFrm_AI_Setting.edt_UrlChange(Sender: TObject);
begin
  HasChanges := True;
end;

procedure TFrm_AI_Setting.FormCreate(Sender: TObject);
begin
  HasChanges := False;
  GridPanelPredefinedQs.RowCollection.Clear;
  pgcSetting.ActivePageIndex := 0;

  // Styling does not work properly in Tokyo and Rio the following lines will make it better.
  if (CompilerVersion = 32{Tokyo}) or (CompilerVersion = 33{Rio}) then
  begin
    pgcSetting.StyleElements := [seFont, seBorder, seClient];

    pnlMain.StyleElements := [seFont, seBorder];
    pnlOpenAI.StyleElements := [seFont, seBorder];
    pnlOther.StyleElements := [seFont, seBorder];
    pnlHistory.StyleElements := [seFont, seBorder];

    chk_History.StyleElements := [seFont, seBorder];
    chk_ProxyActive.StyleElements := [seFont, seBorder];
    chk_CodeFormatter.StyleElements := [seFont, seBorder];
    chk_Rtl.StyleElements := [seFont, seBorder];
    chk_AnimatedLetters.StyleElements := [seFont, seBorder];

    tsPreDefinedQuestions.StyleElements := [seFont, seBorder, seClient];
    pnlPredefinedQ.StyleElements := [seFont, seBorder];
  end;
end;

procedure TFrm_AI_Setting.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Ord(Key) = 27 then
    Close;
end;

procedure TFrm_AI_Setting.FormShow(Sender: TObject);
var
  LvSetting: TSingletonSettingObj;
begin
  LvSetting := TSingletonSettingObj.Instance;
  with Frm_Setting do
  begin
    Edt_ApiKey.Text := LvSetting.ApiKey;
    Edt_Url.Text := LvSetting.URL;
    Edt_MaxToken.Text := LvSetting.MaxToken.ToString;
    Edt_Temperature.Text := LvSetting.Temperature.ToString;
    cbbModel.ItemIndex := Frm_Setting.cbbModel.Items.IndexOf(LvSetting.Model);
    Edt_SourceIdentifier.Text := LvSetting.Identifier;
    chk_CodeFormatter.Checked := LvSetting.CodeFormatter;
    chk_Rtl.Checked := LvSetting.RighToLeft;
    chk_History.Checked := LvSetting.HistoryEnabled;
    lbEdt_History.Text := LvSetting.HistoryPath;
    lbEdt_History.Enabled := LvSetting.HistoryEnabled;
    Btn_HistoryPathBuilder.Enabled := LvSetting.HistoryEnabled;
    ColorBox_Highlight.Selected := LvSetting.HighlightColor;
    chk_AnimatedLetters.Checked := LvSetting.AnimatedLetters;
    lbEdt_Timeout.Text := LvSetting.TimeOut.ToString;

    chk_Offline.Checked := LvSetting.IsOffline;
    cbbModel.Enabled := not LvSetting.IsOffline;
    edt_MaxToken.Enabled := not LvSetting.IsOffline;
    edt_OfflineModel.Enabled := LvSetting.IsOffline;
    if LvSetting.IsOffline then
      edt_OfflineModel.Text := LvSetting.Model;

    AddAllDefinedQuestions;
  end;
end;

procedure TFrm_AI_Setting.pgcSettingChange(Sender: TObject);
begin
  Btn_Default.Visible := pgcSetting.ActivePage = tsMainSetting;
end;

procedure TFrm_AI_Setting.AddAllDefinedQuestions;
var
  LvKey: Integer;
  LvTempSortingArray : TArray<Integer>;
begin
  ClearGridPanel;

  LvTempSortingArray := TSingletonSettingObj.Instance.PredefinedQuestions.Keys.ToArray; // TObjectDictionary is not sorted!
  TArray.Sort<Integer>(LvTempSortingArray);

  for LvKey in LvTempSortingArray do
    AddQuestion(TSingletonSettingObj.Instance.PredefinedQuestions.Items[LvKey]);
end;

procedure TFrm_AI_Setting.AddQuestion(AQuestionpair: TQuestionPair);
var
  LvPanel: Tpanel;
  LvLabeledEditCaption: TLabeledEdit;
  I, LvCounter: Integer;
  LvH: Integer;
begin
  LvH := 0;
  LvCounter := 0;
  with GridPanelPredefinedQs do
  begin
    for I := 0 to Pred(RowCollection.Count + 1) do
      LvH := LvH + 80;

    Height := LvH;
    with RowCollection.Add do
    begin
      SizeStyle := ssAbsolute;
      Value := 80;
    end;
  end;

  LvCounter := GridPanelPredefinedQs.RowCollection.Count;
  LvPanel := TPanel.Create(Self);
  LvPanel.Caption := '';
  LvPanel.Parent := GridPanelPredefinedQs;
  LvPanel.Align := alClient;

  with LvPanel do
  begin
    Name := 'panel' + LvCounter.ToString;
    LvLabeledEditCaption := TLabeledEdit.Create(LvPanel);
    with LvLabeledEditCaption do
    begin
      Name := 'CustomLbl' + LvCounter.ToString;
      Parent := LvPanel;
      AlignWithMargins := True;
      Margins.Left := 55;
      Align := alTop;
      EditLabel.Caption := 'Caption';
      EditLabel.Transparent := True;
      LabelPosition := lpLeft;
      LabelSpacing := 4;
      if Assigned(AQuestionpair) then
        Text := AQuestionpair.Caption
      else
        Text := '';
    end;

    with TMemo.Create(LvPanel) do
    begin
      Name := 'CustomLblQ' + LvCounter.ToString;
      Parent := LvPanel;
      AlignWithMargins := True;
      Margins.Left := 55;
      Align := alClient;
      WordWrap := True;
      if Assigned(AQuestionpair) then
        Lines.Text := AQuestionpair.Question
      else
        Lines.Text := '';
      ScrollBars := ssVertical;
    end;

    with TLabel.Create(LvPanel) do
    begin
      Parent := LvPanel;
      Caption := 'Question';
      Left := 5;
      Top := 57;
    end;
  end;
end;

procedure TFrm_AI_Setting.RemoveLatestQuestion;
begin
  if GridPanelPredefinedQs.RowCollection.Count > 0 then
  begin
    with GridPanelPredefinedQs do
    begin
      FindChildControl('panel' + GridPanelPredefinedQs.RowCollection.Count.ToString).Free;
      RowCollection.Items[Pred(GridPanelPredefinedQs.RowCollection.Count)].Free;
    end;
  end;
end;

function TFrm_AI_Setting.ValidateInputs: Boolean;
var
  LvStr: string;
begin
  Result := False;
  if chk_History.Checked then
  begin
    if Trim(lbEdt_History.Text).IsEmpty then
    begin
      ShowMessage('Please indicate the history folder path.');
      Exit;
    end;
  end;

  if chk_Offline.Checked then
  begin
    if Trim(edt_OfflineModel.Text).IsEmpty then
    begin
      ShowMessage('Please enter the Offline model name.');
      Exit;
    end;
  end
  else if (cbbModel.ItemIndex = -1) or (Trim(cbbModel.Text).Equals(EmptyStr)) then
  begin
    ShowMessage('Please Select the model name.');
    if cbbModel.CanFocus then
      cbbModel.SetFocus;

    Exit;
  end;

  LvStr := edt_Url.Text;
  if (not chk_Offline.Checked) and (LvStr.Contains('localhost')) or (LvStr.Contains('127.0.0.1')) then
  begin
    if MessageDlg('It seems you are using offline server with an online model, it doesn''t work probably, do you want to save anyway?', mtWarning, [mbYes,mbNo], 0) = mrNo then
      Exit;
  end;

  Result := True;
end;

{ TQuestionPair }

constructor TQuestionPair.Create(ACaption, AQuestion: string);
begin
  FCaption := ACaption;
  FQuestion := AQuestion;
end;

initialization
  Cs := TCriticalSection.Create;

finalization
  Cs.Free;
  UnregisterSelf;
end.