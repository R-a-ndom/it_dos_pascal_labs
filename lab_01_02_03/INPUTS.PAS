{
  функции для ввода :
  - строки,
  - целого числа
  - дробного числа
  - одной буквы

  ( Лабораторные работы 1, 2 и 3 )
}

Unit Inputs;

INTERFACE

USES
  CRT, DOS;

CONST

WrongInputWarning      = 'НЕКОРРЕКТНЫЙ ВВОД !';
WrongEmptyFieldWarning = 'ВВОДИТСЯ ПУСТОЕ ПОЛЕ !';

procedure ConsoleCursorOff;
procedure ConsoleCursorOn;

procedure ClearBottomLine;
procedure ClearInputArea(BeginX, BeginY, AreaLen : Integer);
procedure WriteErrorMessage(WarningMsg : String);
procedure WriteContinuePrompt;
procedure ClearRect(BeginX, BeginY, EndX, EndY: Integer);

function InputString(BeginX, BeginY, StrLength: Integer): String;
function InputNumInt(BeginX, BeginY, StrLength: Integer;
         var Result : LongInt):Integer;
function InputNumReal(BeginX, BeginY, StrLength: Integer;
         NegativeEnable : Boolean; var Result : Real):Integer;
function InputOneLetter(BeginX, BeginY : Integer) : Char;

IMPLEMENTATION

CONST
  MaxStrLength = 50;
  MaxNumLength = 20;

  ErrorMsgBeginX = 10;
  ErrorMsgBeginY = 25;
  ContinueMsgBeginX = 20;

procedure ConsoleCursorOff;
var
  Reg : Registers;
begin
  Reg.AH :=  1;
  Reg.CX := $2607;
  Intr($10, Reg);
end;

procedure ConsoleCursorOn;
var
  Reg : Registers;
begin
  Reg.AH := 1;
  Reg.CX := $0607;
  Intr($10, Reg);
end;

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

procedure ClearRect(BeginX, BeginY, EndX, EndY: Integer);
var
  CurrentX, CurrentY : Integer;
begin
  CurrentY := BeginY;
  while CurrentY <= EndY do
  begin
    CurrentX := BeginX;
    GotoXY(CurrentX,CurrentY);
    while (CurrentX <= EndX) do
    begin
      Write(#32);
      inc(CurrentX);
    end;
    inc(CurrentY);
  end;
end;

Procedure WriteErrorMessage(WarningMsg : String);
var
  sym : Char;
begin
  sym := #0;
  Write(#7);
  GotoXY(ErrorMsgBeginX,ErrorMsgBeginY );
  Write(WarningMsg,' Нажмите любую клавишу...');
  repeat
    sym := ReadKey
  until sym <> #0;
  ClearBottomLine;
end;

procedure WriteContinuePrompt;
var
  sym : Char;
begin
  sym := #0;
  GotoXY(ContinueMsgBeginX,ErrorMsgBeginY );
  Write('Для продолжения нажмите любую клавишу...');
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
      'А'..'Я', 'а'..'я', '0'..'9', '-','"','''',' ': { ввод символа }
      if ( CursorPos < StrLength+1 )
         and ( CurrentLength < StrLength ) then
      begin
        Insert(sym, StrTmp, CursorPos);
        inc(CurrentLength);
        inc(CursorPos);
        if ( CursorPos = CurrentLength+1 ) then { если курсор в конце строки}
        begin
          Write(sym);
        end
        else                                { если курсор в середине }
              { если строка уже не заполнена }
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
      #75:        { стрелка ВЛЕВО  <-- }
      if ( CursorPos > 1 ) then
      begin
        dec(CursorScrX);
        dec(CursorPos);
        GotoXY(CursorScrX, BeginY);
      end;
      #77:        { стрелка ВПРАВО --> }
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
      '0'..'9': { ввод символа }
      if ( CursorPos < StrLength+1 ) then
      begin
        Insert(sym, StrTmp, CursorPos);
        inc(CurrentLength);
        inc(CursorPos);
        if ( CursorPos = CurrentLength+1 ) then { если курсор в конце строки}
        begin
          Write(sym);
        end
        else                                  { если курсор в середине }
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
      #75:        { стрелка ВЛЕВО  <-- }
      if ( CursorPos > 1 ) then
      begin
        dec(CursorScrX);
        dec(CursorPos);
        GotoXY(CursorScrX, BeginY);
      end;
      #77:        { стрелка ВПРАВО --> }
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
      if ( NegativeEnable and ( CursorPos = 1 )) then
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
      '0'..'9': { ввод символа }
      if ( CursorPos < StrLength+1 ) then
      begin
        Insert(sym, StrTmp, CursorPos);
        inc(CurrentLength);
        inc(CursorPos);
        if ( CursorPos = CurrentLength+1 ) then { если курсор в конце строки}
        begin
          Write(sym);
        end
        else                                  { если курсор в середине }
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
      #75:        { стрелка ВЛЕВО  <-- }
      if ( CursorPos > 1 ) then
      begin
        dec(CursorScrX);
        dec(CursorPos);
        GotoXY(CursorScrX, BeginY);
      end;
      #77:        { стрелка ВПРАВО --> }
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

function InputOneLetter(BeginX, BeginY : Integer) : Char;
var
  sym : Char;
  tmpLetter : Char;
  LetterInputed : boolean;
begin
  LetterInputed := false;
  GotoXY(BeginX, BeginY);
  repeat
    sym := ReadKey;
    case sym of
      'A'..'Z','a'..'z' :     { ввод буквы }
      if not LetterInputed then
      begin
        Write(sym);
        tmpLetter := sym;
        LetterInputed := true;
      end;

      #8:   { клавиша BACKSPACE }
      if LetterInputed then
      begin
        GotoXY(BeginX, BeginY);
        Write(#32);
        GotoXY(BeginX, BeginY);
        LetterInputed := false;
      end;
    end;  { case }
  until (sym = #13) and (LetterInputed = true);
  InputOneLetter := tmpLetter;
end;



END.