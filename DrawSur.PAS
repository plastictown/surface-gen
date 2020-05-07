program
       getgen;
uses
    crt,
    graph,
    surf;
var
   f:text;
   mas:array[1..40, 1..40] of coords3;
   i,j,k,m:integer;
   masH,masW:byte;
   temp:string;
   tstr:string;
   len:byte;
   tempMas:array[1..3] of string;
   name:string;
begin
     clrscr;
     tstr:='';
     writeln('Input a name of surface file(String, example: land.sur)');
     readln(name);
     assign(f,name);
     reset(f);
     readln(f,temp);
     len:=length(temp);
     for i:=1 to len do if temp[i]<>' ' then tstr:=tstr+temp[i];
     masW:=convertToInt(tstr);
     tstr:='';
     readln(f,temp);
     len:=length(temp);
     for i:=1 to len do if temp[i]<>' ' then tstr:=tstr+temp[i];
     MasH:=convertToInt(tstr);

     for k:=1 to masH do
         begin
              for m:=1 to masW do
                  begin
     for i:= 1 to 3 do tempMas[i]:='';
               readln(f,temp);
               len:=length(temp);
               j:=1;
               for i:=1 to len do
                   begin

                        if temp[i]<>' ' then
                           begin
                                tempMas[j]:=tempMas[j]+temp[i];
                           end
                           else j:=j+1;
                   end;
                       mas[m][k].x:=convertToInt(tempMas[1]);
                       mas[m][k].y:=convertToInt(tempMas[2]);
                       mas[m][k].z:=convertToInt(tempMas[3]);
                   end;
     end;
     close(f);


     graphMode;
     cleardevice;

     for i:=1 to (masH) do
                   begin
                        for j:=1 to (masW-1) do
                            begin
                                { if(mas[i][j].y>5) then setColor(red)
                       else} setColor(blue);
                                 line3(mas[i][j].x,mas[i][j].y,
                                 mas[i][j].z,mas[i][j+1].x,
                                 mas[i][j+1].y,mas[i][j+1].z)
                            end;
                   end;
              for j:=1 to (masW) do
                   begin
                        for i:=1 to (masH-1) do
                            begin
                                 line3(mas[i][j].x,mas[i][j].y,
                                 mas[i][j].z,mas[i+1][j].x,
                                 mas[i+1][j].y,mas[i+1][j].z)
                            end;
                   end;

     readkey
end.