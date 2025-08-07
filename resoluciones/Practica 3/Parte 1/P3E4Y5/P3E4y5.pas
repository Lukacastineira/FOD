program p3e4y5;

type 
     reg_flor = record 
         nombre: String[45]; 
         codigo: integer; 
     end; 
     tArchFlores = file of reg_flor; 

     procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer); 
     var 
         f,aux:reg_flor;
     begin
         reset(a);
         read(a,aux);

         f.nombre := nombre;
         f.codigo := codigo;

         if (aux.codigo = 0) then
         begin
             seek(a,filesize(a));
             write(a,f);
         end
         else
         begin
             seek(a,(aux.codigo*-1));
             read(a,aux);

             seek(a,filePos(a)-1);
             write(a,f);

             seek(a,0);
             write(a,aux);
         end;
         close(a);
     end;

     procedure listarArchivo (var a:tArchFlores);
     var
         f:reg_flor;
     begin
         reset(a);
         while (not EOF(a)) do
         begin
             read(a,f);

             if (f.codigo > 0) then
             begin
                 writeln(' Tipo de Flor: ', f.nombre , ' Codigo: ', f.codigo, ' ');
             end;
         end;
         close(a);
     end;

     procedure eliminarFlor (var a: tArchFlores; flor:reg_flor); 
     var
         f,aux:reg_flor; encontre:boolean;
     begin
         reset(a);
         encontre := false;
         while ((not EOF(a)) and (not encontre)) do
         begin
             read(a,f);
             if (f.codigo = flor.codigo) then
             begin
                 encontre := true;
                 f.codigo := filePos(a)-1 * -1 ;
                 seek(a,0);
                 read(a,aux);
                 seek(a,0);
                 write(a,f);
                 seek(a,f.codigo*-1);
                 write(a,aux);
             end;
         end;
         close(a);
     end;