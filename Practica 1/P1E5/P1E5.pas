


program P1E5;
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
         writeln(txt_Celus,c.codigo,' ',c.precio:0:2,c.marca);
         writeln(txt_Celus, c.stockDispo,' ',c.stockMinimo,c.descripcion);
         writeln(txt_Celus,c.nombre);
      end;
      close(txt_Celus);
      close(arc_Celus);
  end;
  
  
  procedure menu (var arc_Celus:archivo; var txt_Celus:Text);
  var  opcion:integer;
  begin
      repeat
        writeln('[--- Menú de Opciones ---]');
        writeln('1. Crear Archivo Binario celulares: ');
        writeln('2. Imprimir Archivo Binario celulares: ');
        writeln('3. Imprimir Celulares Con Stock menor al minimo: ');
        writeln('4. Imprimir Celulares cuya descripcion coincida con la ingresada: ');
        writeln('5. Exportar archivo de texto: ');
        writeln('6. Cerrar programa: ');
        writeln('Ingrese una opción: ');
        readln(opcion);
        
        case opcion of 
          1: CrearArchivoCelu(arc_Celus,txt_Celus);
          2: imprimirArc(arc_Celus);
          3: imprimirMenosQueMinimo(arc_Celus);
          4: imprimirMismaDesc(arc_Celus);
          5: exportarArchivo(arc_Celus,txt_Celus);
          6: writeln('         [-----Cerrando Programa...     ');
        else 
          writeln( 'Opcion invalida, Intente nuevamente.');
        end;
      until (opcion = 6);
  end;
  var  arc_Celus:archivo; txt_Celus:Text;
begin
    menu(arc_Celus,txt_Celus);
end.
