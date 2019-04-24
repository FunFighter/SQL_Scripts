-- To pull the names together and make sure they are upper cased
-- a1
SELECT first_name,last_name FROM actor

-- a2
SELECT upper(concat(first_name, ' ' ,last_name)) FROM actor

-- 2a
-- We lost Joe, need to find him and get his ID 
SELECT * FROM actor
WHERE first_name like 'Joe%'

--2b
-- For tonights Hit Operation we were told that the client wanted the name with the last name 
-- Gen taken out. Sadly we used Cricket so we could not hear him clearly
SELECT * FROM actor
WHERE last_name like '%GEN%'

-- 2c
SELECT * FROM actor
WHERE last_name like '%LI%';

-- 2d
SELECT country_id, country FROM country
WHERE country in  ('Afghanistan' , 'Bangladesh', 'China');

-- 3a
-- we like blobs here
ALTER TABLE actor
ADD description BLOB;

-- 3b
-- work is hard 
ALTER TABLE actor
DROP COLUMN  description;

-- 4a
SELECT last_name, count(last_name)FROM actor
GROUP BY last_name

-- 4b
-- A guy has the last name "BALL" btw
SELECT last_name, count(last_name)FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >= 2;

-- 4c
-- The actor HARPO WILLIAMS was accidentally entered in the actor table as 
-- GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE  actor
SET first_name = 'GROUCHO'
WHERE  first_name = 'HARPO';

-- 4d
-- lol this guy be changing his name every week
UPDATE  actor
SET first_name = 'HARPO'
WHERE  first_name = 'GROUCHO';

-- 5a
-- Checking Data types
SHOW CREATE TABLE address;

-- just in case you want to rebuild
CREATE TABLE address (
  address_id smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  address varchar(50) NOT NULL,
  address2 varchar(50) DEFAULT NULL,
  district varchar(20) NOT NULL,
  city_id smallint(5) unsigned NOT NULL,
  postal_code varchar(10) DEFAULT NULL,
  phone varchar(20) NOT NULL,
  location geometry NOT NULL,
  last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (address_id),
  KEY idx_fk_city_id (city_id),
  SPATIAL KEY idx_location (location),
  CONSTRAINT fk_address_city FOREIGN KEY (city_id) REFERENCES city (city_id) ON UPDATE CASCADE
) 

-- 6a
-- staff addresss
SELECT first_name, last_name, address FROM staff s
JOIN address  a
ON a.address_id = s.address_id;

-- 6b
SELECT first_name, last_name,  SUM(amount)
 FROM staff s
JOIN payment  p
ON p.staff_id = s.staff_id
WHERE (payment_date >= '2005-08-01 00:00:00' 
AND payment_date <= '2005-08-31 00:00:00') 
GROUP BY first_name, last_name
;

-- 6c
-- Return title and count of actors ON inner joins.
SELECT title, count(a.first_name) 'Actor Count'FROM film f
JOIN film_actor fa
ON f.film_id = fa.film_id
JOIN actor a
ON a.actor_id = fa.actor_id
GROUP BY title
;

-- 6d
SELECT count(f.title) 'Hunchback Impossible Count' FROM inventory i
JOIN film f
ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible'
;

-- 6e
-- how much did each customer pay in total
SELECT first_name, last_name, SUM(amount)'Total Amount Paid' FROM customer c
JOIN payment p
ON p.customer_id = c.customer_id
GROUP BY first_name, last_name;

--7a
-- The music of Queen and Kris Kristofferson started makeing K and Q movies rise again
SELECT f.title, l.name 'Language' FROM film f
JOIN language l 
ON l.language_id = f.language_id
WHERE l.name = 'English'
AND (f.title like 'K%'
OR f.title like 'Q%');

-- 7b
-- Who is in the movine Alone Trip
SELECT
  first_name,
  last_name
-- ,f.title to check the movie name
FROM actor a
JOIN film_actor fa
  ON fa.actor_id = a.actor_id
JOIN film f
  ON f.film_id = fa.film_id
WHERE f.title = 'Alone Trip'
;

-- 7c
-- Find canada people 
SELECT
  first_name, last_name
  -- , co.country to test for country
FROM customer c
JOIN address a
  ON a.address_id = c.address_id
JOIN city ci
  ON ci.city_id = a.city_id
JOIN country co
  ON co.country_id = ci.country_id
WHERE co.country = 'Canada'
;


-- 7d
-- find all family films as a promo
SELECT f.title, c.name FROM film f
JOIN film_category fc
ON fc.film_id = f.film_id
JOIN category c
ON c.category_id = fc.category_id
WHERE c.name = 'family'
;

-- 7e
-- what are people renting
SELECT title, rental_rate FROM film
ORDER BY rental_rate DESC
;

-- 7f
select s.store_id 'Store', a.address,  sum(p.amount) 'Total Amount' from store s
JOIN customer c
ON c.store_id = s.store_id
JOIN payment p 
ON p.customer_id = c.customer_id
JOIN address a 
ON a.address_id = s.address_id
GROUP BY s.store_id 
;

-- 7g
-- They really need better names for their stores
select s.store_id, c.city, co.country from store s
JOIN address a
ON a.address_id = s.address_id
JOIN city c
ON c.city_id = a.city_id
JOIN country co
ON co.country_id = c.country_id
;



-- 7h
SELECT  c.name, count(p.amount) 'amount' 
FROM category c
JOIN film_category fc
ON fc.category_id = c.category_id
JOIN inventory i 
ON i.film_id = fc.film_id
JOIN rental r
ON r.inventory_id = i.inventory_id
JOIN payment p 
ON  p.rental_id = r.rental_id
GROUP BY c.name
order  by count(p.amount) desc
;

 -- 8a
CREATE view top_categories as
SELECT  c.name, count(p.amount) 'amount' 
FROM category c
JOIN film_category fc
ON fc.category_id = c.category_id
JOIN inventory i 
ON i.film_id = fc.film_id
JOIN rental r
ON r.inventory_id = i.inventory_id
JOIN payment p 
ON  p.rental_id = r.rental_id
GROUP BY c.name
order  by count(p.amount) desc
limit 5
;
-- 8b
SELECT * FROM top_categories
;

-- 8c
DROP view top_categories;