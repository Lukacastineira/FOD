{

3. Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado, el cual se proporciona desde el teclado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.

}


program P1E3;
  type
      empleado = record
         numEmple:integer;
         apellido: String[20];
         nombre: String[20];
         edad:integer;
         DNI:integer;
      end;
      archivo = file of empleado; 
      
  procedure iniciarArchivo (var arc_logico: archivo; var arc_fisico:string);   
  begin
      writeln('Ingrese nombre del archivo: ');
      read(arc_fisico);
      assign(arc_logico,arc_fisico);
  end;
  procedure leerEmpleado(var emple:empleado);
  begin
     writeln('Ingrese Empleado: ');
     writeln('Ingrese numero de empleado: ');
     readln(emple.numEmple);
     writeln('Ingrese apellido: ');
     readln(emple.apellido);
     writeln('Ingrese nombre: ');
     readln(emple.nombre);
     writeln('Ingrese edad: ');
     readln(emple.edad);
     writeln('Ingrese DNI: ');
     readln(emple.DNI);
  end;
  
  procedure creacionArchivo(var arc_logico:archivo);
  var
    emple:empleado; arc_fisico:String[30];
  begin
     iniciarArchivo(arc_logico,arc_fisico);
     rewrite(arc_logico);
     leerEmpleado(emple);
     while (emple.apellido <> 'fin') do
     begin
         write(arc_logico, emple);
         leerEmpleado(emple);
     end;
     close(arc_logico);
  end;
  procedure imprimirDatosEmple (e:empleado);
  begin
     writeln('numero de empleado:',e.numEmple);
     writeln('numero de empleado:',e.apellido);
     writeln('numero de empleado:',e.nombre);
     writeln('numero de empleado:',e.edad);
     writeln('numero de empleado:',e.DNI);
  end;
  procedure recorrerArchivoi (var arc_logico:archivo);
  var 
     nom:String[20]; ape:String[20]; e:empleado;
  begin
    writeln(' Ingrese nombre a buscar: ');
    readln(nom);
    writeln(' Ingrese apellido a buscar: ');
    readln(ape);
    reset(arc_logico);
    while (not EOF(arc_logico)) do
    begin
         read(arc_logico,e);
         if ((e.nombre = nom) or (e.apellido=ape)) then
         begin
             imprimirDatosEmple(e);
         end;
    end;
    close(arc_logico);
  end;
  
  procedure recorrerArchivoii (var arc_logico:archivo);
  var
     e:empleado;
  begin
      reset(arc_logico);
      while not EOF(arc_logico) do
      begin
         read(arc_logico,e);
         imprimirDatosEmple(e);
      end;
      close(arc_logico);
  end;
  
  procedure recorrerArchivoiii (var arc_logico:archivo);
  var
     e:empleado;
  begin
      reset(arc_logico);
      writeln(' Empleados prontos a jubilarse: ');
      while not EOF(arc_logico) do
      begin
         read(arc_logico,e);
         if (e.edad > 70) then 
         begin
             imprimirDatosEmple(e);
         end;
      end;
      close(arc_logico);
  end;
  
  procedure menu(var arc_logico:archivo);
var
  opcion: integer;
begin
  repeat
    writeln('--- Menú de Opciones ---');
    writeln('1. Crear archivo y agregar empleados');
    writeln('2. Buscar empleado por nombre o apellido');
    writeln('3. Listar todos los empleados');
    writeln('4. Listar empleados mayores de 70 años');
    writeln('5. Salir');
    write('Ingrese una opción: ');
    readln(opcion);

    case opcion of
      1: creacionArchivo(arc_logico);
      2: recorrerArchivoi(arc_logico);
      3: recorrerArchivoii(arc_logico);
      4: recorrerArchivoiii(arc_logico);
      5: writeln('Saliendo del programa...');
    else
      writeln('Opción inválida, intente nuevamente.');
    end;
  until opcion = 5;
end;
  
var 
     arc_logico:archivo;
begin
     menu(arc_logico);
end.