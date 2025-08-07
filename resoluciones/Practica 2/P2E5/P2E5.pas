{

5. Suponga que trabaja en una oficina donde está montada una  LAN (red local). La misma fue 
construida sobre una topología de red que conecta 5 máquinas entre sí y todas las 
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un 
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por 
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos: 
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos 
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha, 
tiempo_total_de_sesiones_abiertas. 

Notas: 

● Cada archivo detalle está ordenado por cod_usuario y fecha. 

● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o 
inclusive, en diferentes máquinas.  

● El archivo maestro debe crearse en la siguiente ubicación física:  /var/log. 


}

Program P2E5;

Const
     valorAlto = 9999;
Type 

     log = record 
        cod_usuario:integer;
        fecha:integer;
        tiempo_sesion:integer;
     end;
     
     vecRegD = array [1..5] of log;

     detalle = File of log;
     vecDetalle  = array [1..5] of detalle;
     
     maestro = File of log;

     procedure leerD (var d:detalle; var l:log);
     begin
         if (not EOF(d)) then
             read(d,l)
         else 
             l.cod_usuario := valorAlto;
     end;

     procedure minimo (var vD:vecDetalle;var vRd:vecRegD; var min:log );
     var 
         i:integer; ultLeido:integer;
     begin

         min.cod_usuario := valorAlto;
         min.fecha := valorAlto;

         ultLeido:=-1;
         for i:= 1 to 5 do
         begin
             if (vRd[i].cod_usuario <> valorAlto)  then
             begin
                 if (vRd[i].cod_usuario < min.cod_usuario) or ((vRd[i].cod_usuario = min.cod_usuario) and (vRd[i].fecha < min.fecha)) then
                 begin
                   min:=vRd[i];
                   ultLeido:=i;
                 end;
             end;
         end;

         if (ultLeido <> -1) then
             leerD(vD[ultLeido], vRd[ultLeido]);

     end;

     procedure completarMaestro (var vD:vecDetalle; var m:maestro);
     var
        vRd:vecRegD; logM:log; i:integer; min:log; codActual:integer; fechaActual:integer; totalSesionesFecha:integer;
     begin
         for i:=1 to 5 do
             reset(vD[i]);
             leerD(vD,vRd[i]);

         assign(m,'/var/log/maestro.dat');
         rewrite(m);
         minimo(vD,vRd,min);
         
         while (min.cod_usuario <> valorAlto) do
         begin
             codActual := min.cod_usuario;
             fechaActual := min.fecha;
             totalSesionesFecha := 0;
                 while (min.cod_usuario = codActual) and (min.fecha = fechaActual) do
                 begin
                     totalSesionesFecha := totalSesionesFecha + min.tiempo_sesion;
                     minimo(vD,vRd,min);
                 end;
             logM.cod_usuario := codActual;
             logM.fecha := fechaActual;
             logM.tiempo_sesion := totalSesionesFecha;
             write(m,logM);
         end;
         close(m);
         for i:=1 to 5 do
             close(vD[i]);
     end;

     var 
        vD:vecDetalle; mae:maestro;
     begin
         completarMaestro(vD,mae);
     end.