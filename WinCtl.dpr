// ��󻯡���С�����ָ����رա������ƽ�̡����ء����֡�ֻ��ָ������
// WinCtl.exe ����1 ����2
// ����1 = (Max | Min | Restore | Close | Move | Top | UnTop | Hide | UnHide |
//          Alpha | UnAlpha | HideTitle | UnHideTitle | Round | UnRound |
//          MinAll |UnMinAll | Cas | TH | TV | ShowOnly | GetHandle | GetCaption | GetClass)
// ����2 = [ddd | Handle(=|!=|~|!~)ddd | Caption(=|!=|~|!~)"xxx" | Class(=|!=|~|!~)"xxx" | ALL]

// ����1
// -----------
// Max (���)
// Min (��С��)
// Restore (�ָ�)
// Close (�رմ���)
// Move (�ƶ�����)
// Top (�����ö�)
// UnTop (����ȡ���ö�)
// Hide (��������)
// UnHide (����ָ�)
// Alpha (�����͸����͸����)
// UnAlpha (����ȡ����͸��)
// HideTitle (���ر���)
// UnHideTitle (�ָ�����)
// Round (Բ�Ǵ��壬Բ�ǰ뾶)
// UnRound (ȡ��Բ�Ǵ���)
// MinAll (��ʾ����)
// UnMinAll (�ָ�����)
// Cas (������)
// TH (�������ƽ��)
// TV (��������ƽ��)
// ShowOnly (����ʾָ�����壬������С��)
// GetHandle (ȡ�õ�ǰ�����������������)
// GetCaption (ȡ�õ�ǰ������⣬���������)
// GetClass (ȡ�õ�ǰ�������������������)



// ����2
// -----------
// = ����
// != ������
// ~ ������ʽƥ��
//     �� "���±�" ����ƥ�� "�ޱ���-���±�"
//     �� "a.*b" ����ƥ�� "aqecbd", ".*" ������������������ַ�
// !~ ������ʽ��ƥ��
// ddd ��ʾ����
// xxx ��ʾ�ַ�

program WinCtl;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  untWinController in 'Unit\untWinController.pas',
  untOption in 'Unit\untOption.pas',
  untUtility in 'Unit\untUtility.pas',
  untClipboard in 'Unit\untClipboard.pas',
  untLogger in 'Unit\untLogger.pas';

{$R *.res}

var
  WinController: TWinController;
  i: Cardinal;

procedure ShowUsage;
begin
  Writeln('');
  Writeln('');
  Writeln('NAME');
  Writeln('  WinCtl - Contrl Window to ');
  Writeln('           Max/Min/Tile/Hide/UnHide/Top/UnTop/ShowOnly/');
  Writeln('           GetCaption/GetClass');
  Writeln('');
  Writeln('');
  Writeln('VERSION');
  Writeln('  V' + VERSION);
  Writeln('');
  Writeln('');
  Writeln('USAGE');
  Writeln('  Max Window:');
  Writeln('    WinCtl.exe Max ddd');
  Writeln('    WinCtl.exe Max Handle=ddd      // Handle of Window is ddd');
  Writeln('    WinCtl.exe Max Handle!=ddd     // Handle of Window is not ddd');
  Writeln('    WinCtl.exe Max Handle~ddd      // Handle of Window is ddd (Regex Mode)');
  Writeln('    WinCtl.exe Max Handle!~ddd     // Handle of Window is not ddd (Regex Mode)');
  Writeln('    WinCtl.exe Max Caption="xxx"   // Caption of Window is xxx');
  Writeln('    WinCtl.exe Max Caption!="xxx"  // Caption of Window is not xxx');
  Writeln('    WinCtl.exe Max Caption~"xxx"   // Caption of Window is xxx (Regex Mode)');
  Writeln('    WinCtl.exe Max Caption!~"xxx"  // Caption of Window is not xxx (Regex Mode)');
  Writeln('    WinCtl.exe Max Class="xxx"     // Class of Window is xxx');
  Writeln('    WinCtl.exe Max Class!="xxx"    // Class of Window is not xxx');
  Writeln('    WinCtl.exe Max Class~"xxx"     // Class of Window is xxx (Regex Mode)');
  Writeln('    WinCtl.exe Max Class!~"xxx"    // Class of Window is not xxx (Regex Mode)');
  Writeln('    WinCtl.exe Max ALL             // All Windows in Taskbar');
  Writeln('');
  Writeln('  Min Window:');
  Writeln('    (Similar to "Max")');
  Writeln('');
  Writeln('  Restore Window:');
  Writeln('    (Similar to "Max")');
  Writeln('');
  Writeln('  Show the Only Window:');
  Writeln('    (Similar to "Max")');
  Writeln('');
  Writeln('  Close Window:');
  Writeln('    (Similar to "Max")');
  Writeln('    WinCtl.exe Move 12321 [LEFT|RIGHT|UP|DOWN|left, top, width, height]');
  Writeln('');

  // winctl.exe Move 657202 Left             // ����
  // winctl.exe Move 657202 Right            // �Ұ��
  // winctl.exe Move 657202 Top              // �ϰ��
  // winctl.exe Move 657202 Bottom           // �°��
  // winctl.exe Move 657202 Left+Top         // ���� 1/4
  // winctl.exe Move 657202 Left+Bottom      // ���� 1/4
  // winctl.exe Move 657202 Right+Top        // ���� 1/4
  // winctl.exe Move 657202 Right+Bottom     // ���� 1/4
  // winctl.exe Move 657202 100,200,300,400  // ��(����)����(����)����(����)����(����)
  // winctl.exe Move 657202 0.2,0.3,0.4,0.5  // ��(����),��(����)����(����)����(����)
  // winctl.exe Move 657202 100,200,0.5,0.5  // ��(����),��(����)����(����)����(����)
  Writeln('  Move Window:');
  Writeln('    (Similar to "Max")');
  Writeln('');
  Writeln('  Hide Window:');
  Writeln('    (Similar to "Max")');
  Writeln('');
  Writeln('  UnHide Window:');
  Writeln('    (Similar to "Max")');
  Writeln('    WinCtl.exe UnHide              // UnHide the latest hided window');
  Writeln('');
  Writeln('  Alpha Window:');
  Writeln('    (Similar to "Max"), and add one param: Alpha(From 0 to 255)');
  Writeln('    WinCtl.exe Alpha 12321 150     // Alpha = 150 for the specific window');
  Writeln('');
  Writeln('  UnAlpha Window:');
  Writeln('    (Similar to "Max")');
  Writeln('    WinCtl.exe UnAlpha             // UnAlpha the latest Alpha window');
  Writeln('');
//  Writeln('  RoundRect Window:');
//  Writeln('    (Similar to "Max"), and add one param: RoundBorderRadius(Greater than 0)');
//  Writeln('    WinCtl.exe Round 12321 15      // RoundBorderRadius = 15 for the specific window');
//  Writeln('');
//  Writeln('  UnRoundRect Window:');
//  Writeln('    (Similar to "Max")');
//  Writeln('    WinCtl.exe UnRound             // UnRound the latest Rounded window');
//  Writeln('');
  Writeln('  Top Window:');
  Writeln('    (Similar to "Max")');
  Writeln('');
  Writeln('  UnTop Window:');
  Writeln('    (Similar to "Max")');
  Writeln('    WinCtl.exe UnTop               // UnTop the latest hided window');
  Writeln('');
  Writeln('  Min All Window:');
  Writeln('    WinCtl.exe MinAll');
  Writeln('');
  Writeln('  Undo Min All Window:');
  Writeln('    WinCtl.exe UnMinAll');
  Writeln('');
  Writeln('  Cascade Windows:');
  Writeln('    WinCtl.exe Cas');
  Writeln('');
  Writeln('  Tile Horizontally Windows:');
  Writeln('    WinCtl.exe TH');
  Writeln('');
  Writeln('  Tile Vertically Windows:');
  Writeln('    WinCtl.exe TV');
  Writeln('');
  Writeln('  Get Caption of the Window:');
  Writeln('    WinCtl.exe GetCaption ddd');
  Writeln('');
  Writeln('  Get ClassName of the Window:');
  Writeln('    WinCtl.exe GetClass ddd');
  Writeln('');
  Writeln('');
  Writeln('DESCRIPTION');
  Writeln('  Regex Mode');
  Writeln('    Regular Expression Mode');
  Writeln('');
  Writeln('');
  Writeln('AUTHOR');
  Writeln('  ET Worker - JourneyBoy@GMail.com');
end;

begin
  InitLogger(False, False, False);

  WinController := TWinController.Create;

  WinController.GetForegroundWindowHandle;

  //WinController.Test; Exit;

  // ���û�в���������ʾʹ�÷���
  if ParamCount = 0 then
  begin
    ShowUsage;
    Exit;
  end;

  // ��1������������
  if ParamCount >= 1 then
    if not WinController.ReadWinCmdList(ParamStr(1)) then
    begin
      ShowUsage;
      Exit;
    end;

  // ��3����������������
  // ��Ϊ��ȡ��2������ʱ����Ҫʹ�õ���3�������������ȶ���3������
  if ParamCount >= 3 then
    WinController.Param3 := ParamStr(3);

  // ��2�������Ǵ������
  if ParamCount >= 2 then
    if Length(WinController.WinCmdList) > 0 then
      for i := 0 to High(WinController.WinCmdList) do        
      begin
        if not WinController.ReadWinParam(WinController.WinCmdList[i], ParamStr(2)) then
        begin
          ShowUsage;
          Exit;
        end;
      end;

  WinController.HandleCmdList;

  WinController.Free;
end.
