--SET 3

/* 1): Find how much amount spent by each customer on the artist that has has earned the most? 
	   Write a query to return customer name, artist name and total spent.  */

SELECT * FROM customer; --first_name, last_name, customer_id
SELECT * FROM invoice; --customer_id, invoice_id
SELECT * FROM invoice_line; --invoice_id, track_id
SELECT * FROM track; --track_id, album_id
SELECT * FROM album; --album_id, artist_id
SELECT * FROM artist; --artist_id, name

/* Get the artist who has earned the most. Also select the artist's artist_id 
   As it will be used to inner join. 
*/
WITH Best_Selling_Artist AS (
SELECT
	artist.artist_id,
	artist.name,
	SUM((iline.unit_price * iline.quantity)) AS total_price
FROM invoice_line AS iline
LEFT JOIN track AS t
	ON iline.track_id = t.track_id
LEFT JOIN album
	ON album.album_id = t.album_id
LEFT JOIN artist
	ON artist.artist_id = album.artist_id
GROUP BY artist.name, artist.artist_id
ORDER BY total_price DESC
LIMIT 1
),
/* Get the first_name,last_name,artist_id,artist_name and the amount spent by each customer
   on artist.
*/ 
Amount_Spent_Customer AS (
SELECT
	c.first_name AS first_name,
	c.last_name AS last_name,
	artist.artist_id,
	artist.name AS artist_name,
	SUM((iline.unit_price * iline.quantity)) AS total_spent
FROM invoice_line AS iline
LEFT JOIN track AS t
	ON iline.track_id = t.track_id
LEFT JOIN album
	ON album.album_id = t.album_id
LEFT JOIN artist
	ON artist.artist_id = album.artist_id
LEFT JOIN invoice AS i
	ON i.invoice_id = iline.invoice_id
LEFT JOIN customer AS c
	ON c.customer_id = i.customer_id
GROUP BY c.first_name,c.last_name,artist.name,artist.artist_id
)
/* Use Inner Join in order to return just the artist who has earned the most
*/ 
SELECT
	a.first_name,
	a.last_name,
	a.artist_name,
	a.total_spent
FROM Amount_Spent_Customer AS a
INNER JOIN Best_Selling_Artist AS b
	ON a.artist_id = b.artist_id
ORDER BY total_spent DESC;

/* 2): We want to find out the most popular music Genre for each country. We determine
	   the most popular genre as the genre with the highest amount of purchases. Write a 
	   query that returns each country along with the top Genre. For countries where the 
	   maximum number of purchases is shared return all Genres. */

SELECT * FROM genre; --name, genre_id
SELECT * FROM track; --genre_id, track_id
SELECT * FROM invoice_line; --track_id, invoice_id
SELECT * FROM invoice; --invoice_id, billing country

WITH CTE AS(
SELECT
	c.country AS country,
	g.name AS genre,
	g.genre_id AS genre_id,
	COUNT(*) AS number_purchases,
	RANK() OVER(PARTITION BY c.country ORDER BY COUNT(*) DESC) AS ranking
FROM invoice_line AS iline
INNER JOIN invoice AS i
	ON iline.invoice_id = i.invoice_id
INNER JOIN customer AS c
	ON c.customer_id = i.customer_id
INNER JOIN track AS t
	ON t.track_id = iline.track_id
INNER JOIN genre AS g
	ON g.genre_id = t.genre_id
GROUP BY country,genre,g.genre_id
ORDER BY country ASC, number_purchases DESC
)
SELECT 
	country,
	genre,
	genre_id,
	number_purchases,
	ranking
FROM CTE
WHERE ranking = 1;


/* 3): Write a query that determines the customer that has spent the most on each country.
	   Write a query that returns the country along with the top customer as full name 
	   and how much they spent.For countries where the top amount spent is shared, 
	   provide all customers who spent this amount. */
WITH CTE AS (
SELECT
	c.customer_id AS customer_id,
	c.country AS country,
	CONCAT(c.first_name,' ',c.last_name) AS Full_Name,
	SUM(i.total) AS Amount_Spent,
	RANK() OVER(PARTITION BY c.country ORDER BY SUM(i.total) DESC) AS ranking
FROM invoice AS i
LEFT JOIN customer AS c
	ON c.customer_id = i.customer_id
GROUP BY country,Full_Name,c.customer_id
ORDER BY c.country ASC, Amount_Spent DESC
)
SELECT
	customer_id,
	Full_Name,
	country,
	Amount_Spent
FROM CTE
WHERE ranking = 1;




	   





	  