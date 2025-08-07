{

2. El encargado de ventas de un negocio de productos de limpieza desea administrar el stock 
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los 
productos que comercializa. De cada producto se maneja la siguiente información: código de 
producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se 
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De 
cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide 
realizar un programa con opciones para: 

a. Actualizar el archivo maestro con el archivo detalle, sabiendo que: 
● Ambos archivos están ordenados por código de producto. 
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del 
archivo detalle. 
● El archivo detalle sólo contiene registros que están en el archivo maestro. 

b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo 
stock actual esté por debajo del stock mínimo permitido.





}


Program P2E2;

const 
   valorAlto = 9999; 

Type 

   producto = record
         cod:integer; 
         nom:String;
         precio:Real;
         stockA:integer;
         stockM:integer;
   end;

   venta_Producto = record 
         cod:integer;
         cantV:integer;
   end;

   maestro = file of producto ;//        AMBOS ORDENADOS 
   detalle = file of venta_Producto; //      POR CODIGO DE PRODUCTO 


   procedure leerD (var d:detalle; var vP:venta_Producto);
   begin
       if (not EOF(d)) then
             read(d,vP) // tomo el producto del archivo 
       else 
             vP.cod := valorAlto; // Corte
   end;

   procedure leerM (var m:maestro; var p:producto);
   begin
       if (not EOF(m)) then
             read(m,p) // tomo el producto del archivo 
       else 
             p.cod := valorAlto; // Corte
   end;

   procedure actualizarMaestro (var mae:maestro; var det:detalle);
   var 
       p:producto; vProduc:venta_Producto; 
   begin
       reset(det);
       reset(mae);
       leerD(det,vProduc);
       while (vProduc.cod <> valorAlto) do
       begin

             leerM(mae,p);

             while (p.cod <> vProduc.cod) do
             begin
                   leerM(mae,p);
             end;

             while (vProduc.cod = p.cod) do
             begin
                   if (p.stockA <= vProduc.cantV ) then
                   begin
                         p.stockA := 0;
                   end else
                   begin
                       p.stockA := p.stockA - vProduc.cantV;
                   end;

                   leerD(det,vProduc);
             end;
             seek(mae,FilePos(mae)-1);
             write(mae,p);
       end;


      close(mae);
      close(det);

   end;

   procedure pasarDatos (p:producto; var txtS:Text);
   begin
       write(txtS,' Codigo de Producto: ', p.cod, ' Nombre: ', p.nom, ' Precio: ', p.precio:0:2, ' Stock actual: ', p.stockA, ' Stock Minimo: ', p.stockM);
       writeln(txtS);
   end;

   procedure pasarAtxt (var m:maestro; var txtS:Text);
   var 
       p:producto;
   begin
       reset(m);
       leerM(m, p);
       assign(txtS,'stock_minimo.txt');
       rewrite(txtS);
       while(p.cod <> valorAlto) do
       begin
             if (p.stockA < p.stockM) then
             begin
                 pasarDatos(p,txtS);
             end;
             leerM(m, p);
       end;
       close(m);
       close(txtS);
   end; 

   procedure crearMaeYDet(var m: maestro; var d: detalle);
var 
   p: producto;
   v: venta_Producto;
begin
   assign(m, 'archivoMaestro.dat');
   rewrite(m);
   p.cod := 1; p.nom := 'Pan'; p.precio := 100; p.stockA := 10; p.stockM := 5; write(m, p);
   p.cod := 2; p.nom := 'Leche'; p.precio := 200; p.stockA := 3; p.stockM := 5; write(m, p);
   p.cod := 3; p.nom := 'Queso'; p.precio := 500; p.stockA := 7; p.stockM := 5; write(m, p);
   close(m);

   assign(d, 'archivoDetalle.dat');
   rewrite(d);
   v.cod := 1; v.cantV := 4; write(d, v);
   v.cod := 2; v.cantV := 2; write(d, v);
   v.cod := 2; v.cantV := 2; write(d, v); // para que Leche baje a -1 (queda en 0)
   v.cod := 3; v.cantV := 1; write(d, v);
   close(d);
end;

var 
   txtS: Text;
   arc_Detalle: detalle;
   arc_Maestro: maestro;

begin
   crearMaeYDet(arc_Maestro, arc_Detalle);
   actualizarMaestro(arc_Maestro, arc_Detalle);
   pasarAtxt(arc_Maestro, txtS);
   writeln('Se completo la carga de datos al Text. Revisar: "stock_minimo.txt".');
end.