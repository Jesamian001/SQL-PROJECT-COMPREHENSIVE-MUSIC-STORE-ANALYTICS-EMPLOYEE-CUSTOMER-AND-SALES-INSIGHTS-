--Set 2

/* 1): Write a Query to return the email, first name, last name and Genre
	   of all Rock Music listeners ordered by email alphabetically  */

SELECT * FROM customer; --email,firstname,lastname,customer_id
SELECT * FROM invoice; --customer_id, invoice_id
SELECT * FROM invoice_line; --invoice_id, track_id
SELECT * FROM track; --track_id, genre_id
SELECT * FROM genre; --genre_id, track_id

SELECT DISTINCT
	c.email,
	c.first_name,
	c.last_name
FROM customer AS c
LEFT JOIN invoice AS i
	ON c.customer_id = i.customer_id
LEFT JOIN invoice_line AS iline
	ON i.invoice_id = iline.invoice_id
LEFT JOIN track AS t
	ON t.track_id = iline.track_id
LEFT JOIN genre AS g
	ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
ORDER BY c.email ASC;

	  
/* 2): Write a Query that returns the Artist name total track of counts 
       of the top 10 rock bands  */

SELECT * FROM artist; --artist_id
SELECT * FROM album; --artist_id, album_id
SELECT * FROM track; --album_id, genre_id
SELECT * FROM genre; --genre_id

SELECT
	artist.name,
	COUNT(track_id) AS Total_Track
FROM track AS t
LEFT JOIN genre AS g
	ON t.genre_id = g.genre_id
LEFT JOIN album
	ON album.album_id = t.album_id
LEFT JOIN artist
	ON artist.artist_id = album.artist_id
WHERE g.name = 'Rock'
GROUP BY artist.name
ORDER BY Total_Track DESC
LIMIT 10;

/* 3): Return all the track names that have a song length longer than the average
	   song length. Return the Name and Miliseconds for each track. Order by the 
	   song length with the longest songs listed first */

--Get the average song length of all the songs
SELECT AVG(miliseconds)
FROM track;
--Use the query above to compare the length of each song to the average song length
SELECT name, miliseconds
FROM track
WHERE miliseconds > (
	SELECT AVG(miliseconds) AS average_song_length
	FROM track
)
ORDER BY miliseconds DESC;