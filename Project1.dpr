program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils;

type
    pItem = ^TItem;
    TItem=record
        value: char;
        next: pItem;
    end;

procedure Push(var pHead : pItem; chr : char);
var
  i : Integer;
  pTemp : pItem;
begin
  New(pTemp);
  pTemp^.next :=  pHead;
  pTemp^.value := chr;
  pHead := pTemp;
end;

function Pop(var pHead : pItem) : char;
var
  pTemp : pItem;
  tempChr : Char;
begin
  pTemp := pHead;
  tempChr := pHead^.value;
  pHead := pHead^.next;

  //FreeAndNil(pTemp);
  Pop := tempChr
end;

function Get(pHead : pItem): char;
begin
  Get := pHead^.value;
end;


function GetPriority(chr : char) : integer;
var
  priority : integer;
begin
  case chr of
      '+', '-' :   priority := 1;
      '*', '/' :   priority := 3;
      '^'      :   priority := 6;
      'a'..'z', 'A'..'Z': priority := 7;
      '('      :   priority := 9;
      ')'      :   priority := 0;
      '$'      :   priority := -1;
  end;
  GetPriority := priority;
end;

function GetPriorityStack(chr : char) : integer;
var
  priority : integer;
begin
  case chr of
      '+', '-' :   priority := 2;
      '*', '/' :   priority := 4;
      '^'      :   priority := 5;
      'a'..'z', 'A'..'Z': priority := 8;
      '('      :   priority := 0;
      '$'      :   priority := -1;
  end;
  GetPriorityStack := priority;
end;

procedure ShowList(pHead: pItem);
begin
    while (pHead^.next <> nil) do
    begin
        Write(pHead^.value);
        WriteLn(GetPriority(pHead^.value));
        pHead := pHead^.next;
    end;
end;



var
  n, i, j, numOfOperators, numOfOperands : Integer;
  chr : char;
  pHead: pItem;
  st : string;
  chrArr : array of char;

begin
   New(pHead);
   pHead^.value := '$';
   pHead^.next := nil;

   j:= 0;

   ReadLn(st);

   SetLength(chrArr,st.Length);
   for i := 1 to st.Length do
   begin
       if(GetPriorityStack(Get(pHead)) < GetPriority(st[i])) then
       begin
           Push(pHead, st[i]);
       end
       else
       begin
           if (st[i] = ')') then
           begin
               while( GetPriorityStack(Get(pHead)) <> 0) do
               begin
                  chrArr[j] := Pop(pHead);
                  inc(j);
               end;
               Pop(pHead);
           end
           else
           begin
               while (GetPriorityStack(Get(pHead)) >= GetPriority(st[i])) and (Get(pHead) <> '(') do
               begin
                  chrArr[j] := Pop(pHead);
                  inc(j);
               end;
               Push(pHead, st[i]);
           end;
       end;

   end;

   while (Get(pHead) <> '$') do
   begin
      chrArr[j] := Pop(pHead);
      inc(j);
   end;

   for i := 0 to st.Length - 1 do
      write(chrArr[i]);

   for i := 0 to st.Length - 1 do
      case chrArr[i] of
        'a'..'z','A'..'Z' :  inc(numOfOperands);
        '+','-','*','/','^' : inc(numOfOperators);
      end;

   Writeln('');
   Write('Rang:  ');
   Writeln(numOfOperands - numOfOperators);

   readln;

end.
