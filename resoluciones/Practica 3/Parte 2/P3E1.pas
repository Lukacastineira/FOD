program P3E1;

Const
     valorAlto = 9999;
type
     producto = record
         codigo:integer;
         nombre:String;
         precio:real;
         stockAct:integer;
         stockMin:integer;
     end;

     arcMae = file of producto;
     
     venta = record
         codigo:integer;
         cantUnidades:integer;
     end;

     detalle = file of ventas;
     


     procedure actualizarMae (var arc:arcMae; var det:detalle);
     var 
         produ:producto; vent:venta; cantTotalVendida:integer
     begin
         reset(arc);
         reset(det);
         
        
         while (not EOF(arc)) do
         begin

             cantTotalVendida:=0;
             read(arc,produ);

             while (not EOF(det)) do
             begin
                 if (produ.codigo = vent.codigo) then
                     cantTotalVendida := cantTotalVendida + vent.cantUnidades;
             end;

             if (cantTotalVendida > 0) then
             begin
                 produ.stockAct := produ.stockAct - cantTotalVendida;
                 seek(arc,filePos(arc)-1);
                 write(arc,produ);
             end;  

             seek(det,0);

         end;
         close(arc);
         close(det);
     end;

{ 
1B)

encontre := false;

while (not EOF(arc)) do
     begin
         read(arc,produ);
         while (((not EOF(det)) and (not encontre)) do
         begin
             read(det,vent);
             if (produ.codigo = vent.codigo) then
                 encontre := true ;
         end;

         if (produ.codigo = vent.codigo) then
         begin
             produ.stockAct := produ.stockAct - vent.cantUnidades;
             seek(arc,filePos(arc)-1);
             write(arc,produ);
         end;
         
         seek(det,0);
     end;

}