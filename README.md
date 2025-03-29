# SQL-PROJECT-COMPREHENSIVE-MUSIC-STORE-ANALYTICS-EMPLOYEE-CUSTOMER-AND-SALES-INSIGHTS-
![title github](https://github.com/user-attachments/assets/befcbe33-a398-4170-a6ec-54fdf3d3a44a)
## PROJECT DESCRIPTION
This project focuses on analyzing data from various aspects of a music store, utilizing 11 interconnected tables. By exploring the employee, customer, invoice, invoice_line, track, media_type, genre, album, artist, playlist_track, and playlist tables, the project aims to provide insights into sales trends, customer behavior, and employee performance. Key analyses include identifying top-selling albums and tracks, understanding customer preferences, tracking sales by genre, and evaluating the effectiveness of playlists.


## DATABASE SCHEMA IMAGE
![Database Schema](https://github.com/user-attachments/assets/5fa92905-95c4-4a5d-b194-436b367b0fea)
## DATABASE SCHEMA SQL QUERY
```sql
--MEDIA TYPE TABLE
DROP TABLE IF EXISTS media_type;
CREATE TABLE media_type(
	media_type_id SERIAL PRIMARY KEY,
	name VARCHAR(100)
);
--GENRE TABLE
DROP TABLE IF EXISTS genre;
CREATE TABLE genre(
	genre_id SERIAL PRIMARY KEY,
	name VARCHAR(100)
);
--TRACK TABLE
DROP TABLE IF EXISTS track;
CREATE TABLE track (
	track_id SERIAL PRIMARY KEY,
	name VARCHAR(150),
	album_id INT REFERENCES album(album_id) ON DELETE CASCADE ON UPDATE CASCADE,
	media_type_id INT REFERENCES media_type(media_type_id) ON DELETE CASCADE ON UPDATE CASCADE,
	genre_id INT REFERENCES genre(genre_id) ON DELETE CASCADE ON UPDATE CASCADE,
	composer VARCHAR(200),
	miliseconds INT,
	bytes INT,
	unit_price NUMERIC(10,2)
);
--ALBUM TABLE
DROP TABLE IF EXISTS album;
CREATE TABLE album(
	album_id SERIAL PRIMARY KEY,
	title VARCHAR(100),
	artist_id INT REFERENCES artist(artist_id) ON DELETE CASCADE ON UPDATE CASCADE
);
--ARTIST TABLE
DROP TABLE IF EXISTS artist;
CREATE TABLE artist(
	artist_id SERIAL PRIMARY KEY,
	name VARCHAR(100)
);
--PLAYLIST TABLE
DROP TABLE IF EXISTS playlist;
CREATE TABLE playlist(
	playlist_id SERIAL PRIMARY KEY,
	name VARCHAR(100)
);
--PLAYLIST TRACK TABLE
DROP TABLE IF EXISTS playlist_track;
CREATE TABLE playlist_track(
	playlist_id INT REFERENCES playlist(playlist_id) ON DELETE CASCADE ON UPDATE CASCADE,
	track_id INT REFERENCES track(track_id) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (playlist_id,track_id)
);
--INVOICE_LINE TABLE
DROP TABLE IF EXISTS invoice_line;
CREATE TABLE invoice_line (
	invoice_line_id INT PRIMARY KEY,
	invoice_id INT REFERENCES invoice(invoice_id) ON DELETE CASCADE ON UPDATE CASCADE,
	track_id INT REFERENCES track(track_id) ON DELETE CASCADE ON UPDATE CASCADE,
	unit_price NUMERIC(10,2),
	quantity INT
);
--INVOICE TABLE
DROP TABLE IF EXISTS invoice;
CREATE TABLE invoice (
	invoice_id INT PRIMARY KEY,
	customer_id INT REFERENCES customer(customer_ID) ON DELETE CASCADE ON UPDATE CASCADE,
	invoice_date DATE,
	billing_address VARCHAR(50),
	billing_city VARCHAR(50),
	billing_state VARCHAR(10),
	billing_country VARCHAR(20),
	billing_postal_code VARCHAR(20),
	total NUMERIC(10,2)
);
--CUSTOMER TABLE
DROP TABLE IF EXISTS customer;
CREATE TABLE customer (
	customer_id INT PRIMARY KEY,
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	company VARCHAR(100),
	address VARCHAR(100),
	city VARCHAR(100),
	state VARCHAR(10),
	country VARCHAR(50),
	postal_code VARCHAR(20),
	phone VARCHAR(100),
	fax VARCHAR(100),
	email VARCHAR(100),
	support_rep_id INT REFERENCES employee(employee_id) ON DELETE CASCADE ON UPDATE CASCADE
);
--EMPLOYEE TABLE
DROP TABLE IF EXISTS employee;
CREATE TABLE employee (	
	employee_id INT PRIMARY KEY,
	last_name VARCHAR(50),
	first_name VARCHAR(50),
	title VARCHAR(50),
	reports_to INT REFERENCES employee(employee_id) ON DELETE CASCADE ON UPDATE CASCADE,
	levels VARCHAR(10),
	birthdate DATE,
	hire_date DATE,
	address VARCHAR(50),
	city VARCHAR(50),
	state VARCHAR(10),
	country VARCHAR(50),
	postal_code VARCHAR(50),
	phone VARCHAR(30),
	fax VARCHAR(30),
	email VARCHAR(50)
);
```
## BUSINESS QUESTIONS
![set 1 questions](https://github.com/user-attachments/assets/ff82211e-c3c1-4dff-8f79-8063f41c171a)
![set 2 questions](https://github.com/user-attachments/assets/8de5ab0f-4c0f-4d7b-b98f-15a27bbead78)
![set 3 questions](https://github.com/user-attachments/assets/2b0ad143-4eeb-4142-bcda-9766cdfa3fed)

## SET 1: Business Problems and Solutions
### 1). Who is the senior-most employee based on job title? The employee with the highest position.
```sql
SELECT *
FROM employee
ORDER BY levels DESC
limit 1;
```
**Objective:** This query aims to identify the employee who holds the highest position in the organization based on their job title.

### 2). Which countries have the most invoices?
```sql
SELECT billing_country, COUNT(invoice_id) AS count_invoices
FROM invoice
GROUP BY billing_country
ORDER BY count_invoices DESC;
```
**Objective:** The goal is to analyze invoice data and determine which countries have generated the most invoices. This query will help identify which countries are the top markets or have the highest transaction volume for the music store.

### 3). What are the top 3 values of total invoice?
```sql
SELECT total
FROM invoice
ORDER BY total DESC
LIMIT 3;
```
**Objective:** This query is designed to find the top 3 invoices with the highest total value. This helps in identifying the largest sales transactions and gives insights into big-ticket purchases or high-value customers.

### 4). Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the city name and sum of all invoice total
```sql
SELECT billing_city, SUM(total) AS Total_Invoice
FROM invoice
GROUP BY billing_city
ORDER BY Total_Invoice DESC
LIMIT 1;
```
**Objective:** The objective here is to identify the city that has generated the highest total revenue from invoices. This helps determine which city has the highest purchasing power or customer engagement, making it the ideal location for a promotional music festival.

### 5). Who is the best customer? Write a query that returns who has spent the most money.
```sql
SELECT c.customer_id,c.first_name,c.last_name, SUM(total) AS total_amount
FROM invoice AS i
LEFT JOIN customer AS c
	ON i.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY total_amount DESC
LIMIT 1;
```
**Objective:** This query focuses on identifying the customer who has spent the most money in the store. The "best" customer is determined based on their total spending, which provides insight into top customers for loyalty programs or targeted marketing.

## SET 2:Business Problems and Solutions

### 1). Write a Query to return the email, first name, last name and Genre of all Rock Music listeners ordered by email alphabetically
```sql
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
```
**Objective:** The purpose of this query is to find all customers who listen to Rock music. It will extract customer details such as their email, first name, last name, and the genre they prefer (in this case, Rock). The results should be sorted alphabetically by the customer’s email address. This is useful for identifying Rock music listeners and organizing them in a specific order.

### 2). Write a Query that returns the Artist name total track of counts of the top 10 rock bands
```sql
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
```
**Objective:** This query aims to identify the top 10 rock bands (artists) based on the number of tracks they have produced. The result will list each artist's name along with the count of their tracks. This is useful for understanding which artists have contributed the most to the Rock genre in terms of song production. The query likely involves grouping the data by artist and filtering to only include rock genres.

### 3). Return all the track names that have a song length longer than the averagesong length. Return the Name and Miliseconds for each track. Order by the song length with the longest songs listed first
```sql
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
```
**Objective:** The goal of this query is to find all tracks whose song length is longer than the average song length in the database. The query will return the track name and its length (in milliseconds), and the results will be ordered by song length, with the longest songs appearing first. This helps identify the longer tracks in the music catalog and compare them to the average track length.

## SET 3: Business Problems and Solutions

### 1). Find how much amount spent by each customer on the artist that has has earned the most? Write a query to return customer name, artist name and total spent.
```sql
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
```
**Objective:** This query aims to find out how much each customer has spent on the artist who has earned the most money (i.e., the top-earning artist). The result will include the customer's name, the artist's name, and the total amount spent by the customer on that artist. This is useful for identifying loyal customers and understanding spending patterns related to top artists.

### 2). We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres.
```sql
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
```
**Objective:** The objective of this query is to determine the most popular music genre in each country based on the amount of money spent on purchases. The query will return each country along with its most popular genre, and in cases where two or more genres have the same highest total purchase value, it will return all those genres for that country. This is helpful for understanding regional music preferences and tailoring marketing strategies to different countries.

### 3). Write a query that determines the customer that has spent the most on each country. Write a query that returns the country along with the top customer as full name and how much they spent.For countries where the top amount spent is shared, provide all customers who spent this amount.
```sql
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
```
**Objective:** This query aims to identify the top-spending customer for each country, returning the country name, the full name of the top customer, and the total amount they spent. If multiple customers have spent the same highest amount in a country, the query will return all those customers. This information helps identify key high-value customers by country, which can be useful for targeting premium customers and offering specialized promotions.

## INSIGHTS GATHERED:

### The insights gathered from this project help uncover critical information, including:

1). *Customer Preferences:* We identified which music genres and artists are most popular among customers, as well as the geographical regions where certain genres are favored, providing valuable data for targeted marketing and product offerings.

2). *Top-Spending Customers:* By analyzing total purchases, we were able to identify the best customers based on their spending patterns, which can be useful for customer loyalty programs and promotional activities.

3). *High-Performing Employees:* The analysis of employee performance based on sales and customer interaction provided insights into areas where the team could be improved or recognized for excellent work.

4). *Sales Trends and Revenue Insights:* By evaluating total sales, invoice amounts, and customer spending, we were able to pinpoint top-selling albums, tracks, and artists, as well as determine the most profitable cities and countries for the music store.

In summary, this project not only enhances our understanding of customer preferences and behavior but also equips the business with the data needed to optimize its marketing strategies, inventory management, and customer engagement initiatives. The findings will inform decision-making to boost sales, increase customer satisfaction, and ultimately drive the success of the music store in a highly competitive market.













