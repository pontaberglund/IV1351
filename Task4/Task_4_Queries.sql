
CREATE VIEW list_instrument_in_stock AS
SELECT
    ins.instrument_in_stock_id AS id,
    ins.brand AS brand,
    enum.instrument AS instrument, 
    ins.price
FROM 
    instrument_in_stock AS ins 
    INNER JOIN instrument AS enum
    ON ins.instrument_id=enum.instrument_id
    WHERE ins.rental_id IS NULL;

CREATE VIEW list_instrument_not_in_stock AS
SELECT
    ins.instrument_in_stock_id AS id,
    ins.brand AS brand,
    enum.instrument AS instrument, 
    ins.rental_id AS belong_to_rental
FROM 
    instrument_in_stock AS ins 
    INNER JOIN instrument AS enum
    ON ins.instrument_id=enum.instrument_id
    WHERE ins.rental_id IS NOT NULL;
 

CREATE VIEW list_student_and_rentals AS 
SELECT
    s.student_id AS student_id,
    p.first_name AS first_name,
    p.last_name AS last_name,
    r.rental_id AS rental_id,
    ins.instrument AS instrument,
    i.brand AS brand,
    r.start_date,
    r.end_date,
    CASE
        WHEN r.home_delivery='1' THEN 'YES'
        ELSE 'NO'
    END AS home_delivery
FROM
    student AS s INNER JOIN person AS p
    ON s.person_id=p.person_id
    INNER JOIN rental AS r
    ON s.student_id=r.student_id
    INNER JOIN instrument_in_stock AS i
    ON r.rental_id=i.rental_id
    INNER JOIN instrument AS ins
    ON i.instrument_id=ins.instrument_id;


/*Get the latest rental_id*/
SELECT rental_id FROM rental ORDER BY rental.rental_id DESC LIMIT 1;

/*Amount of rentals per student*/
SELECT
    student_id,
    COUNT(*)
FROM 
    rental GROUP BY student_id;
