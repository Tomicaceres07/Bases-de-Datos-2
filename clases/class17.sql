-- Caceres Tomás 7°C

-- 1. Create two or three queries using address table in sakila db:
    -- include postal_code in where (try with in/not it operator)
    -- eventually join the table with city/country tables.
    -- measure execution time.
    -- Then create an index for postal_code on address table.
    -- measure execution time again and compare with the previous ones.
    -- Explain the results
SELECT a.postal_code
FROM address a
WHERE a.postal_code IN(SELECT a2.address_id
                        FROM address a2
                        INNER JOIN staff s USING(address_id))
ORDER BY postal_code;
-- 0.04 sec

SELECT a.postal_code, ci.city, co.country
FROM address a
INNER JOIN city ci USING(city_id)
INNER JOIN country co USING(country_id)
WHERE postal_code BETWEEN 10000 AND 30000
ORDER BY postal_code;
-- 0.03 sec

CREATE INDEX postalCode on address(postal_code);
-- Time after index created:
-- 0.00 sec
-- 0.01 sec

-- This is because MySQL checks if the indexes exist, then MySQL uses the indexes to select exact physical corresponding rows of the table instead of scanning the whole table.


-- 2. Run queries using actor table, searching for first and last name columns independently. Explain the differences and why is that happening?
SELECT first_name
FROM actor
WHERE first_name LIKE "R%"
ORDER BY first_name;

SELECT last_name
FROM actor
WHERE last_name LIKE "%S"
ORDER BY last_name;

-- In velocity, they both lasted 0.00 sec. The only difference that I see thanks to DBeaver, is that the column last_name has an index type BTree.


-- 3. Compare results finding text in the description on table film with LIKE and in the film_text using MATCH ... AGAINST. Explain the results.

-- First I'll create the index FULLTEXT to column description, because it doesn't have one.
ALTER TABLE film_text 
ADD FULLTEXT(description);

SELECT description
FROM film
WHERE description LIKE "%FAST%"
ORDER BY description;
-- 0.00 sec

SELECT description
FROM film_text
WHERE MATCH(description) AGAINST("FAST")
ORDER BY description;
-- 0.01 sec

-- For my surprise, apparently the query with index FULLTEXT (table film_text, using MATCH and AGAINST) lasted more than the query that doesn't have the index. That's kinda weird.
