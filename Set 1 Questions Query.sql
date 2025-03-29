--Set 1
--1) Who is the senior most employee based on job title? The employee with the highest position
SELECT *
FROM employee
ORDER BY levels DESC
limit 1;

--2) Which countries have the most invoices?
SELECT billing_country, COUNT(invoice_id) AS count_invoices
FROM invoice
GROUP BY billing_country
ORDER BY count_invoices DESC;

--3) What are the top 3 values of total invoice?
SELECT total
FROM invoice
ORDER BY total DESC
LIMIT 3;

/* 4) Which city has the best customers? We would like to throw a promotional Music Festival in the city
we made the most money.Write a query that returns one city that has the highest sum of invoice totals.
Return both the city name and sum of all invoice total  */
SELECT billing_city, SUM(total) AS Total_Invoice
FROM invoice
GROUP BY billing_city
ORDER BY Total_Invoice DESC
LIMIT 1;

--5) Who is the best customer? Write a query that returns who has spent the most money
SELECT * FROM invoice;

SELECT * FROM customer;

SELECT c.customer_id,c.first_name,c.last_name, SUM(total) AS total_amount
FROM invoice AS i
LEFT JOIN customer AS c
	ON i.customer_id = c.customer_id
GROUP BY c.customer_id
HAVING SUM(total) = (
	SELECT MAX(total_amount_spent_customer)
	FROM (
		SELECT 
			customer_id,
			SUM(total) AS total_amount_spent_customer
		FROM invoice
		GROUP BY customer_id
		ORDER BY total_amount_spent_customer DESC
	) AS subquery
);


SELECT c.customer_id,c.first_name,c.last_name, SUM(total) AS total_amount
FROM invoice AS i
LEFT JOIN customer AS c
	ON i.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY total_amount DESC
LIMIT 1;

