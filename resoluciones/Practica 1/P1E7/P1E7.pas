{
7. Realizar un programa que permita: 

a) Crear un archivo binario a partir de la información almacenada en un archivo de 
texto. El nombre del archivo de texto es: “novelas.txt”. La información en el 
archivo de texto consiste en: código  de novela, nombre, género y precio de 
diferentes novelas argentinas. Los datos de cada novela se almacenan en dos 
líneas en el archivo de texto. La primera línea contendrá la siguiente información: 
código novela, precio y género, y la segunda línea almacenará el nombre de la 
novela.

b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder 
agregar una novela y modificar una existente. Las búsquedas se realizan por 
código de novela. 

NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado.




}


program P1E7;
type
  novela = record
     codigo:integer;
     nombre:String;
     genero:String;
     precio:real;
  end;
  
  archivo = file of novela;
  
  procedure leerNovela(var n:novela);
  begin
    writeln('Ingrese codigo de la novela: ');
    readln(n.codigo);
    writeln('Ingrese precio: ');
    readln(n.precio);
    writeln('Ingrese genero de la novela: ');
    readln(n.genero);
    writeln('Ingrese nombre de la novela: ');
    readln(n.nombre);
  end;
  
  procedure  creacionArcBinario(var txt_Novela:Text; var arc:archivo);
  var n:novela; nom:String;
  begin
      assign(txt_Novela,'novelas.txt');
      writeln(' Ingrese nombre del archivo: ');
      readln(nom);
      assign(arc,nom);
      reset(txt_Novela);
      rewrite(arc);
      while (not EOF(txt_Novela)) do
      begin
          readln(txt_Novela,n.codigo,n.precio,n.genero);
          readln(txt_Novela,n.nombre);
          write(arc,n);
      end;
      close(arc);
      close(txt_Novela);
  end;
  
  procedure agregarNovela(var arc:archivo);
  var n:novela;
  begin
      writeln('          [Menu: Agregar Nueva Novela]          ');
      leerNovela(n);
      reset(arc);
      seek(arc,FileSize(arc));
      write(arc,n);
      close(arc);
  end;
  
  procedure modificarNovela(var arc:archivo);
  var n:novela;  cod:integer; encontre:boolean; opcion:integer; nueCod:integer; nueNom,nueGenero:String; nuePrecio:real;
  begin
      encontre:=false;
      writeln('          [Menu: Modificar Novela Existente]          ');
      writeln('Ingrese novela(codigo) a modificar: ');
      readln(cod);
      reset(arc);
      while ((not EOF(arc)) and (not encontre)) do
      begin
          read(arc,n);
          if (n.codigo = cod) then
          begin
             encontre:=true;
             repeat
               writeln('1. Modificar codigo: ');
               writeln('2. Modificar precio: ');
               writeln('3. Modificar genero: ');
               writeln('4. Modificar nombre: ');
               writeln('5. Ya termine las modificaciones. ');
               write('Ingrese una opción: ');
               readln(opcion);
             
               case opcion of
                1: begin writeln(' Ingrese nuevo Codigo: '); readln(nueCod); n.codigo:=nueCod; seek(arc,FilePos(arc)-1); write(arc,n); end;
                2: begin writeln(' Ingrese nuevo Precio: '); readln(nuePrecio); n.precio:=nuePrecio;seek(arc,FilePos(arc)-1); write(arc,n); end;
                3: begin writeln(' Ingrese nuevo Genero: '); readln(nueGenero); n.genero:=nueGenero; seek(arc,FilePos(arc)-1); write(arc,n);end;
                4: begin writeln(' Ingrese nuevo Nombre: '); readln(nueNom); n.nombre:=nueNom; seek(arc,FilePos(arc)-1); write(arc,n);end;
                5: writeln(' Guardando modificaciones.... ');
               else
                  writeln('Opción inválida, intente nuevamente.');
               end;
             until(opcion = 5);
          end;
      end;
      if (not encontre) then
      begin
        writeln(' La novela de codigo: ', cod,' no esta en el archivo.');
      end
      else  
        writeln(' Modificaciones guardadas correctamente. ');
        close(arc);
  end;
  procedure menu(var arc:archivo; var txt_Novela:Text);
  var
      opcion: integer;
  begin
    repeat
        writeln('--- Menú de Opciones ---');
        writeln('1. Crear archivo y agregar Novelas');
        writeln('2. Modificar Novela');
        writeln('3. Salir del Programa');
        write('Ingrese una opción: ');
        readln(opcion);

        case opcion of
            1: creacionArcBinario(txt_Novela,arc);
            2: modificarNovela(arc);
            3: writeln('Saliendo del programa...');
        else
            writeln('Opción inválida, intente nuevamente.');
        end;
    until opcion = 3;
 end;
var arc:archivo; txt_Novela:Text;
begin
  menu(arc,txt_Novela);
end.