-- Challenge - Joining on multiple tables
-- Write SQL queries to perform the following tasks using the Sakila database:
USE sakila;

-- 1 List the number of films per category.
SELECT c.name, COUNT(DISTINCT (fc.film_id)) AS total_films
FROM film_category AS fc 
JOIN category AS c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY total_films DESC;

-- 2 Retrieve the store ID, city, and country for each store.
SELECT s.store_id, a.address, c.city, ca.country
FROM sakila.store s
LEFT JOIN sakila.address a ON s.address_id = a.address_id
LEFT JOIN sakila.city c ON a.city_id = c.city_id
LEFT JOIN sakila.country ca ON c.country_id = ca.country_id;

-- 3 Calculate the total revenue generated by each store in dollars.
SELECT s.store_id, SUM(p.amount) AS total_revenue
FROM sakila.payment p 
LEFT JOIN sakila.staff s ON p.staff_id = s.staff_id
LEFT JOIN sakila.store st ON s.store_id = st.store_id
GROUP BY s.store_id;

-- 4 Determine the average running time of films for each category.
SELECT c.name, AVG(f.length) AS avg_time
FROM film as f
LEFT JOIN film_category AS fc ON f.film_id = fc.film_id 
LEFT JOIN category AS c ON fc.category_id = c.category_id
GROUP BY c.name;

-- Bonus:

-- 5 Identify the film categories with the longest average running time.
SELECT c.name, AVG(f.length) AS avg_time
FROM film as f
LEFT JOIN film_category AS fc ON f.film_id = fc.film_id 
LEFT JOIN category AS c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY avg_time DESC;


-- 6 Display the top 10 most frequently rented movies in descending order.
SELECT f.title, COUNT(r.rental_id) AS times_rented
FROM rental AS r
LEFT JOIN inventory AS i ON r.inventory_id = i.inventory_id
LEFT JOIN film AS f ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY times_rented DESC;

-- 7 Determine if "Academy Dinosaur" can be rented from Store 1.
SELECT f.title, s.store_id, COUNT(i.inventory_id) as total_copies
FROM film AS f
JOIN inventory AS i ON f.film_id = i.film_id
JOIN store AS s ON i.store_id = s.store_id
WHERE f.title = 'Academy Dinosaur' AND s.store_id = 1
GROUP BY f.title, s.store_id;

-- Different solution:
SELECT CASE 
    WHEN 'Academy Dinasour' IN (
        SELECT f.title FROM film f
        JOIN inventory i ON f.film_id = i.film_id
        JOIN store s ON s.store_id = i.store_id
        WHERE s.store_id = 1)
    THEN 1
    ELSE 0
    END as 'available';


-- Provide a list of all distinct film titles, along with their availability status in the inventory. 
-- Include a column indicating whether each title is 'Available' or 'NOT available.' Note that there are 42 titles that are not in the inventory, and this information can be obtained using a CASE statement combined with IFNULL."
SELECT DISTINCT f.title, CASE
    WHEN i.film_id IS NULL THEN 0
    ELSE 1
    END AS "available"
FROM film f 
LEFT JOIN inventory i 
ON f.film_id = i.film_id

-- Here are some tips to help you successfully complete the lab:

-- Tip 1: This lab involves joins with multiple tables, which can be challenging. Take your time and follow the steps we discussed in class:
    -- Make sure you understand the relationships between the tables in the database. This will help you determine which tables to join and which columns to use in your joins.
    -- Identify a common column for both tables to use in the ON section of the join. If there isn't a common column, you may need to add another table with a common column.
    -- Decide which table you want to use as the left table (immediately after FROM) and which will be the right table (immediately after JOIN).
    -- Determine which table you want to include all records from. This will help you decide which type of JOIN to use. If you want all records from the first table, use a LEFT JOIN. If you want all records from the second table, use a RIGHT JOIN. If you want records from both tables only where there is a match, use an INNER JOIN.
    -- Use table aliases to make your queries easier to read and understand. This is especially important when working with multiple tables.
    -- Write the query
-- Tip 2: Break down the problem into smaller, more manageable parts. For example, you might start by writing a query to retrieve data from just two tables before adding additional tables to the join. Test your queries as you go, and check the output carefully to make sure it matches what you expect. This process takes time, so be patient and go step by step to build your query incrementally.

