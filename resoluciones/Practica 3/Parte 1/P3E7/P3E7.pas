program P3E7;

Const 
     valorAlto = 9999;
type

     ave = record
         codigo:integer;
         nombreEspecie:String[40];
         familiaAve:String[30];
         descripcion:String[80];
         zonaGeografica:String[40];
     end;

     archivoAves = file of ave;

     procedure baja  (var arc:archivoAves; codigoExtinta:integer);
     var 
         a:ave; encontre:boolean;
     begin
         reset(arc);
         encontre := false;
         while ((not EOF(arc)) and (not encontre))do
         begin
             read(arc,a);
             if (a.codigo = codigoExtinta) then
             begin
                 encontre := true;
                 a.codigo := -1;
                 seek(filePos(arc)-1);
                 write(arc,a);
             end;
         end;
         close(arc);
     end;

     procedure leer (var arc:archivoAves; var a:ave);
     begins
         if (not EOF(arc)) then
             read(arc,a);
         else
             a.codigo := valorAlto;
     end;

     procedure actualizarMae(var arc: archivoAves);
     var
         a, ult: ave;
         pos, fin: integer;
     begin
         reset(arc);
         fin := fileSize(arc);  // Tamaño original del archivo

         leer(arc, a);
         while (a.codigo <> valorAlto) and (filePos(arc) <= fin) do
         begin
             if (a.codigo < 0) then
             begin
                 fin := fin - 1;  // Reducimos el tamaño lógico del archivo

                 // Traemos el último registro válido
                 seek(arc, fin);
                 read(arc, ult);

                 // Volvemos a la posición actual del registro borrado y lo sobrescribimos
                 pos := filePos(arc) - 2;  // -1 por el read anterior, -1 más por volver al borrado
                 seek(arc, pos);
                 write(arc, ult);

                 // Volvemos a la posición actual para seguir leyendo
                 seek(arc, pos);
                 read(arc, a);  // Leemos el nuevo registro que reemplazó al borrado
             end
             else
                 leer(arc, a);  // Seguimos normalmente
         end;

         // Truncamos el archivo para eliminar los registros al final
         seek(arc, fin);
         truncate(arc);

         close(arc);
     end;