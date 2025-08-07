program P3E6;

type 
     prenda = record
         cod_prenda : integer;
         descripcion : String[80];
         colores : String[30];
         tipo_prenda: String[30];
         stock: integer;
         precio_unitario: real;
     end;

     maestro = file of prenda; 

     detalle = file of integer;

     procedure baja (var m:maestro; var d:detalle);
     var
         pM:prenda; pD:integer;
     begin
         reset(m);
         reset(d);
         
         while (not EOF(d)) do
         begin
             read(d,pD);
             seek(m,0);
             read(m,pM);

             while (pD <> pM.codigo) do
             begin
                 read(m,pM);
             end;

             if (pD = pM.codigo) then
             begin
                 pM.stock := -1;
                 seek(m,filePos(m)-1);
                 write(m,pM);
             end;
         end;
         close(d);
         close(m);
     end;

     procedure nueMae (var m,nueMae:maestro);
     var    
         pM:prenda;
     begin
         reset(m);
         rewrite(nueMae);

         while (not EOF(m)) do
         begin
             read(m,pM);
             if (pM.codigo > 0) then
                 write(nueMae,pM);
         end;

         close(nueMae);
         close(m);
         erase(mae);
         rename(nueMae, 'ArchivoMaestro');
     end;