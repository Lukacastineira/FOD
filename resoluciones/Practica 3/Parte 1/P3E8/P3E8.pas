program P3E8;

Const 
     valorAlto = 9999;

type
  
     distribucion = record
         nombre:String;
         anioLanzamiento:integer;
         version:integer;
         cantDesarrolladores:integer;
         descripcion:String;
     end;

     arcDistribucionesLinux = file of distribucion;

     procedure leerDistribucion (var d:distribucion);
     begin
         writeln(' Ingrese nombre de la version: ');
         readln(d.nombre);
         if (d.nombre <> 'FIN' ) then
         begin
             writeln(' Ingrese anio de lanzamiento de la version: ');
             readln(d.anioLanzamiento);
             writeln(' Ingrese codigo de la version: ');
             readln(d.version);
             writeln(' Ingrese cantidad de desarrolladores de la version: ');
             readln(d.cantDesarrolladores);
             writeln(' Ingrese descripcion de la version: ');
             readln(d.descripcion);
         end;
     end;

     procedure crearArchivo (var arc:arcDistribucionesLinux);
     var
         d:distribucion;
     begin
         assign (arc,'DistribucionesLinux');
         rewrite(arc);
         
         d.nombre := '';
         d.anioLanzamiento := 0;
         d.version := 0;
         d.cantDesarrolladores := 0;
         d.descripcion := '';
         
         write (arc,d);

         writeln(' Ingrese "FIN" en nombre para finalizar la lectura. ');
         leerDistribucion(d);

         while (d.nombre <> 'FIN') do

         begin

             write(arc,d);
             leerDistribucion(d);

         end;

         close(arc);

     end;
     procedure leer(var arc:arcDistribucionesLinux; var d:distribucion);
     begin
         if (not eof(arc)) then
             read(arc,d)
         else
             d.version := valorAlto;
     end;

     function buscarDistribucion (var arc: arcDistribucionesLinux; nombre:String):integer;
     var    
         d:distribucion; encontre:boolean; var pos:integer;
     begin
         reset(arc);
         pos:=0;
         leer(arc,d);
         encontre := false;
         while ((d.version <> valorAlto) and (not encontre)) do
         begin
             if (d.nombre = nombre) then
             begin
                 if (d.version > 0 )then
                     pos := filePos(arc)-1
                 else
                     pos:=-1;
                 encontre := true;
             end;
         end;
         
         close(arc);

         if (not encontre) then
             pos := -1;
        buscarDistribucion := pos;
     end;

     procedure altaDistribucion (var arc:arcDistribucionesLinux; newDist:distribucion);
     var
         d,aux:distribucion; 
     begin
         reset(arc);

         seek(arc,0);
         read(arc,d);  
         if (d.cantDesarrolladores = 0) then
         begin
             seek(arc,fileSize(arc));
             write(arc,newDist);
         end
         else
         begin
             seek(arc,d.cantDesarrolladores*-1);
             read(arc,aux);
            
             seek(arc,d.cantDesarrolladores*-1);
             write(arc,newDist);

             seek(arc,0);
             write(arc,aux);
         end;
         close(arc);
     end;

     procedure bajaDistribucion (var arc:arcDistribucionesLinux; nombre:String);
     var 
         d,aux:distribucion; encontre:integer;
     begin
         encontre := buscarDistribucion(arc,nombre);
         reset(arc);
         if (encontre <> -1) then
         begin
             seek(arc,0);
             read(arc,d);
             if (d.cantDesarrolladores = 0) then
             begin
                 seek(arc,encontre);
                 read(arc,d);
                 d.cantDesarrolladores := (filePos(arc)-1)* -1;
                 seek(arc,0);
                 write(arc,d);
             end
             else
             begin

                 seek(arc,encontre);
                 read(arc,d);
                 d.cantDesarrolladores := filePos(arc)-1 * -1;

                 seek(arc,0);
                 read(arc,aux);

                 seek(arc,0);
                 write(arc,d);

                 seek(arc,encontre);
                 write(arc,aux);
             end;
         end;
         close(arc);
     end;

     var 
         arc:arcDistribucionesLinux; d:distribucion; n:String;

     begin
         crearArchivo(arc);
         write(' Ingrese nueva distribucion: ');
         leerDistribucion(d);
         altaDistribucion(arc,d);
         writeln(' Ingrese nombre de distribucion a eliminar: ');
         readln(n);
         bajaDistribucion(arc,n);
     end.