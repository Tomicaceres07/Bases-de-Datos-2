-- Caceres Tomás 7°C

-- Create a new database called imdb
CREATE DATABASE IF NOT EXISTS imdb;
USE imdb;

-- Create tables: film (film_id, title, description, release_year); actor (actor_id, first_name, last_name) , film_actor (actor_id, film_id)

CREATE TABLE film(
    film_id INT(11) NOT NULL AUTO_INCREMENT, -- Use autoincrement id 
    title VARCHAR(50) NOT NULL,
    description VARCHAR(100) NOT NULL,
    release_year YEAR NOT NULL,
    CONSTRAINT film_pk PRIMARY KEY (film_id) -- Create PKs
)ENGINE = InnoDB;  

CREATE TABLE actor(
    actor_id INT(11) NOT NULL AUTO_INCREMENT, -- Use autoincrement id 
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    CONSTRAINT actor_pk PRIMARY KEY (actor_id)
)ENGINE = InnoDB;

CREATE TABLE film_actor(
    film_actor_id INT(11) NOT NULL AUTO_INCREMENT, -- Use autoincrement id 
    actor_id INT(11) NOT NULL,
    film_id INT(11) NOT NULL,
    CONSTRAINT film_actor_pk PRIMARY KEY (film_actor_id) -- Create PKs
)ENGINE = InnoDB;

-- Alter table add column last_update to film and actor
ALTER TABLE film
    ADD last_update DATE NOT NULL;

ALTER TABLE actor
    ADD last_update DATE NOT NULL;

-- Alter table add foreign keys to film_actor table

ALTER TABLE film_actor ADD
    CONSTRAINT actor_fk
        FOREIGN KEY (actor_id)
        REFERENCES actor (actor_id);

ALTER TABLE film_actor ADD
    CONSTRAINT film_fk
        FOREIGN KEY (film_id)
        REFERENCES film (film_id);

-- Insert some actors, films and who acted in each film

INSERT INTO film (title, description, release_year, last_update) VALUES('Harry Potter 1', 'La vida de un mago', 1990, CURDATE());
INSERT INTO film (title, description, release_year, last_update) VALUES('El señor de los anillos', 'Anillos mágicos', 1991, CURDATE());
INSERT INTO film (title, description, release_year, last_update) VALUES('Cars', 'Autos animados con vida', 1992, CURDATE());
INSERT INTO film (title, description, release_year, last_update) VALUES('Toy Story 1', 'Muñecos animados vivientes', 1993, CURDATE());

INSERT INTO actor (first_name, last_name, last_update) VALUES('Carlos', 'Gimenez', CURDATE());
INSERT INTO actor (first_name, last_name, last_update) VALUES('Alfredo', 'Mongolo', CURDATE());
INSERT INTO actor (first_name, last_name, last_update) VALUES('Susana', 'Romero', CURDATE());
INSERT INTO actor (first_name, last_name, last_update) VALUES('Emma', 'Watson', CURDATE());

INSERT INTO film_actor (actor_id, film_id) VALUES(1, 1);
INSERT INTO film_actor (actor_id, film_id) VALUES(2, 2);    
INSERT INTO film_actor (actor_id, film_id) VALUES(3, 3);
INSERT INTO film_actor (actor_id, film_id) VALUES(4, 4);

SELECT * FROM film;
SELECT * FROM actor;
SELECT * FROM film_actor;