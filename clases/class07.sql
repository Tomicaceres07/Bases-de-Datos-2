-- Caceres Tomás 7°C

-- 1. Find the films with less duration, show the title and rating.
SELECT title, rating
    FROM film
    WHERE length <= ALL(SELECT length FROM film);

-- 2. Write a query that returns the tiltle of the film which duration is the lowest. If there are more than one film with the lowest durtation, the query returns an empty resultset.
SELECT title
    FROM film
    WHERE 1=(SELECT COUNT(*)
                FROM film 
                WHERE length <= ALL(SELECT length FROM film));

-- 3. Generate a report with list of customers showing the lowest payments done by each of them. Show customer information, the address and the lowest amount, provide both solution using ALL and/or ANY and MIN.
SELECT customer_id, first_name, last_name, 
        (SELECT DISTINCT amount 
            FROM payment p
            WHERE c.customer_id = p.customer_id 
                AND amount <= ALL (SELECT amount 
                                        FROM payment p2
                                        WHERE c.customer_id = p2.customer_id)) AS min_amount,
        (SELECT address 
	        FROM address a 
	        WHERE c.address_id = a.address_id) AS address
    FROM customer c; 

SELECT customer_id, first_name, last_name,
	    (SELECT MIN(amount) 
	        FROM payment p
	        WHERE p.customer_id = c.customer_id) AS min_amount,
	    (SELECT address 
	        FROM address a 
	        WHERE c.address_id = a.address_id) AS address
    FROM customer c;

-- 4. Generate a report that shows the customer's information with the highest payment and the lowest payment in the same row.

-- Like I'm not sure if I understood well the activity, I'll do two variants.
SELECT customer_id, first_name, last_name,
        CONCAT(
            (SELECT MIN(amount) 
                FROM payment p
                WHERE p.customer_id = c.customer_id),
            " - ",
            (SELECT MAX(amount) 
                FROM payment p
                WHERE p.customer_id = c.customer_id)
        ) AS min_max_payment
    FROM customer c;

SELECT customer_id, first_name, last_name,
	    (SELECT MIN(amount) 
	        FROM payment p
	        WHERE p.customer_id = c.customer_id) AS min_amount,
        (SELECT MAX(amount) 
	        FROM payment p
	        WHERE p.customer_id = c.customer_id) AS max_amount
    FROM customer c;
