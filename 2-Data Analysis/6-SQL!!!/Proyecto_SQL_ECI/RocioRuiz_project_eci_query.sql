use eci;

/*1. Genera una consulta que obtenga la lista ordenada de todas las referencias sin venta*/
SELECT *
FROM articulo
WHERE not exists (SELECT * FROM ventas WHERE ventas.referencia = articulo.referencia);


/*2.Genera una consulta que obtenga las ventas comprendidas entre 2010 y 2011 (ambos incluidos),
 que estén asociados a una campaña de tipo VENTA y que sean del departamento de JOYERÍA*/
 SELECT *
 FROM ventas ven
 LEFT JOIN articulo art ON ven.referencia = art.referencia
 LEFT JOIN departamento dep ON dep.id_dpto = art.id_dpto
 LEFT JOIN depto_campania depcam ON depcam.id_dpto = dep.id_dpto
 LEFT JOIN campania cam ON cam.id_campania = depcam.id_campania
 WHERE dep.desc_dpto = 'JOYERIA'
 AND cam.tipo = 'VENTA'
 AND year(FECHA_VENTA) between 2010 and 2011;
 
 /*3. Genere una consulta que cree un campo "co_ranking" que clasifique en orden ascendente las campañas según el total de venta, 
 siendo 1 la campaña que más ha vendido y N la que menos. (N = Total de campañas)*/
 
 SET @rank=0;

SELECT result.*,  @rank:=@rank+1 AS coranking FROM
(SELECT cam.id_campania, sum(ven.precio)
FROM ventas ven
LEFT JOIN articulo art on ven.referencia = art.referencia
LEFT JOIN departamento dep on dep.id_dpto = art.id_dpto
LEFT JOIN depto_campania depcam on depcam.id_dpto = dep.id_dpto
LEFT JOIN campania cam on cam.id_campania = depcam.id_campania
JOIN (SELECT @row_number := 0) r
GROUP BY cam.id_campania
ORDER BY sum(ven.precio) desc) as result;

/*4. Clasifique todas las ventas en Mayor, Igual o Menor precio respecto a la media de los precios de todas las ventas realizadas.*/
SELECT talon, referencia, precio, fecha_venta, if(precio > MEDIA_PRECIOS, 'MAYOR', if(precio < MEDIA_PRECIOS, 'MENOR', 'IGUAL')) as clasificacion
FROM ventas ven
LEFT JOIN (SELECT avg(precio) as MEDIA_PRECIOS FROM ventas) as medias ON referencia = referencia;

/*5.Genere una consulta que para cada campaña de tipo "venta" obtenga el talón medio, precio medio, nº de referencias compradas y
 nº de talones con venta superior al talón medio.*/
SELECT avg(ven.talon) as talon_medio, avg(ven.precio) as precio_medio, count(art.referencia) as num_referencias, sum(if(ven.talon > tmedio.valor, 1, 0)) as mayor_talon_medio
FROM ventas ven
LEFT JOIN articulo art on ven.referencia = art.referencia
LEFT JOIN  departamento dep on dep.id_dpto = art.id_dpto
LEFT JOIN  depto_campania depcam on depcam.id_dpto = dep.id_dpto
LEFT JOIN  campania cam on cam.id_campania = depcam.id_campania
LEFT JOIN  (SELECT avg(v.talon) as valor FROM ventas v) as tmedio on ven.referencia = ven.referencia
WHERE cam.tipo="venta"
GROUP BY cam.id_campania;

/*6.Genere una o varias consultas que devulevan las combinaciones de familias y campañas cuya venta haya sido superior a 100€*/
SELECT art.cod_familia, cam.id_campania,ven.precio
FROM ventas ven
LEFT JOIN articulo art ON ven.referencia = art.referencia
LEFT JOIN departamento dep ON dep.id_dpto = art.id_dpto
LEFT JOIN depto_campania depcam ON depcam.id_dpto = dep.id_dpto
LEFT JOIN campania cam ON cam.id_campania = depcam.id_campania
WHERE ven.precio>100;

/*7.Genere una o varias consultas que permitan catalogar los artículos vendidos y que no son de la Campaña CA1, según si se tratan de 
artículos de Ropa o Accesorios. En base a los departamentos y familias. 
NOTA: Se valorará la elaboración de la consulta y no la veracidad del propio catálogo)*/
SELECT * ,if(desc_dpto= "joyeria", 'accesorios', if(desc_dpto= "bolsos", 'accesorios', 'ropa')) as tipo_articulo
FROM ventas ven
LEFT JOIN articulo art ON  ven.referencia=art.referencia
LEFT JOIN depto_campania ON art.id_dpto=depto_campania.id_dpto
LEFT JOIN departamento dep ON depto_campania.id_dpto=dep.id_dpto
WHERE depto_campania.id_campania!="CA1";

/*8.Genere una o varias consultas que devuelvan la variación del total de venta entre años. Tomando como variación la siguiente fórmula
𝑌𝑒𝑎𝑟𝑛–𝑌𝑒𝑎𝑟𝑛−1𝑌𝑒𝑎𝑟𝑛−1
(Se valorará el control de valores 0 en la división o de indeterminaciones)*/
SELECT year(fecha_venta), sum(precio) as total_ventas, ventas_prev.year2, ventas_prev.total_ventas2, ((sum(precio) - ventas_prev.total_ventas2) / ventas_prev.total_ventas2) as variacion_ventas
FROM ventas ven
LEFT JOIN (SELECT year(fecha_venta) year2, sum(precio) as total_ventas2 FROM ventas GROUP BY year(fecha_venta)) as ventas_prev ON year(ven.fecha_venta) = ventas_prev.year2 + 1
WHERE year2 is not null
GROUP BY year(fecha_venta)
ORDER BY year(fecha_venta);


 