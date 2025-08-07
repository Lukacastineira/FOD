
{

4. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados. 
De cada producto se almacena: código del producto, nombre, descripción, stock disponible, 
stock mínimo y precio del producto. 
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se 
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo 
maestro. La información que se recibe en los detalles es: código de producto y cantidad 
vendida. Además, se deberá informar en un archivo de texto: nombre de producto, 
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por 
debajo del stock mínimo. Pensar alternativas sobre realizar el informe en el mismo 
procedimiento de actualización, o realizarlo en un procedimiento separado (analizar 
ventajas/desventajas en cada caso). 

Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle 
puede venir 0 o N registros de un determinado producto.


}

Program P2E4;

Const
     valorAlto = 9999;
Type 

     producto = record
         cod : integer;
         nom: String[20];
         desc: String[70];
         stockD: integer;
         stockM: integer;
         precio: real;
     end;

     producDetalle = record 
        cod:integer;
        cantV:integer;
     end;

     maestro = File of producto; 
   
     detalle = File of producDetalle;

     vecDetalle = array [1..30] of detalle;

     procedure leerM (var m:maestro; var p:producto);
     begin
         if (not EOF(m)) then
             read(m,p)
         else
             p.cod := valorAlto;
     end;

     procedure  leerD (var d:detalle; var pD:producDetalle);
     begin 
         if (not EOF(d)) then
             read(d,pD)
         else
             pD.cod := valorAlto;
     end;
     procedure actualizarMae (var vD:vecDetalle; var m:maestro; var txtStock:Text );
     var
         p: producto;  pD:producDetalle; i:integer;  totalStock:integer;
     begin
         assign(txtStock, 'stock_minimo.txt');
         rewrite(txtStock);
         for i:=1 to 30 do
         begin
             reset(m);
             reset(vD[i]);
             leerD(vD[i],pD);
             
             while (pD.cod <> valorAlto) do 
             begin

                 totalStock := 0;

                 leerM(m,p);

                 while (p.cod <> pD.cod) do
                     leerM(m,p);   

                 while (pD.cod = p.cod ) do
                 begin
                     totalStock := totalStock + pD.cantV;
                     leerD(vD[i],pD);
                 end;
                 if (p.stockD <= totalStock) then
                 begin
                     if (p.stockD > 0) then 
                         p.stockD := 0
                     else 
                         p.stockD := -1;
                 end
                 else
                     p.stockD := p.stockD - totalStock;
                 if(p.stockD > -1) then
                 begin
                     seek(m, FilePos(m)-1);
                     write(m,p);

                     write(txtStock,'Producto: ',p.nom, ' Descripcion: ', p.desc, ' stock disponible: ', p.stockD, ' Precio: ', p.precio:0:2 );
                     writeln(txtStock);
                 end;
             end;
             close(vD[i]);    
             {
               Es posible el hacer el informe y completar archivo de texto en el procedimiento pero 
               seria muy ineficiente, tambien podria llegar a evitar productos por ejemplo los que no 
               estan en los detalles (no lo especifica), la ventaja es que recorreria una sola vez
               la estructura.
             }      
 
         end;
         close(m);
         close(txtStock);
     end;

     var 
        vD:vecDetalle; mae:maestro; txtStock:Text;
    begin
         actualizarMae(vD,mae,txtStock);
    end.