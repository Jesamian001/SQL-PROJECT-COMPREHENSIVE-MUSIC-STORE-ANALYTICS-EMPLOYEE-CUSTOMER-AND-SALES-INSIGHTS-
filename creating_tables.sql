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

SELECT * FROM media_type;
SELECT * FROM genre;
SELECT * FROM artist;
SELECT * FROM album;
SELECT * FROM playlist;
SELECT * FROM track;
SELECT * FROM playlist_track;
SELECT * FROM employee;
SELECT * FROM customer;
SELECT * FROM invoice;
SELECT * FROM invoice_line;







