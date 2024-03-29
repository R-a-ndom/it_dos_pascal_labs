Program Lab3;

Uses
  CRT;
Const
  WrongInputWarning      = '  !';
  WrongEmptyFieldWarning = '   !';

  MaxStrLength = 50;
  MaxNumLength = 20;

  ErrorMsgBeginX = 10;
  ErrorMsgBeginY = 25;
  ContinueMsgBeginX = 20;

  NumberMaxLength = 10;

  TitleBeginX = 28;
  TitleBeginY =  1;

  MessageBeginX =  5;
  InputBeginX   = 10;
  InputPosX     = 15;

  InputBeginY       =  4;
  InputCoeffsBeginY =  6;
  InputArgBeginY    = 10;

  ResultBeginY  = 20;

  EndBeginX = 22;
  EndBeginY = 25;

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
  Write(WarningMsg,'  ¦¬¨â¥ «î¡ãî ª« ¢¨èã...');
  repeat
    sym := ReadKey
  until sym <> #0;
  ClearBottomLine;
end;

function InputNumReal(BeginX, BeginY, StrLength: Integer;
                     NegativeEnable : Boolean; var Result:Real):Integer;
var
  ErrorCode: Integer;
  StrTmp: String[MaxNumLength];
  sym, sym_test:Char;
  DotAlreadyInputed : Boolean;
  CursorPos, CursorScrX, CurrentLength: Integer;
  i : Integer;
begin
  StrTmp := Copy(StrTmp, 0, 0);
  CursorPos := 1;
  CurrentLength := 0;
  CursorScrX := BeginX;
  DotAlreadyInputed := false;
  GotoXY(BeginX, BeginY);
  repeat
    sym := ReadKey;
    case sym of
      '-':
      if ( NegativeEnable and  ( StrTmp[1] <> '-' ) and ( CursorPos = 1 ) ) then
        begin
          Insert(sym, StrTmp, CursorPos);
          inc(CurrentLength);
          inc(CursorPos);
          inc(CursorScrX);
          GotoXY(BeginX, BeginY);
          Write(StrTmp);
          GotoXY(CursorScrX, BeginY);
        end;
      '.',',':
      if not DotAlreadyInputed then
        begin
          Insert(sym, StrTmp, CursorPos);
          inc(CurrentLength);
          inc(CursorPos);
          inc(CursorScrX);
          GotoXY(BeginX, BeginY);
          Write(StrTmp);
          GotoXY(CursorScrX, BeginY);
          DotAlreadyInputed := true;
        end;
      '0'..'9': { ¢¢®¤ á¨¬¢®«  }
      if ( CursorPos < StrLength+1 ) then
      begin
        Insert(sym, StrTmp, CursorPos);
        inc(CurrentLength);
        inc(CursorPos);
        if ( CursorPos = CurrentLength+1 ) then { ¥á«¨ ªãàá®à ¢ ª®­æ¥ áâà®ª¨}
        begin
          Write(sym);
        end
        else                                  { ¥á«¨ ªãàá®à ¢ á¥à¥¤¨­¥ }
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
        sym_test := StrTmp[CursorPos-1];
        if ( sym_test = '.' ) or ( sym_test = ',' ) then
          DotAlreadyInputed := false;
        Delete(StrTmp, CursorPos-1, 1);
        dec(CursorPos);
        dec(CurrentLength);
        dec(CursorScrX);
        GotoXY(BeginX, BeginY);
        Write(StrTmp, #32);
        GotoXY(CursorScrX, BeginY);
      end;
      #75:        { áâà¥«ª    <-- }
      if ( CursorPos > 1 ) then
      begin
        dec(CursorScrX);
        dec(CursorPos);
        GotoXY(CursorScrX, BeginY);
      end;
      #77:        { áâà¥«ª   --> }
      if ( CursorPos < CurrentLength+1 ) then
      begin
        inc(CursorScrX);
        inc(CursorPos);
        GotoXY(CursorScrX, BeginY);
      end;
      #83:          { DELETE }
      if ( CursorPos < CurrentLength+1 ) then
      begin
        sym_test := StrTmp[CursorPos];
        if ( sym_test = '.' ) or ( sym_test = ',' ) then
          DotAlreadyInputed := false;
        Delete(StrTmp, CursorPos, 1);
        dec(CurrentLength);
        GotoXY(BeginX, BeginY);
        Write(StrTmp, #32);
        GotoXY(CursorScrX, BeginY);
      end;
    end;
  until sym = #13;
  StrTmp := Copy(StrTmp, 0, CurrentLength);
  for i:=1 to CurrentLength do
  begin
    if StrTmp[i] = ',' then
    begin
      StrTmp[i] := '.';
      break;
    end;
  end;
  Val(StrTmp, Result, ErrorCode);
  InputNumReal := ErrorCode;
end;

var
  RealInputError : Integer;
  num_x, num_y, num_k, num_b : Real;
  
BEGIN
  ClrScr;
  GotoXY(TitleBeginX, TitleBeginY);
  Write('  ');

  GotoXY(MessageBeginX, InputBeginY);
  WriteLn('y = kx + b');
  GotoXY(MessageBeginX, InputBeginY+1);
  WriteLn('¢¥¤¨â¥ §­ ç¥­¨¥ ª®íää¨æ¨¥­â®¢ÿ: ');
  GotoXY(InputBeginX, InputCoeffsBeginY);
  WriteLn('k = ');
  repeat
    RealInputError := InputNumReal(InputPosX,
                                   InputCoeffsBeginY,
                                   NumberMaxLength,
                                   true, num_k);
    if RealInputError <> 0 then
    begin
      WriteErrorMessage(WrongInputWarning);
      ClearInputArea(InputPosX, InputCoeffsBeginY, NumberMaxLength);
    end;
  until RealInputError = 0;
  GotoXY(InputBeginX, InputCoeffsBeginY+1);
  WriteLn('b = ');
  repeat
    RealInputError := InputNumReal(InputPosX,
                                   InputCoeffsBeginY + 1,
                                   NumberMaxLength,
                                   true, num_b);
    if RealInputError <> 0 then
    begin
      WriteErrorMessage(WrongInputWarning);
      ClearInputArea(InputPosX, InputCoeffsBeginY + 1, NumberMaxLength);
    end;
  until RealInputError = 0;

  GotoXY(MessageBeginX, InputArgBeginY);
  WriteLn('¢¥¤¨â¥ §­ ç¥­¨¥  à£ã¬¥­â  : ');
  GotoXY(InputBeginX, InputArgBeginY + 1);
  WriteLn('x = ');
  repeat
    RealInputError := InputNumReal(InputPosX,
                                   InputArgBeginY + 1,
                                   NumberMaxLength,
                                   true, num_x);
    if RealInputError <> 0 then
    begin
      WriteErrorMessage(WrongInputWarning);
      ClearInputArea(InputPosX, InputArgBeginY + 1, NumberMaxLength);
    end;
  until RealInputError = 0;

  GotoXY( MessageBeginX, ResultBeginY );
  WriteLn('­ ç¥­¨¥ äã­ªæ¨¨ : ');
  GotoXY( InputBeginX, ResultBeginY + 1);
  WriteLn('y = ', num_k * num_x + num_b : 7 : 4 );

  GotoXY(EndBeginX, EndBeginY);
  Write('«ï § ¢¥àè¥­¨ï ¯à®£à ¬¬ë ­ ¦¬¨â¥ ENTER');
  repeat
  until KeyPressed;
END.