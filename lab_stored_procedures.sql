-- convert previous query into stored procedure:
DELIMITER //

CREATE PROCEDURE GetCustomersRentingActionMovies()
BEGIN
    SELECT first_name, last_name, email
    FROM customer
    JOIN rental ON customer.customer_id = rental.customer_id
    JOIN inventory ON rental.inventory_id = inventory.inventory_id
    JOIN film ON film.film_id = inventory.film_id
    JOIN film_category ON film_category.film_id = film.film_id
    JOIN category ON category.category_id = film_category.category_id
    WHERE category.name = "Action"
    GROUP BY first_name, last_name, email;
END //

DELIMITER ;

CALL GetCustomersRentingActionMovies();

-- make the stored procedure more dynamic:

DELIMITER //

CREATE PROCEDURE GetCustomersRentsMovsPerCategory(IN categoryName VARCHAR(255))
BEGIN
    SELECT 
        c.first_name, 
        c.last_name, 
        c.email,
        ca.name AS category_name
    FROM customer c
    JOIN rental r ON c.customer_id = r.customer_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON f.film_id = i.film_id
    JOIN film_category fc ON fc.film_id = f.film_id
    JOIN category ca ON ca.category_id = fc.category_id
    WHERE ca.name = categoryName
    GROUP BY c.first_name, c.last_name, c.email, category_name;
END //

DELIMITER ;
CALL GetCustomersRentsMovsPerCategory('Action');
CALL GetCustomersRentsMovsPerCategory('Animation');

-- Write a query to check the number of movies released in each movie category. Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. Pass that number as an argument in the stored procedure.

SELECT 
    c.name as category_name,
    COUNT(distinct f.film_id) as released
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY category_name;

-- 

DELIMITER //

CREATE PROCEDURE FilterCategsByMovieCount(IN minMoviesReleased INT)
BEGIN
    SELECT 
        c.name as category_name,
        count(distinct f.film_id) as `released`
    FROM category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN film f ON fc.film_id = f.film_id
    GROUP BY category_name
    HAVING `released` > minMoviesReleased;
END //

DELIMITER ;

-- Testing it:
CALL FilterCategsByMovieCount(5);