-- Caceres Tomás 7°C

-- 1. Mostrar los datos del cliente, la cantidad de peliculas que alquilo y en una columna separado por comas el nombre de las peliculas que alguna vez alquilo. Ademas debera mostrar su compra maxima y minima.
SELECT  c.first_name, 
        c.last_name,
        (SELECT COUNT(*)
        FROM rental r
        WHERE c.customer_id = r.customer_id) AS 'Cant_pelis_que_alquilo',
        (SELECT GROUP_CONCAT(DISTINCT title ORDER BY title SEPARATOR ', ')
            FROM film
            WHERE film_id IN(SELECT film_id
                                FROM inventory
                                WHERE store_id IN(SELECT store_id
                                                    FROM store
                                                    WHERE store_id IN(SELECT store_id
                                                                        FROM customer
                                                                        WHERE customer_id IN(SELECT customer_id
                                                                                                FROM rental r
                                                                                                WHERE c.customer_id = r.customer_id))))) AS 'Pelis_que_alguna_vez_alquilo'
FROM customer c;

-- 2. Obtener todos los pares de actores que comparten nombre, pero solo aquellos que comienzan con A. Resolver con subqueries.

-- Forma Ineficiente
SELECT first_name, last_name
    FROM actor a1
    WHERE EXISTS(SELECT first_name, last_name
                    FROM actor a2
                    WHERE a1.first_name = a2.first_name
                        AND a1.first_name LIKE 'A%'
                        AND a2.first_name LIKE 'A%'
                        AND a1.actor_id <> a2.actor_id)
    ORDER BY first_name;

-- Forma Inficiente 2
SELECT first_name, last_name
    FROM actor a1
    WHERE a1.first_name LIKE 'A%'
    AND EXISTS(SELECT first_name, last_name
                    FROM actor a2
                    WHERE a1.first_name = a2.first_name
                        AND a1.actor_id <> a2.actor_id)
    ORDER BY first_name;

-- Forma Inficiente 3
SELECT first_name, last_name
    FROM actor a1
    WHERE first_name LIKE 'A%'
    AND first_name = ANY(SELECT first_name
                    FROM actor a2
                    WHERE a1.first_name = a2.first_name
                        AND a1.actor_id <> a2.actor_id)
    ORDER BY first_name;

-- Forma Eficiente
SELECT (SELECT first_name
        FROM actor a2
        WHERE a1.first_name LIKE 'A%' 
        AND first_name = ANY(SELECT first_name
                    FROM actor a2
                    WHERE a1.first_name = a2.first_name
                        AND a1.actor_id <> a2.actor_id)), last_name
    FROM actor a1
    ORDER BY a1.first_name;