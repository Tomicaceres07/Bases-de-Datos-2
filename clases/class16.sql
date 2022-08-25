-- Caceres Tomás 7°C

-- Needs the employee table (defined in the triggers section) created and populated.

-- 1- Insert a new employee to , but with an null email. Explain what happens.
INSERT INTO employees (employeeNumber, lastName, firstName, extension, email, officeCode, reportsTo, jobTitle)
VALUES (1207, 'Maximoff', 'Wanda', 'a1207', NULL, '2', NULL, 'trasher');

-- ERROR 1048 (23000): Column 'email' cannot be null
-- There's not too much to say. Column 'email' cannot be null.

-- 2- Run the first the query
-- UPDATE employees SET employeeNumber = employeeNumber - 20
-- What did happen? Explain. Then run this other

-- Basically that query reduced the employeeNumber column in 20 of every value (employee)

-- UPDATE employees SET employeeNumber = employeeNumber + 20
-- Explain this case also.

-- ERROR 1062 (23000): Duplicate entry '1036' for key 'PRIMARY'
-- The last two employees has a difference of 20, so when the query tries to add 20 to the first of the last two employees, it detects that there's another employee with that value (the last of them)

-- 3- Add a age column to the table employee where and it can only accept values from 16 up to 70 years old.
ALTER TABLE employees
	ADD age int check(age >= 16 and age <= 70);

-- 4- Describe the referential integrity between tables film, actor and film_actor in sakila db.

-- The film_actor table works as a many to many between the tables film and actor.

-- 5- Create a new column called lastUpdate to table employee and use trigger(s) to keep the date-time updated on inserts and updates operations. Bonus: add a column lastUpdateUser and the respective trigger(s) to specify who was the last MySQL user that changed the row (assume multiple users, other than root, can connect to MySQL and change this table).

ALTER TABLE employees 
    ADD lastUpdate datetime;

ALTER TABLE employees
    ADD lastUpdateUser varchar(50);

DELIMITER $$
CREATE TRIGGER before_employees_update
    BEFORE UPDATE ON employees
    FOR EACH ROW 
BEGIN
    SET new.lastUpdate = now();
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER before_employees_insert
    BEFORE INSERT ON employees
    FOR EACH ROW 
BEGIN
    SET new.lastUpdate = now();
END$$
DELIMITER ;

-- 6- Find all the triggers in sakila db related to loading film_text table. What do they do? Explain each of them using its source code for the explanation.

-- sakila.film_text definition
CREATE TABLE `film_text` (
    `film_id` smallint(6) NOT NULL,
    `title` varchar(255) NOT NULL,
    `description` text,
    PRIMARY KEY (`film_id`),
    FULLTEXT KEY `idx_title_description` (`title`,`description`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Triggers:
CREATE DEFINER=`user`@`%` TRIGGER `ins_film` 
    AFTER INSERT ON `film`
    FOR EACH ROW 
BEGIN
    INSERT INTO film_text (film_id, title, description)
        VALUES (new.film_id, new.title, new.description);
END
-- When add a film it's also added in sakila.film_text

CREATE DEFINER=`user`@`%` TRIGGER `upd_film`
    AFTER UPDATE ON `film`
    FOR EACH ROW
BEGIN
    IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)
    THEN
        UPDATE film_text
            SET title=new.title,
                description=new.description,
                film_id=new.film_id
        WHERE film_id=old.film_id;
    END IF;
END
-- When update a film, if the values are different, it's also updated in sakila.film_text

CREATE DEFINER=`user`@`%` TRIGGER `del_film`
    AFTER DELETE ON `film`
    FOR EACH ROW
BEGIN
    DELETE FROM film_text WHERE film_id = old.film_id;
END
-- When delete a film it's also deleted in sakila.film_text