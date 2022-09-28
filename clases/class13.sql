-- Caceres Tomás 7°C


-- Write the statements with all the needed subqueries, do not use hard-coded ids unless is specified. Check which fields are mandatory and which ones can be ommited (use default value).

-- 1. Add a new customer
    -- To store 1
    -- For address use an existing address. The one that has the biggest address_id in 'United States'
INSERT INTO customer (store_id, first_name, last_name, email, address_id, active)
SELECT 1, 'Jennifer', 'Aniston', 'jenniferaniston@gmail.com', MAX(a.address_id), 1
FROM address a
WHERE (SELECT c.country_id
		FROM country c, city c1
		WHERE c.country = "United States"
		AND c.country_id = c1.country_id
		AND c1.city_id = a.city_id);

SELECT * FROM customer WHERE last_name = "Aniston";

-- 2. Add a rental
    -- Make easy to select any film title. I.e. I should be able to put 'film tile' in the where, and not the id.
    -- Do not check if the film is already rented, just use any from the inventory, e.g. the one with highest id.
    -- Select any staff_id from Store 2.
INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id)
SELECT  CURRENT_TIMESTAMP, 
		(SELECT MAX(i.inventory_id)
			FROM inventory i
            INNER JOIN film f USING(film_id)
            WHERE f.title = "ZORRO ARK"
            LIMIT 1),
        600,
        NULL,
		(SELECT staff_id
            FROM staff
            INNER JOIN store s USING(store_id)
            WHERE s.store_id = 2 
            LIMIT 1);

SELECT * FROM rental WHERE customer_id = 600;

-- 3. Update film year based on the rating
    -- For example if rating is 'G' release date will be '2001'
    -- You can choose the mapping between rating and year.
    -- Write as many statements are needed.
SELECT title, release_year, rating FROM film LIMIT 10;

UPDATE film SET release_year = 2020 WHERE rating = 'PG';
UPDATE film SET release_year = 2018 WHERE rating = 'G';
UPDATE film SET release_year = 2019 WHERE rating = 'NC-17';
UPDATE film SET release_year = 2017 WHERE rating = 'PG-13';
UPDATE film SET release_year = 2016 WHERE rating = 'R';

SELECT title, release_year, rating FROM film LIMIT 10;

-- 4. Return a film
    -- Write the necessary statements and queries for the following steps.
    -- Find a film that was not yet returned. And use that rental id. Pick the latest that was rented for example.
    -- Use the id to return the film.
SELECT r.rental_id, r.return_date
FROM film f
    INNER JOIN inventory i USING(film_id)
    INNER JOIN rental r USING(inventory_id)
WHERE r.return_date IS NULL
ORDER BY r.rental_date DESC
LIMIT 1;

UPDATE rental
SET
    return_date = CURRENT_TIMESTAMP
WHERE rental_id = 16053;

SELECT r.rental_id, r.return_date
FROM film f
    INNER JOIN inventory i USING(film_id)
    INNER JOIN rental r USING(inventory_id)
WHERE r.return_date IS NOT NULL
ORDER BY r.rental_date DESC
LIMIT 1;

-- 5. Try to delete a film
    -- Check what happens, describe what to do.
    -- Write all the necessary delete statements to entirely remove the film from the DB.

-- First, let's get a random title of a film
SELECT title
FROM film
WHERE film_id = 800;
-- It shows: SINNERS ATLANTIS

-- Now, let's try to delete that film.
DELETE FROM film WHERE title = 'SINNERS ATLANTIS';
-- It shows: ERROR 1451 (23000): Cannot delete or update a parent row: a foreign key constraint fails (`sakila`.`film_actor`, CONSTRAINT `fk_film_actor_film` FOREIGN KEY (`film_id`) REFERENCES `film` (`film_id`) ON UPDATE CASCADE)

-- The solution to delete this film, would be deleting first the registers in which this film is related to (In the tables where one doesn't depend on the other one).
-- So, the furthest table that doesn't depend on other is payment.
DELETE FROM payment
WHERE rental_id IN (SELECT rental_id
                    FROM rental
                    INNER JOIN inventory USING(inventory_id)
                    WHERE film_id = 800);

-- The next one is the table rental
DELETE FROM rental
WHERE inventory_id IN (SELECT inventory_id
                        FROM inventory
                        WHERE film_id = 800);

-- Now we can delete the film_id in the tables that exists.
DELETE FROM inventory WHERE film_id = 800;

DELETE FROM film_actor WHERE film_id = 800;

DELETE FROM film_category WHERE film_id = 800;

-- And finally we can delete that film.
DELETE FROM film WHERE title = 'SINNERS ATLANTIS';

-- If we ask again about that film, it will show Empty Set
SELECT title
FROM film
WHERE film_id = 800;

-- 6. Rent a film
    -- Find an inventory id that is available for rent (available in store) pick any movie. Save this id somewhere.
    -- Add a rental entry
    -- Add a payment entry
    -- Use sub-queries for everything, except for the inventory id that can be used directly in the queries.

-- Let's get an inventory id available for rent and pick any movie.
SELECT inventory_id, film_id
FROM inventory
WHERE inventory_id NOT IN (SELECT inventory_id
								FROM inventory
								INNER JOIN rental USING (inventory_id)
								WHERE return_date IS NULL);
-- inventory_id: 3700
-- film_id: 810

-- Now let's insert into rental an entry
INSERT INTO rental (rental_date, 
                    inventory_id, 
                    customer_id, 
                    staff_id)
VALUES( CURRENT_DATE(), 
        3700,
		(SELECT customer_id FROM customer ORDER BY customer_id DESC LIMIT 1),
		(SELECT staff_id FROM staff WHERE store_id = (SELECT store_id FROM inventory WHERE inventory_id = 3700)));

-- Finally let's insert into payment an entry
INSERT INTO payment (customer_id, 
                        staff_id, 
                        rental_id, 
                        amount, 
                        payment_date)
	VALUES( (SELECT customer_id FROM customer ORDER BY customer_id DESC LIMIT 1),
			(SELECT staff_id FROM staff LIMIT 1),
			(SELECT rental_id FROM rental ORDER BY rental_id DESC LIMIT 1) ,
			(SELECT rental_rate FROM film WHERE film_id = 400),
			CURRENT_DATE());

-- Once you're done. Restore the database data using the populate script from class 3.