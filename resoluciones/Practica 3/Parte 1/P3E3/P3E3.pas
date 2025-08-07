program P3E3;

Const 
     valorAlto = 32767;
type

     novela = record
         codigo:integer;
         genero:String[30];
         nombre: String [35];
         duracion: String[35];
         director: String[35];
         precio:real;
     end;

     archivoNovelas = file of novela;


     procedure leerNovela (var n:novela);
     begin
         writeln(' Ingrese codigo de novela: ');
         readln(n.codigo);
         if (n.codigo <> -1) then
         begin
             writeln(' Ingrese genero de la novela: ');
             readln(n.genero);
             writeln(' Ingrese nombre de la novela: ');
             readln(n.nombre);
             writeln(' Ingrse duracion de la novela: ');
             readln(n.duracion);
             writeln(' Ingrese nombre completo del director: ');
             readln(n.director);
             writeln(' Ingrese precio de la novela: ');
             readln(n.precio);
         end;
     end; 
     procedure crearArchivo (var arc:archivoNovelas);
     var 
         n:novela; nomFisico:String;
     begin
         writeln(' Ingrese nombre del archivo: ');
         readln(nomFisico);
         assign(arc,nomFisico);
         rewrite(arc);

         n.codigo := 0 ;
         n.genero := '';
         n.nombre := '';
         n.duracion := '';
         n.director := '';
         n.precio := 0;
         
         write(arc,n);

         leerNovela(n);

         while (n.codigo <> -1) do
         begin
             write(arc,n);
             leerNovela(n);
         end;
        close(arc);
        writeln(' Se genero el archivo satisfactoriamente. ');
     end;



     procedure alta (var arc:archivoNovelas);
     var 
        n,aux:novela;
     begin
         reset(arc);
         read(arc,aux);
         leerNovela(n);
         if (aux.codigo = 0) then
         begin
             seek(arc,filesize(arc));
             write(arc,n);
         end
         else
         begin
             seek(arc, aux.codigo * -1);
             read(arc,aux);
             seek(arc,filepos(arc)-1);
             write(arc,n);
             seek(arc,0);
             write(arc,aux);
         end;
         close(arc);
     end;
     
     procedure leer (var arc:archivoNovelas; var n:novela);
     begin  
         if (not EOF(arc)) then
             read(arc,n)
         else
             n.codigo := valorAlto;
     end;

     procedure modificarTodo(var n:novela);
     begin
         writeln(' Ingrese nuevo genero de la novela: ');
         readln(n.genero);
         writeln(' Ingrese nuevo nombre de la novela: ');
         readln(n.nombre);
         writeln(' Ingrse nuevo duracion de la novela: ');
         readln(n.duracion);
         writeln(' Ingrese nuevo nombre completo del director: ');
         readln(n.director);
         writeln(' Ingrese nuevo precio de la novela: ');
         readln(n.precio);
     end;

     procedure modificarGenero (var n:novela);
     begin
         writeln(' Ingrese nuevo genero de la novela: ');
         readln(n.genero);
     end;

    procedure modificarNombre (var n:novela);
     begin
         writeln(' Ingrese nuevo nombre de la novela: ');
         readln(n.nombre);
     end;
     
     procedure modificarDuracion (var n:novela);
     begin
         writeln(' Ingrse nuevo duracion de la novela: ');
         readln(n.duracion);
     end;
     
     procedure modificarDirector (var n:novela);
     begin
         writeln(' Ingrese nuevo nombre completo del director: ');
         readln(n.director);
     end;
     
     procedure modificarPrecio (var n:novela);
     begin
         writeln(' Ingrese nuevo precio de la novela: ');
         readln(n.precio);
     end;
     
     
     procedure modificaciones (var n:novela);
     var 
         opcion:integer;
     begin
          writeln(' Menu de modificaciones ');
             writeln(' 1. Modificar todos los campos: ');
             writeln(' 2. modificar genero: ');
             writeln(' 3. Modificar nombre: ');
             writeln(' 4. modificar duracion: ');
             writeln(' 5. modificar director. ');
             writeln(' 6. modificar precio. ');
             readln(opcion);

         case opcion of
             1: modificarTodo(n);
             2: modificarGenero(n);
             3: modificarNombre(n);
             4: modificarDuracion(n);
             5: modificarDirector(n);
             6: modificarPrecio(n);
         else 
             writeln(' Ingrese un numero del 1 al 6');
         end;
     end;
     

     procedure modificar (var arc:archivoNovelas);
     var n:novela; cod:integer; encontre: boolean;
     begin
         writeln(' Ingrese codigo de novela a modificar ');
         readln(cod);
         reset(arc);
         encontre := false;
         leer(arc,n);
         while ((n.codigo <> valorAlto) and (not encontre)) do
         begin
             if (n.codigo = cod) then
                 encontre := true
             else
                 leer(arc,n);
         end;

         if (encontre) then
         begin  
             modificaciones(n);
             seek(arc,filepos(arc)-1);
             write(arc,n);
             writeln( ' La Novela se modifico correctamente. ');
         end
         else
             writeln(' La novela que se introdujo no existe. ');
         close(arc);
     end;

     procedure eliminarNovela (var arc:archivoNovelas);
     var    
         cod:integer; encontre:boolean; n,aux:novela;
     begin
         writeln( ' Ingrese codigo de novela a eliminar ');
         readln(cod);
         reset(arc);
         encontre := false;
         leer(arc,n);
         while ((n.codigo <> valorAlto) and (not encontre)) do
         begin
             if (n.codigo = cod) then
             begin
                 encontre := true;
                 n.codigo := (filepos(arc)-1)*-1; 
                 seek(arc,0);
                 read(arc,aux);
                 seek(arc,n.codigo*-1);
                 write(arc,aux);
                 seek(arc,0);
                 write(arc,n);
             end
             else
                 leer(arc,n);
         end; 

         if (encontre) then
             writeln( ' Se elimino correctamente la novela con codigo ', cod)
         else
             writeln(' No existe la novela con codigo ', cod);
         close(arc);
     end;

     procedure listadoNovelas (var arc:archivoNovelas; var novelasTxt:Text);
     var 
         n:novela;
     begin
         assign(novelasTxt, 'novelas.txt');
         reset(arc);
         rewrite(novelasTxt);
         leer(arc,n);
         while (n.codigo <> valorAlto) do
         begin
             writeln(novelasTxt, ' Codigo: ', n.codigo , ' ');
             writeln(novelasTxt, ' Genero: ', n.genero, ' ');
             writeln(novelasTxt, ' Novela: ', n.nombre, ' ');
             writeln(novelasTxt, ' Duracion: ', n.duracion, ' ');
             writeln(novelasTxt, ' Director: ', n.director, ' ');
             writeln(novelasTxt, ' Precio: ', n.precio, ' ');
             writeln(novelasTxt);
             leer(arc,n);
         end;
         close(arc);
         close(novelasTxt);
     end;
     procedure menu (var arc:archivoNovelas; var arcTxt:Text);
     var
         opcion:integer;
     begin
         repeat
             writeln(' Menu de Opciones ');
             writeln(' 1. Crear Archivo Novelas: ');
             writeln(' 2. Dar de alta una novela: ');
             writeln(' 3. Modificar datos de una novela existente: ');
             writeln(' 4. Eliminar una novela existente: ');
             writeln(' 5. Generar listado de novelas en archivo de texto. ');
             writeln(' 6. Salir del Programa. ');
             readln(opcion);
             case opcion of 

                 1: crearArchivo(arc);
                 2: alta(arc);
                 3: modificar(arc);
                 4: eliminarNovela(arc);
                 5: listadoNovelas(arc, arcTxt);
                 6: writeln(' Saliendo del Programa... ');
             else
                 writeln(' Introduzca un numero correcto (1-6) ');
             end;
         until (opcion = 6);
     end;

     var archivo : archivoNovelas; archivoTexto:Text; 
     begin
         menu(archivo,archivoTexto);
     end.