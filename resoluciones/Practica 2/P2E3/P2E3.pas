{

3. A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un 
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas 
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos 
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de 
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos 
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle. 

NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle      
pueden venir 0, 1 ó más registros por cada provincia.

}


Program P2E3;

Const 
     valorAlto='ZZZZ';
Type
     datoMae = record   
         nomProvincia: String[20];
         cantAlfabetizados: integer;
         totalEncuestados: integer;
     end;

     datoDet = record
         nomProvincia: String[20];
         codLocalidad: integer;
         cantAlfabetizados: integer;
         cantEncuestados: integer;
     end;

     maestro = file of datoMae;

     detalle = file of datoDet;

     procedure leerM (var m:maestro; var dat:datoMae);
     begin
        if (not EOF(m)) then
             read(m,dat)
        else 
             dat.nomProvincia := valorAlto;
     end;

     procedure leerD (var d:detalle; var dat:datoDet);
     begin
        if (not EOF(d)) then
             read(d,dat)
        else 
             dat.nomProvincia:= valorAlto;
     end;
      
     procedure minimo (var det1,det2: detalle; var datDet1,datDet2: datoDet; var min:datoDet );
     begin
         if (datDet1.nomProvincia <= datDet2.nomProvincia) then
         begin
             min:= datDet1;
             leerD(det1,datDet1);   { Leemos el siguiente registro de det1 }
         end 
         else begin
             min := datDet2;
             leerD(det2,datDet2);  { Leemos el siguiente registro de det2 }
         end;
     end;

     procedure actualizarMae (var m:maestro; var d1:detalle; var d2:detalle);
     var 
         datMae:datoMae;  datDet1,datDet2,min:datoDet;  provAct:String[20]; totalEncuestados:integer; totalAlfabetizados:integer;
     begin
         reset(m);
         reset(d1);
         reset(d2);
         leerD(d1,datDet1);
         leerD(d2,datDet2);
         minimo(d1,d2,datDet1,datDet2,min);
         while (min.nomProvincia <> valorAlto) do 
         begin
             totalAlfabetizados:=0;
             totalEncuestados:=0;
             provAct := min.nomProvincia;
             leerM(m,datMae);
             while (datMae.nomProvincia <> provAct) do
                 leerM(m,datMae);
             while (min.nomProvincia = datMae.nomProvincia) do
             begin
                 totalEncuestados := totalEncuestados + min.cantEncuestados;
                 totalAlfabetizados:= totalAlfabetizados + min.cantAlfabetizados;
                 minimo(d1,d2,datDet1,datDet2,min);
             end;
             seek(m,FilePos(m)-1);
             datMae.cantAlfabetizados:= totalAlfabetizados;
             datMae.totalEncuestados:= totalEncuestados;
             write(m,datMae);
         end;
     end;
     var 
        m:maestro; d1,d2: detalle;
     begin
         actualizarMae(m,d1,d2);
     end.