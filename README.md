# Music Store Analysis

## Project Overview

SQL Portfolio Project | Music Store Data Analysis

### Raw Data Source - [db_dump.sql](db_dump.sql)

## Steps

- import the CSV files in My SQL database
- Perform QA testing and Data Profiling
- Answer all sets of questions regarding the dataset.


## Tools

- MY SQL - For QA testing, Data profiling and answering questions

## My SQL Queries and Results

                  -- Question set 1 - Easy --
			
### Q1: Who is the senior most employee based on job title?
```SQL
SELECT *
FROM employee
ORDER BY levels DESC
LIMIT 1;
```
![Screenshot 2023-12-19 151231](https://github.com/SushantKG/Music-Store-Data-Analysis/assets/152982735/8ed340a1-e7ef-4829-9778-0abdc06108e2)

### Q2: Which countries have the most Invoices?
```SQL
SELECT billing_country AS country, COUNT(*) AS total_invoices
FROM invoice
GROUP BY billing_country
ORDER BY total_invoices DESC
LIMIT 10;
```
![Screenshot 2023-12-19 151256](https://github.com/SushantKG/Music-Store-Data-Analysis/assets/152982735/2ee0589a-7fef-4ea2-a3c2-86ad3983f71b)

### Q3: What are the top 3 values of the total invoice?
```SQL
SELECT total
FROM invoice
ORDER BY total DESC
LIMIT 3;
```
![Screenshot 2023-12-19 151321](https://github.com/SushantKG/Music-Store-Data-Analysis/assets/152982735/9b191905-6ef6-4d60-8fd7-3e09f99c01c8)

### Q4: Which city has the best customers?
	      We would like to throw a promotional Music Festival in the city where we made the most money,
        Write a query that returns one city that has the highest sum of invoice total,
        Return both the city name & sum of all invoice totals. 
```SQL
SELECT billing_city AS city, SUM(total) AS invoice_total
FROM invoice
GROUP BY billing_city
ORDER BY SUM(total) DESC;
```
![Screenshot 2023-12-19 151409](https://github.com/SushantKG/Music-Store-Data-Analysis/assets/152982735/f90cdb47-b856-4859-8322-0ac7aed7bfa8)


### Q5: Who is the best customer?
        The customer who has spent the most money will be declared the best customer,
	      Write a query that returns the person who has spent the most money.
```SQL
SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(invoice.total) AS total_spent
FROM customer
JOIN invoice
ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name
ORDER BY total_spent DESC
LIMIT 1;
```
![Screenshot 2023-12-19 151427](https://github.com/SushantKG/Music-Store-Data-Analysis/assets/152982735/8b66cf1d-6d52-4c3b-bc93-dd77019a9610)

                     -- Question set 2 - Moderate -- 

### Q1: Write a query to return the email, first name, and last name of all Rock Music listeners
        Return your list ordered alphabetically by email starting with A.
```SQL 	
SELECT DISTINCT email, first_name, last_name, genre. name AS genre
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
ORDER BY customer. email ASC;
```
![Screenshot 2023-12-19 151507](https://github.com/SushantKG/Music-Store-Data-Analysis/assets/152982735/f8e46f72-592f-4f84-9bfc-4521f5229273)


### Q2: Let's invite the artists who have written the most rock music in our dataset
        Write a query that returns the Artist name and total track count of the top 10 rock bands.
```SQL
SELECT DISTINCT artist.artist_id, artist.name artist_name, COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album2
ON track.album_id = album2.album_id
JOIN artist
ON artist.artist_id = album2.album_id
JOIN genre
ON track.genre_id = genre.genre_id
WHERE genre.name = "Rock"
GROUP BY artist.artist_id, artist.name
ORDER BY number_of_songs DESC
LIMIT 10;
```
![Screenshot 2023-12-19 151535](https://github.com/SushantKG/Music-Store-Data-Analysis/assets/152982735/c354f4ae-7c06-4de4-a464-9219ed438e6a)

### Q3: Return all the track names that have a song length longer than the average song length.
        Return the Name and Milliseconds for each track,
        Order by the song length with the longest songs listed first.
```SQL       
SELECT name AS track_name, milliseconds
FROM track
WHERE milliseconds > (
SELECT AVG(milliseconds)
FROM track)
GROUP BY name, milliseconds
ORDER BY milliseconds desc;
```
![Screenshot 2023-12-19 151558](https://github.com/SushantKG/Music-Store-Data-Analysis/assets/152982735/818c55a8-16b1-4b3f-885a-264764ea851b)

                        -- Question Set 3 - Advance --

### Q1: Find how much amount spent by each customer on artists.
        Write a query to return the customer name, artist name, and total spent.
```SQL
SELECT distinct customer.customer_id, first_name, last_name, artist.name AS artist, SUM(invoice_line.unit_price * invoice_line.quantity) AS total_spent
FROM customer
JOIN invoice
ON customer.customer_id = invoice.customer_id
join invoice_line
ON invoice.invoice_id = invoice_line.invoice_id
JOIN track
ON invoice_line.track_id = track.track_id
JOIN album2
ON track.album_id = album2.album_id
JOIN artist 
ON album2.artist_id = artist.artist_id
GROUP BY customer.customer_id, first_name, last_name, artist
ORDER BY total_spent DESC;
```
![Screenshot 2023-12-19 151619](https://github.com/SushantKG/Music-Store-Data-Analysis/assets/152982735/2f279049-9102-4067-9466-65f7af89ddfe)

### Q2: We want to find out the most popular music Genre for each country.
        We determine the most popular genre as the genre with the highest amount of purchases,
        Write a query that returns each country along with the top Genre,
        For countries where the maximum number of purchases is shared return all Genres.
```SQL
WITH popular_genre AS
(
SELECT customer. country AS country, genre.name AS most_popular_genre , COUNT(invoice_line.quantity) AS amount_of_purchases,
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
```
![Screenshot 2023-12-19 151644](https://github.com/SushantKG/Music-Store-Data-Analysis/assets/152982735/6b9b77b8-083f-4849-ab76-9e30a86f5abc)



### Q3: Write a query that determines the customer that has spent the most on music for each country.
        Write a query that returns the country along with the top customer and how much they spent,
        For countries where the top amount spent is shared, provide all customers who spent this amount.
```SQL
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
```
![Screenshot 2023-12-19 151702](https://github.com/SushantKG/Music-Store-Data-Analysis/assets/152982735/3c67e49e-0cfa-479c-a77d-e9f886901e7d)





