-- Caceres Tomás 7°C

-- 1. Show title and special_features of films that are PG-13
SELECT f.title, f.special_features FROM film f
WHERE f.rating LIKE "%PG-13%";

-- 2. Get a list of all the different films duration.
SELECT length FROM film GROUP BY length;

-- 3. Show title, rental_rate and replacement_cost of films that have replacement_cost from 20.00 up to 24.00
SELECT title, rental_rate, replacement_cost FROM film
WHERE replacement_cost BETWEEN 20.00 AND 24.00;

-- 4. Show title, category and rating of films that have 'Behind the Scenes' as special_features

-- v1 (Sin Join)
SELECT f.title, c.name AS 'category', f.rating 
FROM film f, film_category fc, category c
WHERE f.film_id = fc.film_id 
    AND fc.category_id = c.category_id
    AND f.special_features LIKE '%Behind the Scenes%';

-- v2 (Con Join)
SELECT f.title, c.name AS 'category', f.rating 
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
    WHERE f.special_features LIKE '%Behind the Scenes%';

-- 5. Show first name and last name of actors that acted in 'ZOOLANDER FICTION'

-- v1 (Sin Join)
SELECT a.first_name, a.last_name
FROM actor a, film_actor fa, film f
WHERE a.actor_id = fa.actor_id AND fa.film_id = f.film_id
    AND f.title LIKE '%ZOOLANDER FICTION%';

-- v2 (Con Join)
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
    WHERE f.title LIKE '%ZOOLANDER FICTION%';

-- 6. Show the address, city and country of the store with id 1
SELECT a.address, ci.city, co.country
FROM store s
JOIN address a ON s.address_id = a.address_id 
JOIN city ci ON a.city_id = ci.city_id 
JOIN country co ON ci.country_id = co.country_id
    WHERE s.store_id = 1;

-- 7. Show pair of film titles and rating of films that have the same rating.
SELECT ANY_VALUE(title), rating FROM film 
GROUP BY rating;

-- 8. Get all the films that are available in store id 2 and the manager first/last name of this store (the manager will appear in all the rows).
SELECT f.title, f.description, sta.first_name, sta.last_name FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN store s ON i.store_id = s.store_id
JOIN staff sta ON s.manager_staff_id = sta.staff_id
    WHERE s.store_id = 2;
