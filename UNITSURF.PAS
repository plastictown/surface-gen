unit
    surf;
interface
uses
    crt,
    graph,
    windos;
type coords3=record
     x:integer;
     y:integer;
     z:integer;
     end;
type coords2=record
     x,y:integer;
     end;
const center:coords3=(x:320;y:240;z:0);
const radKoef:real=180/pi;
var
   grDriver: Integer;
   grMode: Integer;
   ErrCode: Integer;
   myCoord2: coords2;
   key:char;
   count:word;
   angle:integer;
   counter:integer;
procedure graphMode;
procedure getProjection(x,y,z:integer);
procedure line3(x1,y1,z1,x2,y2,z2:integer);
procedure drawORT;
function ConvertToInt(s:string):integer;
procedure getSurfaceFromFile(fname:string; x,y,z:integer);
procedure getLinesFromFile(fname:string;x,y,z:integer);
Implementation
procedure graphMode;
          begin
               grDriver := Detect;
               InitGraph(grDriver, grMode,'');
               ErrCode := GraphResult;
          end;
procedure getProjection(x,y,z:integer);
          var
             result:coords2;
             zz:real;
          begin
               zz:=z*(sqrt(2)/2);
               result.x:=round(x-zz)+center.x;
               result.y:=-round(y-zz)+center.y;
               MyCoord2:=result;
          end;
procedure getPerspective(x,y,z:integer);
          var
             length_eye:integer;
             length_point:real;
             eye:coords3;
             hor:coords3;
             koef:real;
             offset:word;
             a,b,c:real;
          begin
               eye.x:=0; eye.y:=100; eye.z:=300;
               hor.x:=0; hor.y:=0; eye.z:=-300;
               length_eye:=round(sqrt(10000+360000));
               length_point:=round(sqrt(sqr(x)+
               sqr(y)+sqr(-300-z)));
               koef:=length_eye/length_point;
               offset:=round(koef*100);
               getPerspective(x,y,z);
               if myCoord2.x<0 then myCoord2.x:=myCoord2.x-offset;
               if myCoord2.x>0 then myCoord2.x:=myCoord2.x+offset;
          end;
procedure line3(x1,y1,z1,x2,y2,z2:integer);
          var
             temp:coords2;
          begin

             getProjection(round(x1*cos(angle))-round(z1*sin(angle)),
             y1,round(x1*sin(angle))+round(z1*cos(angle)));

             temp:=MyCoord2;
            { getProjection(x2,y2,z2);}

            getProjection(round(x2*cos(angle))-round(z2*sin(angle)),
             y2,round(x2*sin(angle))+round(z2*cos(angle)));

             line(temp.x,temp.y,myCoord2.x,myCoord2.y);
          end;
procedure drawORT;
          begin
               line3(-40,0,0,40,0,0);
               line3(0,-40,0,0,40,0);
               line3(0,0,-40,0,0,40);
          end;
procedure drawTest;
          begin
          line3(-30,0,0,0,0,10);
          line3(0,0,10,0,20,10);
          line3(0,20,10,-30,0,0);
          line3(-30,0,0,0,0,-10);
          line3(0,0,-10,0,0,10);
          line3(0,0,-10,0,20,-10);
          line3(0,20,-10,0,20,10);
          line3(-30,0,0,0,20,-10);
          end;
procedure circleXZ(x,y,z:integer;radius,color:word);
          var
             counter:word;
             koef:real;
             xx,zz:word;
             temp:coords3;
          begin
               koef:=180/pi;
               for counter:=1 to 360 do
                   begin
                        xx:=round(radius*cos(counter/koef));
                        zz:=round(radius*sin(counter/koef));
                        temp.x:=xx+x;
                        temp.y:=y;
                        temp.z:=zz+z;
                        getProjection(temp.x,temp.y,temp.z);
                        putPixel(MyCoord2.x,MyCoord2.y,color);
                   end;
          end;
procedure drawCylinder(x,y,z:integer;radius,size:word);
          var
             halfSize:word;
             temp,temp2:coords2;
             koef:real;
          begin
               koef:=round(180/pi);
               halfSize:=round(size/2);
               circleXZ(x,y+halfSize,z,radius,white);
               circleXZ(x,y-halfSize,z,radius,white);
               temp.x:=round(radius*(cos(315/koef)));
               temp.y:=round(radius*sin(315/koef));
               temp2.x:=round(radius*(cos(135/koef)));
               temp2.y:=round(radius*(sin(135/koef)));
               line3(temp2.x+x,y+halfSize,temp2.y+z,
               temp2.x+x,y-halfSize,temp2.y-z);
               line3(temp.x+x,y+halfSize,temp.y+z,
               temp.x+x,y-halfSize,temp.y-z);
          end;
function ConvertToInt(s:string):integer;
         var
            i:integer;
            code:integer;
         begin
              val(s,i,code);
              convertToInt:=i;
         end;
procedure getSurfaceFromFile(fname:string; x,y,z:integer);
          var
             f:text;
             surfW,
             surfH:byte;
             surf:array[0..10] of coords3;
             tempMas:array[0..10] of string;
             temp:string;
             temp_length:byte;
             i,j,k,m,n:byte;
             counter:byte;
             surface:array[1..3,1..3] of coords3;
          begin
               surfW:=0;
               surfH:=0;
               for i:=0 to 10 do
                   begin
                        tempMas[i]:='';
                   end;
               assign(f,fname);
               reset(f);
               readln(f,temp);
               temp_length:=length(temp);
               surfW:=convertToInt(temp); {Width}

               readln(f,temp);
               temp_length:=length(temp);
               surfH:=convertToInt(temp); {Height}
               for k:=1 to surfH*3 do
               begin
                    readln(f,temp);
                    temp_length:=length(temp);

                    j:=1;
                    counter:=0;
                    n:=1;
                    for i:=1 to temp_length do
                        begin
                             if (temp[i]<>' ') then
                                begin
                                     tempMas[j]:=tempMas[j]+temp[i];
                                end else j:=j+1;
                             counter:=counter+j;

                             end;
                            { writeln(tempmas[3]);}
                             case k of
                             1:begin
                             for m:=1 to 3 do surf[m].x:=convertToInt(tempMas[m]);
                             end;
                             2:begin
                             for m:=4 to 6 do surf[m].x:=convertToInt(TempMas[m-3]);
                             end;
                             3:begin
                             for m:=7 to 9 do surf[m].x:=convertToInt(TempMas[m-6]);
                             end;

                             4:begin
                             for m:=1 to 3 do surf[m].y:=convertToInt(tempMas[m]);
                             end;
                             5:begin
                             for m:=4 to 6 do surf[m].y:=convertToInt(TempMas[m-3]);
                             end;
                             6:begin
                             for m:=7 to 9 do surf[m].y:=convertToInt(TempMas[m-6]);
                             end;

                             7:begin
                             for m:=1 to 3 do surf[m].z:=convertToInt(tempMas[m]);
                             end;
                             8:begin
                             for m:=4 to 6 do surf[m].z:=convertToInt(TempMas[m-3]);
                             end;
                             9:begin
                             for m:=7 to 9 do surf[m].z:=convertToInt(TempMas[m-6]);
                             end;
                             end;
                                    { surf[n].x:=convertToInt(tempMas[m]);
                                     n:=n+1;}

                             for n:= 0 to j do
                                 begin
                                      tempMas[n]:='';

                                     end;
                                end;

               close(f);
               counter:=1;
               for i:=1 to surfH do
                   begin
                        for j:=1 to surfW do
                            begin
                                surface[i][j]:=surf[counter];
                                counter:=counter+1;
                            end;
                   end;
               for i:=1 to (surfH) do
                   begin
                        for j:=1 to (surfW-1) do
                            begin
                                 line3(surface[i][j].x+x,surface[i][j].y+y,
                                 surface[i][j].z+z,surface[i][j+1].x+x,
                                 surface[i][j+1].y+y,surface[i][j+1].z+z)
                            end;
                   end;
              for j:=1 to (surfW) do
                   begin
                        for i:=1 to (surfH-1) do
                            begin
                                 line3(surface[i][j].x+x,surface[i][j].y+y,
                                 surface[i][j].z+z,surface[i+1][j].x+x,
                                 surface[i+1][j].y+y,surface[i+1][j].z+z)
                            end;
                   end;
          end;
procedure getLinesFromFile(fname:string;x,y,z:integer);
          var
             tempMas:array[1..3] of string;
             tempStr:string;
             f:text;
             pointOld,
             pointNew:coords3;
             i,j,k:word;
             long:byte;
             first:boolean;
          begin
               first:=true;
               assign(f,fname);
               reset(f);


               while(not eof(f)) do
               begin
               for i:= 1 to 3 do tempMas[i]:='';
               readln(f,tempStr);
               long:=length(tempStr);
               j:=1;
               for i:=1 to long do
                   begin

                        if tempStr[i]<>' ' then
                           begin
                                tempMas[j]:=tempMas[j]+tempStr[i];
                           end
                           else j:=j+1;
                   end;

               pointNew.x:=convertToInt(TempMas[1]);
               PointNew.y:=convertToInt(TempMas[2]);
               PointNew.z:=convertToInt(TempMas[3]);

               if first then
                  begin
                       PointOld:=PointNew;
                       first:=false;
                  end;
                  {Drawing}
               line3(pointOld.x+x, PointOld.y+y, PointOld.z+z,
               PointNew.x+x,PointNew.y+y, PointNew.z+z);
               PointOld:=PointNew;
               end;
               close(f);
          end;
begin
end.