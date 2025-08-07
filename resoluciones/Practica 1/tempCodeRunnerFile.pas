{
4. Agregar al menú del programa del ejercicio 3, opciones para:
 
 
 
 a. Añadir uno o más empleados al final del archivo con sus datos ingresados por
 teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
 un número de empleado ya registrado (control de unicidad).
 
 
 
 b. Modificar la edad de un empleado dado.
 
 
 
 c. Exportar el contenido del archivo a un archivo de texto llamado
 “todos_empleados.txt”.
 
 
 
 d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
 que no tengan cargado el DNI (DNI en 00).
 NOTA: Las búsquedas deben realizarse por número de empleado.
}


program P1E4;
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
     writeln('apellido de empleado:',e.apellido);
     writeln('nombre de empleado:',e.nombre);
     writeln('edad de empleado:',e.edad);
     writeln('DNI de empleado:',e.DNI);
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
  
  procedure agregarEmpleadoAlFinal (var arc_logico:archivo);
    var emple,e:empleado;  cargado:boolean;
    begin
        cargado:=false;
        writeln(' Ingrese numero de empleado a agregar: ');
        readln(emple.numEmple);
        reset(arc_logico);
        while ((not EOF(arc_logico)) and (not cargado)) do 
        begin
            read(arc_logico,e);
            if (e.numEmple = emple.numEmple) then
                cargado:=true;
        end;
        if (not cargado) then
        begin
             writeln(' Ingrese apellido de empleado a agregar: ');
             readln(emple.apellido);
             writeln(' Ingrese nombre de empleado a agregar: ');
             readln(emple.nombre);
             writeln(' Ingrese edad de empleado a agregar: ');
             readln(emple.edad);
             writeln(' Ingrese DNI de empleado a agregar: ');
             readln(emple.DNI);
             seek(arc_logico,FileSize(arc_logico));
             write(arc_logico, emple);
             writeln( 'Empleado agregado correctamente. ');
        end
        else 
           writeln( ' El Empleado ya estaba cargado.');
        close(arc_logico);
    end;
  
    procedure modificarEdadEmple (var arc_logico:archivo);
    var e:empleado; edad,num:integer; encontre:boolean;
    begin
       writeln(' Numero de empleado que se desea cambiar la edad: ');
       readln(num);
       encontre:=false;
       reset(arc_logico);
       while ((not EOF(arc_logico)) and (not encontre)) do
       begin
           read(arc_logico,e);
           if (e.numEmple = num ) then
           begin
               writeln(' Ingrese edad del empleado: ');
               readln(edad);
               e.edad := edad;
               seek(arc_logico, FilePos(arc_logico) - 1);
               write(arc_logico,e);
               encontre := true;
            end;
       end;
       if (not encontre) then
           writeln( ' El empleado no existe. ')
       else  
           writeln('Campo edad se modifico correctamente.');
    end;
    
    procedure exportarTextoEmple(var txt_empleados:Text; var arc_logico:archivo);
    var 
       e:empleado;
    begin
        assign(txt_empleados, 'todos_empleados.txt');
        reset(arc_logico);
        rewrite(txt_empleados);
        while(not EOF(arc_logico)) do
        begin
           read(arc_logico,e);
           write(txt_empleados,' Numero Empleado: ', e.numEmple, ' Apellido: ',e.apellido, ' Nombre: ',e.nombre,' Edad: ',e.edad,' DNI: ', e.DNI, ' ');
           writeln(txt_empleados);
        end;
        close(txt_empleados);
        close(arc_logico);
    end;
    
    procedure exportarEmpleadoSinDNI (var arc_logico:archivo; var txt_Falta:Text );
    var numEmple:integer; e:empleado; encontre:boolean;
    begin
       encontre:=false;
       writeln( ' Ingrese numero de Empleado a buscar: ');
       readln(numEmple);
       reset(arc_logico);
       while ((not EOF(arc_logico)) and not encontre) do
       begin
           read(arc_logico,e);
           encontre:=true;
           if (e.numEmple = numEmple) then
           begin
               if(e.DNI = 00) then
               begin
                   assign(txt_Falta,'faltaDNIEmpleado.txt');
                   rewrite(txt_Falta);
                   writeln(txt_Falta,' Numero Empleado: ', e.numEmple, ' Apellido: ',e.apellido, ' Nombre: ',e.nombre,' Edad: ',e.edad,' DNI: ', e.DNI, ' ');
                   writeln(txt_Falta);
                   writeln(' Se agrego correctamente el empleado sin DNI al archivo de texto. ');
                   close(txt_Falta);
               end
               else 
                   writeln(' El numero de empleado ingresado tiene un DNI cargado.');
           end;
        end;
        if (not encontre) then
           writeln(' No se encontro el empleado. ');
       close(arc_logico);
    end;
  
  procedure menu(var arc_logico:archivo; var txt_empleados: Text; var txt_Falta:Text);
var
  opcion: integer;
begin
  repeat
    writeln('--- Menú de Opciones ---');
    writeln('1. Crear archivo y agregar empleados');
    writeln('2. Buscar empleado por nombre o apellido');
    writeln('3. Listar todos los empleados');
    writeln('4. Listar empleados mayores de 70 años');
    writeln('5. Agregar empledados al final del archivo (si no lo estan). ');
    writeln('6. Modificar la edad de un empleado (si esta en el archivo.');
    writeln('7. Exportar a Archivo de Texto.');
    writeln('8. Exportar a Archivo de Texto de Empleados sin DNI (DNI=00).');
    writeln('9. Salir');
    write('Ingrese una opción: ');
    readln(opcion);

    case opcion of
      1: creacionArchivo(arc_logico);
      2: recorrerArchivoi(arc_logico);
      3: recorrerArchivoii(arc_logico);
      4: recorrerArchivoiii(arc_logico);
      5: agregarEmpleadoAlFinal(arc_logico);
      6: modificarEdadEmple(arc_logico);
      7: exportarTextoEmple(txt_empleados, arc_logico);
      8: exportarEmpleadoSinDNI(arc_logico,txt_Falta);
      9: writeln('Saliendo del programa...');
    else
      writeln('Opción inválida, intente nuevamente.');
    end;
  until opcion = 9;
end;
  
var 
     arc_logico:archivo; txt_empleados: Text; txt_Falta:Text;
begin
     menu(arc_logico, txt_empleados, txt_Falta);
end.