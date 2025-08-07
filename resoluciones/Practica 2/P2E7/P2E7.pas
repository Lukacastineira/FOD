{ 

7. Se dispone de un archivo maestro con información de los alumnos de la Facultad de 
Informática. Cada registro del archivo maestro contiene: código de alumno, apellido, nombre, 
cantidad de cursadas aprobadas y cantidad de materias con final aprobado. El archivo 
maestro está ordenado por código de alumno. 

Además, se tienen dos archivos detalle con información sobre el desempeño académico de 
los alumnos: un archivo de cursadas y un archivo de exámenes finales. El archivo de 
cursadas contiene información sobre las materias cursadas por los alumnos. Cada registro 
incluye: código de alumno, código de materia, año de cursada y resultado (solo interesa si la 
cursada fue aprobada o desaprobada). Por su parte, el archivo de exámenes finales 
contiene información sobre los exámenes finales rendidos. Cada registro incluye: código de 
alumno, código de materia, fecha del examen y nota obtenida. Ambos archivos detalle 
están ordenados por código de alumno y código de materia, y pueden contener 0, 1 o 
más registros por alumno en el archivo maestro. Un alumno podría cursar una materia 
muchas veces, así como también podría rendir el final de una materia en múltiples 
ocasiones. 

Se debe desarrollar un programa que actualice el archivo maestro, ajustando la cantidad 
de cursadas aprobadas y la cantidad de materias con final aprobado, utilizando la 
información de los archivos detalle. Las reglas de actualización son las siguientes: 

● Si un alumno aprueba una cursada, se incrementa en uno la cantidad de cursadas 
aprobadas. 

● Si un alumno aprueba un examen final (nota >= 4), se incrementa en uno la cantidad 
de materias con final aprobado. 
Notas: 

● Los archivos deben procesarse en un único recorrido. 

● No es necesario comprobar que no haya inconsistencias en la información de los 
archivos detalles. Esto es, no puede suceder que un alumno apruebe más de una 
vez la cursada de una misma materia (a lo sumo la aprueba una vez), algo similar 
ocurre con los exámenes finales.

}

Program P2E7;

Const 
     valorAlto = 9999  ;

Type
     alumno = record 
         codAlumno:integer;
         nomApellido:String[30];
         cursadasAprobadas:integer;
         materiasAprobadas:integer;
     end;

     maestro = File of alumno; 

     materia = record 
         codAlumno:integer;
         codMateria:integer;
         anio:integer;
         aprobado:boolean;
     end;

     detalleCursada = File of materia;

             // ordenados por codigo de alumno y de materia  
             //0, 1 o más registros por alumno en el archivo maestro
     final = record
         codAlumno:integer;
         codMateria:integer;
         fecha:integer;
         nota:integer;
     end;

     detalleFinales = File of final;
     

     regFacu = record
         codAlumno:integer;
         codMateria:integer;
         fecha:integer;
         aprobado:boolean;
         f:boolean;
     end; 

procedure leerFinales(var d: detalleFinales; var f: final);
begin
  if (not EOF(d)) then
    read(d, f)
  else
    f.codAlumno := valorAlto;
end;

procedure leerCursada(var d: detalleCursada; var c: materia);
begin
  if (not EOF(d)) then
    read(d, c)
  else
    c.codAlumno := valorAlto;
end;

procedure minimo(var rCombinado: regFacu; var dF: detalleFinales; var dC: detalleCursada);
var
     f: final;
     c: materia;
begin
     leerFinales(dF, f);
     leerCursada(dC, c);

     if (f.codAlumno = valorAlto) and (c.codAlumno = valorAlto) then
     begin
         rCombinado.codAlumno := valorAlto;
     end
     else if (c.codAlumno = valorAlto) or ((f.codAlumno < c.codAlumno) or ((f.codAlumno = c.codAlumno) and (f.codMateria <= c.codMateria))) then
     begin
     // Elegimos Final
         rCombinado.codAlumno := f.codAlumno;
         rCombinado.codMateria := f.codMateria;
         rCombinado.fecha := f.fecha;
         if (f.nota >= 4) then rCombinado.aprobado := true
         else 
             rCombinado.aprobado := false;  // o lo que tenga sentido en tu contexto
         rCombinado.f := true;
     end
     else
     begin
     // Elegimos Cursada
         rCombinado.codAlumno := c.codAlumno;
         rCombinado.codMateria := c.codMateria;
         rCombinado.fecha:= c.anio;
         rCombinado.aprobado := c.aprobado;
         rCombinado.f := false;
     end;
end;


procedure actualizarMae (var dF:detalleFinales; var dC:detalleCursada; var mae:maestro);
var 
     rCombinado:regFacu; codAluAct:integer; codMateAct:integer; cantTotalFinales:integer; cantTotalCursadas:integer; maeR:alumno;
begin
     reset(mae);
     reset(dF);
     reset(dC);
     minimo(rCombinado,dF,dC);
     read(mae, maeR);
     codAluAct := rCombinado.codAlumno;
     while (rCombinado.codAlumno <> valorAlto)  do
     begin 

         codAluAct := rCombinado.codAlumno;
         cantTotalCursadas:=0;
         cantTotalFinales:=0;

         while (rCombinado.codAlumno <> valorAlto) and (codAluAct = rCombinado.codAlumno) do
         begin

             codMateAct := rCombinado.codMateria;

             while (not EOF(mae)) and (maeR.codAlumno <> rCombinado.codAlumno) do // busco el alumno en el maestro
                 read(mae,maeR);
 

             while (rCombinado.codAlumno <> valorAlto) and (codAluAct = rCombinado.codAlumno) and (codMateAct = rCombinado.codMateria) do
             begin
                 if(rCombinado.f) then
                 begin
                     if(rCombinado.aprobado) then
                         cantTotalFinales := cantTotalFinales + 1;
                 end
                 else
                 begin
                     if(rCombinado.aprobado) then
                         cantTotalCursadas := cantTotalCursadas + 1;
                 end;
                 minimo(rCombinado,dF,dC);
             end; // end codMateria
         end; // end codALumno
         seek(mae,FilePos(mae)-1);

         maeR.cursadasAprobadas := maeR.cursadasAprobadas + cantTotalCursadas;
         maeR.materiasAprobadas := maeR.materiasAprobadas + cantTotalFinales;
         write(mae,maeR);

     end; // end valor alto

     close (mae);
     close(dF);
     close(dC);
end;


var

        dF:detalleFinales;  dC:detalleCursada; mae:maestro;

begin
     actualizarMae (dF, dC, mae);
end.