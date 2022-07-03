-- Caceres Tomás 7°C

-- 1. Get the amount of cities per country in the database. Sort them by country, country_id.
SELECT co.country, COUNT(ci.city)
FROM country co
JOIN city ci ON co.country_id = ci.country_id
GROUP BY co.country, co.country_id
ORDER BY co.country;

-- 2. Get the amount of cities per country in the database. Show only the countries with more than 10 cities, order from the highest    amount of cities to the lowest
SELECT co.country, COUNT(ci.city) 
FROM country co
JOIN city ci ON co.country_id = ci.country_id
GROUP BY co.country, co.country_id
HAVING COUNT(ci.city) > 10
ORDER BY COUNT(ci.city) DESC;

-- 3. Generate a report with customer (first, last) name, address, total films rented and the total money spent renting films.
    -- Show the ones who spent more money first .
SELECT  c.first_name, 
        c.last_name, 
        (SELECT a.address FROM address a WHERE a.address_id = c.address_id) AS `address`,
        (SELECT COUNT(*) FROM rental r WHERE c.customer_id = r.customer_id) AS `quantity_rented`,
        (SELECT SUM(p.amount) FROM payment p WHERE c.customer_id = p.customer_id) AS `total_spent`
FROM customer c
ORDER BY `total_spent` DESC;

-- 4. Which film categories have the larger film duration (comparing average)?
    -- Order by average in descending order
SELECT c.name, AVG(f.`length`)
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
HAVING AVG(f.`length`) > (SELECT AVG(f2.`length`) FROM film f2)
ORDER BY AVG(f.`length`);

-- 5. Show sales per film rating
SELECT f.rating AS 'rating', COUNT(r.rental_id) AS 'total_rentals'
FROM film f
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY f.rating
ORDER BY 'rating';