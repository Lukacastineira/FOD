{

6. Agregar al menú del programa del ejercicio 5, opciones para: 
a. Añadir uno o más celulares al final del archivo con sus datos ingresados por 
teclado. 
b. Modificar el stock de un celular dado. 
c. Exportar el contenido del archivo binario a un archivo de texto denominado: 
”SinStock.txt”, con aquellos celulares que tengan stock 0. 
NOTA: Las búsquedas deben realizarse por nombre de celular. 


}


program P1E6;
type
   celular = record 
      codigo:integer;
      precio:real;
      marca:String;
      stockDispo:integer;
      stockMinimo:integer;
      descripcion: String;
      nombre:String;
   end;
   
   archivo = file of celular;

  procedure leerCelu (var c:celular);
  begin
      writeln('Ingrese codigo del celular: ');
      readln(c.codigo);
      writeln('Ingrese precio del celular: ');
      readln(c.precio);
      writeln('Ingrese Marca del celular: ');
      readln(c.marca);
      writeln('Ingrese Stock Disponible del celular: ');
      readln(c.stockDispo);
      writeln('Ingrese Stock Minimo del celular: ');
      readln(c.stockMinimo);
      writeln('Ingrese Descripcion del celular: ');
      readln(c.descripcion);
      writeln('Ingrese Modelo del celular: ');
      readln(c.nombre);
  end;
  procedure CrearArchivoCelu(var arc_Celus:archivo; var txt_Celus:Text);
  var
      c:celular;  nom:String;
  begin
       writeln(' Ingrese nombre del archivo: ');
       readln(nom);
       assign(txt_Celus,'celulares.txt');
       reset(txt_Celus);
       assign(arc_Celus, nom);
       rewrite(arc_Celus);
       while (not EOF(txt_Celus)) do
       begin
           readln(txt_Celus,c.codigo,c.precio,c.marca);
           readln(txt_Celus,c.stockDispo,c.stockMinimo,c.descripcion);
           readln(txt_Celus,c.nombre);
           write(arc_Celus,c);
       end;
       writeln(' Se cargo el Archivo.');
       close(arc_Celus);
       close(txt_Celus);
  end;
  
  procedure imprimirCelu (c:celular);
  begin
      writeln(' Codigo de celular: ', c.codigo);
      writeln(' Precio: ', c.precio:10:2);
      writeln(' Marca: ', c.marca);
      writeln(' Stock Disponible: ', c.stockDispo);
      writeln(' Stock Minimo: ', c.stockMinimo);
      writeln(' Descripcion: ', c.descripcion);
      writeln(' Modelo: ', c.nombre);
  end;
  
  procedure imprimirMenosQueMinimo(var arc_Celus:archivo);
  var  c:celular;
  begin
      reset(arc_Celus);
      while (not EOF(arc_Celus)) do
      begin
          read(arc_Celus,c);
          if (c.stockDispo < c.stockMinimo) then
             imprimirCelu(c); 
      end;
      close(arc_Celus);
  end;
  
  procedure imprimirMismaDesc(var arc_Celus:archivo);
  var c:celular; desc:String;
  begin
      writeln( ' Ingrese Descripcion que desea buscar: ');
      readln(desc);
      reset(arc_Celus);
      while (not EOF(arc_Celus)) do
      begin
          read(arc_Celus,c);
          //if (c.descripcion = desc) then
          //  imprimirCelu(c);
          if Pos(desc, c.descripcion) > 0 then
            imprimirCelu(c);
      end;
      close(arc_Celus);
  end;
  
  procedure imprimirArc(var arc_Celus:archivo);
  var  c:celular;
  begin
      reset(arc_Celus);
      while (not EOF(arc_Celus))do
      begin
          read(arc_Celus,c);
          imprimirCelu(c);
      end;
      close(arc_Celus);
  end;
  
  procedure exportarArchivo (var arc_Celus:archivo; var txt_Celus:Text);
  var c:celular;
  begin
      reset(arc_Celus);
      rewrite(txt_Celus);
      while (not EOF(arc_Celus)) do
      begin
         read(arc_Celus,c);
         writeln(txt_Celus,c.codigo,' ',c.precio:0:2,' ',c.marca);
         writeln(txt_Celus, c.stockDispo,' ',c.stockMinimo,' ',c.descripcion);
         writeln(txt_Celus,c.nombre);
      end;
      writeln('      Archivo Exportado con Exito.      ');
      close(txt_Celus);
      close(arc_Celus);
  end;
  
  procedure agregarCelulares(var arc_Celus:archivo);
  var c:celular; n,i:integer;
  begin
      reset(arc_Celus);
      writeln(' Ingrese cantidad de celulares a agregar: ');
      readln(n);
      for i:=1 to n do
      begin
          leerCelu(c);
          seek(arc_Celus,FileSize(arc_Celus));
          write(arc_Celus,c);
      end;
      close(arc_Celus);
  end;
  
  procedure modificarStockCelu (var arc_Celus:archivo);
  var c:celular; nom:String; encontre: boolean; stock:integer;
  begin
      encontre:=false;
      reset(arc_Celus);
      writeln('Ingrese Modelo de celular a modificar Stock: ');
      readln(nom);
      while ((not EOF(arc_Celus)) and (not encontre)) do
      begin
          read(arc_Celus,c);
          if (c.nombre = nom) then
          begin
              encontre := true;
              writeln(' Ingrese nuevo Stock del celular: ');
              readln(stock);
              seek(arc_Celus,FilePos(arc_Celus)-1);
              c.stockDispo:=stock;
              write(arc_Celus,c);
              writeln(' Se modifico el Stock del ', nom);
          end;
      end;
      if (not encontre) then
              writeln('El modelo ingresado no se encuentra en el archivo.');
      close(arc_Celus);
  end;
  
  procedure txtStockZ(var arc_Celus:archivo; var txt_SinStock:Text);
  var c:celular; i:integer;
  begin
      reset(arc_Celus);
      i:=0;
      while (not EOF(arc_Celus)) do
      begin
          read(arc_Celus,c);
          if (c.stockDispo = 0) then
          begin
              if (i = 0) then
              begin
                assign(txt_SinStock, 'SinStock.txt');
                rewrite(txt_SinStock);
                i:=1;
              end;
              writeln(txt_SinStock,c.codigo,' ',c.precio:0:2,' ',c.marca);
              writeln(txt_SinStock, c.stockDispo,' ',c.stockMinimo,' ',c.descripcion);
              writeln(txt_SinStock,c.nombre);
          end;
      end;
      close(arc_Celus);
      close(txt_SinStock);
  end;
  
  procedure menu (var arc_Celus:archivo; var txt_Celus:Text; var txt_SinStock:Text);
  var  opcion:integer;
  begin
      repeat
        writeln('[--- Menú de Opciones ---]');
        writeln('1. Crear Archivo Binario celulares: ');
        writeln('2. Imprimir Archivo Binario celulares: ');
        writeln('3. Imprimir Celulares Con Stock menor al minimo: ');
        writeln('4. Imprimir Celulares cuya descripcion coincida con la ingresada: ');
        writeln('5. Exportar archivo de texto: ');
        writeln('6. Agregar Celulares a el archivo: ');
        writeln('7. Modificar Stock de un Celular: ');
        writeln('8. Exportar Celulares sin Stock a archivo de texto: ');
        writeln('9. Cerrar programa: ');
        writeln('Ingrese una opción: ');
        readln(opcion);
        
        case opcion of 
          1: CrearArchivoCelu(arc_Celus,txt_Celus);
          2: imprimirArc(arc_Celus);
          3: imprimirMenosQueMinimo(arc_Celus);
          4: imprimirMismaDesc(arc_Celus);
          5: exportarArchivo(arc_Celus,txt_Celus);
          6: agregarCelulares(arc_Celus);
          7: modificarStockCelu(arc_Celus);
          8: txtStockZ(arc_Celus,txt_SinStock);
          9: writeln('         [-----Cerrando Programa...     ');
        else 
          writeln( 'Opcion invalida, Intente nuevamente.');
        end;
      until (opcion = 9);
  end;
  var  arc_Celus:archivo; txt_Celus:Text; txt_SinStock:Text;
begin
    menu(arc_Celus,txt_Celus,txt_SinStock);
end.