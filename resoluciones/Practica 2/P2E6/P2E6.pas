
{

6. Se desea modelar la información necesaria para un sistema de recuentos de casos de covid 
para el ministerio de salud de la provincia de buenos aires.
Diariamente se reciben archivos provenientes de los distintos municipios, la información 
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad de 
casos activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos 
fallecidos. 
El ministerio cuenta con un archivo maestro con la siguiente información: código localidad, 
nombre localidad, código cepa, nombre cepa, cantidad de casos activos, cantidad de casos 
nuevos, cantidad de recuperados y cantidad de fallecidos. 
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles 
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de 
localidad y código de cepa. 

Para la actualización se debe proceder de la siguiente manera:  

1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle. 

2. Idem anterior para los recuperados. 

3. Los casos activos se actualizan con el valor recibido en el detalle. 

4. Idem anterior para los casos nuevos hallados. 

Realice las declaraciones necesarias, el programa principal y los procedimientos que 
requiera para la actualización solicitada e informe cantidad de localidades con más de 50 
casos activos (las localidades pueden o no haber sido actualizadas).


}

program P2P6;


Const
     valorAlto = 9999;
Type
     regMunicipio = record  
         codLocalidad:integer;
         codCepa: integer;
         CasosActivos:integer;
         casosNuevos:integer;
         casosRecuperados:integer;
         casosFallecidos:integer;
     end;

     detalle = File of regMunicipio;

     vecDetalle = array [1..10] of detalle; 
     vecRegDetalle = array [1..10] of regMunicipio;


     regMinisiterioMae = record 
         codLocalidad:integer;
         nomLocalidad:String[30];
         codCepa:integer;
         nomCepa:String[30];
         casosActivos:integer;
         casosNuevos:integer;
         casosRecuperados:integer;
         casosFallecidos:integer;
     end;

     maestro = File of regMinisiterioMae;



     procedure leerD (var d:detalle; var rM:regMunicipio);
     begin
         if (not EOF(d)) then
             read(d,rM)
         else
             rM.codLocalidad := valorAlto;
     end;
     
     procedure leerM (var m:maestro; var rMM:regMinisiterioMae);
     begin
         if(not EOF(m)) then
             read(m,rMM)
        else
             rMM.codLocalidad := valorAlto;
     end;

     procedure minimo (var vD:vecDetalle; var vRd:vecRegDetalle; var min:regMunicipio);
     var 
         i:integer;   ultLeido:integer;
     begin

         min.codLocalidad := valorAlto;
         min.codCepa := valorAlto;

         ultLeido := -1;
         for i:=1 to 10 do
         begin
             if (vRd[i].codLocalidad < valorAlto) then
             begin
                 if(vRd[i].codLocalidad < min.codLocalidad) or ((vRd[i].codLocalidad = min.codLocalidad) and (vRd[i].codCepa < min.codCepa))then
                begin
                     min := vRd[i];
                     ultLeido := i;
                end;
             end;    
         end;
         if (ultLeido <> -1) then
             leerD(vD[ultLeido],vRd[ultLeido]);
     end;

     procedure actualizarMae (var vD: vecDetalle; var m:maestro);
     var 
         i : integer;  vRd:vecRegDetalle; min:regMunicipio; rM:regMinisiterioMae; codLocalidadActual:integer; codCepaActual:integer;
         totalFallecidos:integer;  totalRecuperados:integer; totalActivos:integer; totalNuevos:integer; 
     begin
         for i:= 1 to 10 do
             reset(vD[i]);
         reset(m);

         for i:= 1 to 10 do
             leerD(vD[i],vRd[i]);

         minimo(vD,vRd,min);
         leerM(m,rM);


         while (min.codLocalidad <> valorAlto) do
         begin
             codLocalidadActual := min.codLocalidad;
             codCepaActual := min.codCepa;

             totalFallecidos:=0; 
             totalRecuperados:=0;
             totalActivos:=0;
             totalNuevos:=0;


             while (rM.codLocalidad <> min.codLocalidad) and (rM.codLocalidad <> valorAlto) do
             begin
                 leerM(m,rM);
                 while (rM.codCepa <> min.codCepa) do
                     leerM(m,rM);
             end;

             while ((codLocalidadActual = min.codLocalidad) and (codCepaActual = min.codCepa)) do
             begin
                 totalFallecidos := totalFallecidos + min.casosFallecidos;
                 totalRecuperados := totalRecuperados + min.casosRecuperados;
                 totalActivos := totalActivos + min.casosActivos;
                 totalNuevos := totalNuevos + min.casosNuevos;

                 minimo(vD,vRd,min);
             end;

             seek(m,FilePos(m)-1);

             rM.casosActivos := totalActivos;
             rM.casosNuevos := totalNuevos;
             rM.casosFallecidos := rM.casosFallecidos + totalFallecidos;
             rM.casosRecuperados := rM.casosRecuperados + totalRecuperados;


             write(m,rM);
         end;
        
        
         
         for i:= 1 to 10 do
             close(vD[i]);
         close(m);
     end;

     procedure calcularLocalidadesMas (var m:maestro);
     var 
         rM:regMinisiterioMae;  cantLocalidadesMas:integer;
     begin
         reset(m);
         cantLocalidadesMas:=0;
         while (rM.codLocalidad <> valorAlto) do
         begin
             if (rM.casosActivos > 50) then
                 cantLocalidadesMas := cantLocalidadesMas + 1;
         end;
          writeln('La cantidad de localidades con mas de 50 casos activos es: ', cantLocalidadesMas);
         close(m);
     end;



     var 
         vectorDetalle : vecDetalle; arc_Maestro:maestro; 
     begin
         actualizarMae(vectorDetalle,arc_Maestro);
         calcularLocalidadesMas(arc_Maestro);
     end.