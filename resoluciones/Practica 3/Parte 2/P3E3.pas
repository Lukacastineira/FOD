program P3E3;

type
     sesion = record
         cod_usuario :integer;
         fecha :String;
         tiempo_sesion:integer;
     end;
     
     arcLogs = file of sesion;

     vectorMaquinas = array [1..5] of arcLogs;

     procedure crearMae (var sesiones:vectorMaquinas; var mae:arcLogs);
     var
         s:sesion; sMae:sesion; i:integer; encontre:boolean;
     begin
         rewrite(mae);
         
         for(i := 1 to 5) do
         begin             
             reset(sesiones[i]);
             while (not EOF(sesiones[i])) do
             begin
                 encontre := false;
                 read(sesiones[i],s);

                 if (fileSize(mae) > 0) then
                 begin

                     while ((not eof(mae)) and (not encontre)) do 
                     begin
                         read(mae,sMae);
                         if ((s.cod_usuario = sMae.cod_usuario) and (s.fecha = sMae.fecha)) then
                             encontre := true;
                     end;

                 end;

                 if (encontre) then
                 begin
                     sMae.tiempo_sesion := sMae.tiempo_sesion + s.tiempo_sesion;
                     seek(mae,filePos(mae)-1);
                     write(mae,sMae);
                 end
                 else

                 begin
                     sMae.cod_usuario := s.cod_usuario;
                     sMae.fecha := s.fecha;
                     sMae.tiempo_sesion := s.tiempo_sesion;
                     seek(mae,fileSize(mae));
                     write(mae,sMae);
                 end;
                 seek(mae,0);
             end;
             close (sesiones[i]);
         end;
         close(mae);
     end;