
-- Create a database named "music_store_db" 
-- Import all the required csv files to this database as tables
-- check all the tables & its columns
-- Now we will answer some questions using sql queries
-----------------------------------------------------------------------------------------------

                  -- Question set 1 - Easy --
                  
-- Q1: Who is the senior most employee based on job title?

SELECT *
FROM employee
ORDER BY levels DESC
LIMIT 1;


-- Q2: Which countries have the most Invoices?

SELECT billing_country AS country, COUNT(*) AS total_invoices
FROM invoice
GROUP BY billing_country
ORDER BY total_invoices DESC;


-- Q3: What are top 3 values of total invoice?

SELECT total
FROM invoice
ORDER BY total DESC
LIMIT 3;


/* Q4: Which city has the best customers?
	   We would like to throw a promotional Music Festival in the city we made the most money.
       Write a query that returns one city that has the highest sum of invoice total.
       Return both the city name & sum of all invoice total. */

SELECT billing_city AS city, SUM(total) AS invoice_total
FROM invoice
GROUP BY billing_city
ORDER BY SUM(total) DESC;


/* Q5: Who is the best customer?
       The customer who has spent the most money will be declared the best customer.
	   Write a query that returns the person who has spent the most money */

SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(invoice.total) AS total_spent
FROM customer
JOIN invoice
ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name
ORDER BY total_spent DESC
LIMIT 1;

                     -- Question set 2 - Moderate -- 

/* Q1: Write query to return the email, first name, last name of all Rock Music listeners
       Return your list ordered alphabetically by email starting with A */
	
SELECT DISTINCT email, first_name, last_name, genre.name AS genre
FROM customer
JOIN invoice
ON customer.customer_id = invoice.customer_id
JOIN invoice_line
ON invoice.invoice_id = invoice_line.invoice_id
JOIN track 
ON invoice_line.track_id = track.track_id
JOIN genre
ON track.genre_id = genre.genre_id
WHERE genre.name = "Rock"
GROUP BY email, first_name, last_name
ORDER BY customer.email ASC;


/* Q2: Let's invite the artists who have written the most rock music in our dataset
       Write a query that returns the Artist name and total track count of the top 10 rock bands */

SELECT DISTINCT artist.artist_id, artist.name artist_name, COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album
ON track.album_id = album.album_id
JOIN artist
ON artist.artist_id = album.album_id
JOIN genre
ON track.genre_id = genre.genre_id
WHERE genre.name = "Rock"
GROUP BY artist.artist_id, artist.name
ORDER BY number_of_songs DESC
LIMIT 10;


/* Q3: Return all the track names that have a song length longer than the average song length.
       Return the Name and Milliseconds for each track.
       Order by the song length with the longest songs listed first */
       
SELECT name AS track_name, milliseconds
FROM track
WHERE milliseconds > (
SELECT AVG(milliseconds)
FROM track)
GROUP BY name, milliseconds
ORDER BY milliseconds desc;


                        -- Question Set 3 - Advance --

/* Q1: Find how much amount spent by each customer on artists?
       Write a query to return customer name, artist name and total spent  */

SELECT distinct customer.customer_id, first_name, last_name, artist.name AS artist, SUM(invoice_line.unit_price * invoice_line.quantity) AS total_spent
FROM customer
JOIN invoice
ON customer.customer_id = invoice.customer_id
join invoice_line
ON invoice.invoice_id = invoice_line.invoice_id
JOIN track
ON invoice_line.track_id = track.track_id
JOIN album
ON track.album_id = album.album_id
JOIN artist 
ON album.artist_id = artist.artist_id
GROUP BY customer.customer_id, first_name, last_name, artist
ORDER BY total_spent DESC;


/* Q2: We want to find out the most popular music Genre for each country.
       We determine the most popular genre as the genre with the highest amount of purchases.
       Write a query that returns each country along with the top Genre.
       For countries where the maximum number of purchases is shared return all Genres */


WITH popular_genre AS
(
SELECT customer.country AS country, genre.name AS most_popular_genre , COUNT(invoice_line.quantity) AS amount_of_purchases,
ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS row_no
FROM invoice_line
JOIN invoice
ON invoice.invoice_id = invoice_line.invoice_id
JOIN customer
on invoice.customer_id = customer.customer_id
JOIN track
ON invoice_line.track_id = track.track_id
JOIN genre
ON track.genre_id = genre.genre_id
GROUP BY country, genre.name
ORDER BY amount_of_purchases DESC
)
SELECT * FROM popular_genre WHERE row_no <= 1 ;


/* Q3: Write a query that determines the customer that has spent the most on music for each country.
       Write a query that returns the country along with the top customer and how much they spent.
       For countries where the top amount spent is shared, provide all customers who spent this amount */

WITH best_customer AS
(
SELECT invoice.customer_id, customer.first_name, customer.last_name, invoice.billing_country AS country, SUM(invoice.total) AS total_spent,
ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(invoice.total) DESC) AS row_no
FROM invoice
JOIN customer
ON invoice.customer_id = customer.customer_id
GROUP BY customer_id, customer.first_name, customer.last_name, invoice.billing_country, invoice.total
ORDER BY SUM(invoice.total) DESC
)
SELECT * FROM best_customer WHERE row_no = 1;



