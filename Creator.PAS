program
       new3d;
uses
    crt,
    graph,
    surf;
var
   mas:array[1..40,1..40] of coords3;
   i,j:integer;
   f:text;
   ran:byte;
   name:string;
begin
     clrscr;
     writeln('Generator of surfaces');
     writeln;
     writeln('Input a filename...(String, For example: land.sur)');
     readln(name);
     writeln('Input amplitude...(Byte, for example: 10)');
     readln(ran);
     assign(f,name);
     rewrite(f);
     writeln(f,'40');
     writeln(f,'40');
     for i:=1 to 40 do
         begin
              for j:=1 to 40 do
                  begin
                       mas[i][j].x:=i*10 - 200;
                       mas[i][j].z:=j*10 - 200;
                       mas[i][j].y:=random(ran);
                       mas[i][j].y:=mas[i][j].y-(ran*2);
                       writeln(f,mas[i][j].x,' ',mas[i][j].y,' ',
                       mas[i][j].z);
                  end;
         end;
         close(f);
     graphMode;
     ClearDevice;
     for i:=1 to (40) do
                   begin
                        for j:=1 to (39) do
                            begin
                                { if(mas[i][j].y>5) then setColor(red)
                       else} setColor(green);
                                 line3(mas[i][j].x,mas[i][j].y,
                                 mas[i][j].z,mas[i][j+1].x,
                                 mas[i][j+1].y,mas[i][j+1].z)
                            end;
                   end;
              for j:=1 to (40) do
                   begin
                        for i:=1 to (39) do
                            begin

                                 line3(mas[i][j].x,mas[i][j].y,
                                 mas[i][j].z,mas[i+1][j].x,
                                 mas[i+1][j].y,mas[i+1][j].z);

                                 if (mas[i][j].y>5) then
                                    begin
                                         getProjection(mas[i][j].x,
                                         mas[i][j].y, mas[i][j].z);

                                         PutPixel(MyCoord2.x,MyCoord2.y,red);


                                    end;
                            end;
                   end;
     readkey
end.