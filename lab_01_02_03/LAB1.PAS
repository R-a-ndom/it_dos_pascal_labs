Program Lab1;

Uses
  CRT;

Const
  MaxStrLength = 50;
  MaxNumLength = 20;

  ErrorMsgBeginX = 10;
  ErrorMsgBeginY = 25;
  ContinueMsgBeginX = 20;
  
  NameLength     = 20;
  LastNameLength = 30;
  FamilyLength   = 25;

  TitleBeginX = 35;
  TitleBeginY =  1;

  EndBeginX = 22;
  EndBeginY = 25;

  ResultBeginX =  5;
  ResultBeginY = 15;

  CaptionBeginX =  5;
  InputBeginX   = 15;

  FamilyBeginY   = 6;
  NameBeginY     = 7;
  LastNameBeginY = 8;

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

var
  UserName : String[NameLength];
  UserLastname : String[LastnameLength];
  UserFamily : String[FamilyLength];
begin
  ClrScr;
  GotoXY(TitleBeginX, TitleBeginY);
  Write('ПОЛЬЗОВАТЕЛЬ');

  GotoXY(CaptionBeginX, FamilyBeginY);
  WriteLn('фамилия : ');
  UserFamily := InputString(InputBeginX, FamilyBeginY, FamilyLength);

  GotoXY(CaptionBeginX, NameBeginY);
  WriteLn('    имя : ');
  UserName := InputString(InputBeginX, NameBeginY, NameLength);

  GotoXY(CaptionBeginX, LastNameBeginY);
  WriteLn('отчество: ');
  UserLastName := InputString(InputBeginX, LastNameBeginY, LastNameLength);

  GotoXY(ResultBeginX, ResultBeginY);
  WriteLn('ВВЕДЕН ПОЛЬЗОВАТЕЛЬ: ',UserFamily,
           #32, UserName, #32, UserLastName);

  GotoXY(EndBeginX, EndBeginY);
  Write('Для завершения программы нажмите ENTER');

  repeat
  until KeyPressed;
end.