use eci;

/*1. Genera una consulta que obtenga la lista ordenada de todas las referencias sin venta*/
SELECT *
FROM articulo
WHERE not exists (SELECT * FROM ventas WHERE ventas.referencia = articulo.referencia);


/*2.Genera una consulta que obtenga las ventas comprendidas entre 2010 y 2011 (ambos incluidos),
 que estén asociados a una campaña de tipo VENTA y que sean del departamento de JOYERÍA*/
 SELECT *
 FROM ventas ven
 left join articulo art on ven.referencia = art.referencia
 left join departamento dep on dep.id_dpto = art.id_dpto
 left join depto_campania depcam on depcam.id_dpto = dep.id_dpto
 left join campania cam on cam.id_campania = depcam.id_campania
 where dep.desc_dpto = 'JOYERIA'
 and cam.tipo = 'VENTA'
 and year(FECHA_VENTA) between 2010 and 2011;
 
 /*3. Genere una consulta que cree un campo "co_ranking" que clasifique en orden ascendente las campañas según el total de venta, 
 siendo 1 la campaña que más ha vendido y N la que menos. (N = Total de campañas)*/
 
 SET @rank=0;

select result.*,  @rank:=@rank+1 AS coranking from
 (SELECT cam.id_campania, sum(ven.precio)
 FROM ventas ven
 left join articulo art on ven.referencia = art.referencia
 left join departamento dep on dep.id_dpto = art.id_dpto
 left join depto_campania depcam on depcam.id_dpto = dep.id_dpto
 left join campania cam on cam.id_campania = depcam.id_campania
 JOIN (SELECT @row_number := 0) r
 group by cam.id_campania
 order by sum(ven.precio) desc) as result
 ;

/*4. Clasifique todas las ventas en Mayor, Igual o Menor precio respecto a la media de los precios de todas las ventas realizadas.*/
select talon, referencia, precio, fecha_venta, if(precio > MEDIA_PRECIOS, 'MAYOR', if(precio < MEDIA_PRECIOS, 'MENOR', 'IGUAL')) as clasificacion
from ventas ven
left join (select avg(precio) as MEDIA_PRECIOS from ventas) as medias on referencia = referencia