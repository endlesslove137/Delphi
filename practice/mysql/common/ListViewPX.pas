unit ListViewPX;

interface 

uses CommCtrl,ComCtrls; 

procedure LVPX(ListView:TListView;Column:TListColumn);

implementation 
var 
LastCompare:integer; 

function IsBig(First,Second: string):Boolean;
begin 
  Result := False; 
  if First='' then Result := False 
  else if Second = '' then 
      Result := True 
  else Result := First > Second; 
end;

function Compare1(Item1,Item2,FIndex:Integer):Integer;stdcall; 
var 
ListItem1,ListItem2: TListItem; 
S1, S2: string; 
begin 
ListItem1 := TListItem(Item1); 
ListItem2 := TListItem(Item2); 
case FIndex of 
    0: 
      begin 
        S1 := ListItem1.Caption; 
        S2 := ListItem2.Caption; 

        if IsBig(S1,S2) then Result := 1
        else 
          if IsBig(S2,S1) then Result := -1 
          else Result := 0; 
      end; 
  else 
    begin 
      if FIndex > ListItem1.SubItems.Count then 
      begin 
        if FIndex > ListItem2.SubItems.Count then 
          Result := 0 
        else 
          Result := -1; 
      end 
      else 
        if FIndex > ListItem2.SubItems.Count then 
          Result := 1 
        else 
        begin 
          S1 := ListItem1.SubItems[FIndex - 1]; 
          S2 := ListItem2.SubItems[FIndex - 1]; 
          if IsBig(S1,S2) then 
            Result := 1 
          else 
            if IsBig(S2,S1) then 
              Result := -1 
            else 
              Result := 0; 
        end; 
    end; 
  end; 
end; 

function Compare2(Item1,Item2,FIndex:Integer):Integer;stdcall; 
begin 
Result := -Compare1(Item1,Item2,FIndex); 
end; 

procedure LVPX(ListView:TListView;Column:TListColumn); 
begin 
if LastCompare = Column.Index then 
  begin 
    LastCompare := -1; 
    ListView.CustomSort(TLVCompare(@Compare2),Column.Index); 
  end 
else 
  begin 
    LastCompare := Column.Index; 
    ListView.CustomSort(TLVCompare(@Compare1),Column.Index); 
  end; 
end; 

end.
