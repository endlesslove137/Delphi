unit Upublic;

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,db,Controls,DBCtrls,Forms,
  Dialogs,ADODB,StdCtrls,DBGrids,udata,Buttons,WinSkinData,ComCtrls;    //
  procedure comboboxadditem(table: TADOTable;combobox: tcombobox;s:string);overload;
  procedure comboboxadditem(query: TADOquery;combobox: tcombobox;s:string);overload;
  procedure showform(InstanceClass: Tformclass;form:tform);
  procedure adoqueryopen(query:tadoquery;var s:string);
  procedure comboboxadditem(procedurename:string;combobox: tcombobox;theaddvalue:string);overload;
  procedure showdbgrid(dbgrid:tdbgrid;datasource:tdatasource;adoquery:tadotable;dbnavigator:tdbnavigator);
  procedure settemp(s:string);
  function issure:boolean;
  procedure deleteontable(table:tadotable);

  //将query中的s值给lable.text
  procedure setlabel(label1:tlabel;s:string;x:string);
  procedure setenable(component:tcomponent;i:integer);
  //根据procedurename参数paramname的值combobox.text打开procedure
  procedure setprocedure(procedurename:string;paramname:string;component:tcomponent;haveresult:boolean=true);overload;
  //将procedure中s的值给label1.text
  //
  function isnull(component:tcomponent):boolean;
  procedure restore(edit1:tedit;animate1:tanimate;command:tadocommand);
  procedure listboxadditem(listbox:tlistbox;query:TADOquery;field:string);
  procedure backup(edit1:tedit;animate1:tanimate;command:tadocommand);
  procedure  dynimic(self:tform;Sender: TObject);
  function isexit(self:tform;var Action: TCloseAction):boolean;
  procedure setfield(table:tadotable;s:string;component:tcomponent);
  function selectidbyname(sql:string;field:string):variant;
  procedure normalspace(dbgrid1:tdbgrid);
  procedure settextbytable(table:tadotable;field:string;component:tcomponent);
  procedure settextbyquery(query:tadoquery;field:string;component:tcomponent);
  procedure searchinquery(query:tadoquery;sql:string);
  procedure selectallinquery(query:tadoquery);
  procedure deleteonquery(query:tadoquery);
  procedure setprocedure(procedurename:string;paramname1,paramname2:string;component1,component2:tcomponent);overload;
  procedure setcheckbox(checkbox:tcheckbox;field:string);
  procedure setprocedure(procedurename:string;paramname1,paramname2:string;param1value,param2value:variant);overload;
  procedure candelete(component1:tcomponent);
  procedure chgskn(skindata1:tskindata;s:string);
  procedure setprocedure(procedurename:string);overload;

var
 date1,date2:tdatetime;
 user:string;
 department:string;
 isdelete:integer;
 oid:variant;
 isjlxx:boolean;//判断是否进行过审请详细的操作
implementation

procedure chgskn(skindata1:tskindata;s:string);
 var
 dir :string;
begin
 getdir(0,dir);
 dir:=dir+'\张明明\';
 dir:=dir+s+'.张明明';
 skindata1.LoadFromFile(dir);
 skindata1.Active:=true;
end;

procedure setprocedure(procedurename:string);overload;
begin
    fdata.procedure1.Close;
    fdata.procedure1.ProcedureName:=procedurename;
    fdata.procedure1.Parameters.Refresh;
    fdata.procedure1.Prepared;
    fdata.procedure1.open;
end;

procedure candelete(component1:tcomponent);
begin
 if not(department='管理员') then
  begin
    if (component1 is tedit) then tedit(component1).Enabled:=false else
    if (component1 is tcombobox) then tcombobox(component1).Enabled:=false  else
    if (component1 is tdatetimepicker) then tdatetimepicker(component1).Enabled:=false else
    if (component1 is tmemo) then tmemo(component1).Enabled:=false  else
    if (component1 is tlabel) then tlabel(component1).Enabled:=false  else
    if (component1 is tspeedbutton) then tspeedbutton(component1).Enabled:=false  else
    exit;
  end
 else
  begin
    if (component1 is tedit) then tedit(component1).Enabled:=true else
    if (component1 is tcombobox) then tcombobox(component1).Enabled:=true  else
    if (component1 is tdatetimepicker) then tdatetimepicker(component1).Enabled:=true else
    if (component1 is tmemo) then tmemo(component1).Enabled:=true  else
    if (component1 is tlabel) then tlabel(component1).Enabled:=true  else
    if (component1 is tspeedbutton) then tspeedbutton(component1).Enabled:=true  else
    exit;
  end;
end;

procedure setprocedure(procedurename:string;paramname1,paramname2:string;param1value,param2value:variant);overload;
begin
    fdata.procedure1.Close;
    fdata.procedure1.ProcedureName:=procedurename;
    fdata.procedure1.Parameters.Refresh;
    fdata.procedure1.Parameters.ParamValues[paramname1]:=param1value;
    fdata.procedure1.Parameters.ParamValues[paramname2]:=param2value;
    fdata.procedure1.Prepared;
    fdata.procedure1.open;
end;


procedure setcheckbox(checkbox:tcheckbox;field:string);
begin
 checkbox.Checked:=fdata.temp.FieldValues[field];
end;

procedure setprocedure(procedurename:string;paramname1,paramname2:string;component1,component2:tcomponent);overload;
var
 v1,v2:variant;
begin
    if (component1 is tedit) then v1:=tedit(component1).Text else
    if (component1 is tcombobox) then v1:=tcombobox(component1).text else
    if (component1 is tdatetimepicker) then v1:=tdatetimepicker(component1).Date else
    if (component1 is tmemo) then v1:=tmemo(component1).Text else
    if (component1 is tlabel) then v1:=tlabel(component1).Caption else
    exit;
    if (component2 is tedit) then v2:=tedit(component2).Text else
    if (component2 is tcombobox) then v2:=tcombobox(component2).text else
    if (component2 is tdatetimepicker) then v2:=tdatetimepicker(component2).Date else
    if (component2 is tmemo) then v2:=tmemo(component2).Text else
    if (component2 is tlabel) then v2:=tlabel(component2).Caption else
    exit;
    fdata.procedure1.Close;
    fdata.procedure1.ProcedureName:=procedurename;
    fdata.procedure1.Parameters.Refresh;
    fdata.procedure1.Parameters.ParamValues[paramname1]:=v1;
    fdata.procedure1.Parameters.ParamValues[paramname2]:=v2;
    fdata.procedure1.Prepared;
    fdata.procedure1.open;
end;

procedure deleteonquery(query:tadoquery);
begin
 if issure then query.Delete
 else exit;
end;

procedure selectallinquery(query:tadoquery);
var
 s:string;
begin
 s:='select * from '+query.Name;
 searchinquery(query,s);
end;

procedure searchinquery(query:tadoquery;sql:string);
begin
 query.Close;
 query.SQL.Clear;
 query.sql.Add(sql);
 query.Prepared;
 query.Open;
end;

procedure settextbytable(table:tadotable;field:string;component:tcomponent);
begin
 if not table.Eof or not table.bof then
 begin
    if (component is tedit) then tedit(component).Text:=table.FieldValues[field] else
    if (component is tcombobox) then tcombobox(component).text:=table.FieldValues[field] else
    if (component is tdatetimepicker) then tdatetimepicker(component).Date:=table.FieldValues[field] else
    if (component is tmemo) then tmemo(component).Text:=table.FieldValues[field] else
    if (component is tlabel) then tlabel(component).Caption:=table.FieldValues[field]
 end else
 exit;
end;

procedure settextbyquery(query:tadoquery;field:string;component:tcomponent);
begin
 if not query.Eof or not query.bof then
 begin
    if (component is tedit) then tedit(component).Text:=query.FieldValues[field] else
    if (component is tcombobox) then tcombobox(component).text:=query.FieldValues[field] else
    if (component is tdatetimepicker) then tdatetimepicker(component).Date:=query.FieldValues[field] else
    if (component is tmemo) then tmemo(component).Text:=query.FieldValues[field] else
    if (component is tlabel) then tlabel(component).Caption:=query.FieldValues[field];
 end else
 exit;
end;


procedure normalspace(dbgrid1:tdbgrid);
var i:integer;
begin
    i:=dbgrid1.Columns.Count-1;
    for i:=0 to i do
    begin
     with dbgrid1 do
     begin
      Columns[i].Width:=73;
     end;
    end;
end;
function selectidbyname(sql:string;field:string):variant;
begin
 fdata.temp.Close;
 fdata.temp.SQL.Clear;
 fdata.temp.sql.Add(sql);
 fdata.temp.Prepared;
 fdata.temp.Open;
 result:=fdata.temp.FieldValues[field];
end;
procedure setfield(table:tadotable;s:string;component:tcomponent);
begin
    table.Edit;
    if (component is tedit) then table.FieldValues[s]:=tedit(component).Text else
    if (component is tcombobox) then table.FieldValues[s]:=tcombobox(component).text else
    if (component is tdatetimepicker) then table.FieldValues[s]:=tdatetimepicker(component).Date else
    if (component is tmemo) then table.FieldValues[s]:=tmemo(component).Text;

end;
procedure deleteontable(table:tadotable);
begin
 if issure then
 table.Delete
 else
 exit;
end;

function issure:boolean;
begin
  if application.messagebox('确定?此操作不可恢复','Warging',mb_okcancel+mb_iconquestion)=idok then
  result:=true
  else
  result:=false;
end;

function isexit(self:tform;var Action: TCloseAction):boolean;
begin
 if messagebox(self.Handle,'确定退出?','Warging',mb_okcancel+mb_iconquestion)=idok then
 begin
     result:=true;
     action:=cafree;
 end
 else
 begin
  action:=canone;result:=false;
 end;
end;

procedure backup(edit1:tedit;animate1:tanimate;command:tadocommand);
begin
  if Trim(Edit1.Text)='' then
  begin
   showmessage('请选择路径');
   exit;
  end;
  try
    Animate1.Visible:=True;//将Animate1隐藏
    command.CommandText:='backup database logistics to disk='+''''+Trim(Edit1.Text)+'''';//将'backup database logistics to disk='+''''+Trim(Edit1.Text)+''''赋给command.CommandText
    Animate1.Active:=True;//将Animate1的属性Active设为true
    command.Execute;
    Animate1.Active:=False;//将Animate1的属性Active设为false
    Application.MessageBox('备份数据成功','提示',mb_ok);
  except
    Application.MessageBox('备份数据失败','提示',mb_ok);
  end;
  Animate1.Visible:=False;//不将Animate1隐藏
end;

procedure restore(edit1:tedit;animate1:tanimate;command:tadocommand);
begin
 if Application.MessageBox('恢复前请先备份，是否开始恢复？','提示',mb_yesno)=id_no then
    Exit;
  if Trim(Edit1.Text)='' then
  begin
   showmessage('请您选择路径');
   Exit;
  end;
  try
    try
      Animate1.Visible:=True;//将Animate1隐藏
      command.CommandText:='use master alter database logistics set offline WITH ROLLBACK IMMEDIATE use master restore database logistics from disk='+''''+Trim(Edit1.Text)+''''+'with replace alter database logistics set online with rollback immediate';
      Animate1.Active:=True;//将Animate1的属性Active设为True
      command.Execute;
      Animate1.Active:=False;
      Application.MessageBox('恢复数据成功..您需要重启软件以使用还原的数据','提示',mb_ok);
    finally
      command.CommandText:='use logistics';//将'use logistics'赋给command.CommandText
      command.Execute;
    end;
  except
    Application.MessageBox('恢复数据失败','提示',mb_ok);
  end;
  Animate1.Visible:=False;//不将Animate1隐藏
end;


procedure  dynimic(self:tform;Sender: TObject);
var
 i:integer;
begin
   for i:=0 to self.ComponentCount-1 do
   begin
    if self.Components[i] is tspeedbutton then
    begin
      if (tspeedbutton(self.Components[i]).Tag<=6) and (tspeedbutton(self.Components[i]).Tag>=1)then
      begin
       if tspeedbutton(self.Components[i]).Tag=tspeedbutton(sender).Tag then
         tspeedbutton(sender).Layout:=blglyphbottom
       else
          tspeedbutton(self.Components[i]).Layout:=blglyphtop;
      end
      else
       begin
        if tspeedbutton(self.Components[i]).Tag=tspeedbutton(sender).Tag then
           tspeedbutton(self.Components[i]).Layout:=blglyphright
        else
           tspeedbutton(self.Components[i]).Layout:=blglyphleft;
       end;
    end;
   end;
end;



procedure setprocedure(procedurename:string;paramname:string;component:tcomponent;haveresult:boolean=true);overload;
begin
  fdata.procedure1.Close;
  fdata.procedure1.ProcedureName:=procedurename;
  fdata.procedure1.Parameters.Refresh;
  if component is tcombobox then
  fdata.procedure1.Parameters.ParamValues[paramname]:=tcombobox(component).Text
  else if component is tlistbox then
  fdata.procedure1.Parameters.ParamValues[paramname]:=tlistbox(component).Items.Strings[tlistbox(component).itemindex]
  else if component is tedit then
  fdata.procedure1.Parameters.ParamValues[paramname]:=tedit(component).Text;
   if haveresult then
  fdata.procedure1.Open
  else
  fdata.procedure1.ExecProc;
end;

procedure setlabel(label1:tlabel;s:string;x:string);
begin

 if x='q' then
  label1.Caption:=fdata.temp.FieldValues[s]
 else
 label1.Caption:=fdata.procedure1.FieldValues[s];
end;
procedure setenable(component:tcomponent;i:integer);
begin
  case i of
   0:
   begin
    if (component is tedit) then tedit(component).Enabled:=false else
    if (component is tcombobox) then tcombobox(component).Enabled:=false else
    if (component is tgroupbox) then tgroupbox(component).Enabled:=false else
    if (component is tbutton) then tbutton(component).Enabled:=false else
    if (component is tspeedbutton) then tspeedbutton(component).Enabled:=false else
    if (component is tcheckbox) then tcheckbox(component).Enabled:=false else
     exit;
   end;
   1:
   begin
    if (component is tedit) then tedit(component).Enabled:=true else
    if (component is tcombobox) then tcombobox(component).Enabled:=true else
    if (component is tgroupbox) then tgroupbox(component).Enabled:=true else
    if (component is tbutton) then tbutton(component).Enabled:=true else
    if (component is tspeedbutton) then tspeedbutton(component).Enabled:=true else
     exit;
   end;
  end;
end;
procedure showdbgrid(dbgrid:tdbgrid;datasource:tdatasource;adoquery:tadotable;dbnavigator:tdbnavigator);
begin
 adoquery.Open;
 dbgrid.DataSource:=datasource;
 dbnavigator.DataSource:=datasource;
end;

procedure settemp(s:string);
begin
 fdata.temp.Close;
 fdata.temp.SQL.Clear;
 fdata.temp.SQL.Add(s);
 fdata.temp.Prepared;
 fdata.temp.Open;
end;

procedure comboboxadditem(procedurename:string;combobox: tcombobox;theaddvalue:string);overload;
begin
  fdata.procedure1.Close;
  fdata.procedure1.ProcedureName:=procedurename;
  fdata.procedure1.Parameters.Refresh;
  fdata.procedure1.Open;
  fdata.procedure1.First;
  combobox.Items.Clear;
  while not fdata.procedure1.Eof do
  begin
   combobox.Items.add(fdata.procedure1.FieldValues[theaddvalue]);
   fdata.procedure1.Next;
  end;
  combobox.ItemIndex:=1;
end;

procedure listboxadditem(listbox:tlistbox;query:TADOquery;field:string);
begin
  listbox.Items.Clear;
  query.Open;
  query.First;
  while not query.Eof do
  begin
   listbox.Items.Add(query.FieldValues[field]);
   query.Next;
  end;
end;

procedure showform(InstanceClass: Tformclass;form:tform);
var
  i:integer;
begin
 if not Assigned(Form) then
 begin
  form:=InstanceClass.Create(application);
  for i:=form.ComponentCount-1 downto 0 do
    if (form.Components[i] is Tlabel) then
    begin
    //  Tlabel(form.Components[i]).Caption:='';
      Tlabel(form.Components[i]).Transparent:=true;
    end;
  form.Show;
  animatewindow(form.Handle,300,aw_center+aw_activate);
 end else
 begin
  form.Show;
  animatewindow(form.Handle,700,aw_center+aw_activate);
 end;
end;



procedure adoqueryopen(query:tadoquery;var s:string);
begin
 with query do
 begin
  close;
  sql.Clear;
  sql.Add(s);
  Prepared;
  open;
 end;
end;

procedure comboboxadditem(table: TADOTable;combobox: tcombobox;s:string);
begin
  combobox.Items.Clear;
  table.Open;
  table.First;
  while not table.Eof do
  begin
   combobox.Items.Add(table.fieldbyname(s).AsString);
   table.Next;
  end;
  table.Close;
end;

procedure comboboxadditem(query: TADOquery;combobox: tcombobox;s:string);overload;
begin
  combobox.Items.Clear;
  query.Close;
  selectallinquery(query);
  query.First;
  while not query.Eof do
  begin
   combobox.Items.Add(query.fieldbyname(s).AsString);
   query.Next;
  end;
end;


function isnull(component:tcomponent):boolean;
begin
    if (component is tedit) then
    begin
     if (tedit(component).Text='') then
     begin
     result:=true;
     end else
     result:=false;
    end else
    if (component is tcombobox) then
    begin
     if (tcombobox(component).Text='') then
     begin
      result:=true;
     end else
     result:=false;
    end else
    result:=true;
end;

end.
 