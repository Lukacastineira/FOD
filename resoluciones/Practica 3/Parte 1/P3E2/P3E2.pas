program P3E2;

Const   
     valorAlto = 99999;
type

     asistente = record
         num_Asistente :integer;
         apeYnom:String[35];
         email:String[35];
         tel:String[35];
         DNI:integer;
     end;

     infoAsistentes = file of asistente;

     procedure leer (var arc:infoAsistentes; var a:asistente);
     begin
         if (not EOF(arc)) then
             read(arc,a);
         else
             a.num_Asistente := valorAlto;
     end;

     procedure eliminarAsistentes(var arc:infoAsistentes);
     var
        a:asistente;
     begin

         reset(arc);
         leer(arc,a);

         while (a.num_Asistente <> valorAlto) do
         begin

             if (a.num_Asistente < 1000) then
             begin
                 seek(arc, filePos(arc)-1);
                 a.apeYnom := '@' + a.apeYnom;
                 write(arc,a);
             end;

             leer(arc,a);

         end;

         close(arc);

     end;
