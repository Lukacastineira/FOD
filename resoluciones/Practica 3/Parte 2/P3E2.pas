program P3E2;

type 
     mesa = record
         codigo:integer;
         numMesa:integer;
         cantVotos :integer;
     end;

     arcMesas = file of mesa;

     votoslocalidad = record
         codigo:integer;
         cantVotos:integer;
     end;

     arcTotalVotosLocalidades = file of votoslocalidad;

     procedure contabilizarVotos (var mesas:arcMesas; var arcLocalidades:arcTotalVotosLocalidades; var totalVotos:integer);
     var    
         m:mesa; vLocalidad:votoslocalidad; locAct:integer; encontre:boolean;
     begin
         reset(mesas);
         assign(arcLocalidades,'ArchivoVotosLocalidades');
         rewrite(arcLocalidades);

         while(not EOF(mesas)) do
         begin
             read(mesas,m);
             encontre := false;
             
             if (fileSize(arcLocalidades) > 0) then
             begin
                 while ((not EOF(arcLocalidades)) and (not encontre)) do
                 begin
                     read(arcLocalidades,vLocalidad);
                     if (m.codigo = vLocalidad.codigo) then
                         encontre := true;
                 end;
             end;

             if (encontre) then
             begin
                 vLocalidad.cantVotos := vLocalidad.cantVotos + m.cantVotos;
                 seek(arcLocalidades,filePos(arcLocalidades)-1);
                 write(arcLocalidades,vLocalidad);
             end
             else
             begin
                 vLocalidad.cantVotos := m.cantVotos;
                 vLocalidad.codigo := m.codigo;
                 seek(arcLocalidades, fileSize(arcLocalidades));
                 write(arcLocalidades,vLocalidad);
             end;

             totalVotos := totalVotos + m.cantVotos;

             seek(arcLocalidades,0);
             
         end;
         close(mesas);
         close(arcLocalidades);
     end;

     procedure imprimirTotalVotos (var arc:arcLocalidades; totalVotos:integer);
     var
         v:votoslocalidad;
     begin
         reset(arc);
         writeln(' Codigo de Localidad ' , '    Total de Votos');
         while (not EOF(arc)) do
         begin
             read(arc,v);
             writeln ('  ',v.codigo, '   ', v.cantVotos);
         end;

         writeln (' Total General de Votos: ', totalVotos);
         close(arc);
     end;

     var
         archivoMesas:arcMesas; archivoVotosLocalidades:arcLocalidades; totalVotos:integer;

     begin
         totalVotos := 0;
         contabilizarVotos(archivoMesas,archivoVotosLocalidades,totalVotos);
         imprimirTotalVotos(archivoVotosLocalidades,totalVotos);
     end.