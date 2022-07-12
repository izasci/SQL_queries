-- Get all data about all customers. Sort results by customer id and email in ascending order.
SELECT *
FROM customer
ORDER BY customer_id, email;

-- Get all data about rentals. Results should be sorted by item rental date.
SELECT *
FROM rental
ORDER BY rental_date;

-- Get all basic data (id, title, release date, rating) about films. Sort results by id in ascending order and by title in descending order. Release date and rating show as one column named Year and Rating.
SELECT film_id, title, CONCAT( release_year,' ', rating) AS 'Year and Rating'
FROM film
ORDER BY film_id DESC;

-- Show ids of customers that already rented anything from the store. Sort results out by id.
SELECT customer_id
FROM customer
WHERE active=1;

-- Which inventory items were already rented by which customers? Get only the id of an inventory and the id of a client.Order results by inventory id. Consider only inventory items that were already rented. The result must be presented as:
-- Inventory (id:...) was rented by customer (id: ...). Result column must be named Rental information
SELECT CONCAT ('Inventory ', inventory_id, ' was rented by customer ', customer_id) AS 'Rental information'
FROM rental;

-- On which days was each inventory item rented by each customer? For each customer, described by their ID, provide the date of inventory item rental. Sort the result by the customer and rental data.
SELECT rental_date, inventory_id, customer_id
FROM rental
ORDER BY customer_id, rental_date;

-- When was a particular rental  it paid? Get rental id and payment data. The result should be printed as follows: Rental (id) was paid on (payment date). Name the result column as Payment information. Sort the results by rental id and payment date.
SELECT CONCAT('Rental', ' ', rental_id, ' ', 'was paid on', ' ', payment_date) AS 'Payment information'
FROM payment
WHERE rental_id IS NOT NULL
ORDER BY rental_id, payment_date;

-- Show basic data (last name, first name, id) about customers whose last name starts with M. Sort the result by the address where customers live.
SELECT last_name, first_name, customer_id
FROM customer
WHERE last_name LIKE 'M%'
ORDER BY address_id;

-- Get all inventory IDs rented by customers with id between 3 and 205. Arrange the result by inventory ids.
SELECT inventory_id
FROM rental
WHERE customer_id BETWEEN 3 AND 205
ORDER BY inventory_id;

-- Get all customers with the last name starting with MO. Arrange customers alphabetically.
SELECT *
FROM customer
WHERE last_name LIKE 'MO%'
ORDER BY last_name;

-- Get all customers created after 20 April 2001.
SELECT *
FROM customer
WHERE create_date>"2001-04-20 00:00:01";

-- Show all inventories rented between 01.01.2000 and 01.01.2001. Additionally, present them as string Inventory (id) was rented on (date) and returned on (date). Sort the result by inventory id.
SELECT CONCAT('Inventory', ' ', inventory_id, ' was rented on ', rental_date, ' and returned on ', return_date) AS 'Rental information'
FROM rental
WHERE rental_date BETWEEN "2000-01-01 00:00:00" AND "2001-01-01 00:00:00"
ORDER BY inventory_id;

-- Show customer ids of all customers who rented something in period from 01.01.2002 to 28.05.2002. Arrange the results by customer id.
SELECT customer_id
FROM rental
WHERE rental_date BETWEEN "2002-01-01 00:00:00" AND "2002-05-28 00:00:00"
ORDER BY customer_id;

-- Which films were released in 1994? Get film id, title, description, and language id. Arrange data by language.
SELECT film_id, title, description, language_id
FROM film
WHERE release_year=1994
ORDER BY language_id;

-- Show the first name and last name of customers who rented something. Arrange results by inventory id.
SELECT c.first_name, c.last_name
FROM customer AS c
JOIN rental AS r ON c.customer_id=r.customer_id
WHERE c.active=1
ORDER BY r.inventory_id;

-- Show the first name and last name of customers who rented the film with the title AFRICAN EGG.
SELECT c.first_name, c.last_name
FROM customer AS c
JOIN rental AS r ON c.customer_id=r.customer_id
JOIN inventory AS i ON r.inventory_id=i.inventory_id
JOIN film AS f ON i.film_id=f.film_id
WHERE f.title='AFRICAN EGG';

-- Which film hasn’t been rented yet? Get its title.
SELECT *
FROM film AS f
LEFT JOIN inventory AS i ON f.film_id=i.film_id
LEFT JOIN rental AS r ON i.inventory_id=r.inventory_id
WHERE r.inventory_id IS NULL;

-- Which stores have no employees? Get the id of the store and its address and postal code.
SELECT s.store_id, a.address, a.postal_code
FROM store AS s
LEFT JOIN staff AS st ON s.store_id=st.store_id
LEFT JOIN address AS a ON s.address_id=a.address_id
WHERE st.staff_id IS NULL;

-- Which employee rented films with id equals to 1 and 10? Consider only those employees who rented both films.
SELECT DISTINCT s.first_name, s.last_name
FROM staff AS s
JOIN rental AS r ON s.staff_id=r.staff_id
JOIN inventory AS i ON r.inventory_id=i.inventory_id
WHERE i.film_id = 1 AND s.first_name = ANY(SELECT s.first_name FROM staff AS s JOIN rental AS r ON s.staff_id=r.staff_id JOIN inventory AS i ON r.inventory_id=i.inventory_id WHERE i.film_id = 10);

-- How many inventories have been rented in every store? Consider also stores without any rentals. Provide store address and postal code of store and number of rented inventories. Give a proper name for a column with information about how many inventories were rented.
SELECT a.address, a.postal_code, s.store_id, count(1) AS 'Rented inventories'
FROM inventory AS i
RIGHT JOIN store AS s ON i.store_id=s.store_id
JOIN address AS a ON s.address_id=a.address_id
GROUP BY store_id
HAVING COUNT(1)>1
UNION ALL
SELECT a.address, a.postal_code, s.store_id, 0
FROM inventory AS i
RIGHT JOIN store AS s ON i.store_id=s.store_id
JOIN address AS a ON s.address_id=a.address_id
WHERE i.store_id IS NULL;

-- How many employees rented something in each store? Consider also stores without any rental.
SELECT COUNT(1) AS 'employees rented something', rented.store_id
FROM (SELECT st.staff_id, s.store_id
FROM store AS s
JOIN staff AS st ON s.store_id=st.store_id
JOIN rental AS r ON st.staff_id=r.staff_id
GROUP BY staff_id) AS rented
GROUP BY rented.store_id
UNION ALL
SELECT 0, s.store_id
FROM store AS s
LEFT JOIN staff AS st ON s.store_id=st.store_id
LEFT JOIN rental AS r ON st.staff_id=r.staff_id
WHERE r.staff_id IS NULL;

-- Which film was rented more than 5 times in a store located in 692 Joliet Street? For each store located at this address show all staff (first name and last name).
SELECT f.title
FROM film AS f
JOIN inventory AS i ON f.film_id=i.film_id
JOIN rental AS r ON i.inventory_id=r.inventory_id
JOIN staff AS s ON r.staff_id=s.staff_id
JOIN store AS st ON s.store_id=st.store_id
JOIN address AS a ON st.address_id=a.address_id
WHERE a.address='692 Joliet Street'
GROUP BY f.title
HAVING COUNT(1)>5;

-- Which employee rented more than 100 films? Get the first name, last name, and several rented films. Arrange the result by first and last name.
SELECT count(1) AS 'Number of rentals', r.staff_id, s.last_name, s.first_name
FROM rental AS r
JOIN staff AS s ON r.staff_id=s.staff_id
GROUP BY r.staff_id
HAVING COUNT(1)>100
ORDER BY s.first_name, s.last_name;

-- Get the date of the first and the last rental made by each employee. Consider also employees without any rentals.
