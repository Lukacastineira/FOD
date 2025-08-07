{

2. Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creado en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.

}


program P1E2;
  type
      archivo = file of integer; 
      
  procedure creacionArchivo (var arc_logico: archivo; var arc_fisico:string);   
  begin
      writeln('Ingrese nombre del archivo: ');
      read(arc_fisico);
      assign(arc_logico,arc_fisico);
  end;
  
  
  procedure agregarAlArchivo(var arc_logico:archivo);
  var
    num:integer;
  begin
     rewrite(arc_logico);
     writeln('Ingrese numero a agregar: ');
     readln(num);
     while (num <>3000) do
     begin
         write(arc_logico, num);
         writeln('Ingrese numero a agregar: ');
         readln(num);
     end;
  end;
  function prom (num:integer; cant:integer):integer;
  begin
    prom:= num div cant;
  end;
  procedure recorrerArchivo (var arc_logico:archivo);
  var 
     total:integer; num:integer; cant:integer;
  begin
    total:=0; cant:=0;
    reset(arc_logico);
    while (not EOF(arc_logico)) do
    begin
         read(arc_logico,num);
         cant:=cant+1;
         writeln(num);
         total := total + num;
    end;
    writeln(' El Promedio de los numeros de archivo es: ', prom(total,cant));
  end;
  
var 
     arc_logico:archivo; arc_fisico:String[30];
begin
     creacionArchivo(arc_logico,arc_fisico);
     agregarAlArchivo(arc_logico);
     recorrerArchivo(arc_logico);
     close(arc_logico);
end.