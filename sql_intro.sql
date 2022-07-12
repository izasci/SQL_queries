-- Select all the actors from the table actor.
SELECT *
FROM actor;
-- Select the first and the last name as well as email address from the customer table.
SELECT first_name, last_name, email
FROM customer;
-- Select first and last actor names from the table actor without duplicates.
SELECT DISTINCT first_name, last_name
FROM customer;
-- Count all unique first names and last names from table actor. Count again without using DISTINCT syntax and see how both results differ.
SELECT COUNT(DISTINCT first_name, last_name) 
FROM actor;
SELECT COUNT(1)
FROM actor;
-- Find and display only the ten most profitable films. For that, use nicer_but_slower_film_list View.
SELECT title
FROM nicer_but_slower_film_list
ORDER BY price
LIMIT 10;
-- Select addresses from the district Coahuila de Zaragoza.
SELECT *
FROM address
WHERE district='Coahuila de Zaragoza';
-- Select all films released in 1945.
SELECT *
FROM film
WHERE release_year=1945;
-- Select all films that have been released after 1945.
SELECT *
FROM film
WHERE release_year>1945;
-- You need to present the first ten rows that have the biggest replacement_cost per film from the table film. You will be showing the result to stakeholders in your project. Your task is to show the movie title, the description, release year and the actor's replacement cost. Do so by providing readable aliases for your query. Avoid a naming convention based on underscore _.
SELECT title AS 'The movie title', description AS 'The description', release_year AS 'Release year', replacement_cost AS 'Actors replacement cost'
FROM film
ORDER BY replacement_cost DESC
LIMIT 10;
-- Join city and country tables. Present naming convention both for columns and tables.
SELECT c.city AS 'City', co.country AS 'Country'
FROM city AS c
JOIN country AS co ON c.country_id=co.country_id;
-- Find the figure for total_sales in film categories such as Sports and Travel. Check the view sales_by_film_category.
SELECT *
FROM sales_by_film_category
WHERE category IN ('Sports', 'Travel');
-- Find two tables that contain the same column names. Find a way to use them in one query with a subquery.
SELECT title
FROM film
WHERE title IN (SELECT title FROM film_text WHERE description IS NOT NULL);
-- Check the rental_rate between the lowest and the highest rate. Do you have to use the exact rates to check that?
SELECT DISTINCT rental_rate
FROM film
WHERE rental_rate BETWEEN (SELECT MIN(rental_rate) FROM film) AND (SELECT MAX(rental_rate) FROM film)
ORDER BY rental_rate;
-- Check the lifecycle of the film table by searching between today's date and a few years back. Make sure you use the DISTINCT clause to avoid duplicates and provide clean results.
SELECT DISTINCT title
FROM film
WHERE release_year BETWEEN 2017 AND 2022;
-- Find the description of a film that was released in 1997 and has a rental_duration of 4.
SELECT description
FROM film
WHERE release_year=1997 AND rental_duration=4;
-- Find films suitable for a Horror freak that would cost 0.99, or maybe 2.99. Use View called nicer_but_slower_film_list.
SELECT *
FROM nicer_but_slower_film_list
WHERE category='Horror' AND (price=0.99 OR price='2.99');
-- Find films suitable for a Family evening. Avoid films of categories like hammer or Horror. Again, use View called nicer_but_slower_film_list.
SELECT *
FROM nicer_but_slower_film_list
WHERE category NOT IN ('Horror', 'hammer');
-- Combine tables mentioned in this chapter: film and film_text. Count all of the occurrences of the film ACADEMY DINOSAUR
SELECT COUNT( title) FROM film WHERE title='ACADEMY DINOSAUR'
UNION ALL
SELECT COUNT( title) FROM film_text WHERE title='ACADEMY DINOSAUR';
-- Combine actors and customers by their names.
SELECT first_name, last_name FROM actor 
UNION
SELECT first_name, last_name FROM customer;
-- Check if any films have no original_language_id provided.
SELECT title
FROM film 
WHERE original_language_id IS NULL;
-- List all films released in 2014 that have all records filled.
SELECT *
FROM film 
WHERE title IS NOT NULL 
AND description IS NOT NULL 
AND language_id IS NOT NULL
AND original_language_id IS NOT NULL
AND rental_duration IS NOT NULL
AND rental_rate IS NOT NULL
AND length IS NOT NULL
AND replacement_cost IS NOT NULL
AND rating IS NOT NULL
AND special_features IS NOT NULL;
-- Count the films that have more rental_rate than 2.99.
SELECT count(1)
FROM film 
WHERE rental_rate>2.99;
-- List the films that use the most common language. Your query should post only such films. It's up to you if you count those records, or not.
SELECT title
FROM film
WHERE language_id = (SELECT language_id FROM film GROUP BY language_id ORDER BY count(1) DESC LIMIT 1);
-- Count all actors that are in the database. Alias them properly.
SELECT COUNT(1) AS 'All actors in DB'
FROM actor;
-- The business wants you to count all inactive customers to show them how many customers resigned.
SELECT COUNT(1) AS 'Inactive customers'
FROM customer
WHERE active=0;
-- Count all of the films for the Sci-Fi category.
SELECT *
FROM film
WHERE film_id=ANY(SELECT film_id FROM film_category WHERE category_id=ANY(SELECT category_id FROM category WHERE name='Sci-Fi'));
-- Summarize total sales by store. Use the sales_by_store view to do so.
SELECT SUM(total_sales) AS 'total sales'
FROM sales_by_store;
-- You were asked to sum up the replacement_cost for films with length greater than 120 for a business client.
SELECT SUM(replacement_cost) AS 'Replacement cost'
FROM film
WHERE length>120;
-- Find out the average sales of films by category. Use sales_by_film_category view.
SELECT AVG(total_sales) AS 'avarage sales of films'
FROM sales_by_film_category;
-- Find the average length of a movie. Provide the average, title name and language name for those films.
SELECT f.title, l.name, AVG(f.length)
FROM film AS f
JOIN language AS l ON f.language_id=l.language_id
GROUP BY f.title, l.name;
-- Find the lowest value of total_sales from view sales_by_film_category.
SELECT MIN(total_sales)
FROM sales_by_film_category;
-- You were asked to find the shortest film available to check if it's profitable. Also, provide the replacement_cost and order your findings by both rental_rate and replacement_cost
SELECT title, replacement_cost
FROM film
WHERE length=(SELECT MIN(length)FROM film)
ORDER BY rental_rate, replacement_cost;
-- Find the largest value of total_sales from the view sales_by_film_category.
SELECT MAX(total_sales)
FROM sales_by_film_category;
-- Find the newest film available. Provide the title, language name,rental_rate and the flm's length.
SELECT f.title, l.name, f.rental_rate, f.length
FROM film AS f
JOIN language AS l ON f.language_id=l.language_id
WHERE f.release_year=(SELECT MAX(release_year) FROM film);
-- Order films by their release year. Make sure that you start from the oldest record.
SELECT *
FROM film
ORDER BY release_year;
-- Order films by their release year and rental_rate. Let rental_rate indicate, which of those films were most valuable in years they were released.
SELECT *
FROM film
ORDER BY release_year ASC, rental_rate DESC;
-- Order films to indicate the newest to oldest productions released. Again, use rental_rate from the lowest to highest per year of the release.
SELECT *
FROM film
ORDER BY release_year DESC, rental_rate ASC;
-- You have to specify in which city there is a street named named 1031 Daugavpils Parkway. Provide the address, district and the city name
SELECT a.address, a.district, c.city
FROM address AS a
JOIN city AS c ON a.city_id=c.city_id
WHERE a.address='1031 Daugavpils Parkway';
-- Check if there are any customers records in the rental table that may not have records on either of the sides.
SELECT * 
FROM customer AS c
JOIN rental AS r ON c.customer_id=r.customer_id
WHERE r.customer_id IS NULL