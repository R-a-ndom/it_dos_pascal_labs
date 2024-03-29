Program Lab2;

Uses
  CRT;
Const
  WrongInputWarning      = '������������ ���� !';
  WrongEmptyFieldWarning = '�������� ������ ���� !';

  MaxStrLength = 50;
  MaxNumLength = 20;

  ErrorMsgBeginX = 10;
  ErrorMsgBeginY = 25;
  ContinueMsgBeginX = 20;


  GoodsNameMaxLength = 35;
  GoodsQuantityInputLength = 10;

  TitleBeginX = 35;
  TitleBeginY =  1;

  EndBeginX = 22;
  EndBeginY = 25;

  ResultBeginX =  5;
  ResultBeginY = 15;

  CaptionBeginX =  5;
  InputBeginX   = 25;

  GoodsNameBeginY     = 6;
  GoodsQuantityBeginY = 7;

Procedure ClearBottomLine;
var
  i:Integer;
begin
  i := 1;
  GotoXY(i, 25);
  for i := 1 to 79 do
    Write(' ');
end;

procedure ClearInputArea(BeginX, BeginY, AreaLen : Integer);
var
  i : Integer;
begin
  GotoXY(BeginX, BeginY);
  for i := 0 to AreaLen do
    Write(#32);
end;

Procedure WriteErrorMessage(WarningMsg : String);
var
  sym : Char;
begin
  sym := #0;
  Write(#7);
  GotoXY(ErrorMsgBeginX,ErrorMsgBeginY );
  Write(WarningMsg,' ������ ���� �������...');
  repeat
    sym := ReadKey
  until sym <> #0;
  ClearBottomLine;
end;

function InputString(BeginX, BeginY, StrLength: Integer): String;
var
  StrTmp:String[MaxStrLength];
  sym:Char;
  CursorPos, CursorScrX, CurrentLength: Integer;
begin
  StrTmp := Copy(StrTmp, 0, 0);
  GotoXY(BeginX, BeginY);
  CursorPos := 1;
  CurrentLength := 0;
  CursorScrX := BeginX;
  GotoXY(CursorScrX, BeginY);
  repeat
    sym := ReadKey;
    case sym of
      '�'..'�', '�'..'�', '0'..'9', '-','"','''',' ': { ���� ᨬ���� }
      if ( CursorPos < StrLength+1 )
         and ( CurrentLength < StrLength ) then
      begin
        Insert(sym, StrTmp, CursorPos);
        inc(CurrentLength);
        inc(CursorPos);
        if ( CursorPos = CurrentLength+1 ) then { �᫨ ����� � ���� ��ப�}
        begin
          Write(sym);
        end
        else                                { �᫨ ����� � �।��� }
              { �᫨ ��ப� 㦥 �� ��������� }
        begin
          GotoXY(BeginX, BeginY);
          Write(StrTmp);
          GotoXY(CursorScrX, BeginY);
        end;
        inc(CursorScrX);
      end;
      #8:          { BACKSPACE }
      if ( CursorPos > 1 ) then
      begin
        Delete(StrTmp, CursorPos-1, 1);
        dec(CursorPos);
        dec(CurrentLength);
        dec(CursorScrX);
        GotoXY(BeginX, BeginY);
        Write(StrTmp, #32);
        GotoXY(CursorScrX, BeginY);
      end;
      #75:        { ��५�� �����  <-- }
      if ( CursorPos > 1 ) then
      begin
        dec(CursorScrX);
        dec(CursorPos);
        GotoXY(CursorScrX, BeginY);
      end;
      #77:        { ��५�� ������ --> }
      if ( CursorPos < CurrentLength+1 ) then
      begin
        inc(CursorScrX);
        inc(CursorPos);
        GotoXY(CursorScrX, BeginY);
      end;
      #83:          { DELETE }
      if ( CursorPos < CurrentLength+1 ) then
      begin
        Delete(StrTmp, CursorPos, 1);
        dec(CurrentLength);
        GotoXY(BeginX, BeginY);
        Write(StrTmp, #32);
        GotoXY(CursorScrX, BeginY);
      end;
    end;
  until sym = #13;
  StrTmp := Copy(StrTmp, 0, CurrentLength);
  InputString := StrTmp;
end;

function InputNumInt(BeginX, BeginY, StrLength: Integer;
                     var Result:LongInt):Integer;
var
  ErrorCode: Integer;
  StrTmp: String[MaxNumLength];
  sym:Char;
  CursorPos, CursorScrX, CurrentLength: Integer;
begin
  StrTmp := Copy(StrTmp, 0, 0);
  CursorPos := 1;
  CurrentLength := 0;
  CursorScrX := BeginX;
  GotoXY(BeginX, BeginY);
  repeat
    sym := ReadKey;
    case sym of
      '0'..'9': { ���� ᨬ���� }
      if ( CursorPos < StrLength+1 ) then
      begin
        Insert(sym, StrTmp, CursorPos);
        inc(CurrentLength);
        inc(CursorPos);
        if ( CursorPos = CurrentLength+1 ) then { �᫨ ����� � ���� ��ப�}
        begin
          Write(sym);
        end
        else                                  { �᫨ ����� � �।��� }
        begin
          GotoXY(BeginX, BeginY);
          Write(StrTmp);
          GotoXY(CursorScrX, BeginY);
        end;
        inc(CursorScrX);
      end;
      #8:          { BACKSPACE }
      if ( CursorPos > 1 ) then
      begin
        Delete(StrTmp, CursorPos-1, 1);
        dec(CursorPos);
        dec(CurrentLength);
        dec(CursorScrX);
        GotoXY(BeginX, BeginY);
        Write(StrTmp, #32);
        GotoXY(CursorScrX, BeginY);
      end;
      #75:        { ��५�� �����  <-- }
      if ( CursorPos > 1 ) then
      begin
        dec(CursorScrX);
        dec(CursorPos);
        GotoXY(CursorScrX, BeginY);
      end;
      #77:        { ��५�� ������ --> }
      if ( CursorPos < CurrentLength+1 ) then
      begin
        inc(CursorScrX);
        inc(CursorPos);
        GotoXY(CursorScrX, BeginY);
      end;
      #83:          { DELETE }
      if ( CursorPos < CurrentLength+1 ) then
      begin
        Delete(StrTmp, CursorPos, 1);
        dec(CurrentLength);
        GotoXY(BeginX, BeginY);
        Write(StrTmp, #32);
        GotoXY(CursorScrX, BeginY);
      end;
    end;
  until sym = #13;
  StrTmp := Copy(StrTmp, 0, CurrentLength);
  Val(StrTmp, Result, ErrorCode);
  InputNumInt := ErrorCode;
end;
var
  GoodsName     : String[GoodsNameMaxLength];

  GoodsQuantity     : LongInt;
  IntegerInputError : Integer;

BEGIN
  ClrScr;
  GotoXY(TitleBeginX, TitleBeginY);
  Write('�����');

  GotoXY(CaptionBeginX, GoodsNameBeginY);
  WriteLn('������������ : ');
  GoodsName := InputString(InputBeginX,
                            GoodsNameBeginY,
                            GoodsNameMaxLength);

  GotoXY(CaptionBeginX, GoodsQuantityBeginY);
  WriteLn('  ������⢮�: ');
  repeat
    IntegerInputError := InputNumInt(InputBeginX,
                                     GoodsQuantityBeginY,
                                     GoodsQuantityInputLength,
                                     GoodsQuantity);
    if ( IntegerInputError <> 0 ) then
    begin
      WriteErrorMessage(WrongInputWarning);
    end;
  until IntegerInputError = 0;
  GotoXY(ResultBeginX, ResultBeginY);
  WriteLn('������ �����: ',GoodsName,
           #32, GoodsQuantity, ' ������');

  GotoXY(EndBeginX, EndBeginY);
  Write('��� �����襭�� �ணࠬ�� ������ ENTER');

  repeat
  until KeyPressed;
END.