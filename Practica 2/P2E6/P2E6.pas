
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

Type

