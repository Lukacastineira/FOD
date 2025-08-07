{


1. Una empresa posee un archivo con información de los ingresos percibidos por diferentes 
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado, 
nombre y monto de la comisión. La información del archivo se encuentra ordenada por 
código de empleado y cada empleado puede aparecer más de una vez en el archivo de 
comisiones.  
Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En 
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una 
única vez con el valor total de sus comisiones. 

NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser 
recorrido una única vez. 


}  

Program P2E1;

const 
     valorAlto =  -1;
Type

  empleado = record
    cod: integer;
    nombre: string[20];
    comision: real;
  end;

  archivo = file of empleado;

  procedure CompletarArchivo (var a: archivo);
    var 
        i: integer; e: empleado;
    begin
       assign(a, 'empleados.dat');
       rewrite(a);
       e.cod:=1;
       e.nombre := 'Empleado'; 
       e.comision := 1000.0;
       write(a, e);  
       for i:=1 to 10 do begin
          e.cod := i;
          e.nombre := 'Empleado';
          e.comision := i * 1000.0;
          write(a, e);
       end;
       close(a);
    end;

   procedure leerArchivo (var a: archivo; var e: empleado); 
      begin
         if (not eof(a)) then begin
             read(a, e);
         end else begin
             e.cod := valorAlto;
         end;
      end;

   procedure compactarArchivo (var detalle: archivo; var mae: archivo);
      var
          regD,regMae:empleado; total:real; empleAct:integer; nomAct:String; 
      begin
         reset(detalle);
         assign(mae, 'maestro.dat');
         rewrite(mae);
         leerArchivo(detalle,regD);  // leo el primer empleado o comision..
         while (regD.cod <> valorAlto) do
         begin
             empleAct := regD.cod; nomAct:= regD.nombre;
             total:= 0;
             while (empleAct = regD.cod) do  // mientras sea el mismo empleado.
             begin
                total:= total + regD.comision;
                leerArchivo(detalle,regD);
             end; // end del while de mismo empleado.
             regMae.cod := empleAct;
             regMae.nombre := nomAct;
             regMae.comision := total;;
             write(mae,regMae);
         end; // end del primer while.
         close(detalle);
         close(mae);
      end;

      var 
        detalle:archivo; maestro:archivo; 
      begin
        CompletarArchivo(detalle);
        compactarArchivo(detalle,maestro);
      end.