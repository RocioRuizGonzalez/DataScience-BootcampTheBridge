/*Ejercicio Chinook SQL*/

/*Ejer 1*/
SELECT DISTINCT Country
FROM customer;

SELECT *
FROM customer
WHERE Country="Brazil";

/*Ejer 2*/
SELECT DISTINCT Title
FROM employee;

SELECT *
FROM employee
WHERE Title="Sales Support Agent";

/* Ejer 3*/
 SELECT *
 FROM track;
 
  SELECT *
 FROM track
 WHERE Composer="AC/DC";
 
 /*Ejer 4*/
 SELECT Country
 FROM customer;
 
SELECT *
FROM customer
WHERE Country!="USA";

/*Ejer 5*/
SELECT LastName,FirstName,City,State,Country,Email
FROM employee
WHERE Title="Sales Support Agent";

/*Ejer 6*/
SELECT DISTINCT BillingCountry
FROM invoice; 

/*Ejer 7*/
SELECT DISTINCT STATE
FROM customer
WHERE Country ="USA";

/*Ejer 8*/
SELECT *
FROM invoiceline
WHERE InvoiceId="37";

/*Ejer 9*/
 SELECT *
 FROM track
 WHERE Composer="AC/DC";
 
 /*Ejer 10*/
SELECT InvoiceLineId,count(Quantity)
FROM invoiceline
GROUP BY InvoiceLineId;

/*Ejer 11*/
SELECT BillingCountry,count(InvoiceId)
FROM invoice
group by BillingCountry;

/*Ejer 12*/
SELECT InvoiceId,Year(InvoiceDate)
FROM invoice
where Year(InvoiceDate)=2009 or Year(InvoiceDate)=2011;

/*Ejer 13*/
SELECT InvoiceId,Year(InvoiceDate)
FROM invoice
where Year(InvoiceDate) between 2009 and 2011;

/*Ejer 14*/
SELECT Country, count(CustomerId)
FROM customer
WHERE Country ="Spain" or Country ="Brazil"
GROUP BY Country;

/*Ejer 15*/
SELECT Name
FROM track
where Name LIKE "You%";

/*SEGUNDA PARTE*/

/*Ejer 1:Facturas de Clientes de Brasil, Nombre del cliente, Id de factura, fecha de la factura y el pais de la factura*/
SELECT customer.CustomerId,customer.FirstName,customer.LastName,customer.Country,invoice.InvoiceId,invoice.InvoiceDate,invoice.BillingCountry
FROM customer
LEFT JOIN invoice
ON customer.CustomerId = invoice.CustomerId
WHERE Country="Brazil";

/*Ejer 2:Facturas de Clientes de Brasil*/
SELECT *
FROM invoice
WHERE BillingCountry ="Brazil";

/*Ejer 3: Muestra cada factura asociada a cada agente de ventas con su nombre completo*/
SELECT customer.CustomerId,customer.FirstName,customer.LastName,customer.SupportRepId,employee.FirstName,employee.LastName,invoice.InvoiceId
FROM customer
LEFT JOIN invoice
ON customer.CustomerId=invoice.CustomerId
LEFT JOIN employee
ON customer.SupportRepId=employee.EmployeeId;


/*Ejer 4: Muestra el nombre del cliente, el pais, el nombre del agente y el total*/
SELECT customer.FirstName,customer.LastName,customer.Country,customer.SupportRepId,employee.FirstName,employee.LastName,invoice.Total
FROM customer
LEFT JOIN invoice
ON customer.CustomerId =invoice.CustomerId
LEFT JOIN employee
ON customer.SupportRepId=employee.EmployeeId;

/*Ejer 5:Muestra cada articulo de la factura con el nombre de la cancion*/
SELECT invoiceline.InvoiceLineId,invoiceline.TrackId,track.Name
FROM invoiceline
LEFT JOIN track
ON invoiceline.TrackId=track.TrackId;

/*Ejer 6: Muestra todas las conciones con su nombre, formato, album y genero*/
SELECT track.TrackId,track.Name,track.AlbumId,album.Title as Album,track.MediaTypeId,mediatype.Name as formato,track.GenreId,genre.Name as genero
FROM track
LEFT JOIN album
ON track.AlbumId=album.AlbumId
LEFT JOIN mediatype
ON track.MediaTypeId=mediatype.MediaTypeId
LEFT JOIN genre
ON track.GenreId=genre.GenreId;

/*Ejer 7: Muestr a cuantas canciones hay en cada playlist y el nombre de cada playlist*/
SELECT playlist.Name as PlaylistName,count(playlisttrack.TrackId) as PlaylistSongs
FROM playlist
LEFT JOIN playlisttrack
ON playlist.PlaylistId=playlisttrack.PlaylistId
GROUP BY playlist.Name;

/*Ejer 8: Muestra cuánto ha vendido cada empleado*/
SELECT CONCAT(employee.LastName," ",employee.FirstName),sum(invoice.total)
FROM customer
LEFT JOIN employee
ON customer.SupportRepId=employee.EmployeeId
LEFT JOIN invoice
ON customer.CustomerId=invoice.CustomerId
GROUP BY 1

/*Ejer 9:Quien ha sido el agente de ventas que más ha vendido en 2009?*/

SELECT total.Name, max(total.Totalsale)
FROM (SELECT CONCAT(employee.LastName, " ",employee.FirstName) as "Name",sum(invoice.total) as Totalsale
	FROM customer
	LEFT JOIN employee
	ON customer.SupportRepId=employee.EmployeeId
	LEFT JOIN invoice
	ON customer.CustomerId=invoice.CustomerId
	WHERE Year(invoice.InvoiceDate)=2009
	GROUP BY 1) total
    ORDER BY 2 DESC
    LIMIT 1;

/*Ejer 10: Quien es son los 3 grupos que más han vendido?*/
SELECT artist.Name,sum(invoice.Total)
FROM invoice
LEFT JOIN invoiceline
ON invoice.InvoiceId=invoiceline.InvoiceId
LEFT JOIN track
ON  invoiceline.TrackId=track.TrackId
LEFT JOIN album
ON track.AlbumId=album.AlbumId
LEFT JOIN artist
ON artist.ArtistId=album.ArtistId
GROUP BY artist.Name
ORDER BY 2 DESC
LIMIT 3;

















