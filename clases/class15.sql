-- Caceres Tomás 7°C

-- 1. Create a view named list_of_customers, it should contain the following columns:
    -- customer id
    -- customer full name,
    -- address
    -- zip code
    -- phone
    -- city
    -- country
    -- status (when active column is 1 show it as 'active', otherwise is 'inactive')
    -- store id
CREATE OR REPLACE VIEW list_of_customers AS
    SELECT  c.customer_id, 
            CONCAT(c.first_name, ' ', c.last_name) AS 'Full name',
            a.address,
            a.postal_code,
            a.phone,
            ci.city,
            co.country,
            IF(c.active = 1, 'active', 'inactive') AS 'status',
            s.store_id
    FROM customer c
    INNER JOIN address a USING(address_id)
    INNER JOIN city ci USING(city_id)
    INNER JOIN country co USING(country_id)
    INNER JOIN store s USING(store_id);

SELECT * FROM list_of_customers;

-- 2. Create a view named film_details, it should contain the following columns: film id, title, description, category, price, length, rating, actors - as a string of all the actors separated by comma. Hint use GROUP_CONCAT
CREATE OR REPLACE VIEW film_details AS
    SELECT  f.film_id,
            f.title,
            f.description,
            f.rental_rate,
            f.length,
            f.rating,
            GROUP_CONCAT(CONCAT_WS(" ", a.first_name, a.last_name) SEPARATOR ",") AS `actors`
    FROM film f
    INNER JOIN film_category USING(film_id)
    INNER JOIN category c USING(category_id)
    INNER JOIN film_actor USING(film_id)
    INNER JOIN actor a USING(actor_id)
    GROUP BY film_id;

SELECT * FROM film_details;

-- 3. Create view sales_by_film_category, it should return 'category' and 'total_rental' columns.
CREATE OR REPLACE VIEW sales_by_film_category AS
    SELECT  c.name AS `category`,
            SUM(p.amount) AS `total_sales`
    FROM payment p
    INNER JOIN rental r USING(rental_id)
    INNER JOIN inventory i USING(inventory_id)
    INNER JOIN film f USING(film_id)
    INNER JOIN film_category fc USING(film_id)
    INNER JOIN category c USING(category_id)
    GROUP BY `category`
    ORDER BY `total_sales` DESC;

SELECT * FROM sales_by_film_category;

-- 4. Create a view called actor_information where it should return, actor id, first name, last name and the amount of films he/she acted on.
CREATE OR REPLACE VIEW actor_information AS
SELECT  a.actor_id,
        a.first_name,
        a.last_name,
        COUNT(fa.actor_id) AS 'amount_films_acted'
    FROM actor a
    INNER JOIN film_actor fa USING(actor_id)
    GROUP BY a.actor_id;

SELECT * FROM actor_information;

-- 5. Analyze view actor_info, explain the entire query and specially how the sub query works. Be very specific, take some time and decompose each part and give an explanation for each.
-- The view actor_info brings 4 columns. In the first three, basic data from actor (actor_id, first_name, last_name).
-- In the fourth column, it makes a group_concat, which concatenate each name of category that the actor acted, with all its films of that category.
-- All this data is getted thanks to the sentences join made inside the group_concat, and the left join sentences made after select the four columns.
-- Finally it groups by actor_id first_name and last_name so they can't repeat each other


-- 6. Materialized views, write a description, why they are used, alternatives, DBMS were they exist, etc.
-- A Materialized View persists the data returned from the view definition query and automatically gets updated as data changes in the underlying tables.
-- Creating and maintaining a materialized view can reduce the query costs paid for expensive or frequently run queries.
-- They are used in different DBMS (DataBase Management System), but they doesn't exists in MySQL. So the alternative could be use triggers or stored procedures.
