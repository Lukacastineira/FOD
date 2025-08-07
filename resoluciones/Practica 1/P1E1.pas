{

1. Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. La carga finaliza
cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del
archivo debe ser proporcionado por el usuario desde teclado.

}


program P1E1;
  type
      archivo = file of integer; 
      
  procedure creacionArchivo (var arc_logico: archivo);   
  var
     arc_fisico:string[30];
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
  
var 
     arc_logico:archivo; 
begin
     creacionArchivo(arc_logico);
     agregarAlArchivo(arc_logico);
     close(arc_logico);
end.