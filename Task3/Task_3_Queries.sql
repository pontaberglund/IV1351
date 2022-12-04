/*Total, Individual, group and ensemble lessons per month*/
SELECT
    date_part('month', tim1.date) AS month,
    COUNT(*) AS total,
    COUNT(individual_lesson_id) AS individual_lesson,
    COUNT(group_lesson_id) AS group_lesson,
    COUNT(ensemble_id) AS ensemble
FROM
    time_slot AS tim1 FULL OUTER JOIN group_lesson AS gro
    ON tim1.time_slot_id=gro.time_slot_id
    FULL OUTER JOIN ensemble AS ens 
    ON tim1.time_slot_id=ens.time_slot_id 
    FULL OUTER JOIN individual_lesson AS ind
    ON tim1.time_slot_id=ind.time_slot_id
    WHERE tim1.date BETWEEN '2023-01-01' AND '2023-12-31'
    GROUP BY date_part('month', tim1.date)
    ORDER BY date_part('month', tim1.date);

/*SIBLINGS*/
SELECT
COUNT(*) AS students_with_siblings,
siblings AS amount_of_siblings
FROM
(SELECT
student_id, COUNT(stu.sibling_id) AS siblings
FROM
student_sibling AS stu GROUP BY student_id) AS foo
GROUP BY siblings
UNION
SELECT COUNT(student_id), 0
FROM student 
WHERE student_id NOT IN (SELECT student_id FROM student_sibling) ORDER BY amount_of_siblings;

/*List all instructors who has given moret than a specific number of lessons during the current month*/

/*During 2023*/
SELECT 
    instructor_id,
    COUNT(*) AS amount
FROM
    ((SELECT
        instructor_id
    FROM 
        individual_lesson NATURAL JOIN time_slot
        WHERE time_slot.date BETWEEN '2023-01-01' AND '2023-12-31')
    UNION ALL
    (SELECT
        instructor_id
    FROM
        group_lesson NATURAL JOIN time_slot
        WHERE time_slot.date BETWEEN '2023-01-01' AND '2023-12-31')
    UNION ALL
    (SELECT
        instructor_id
    FROM
        ensemble NATURAL JOIN time_slot
        WHERE time_slot.date BETWEEN '2023-01-01' AND '2023-12-31')) AS foo
    GROUP BY 1
    HAVING COUNT(*) > 2
    ORDER BY COUNT(*) DESC;

/*During current month*/
SELECT 
    instructor_id,
    COUNT(*) AS amount
FROM
    ((SELECT
        instructor_id
    FROM 
        individual_lesson NATURAL JOIN time_slot
        WHERE date_part('month', time_slot.date)=date_part('month', current_date)
        AND date_part('year', time_slot.date)=date_part('year', current_date))
    UNION ALL
    (SELECT
        instructor_id
    FROM
        group_lesson NATURAL JOIN time_slot
        WHERE date_part('month', time_slot.date)=date_part('month', current_date)
        AND date_part('year', time_slot.date)=date_part('year', current_date))
    UNION ALL
    (SELECT
        instructor_id
    FROM
        ensemble NATURAL JOIN time_slot
        WHERE date_part('month', time_slot.date)=date_part('month', current_date)
        AND date_part('year', time_slot.date)=date_part('year', current_date))) AS foo
    GROUP BY 1
    HAVING COUNT(*) > 2
    ORDER BY COUNT(*) DESC;
    




/* ENSEMBLES */
/*All ensembles during 2023*/
SELECT 
    id,
    CASE 
    WHEN genre=1 THEN 'Blues'
    WHEN genre=2 THEN 'Country'
    WHEN genre=3 THEN 'Electronic'
    WHEN genre=4 THEN 'Jazz'
    WHEN genre=5 THEN 'Hip Hop'
    WHEN genre=6 THEN 'Pop'
    WHEN genre=7 THEN 'Rock'
    ELSE 'X'
    END AS genre,
    day,
    CASE
    WHEN places-people= 0 THEN 'full'
    WHEN places-people < 2 THEN '1-2 seats left'
    ELSE '>2 seats left'
    END AS places_left
FROM 
(
SELECT
    ens.ensemble_id AS id,
    ens.genre_id AS genre,
    date_part('isodow', tim.date) AS day,
    ens.number_of_places AS places,
    COUNT(student_id) AS people
FROM
    ensemble AS ens INNER JOIN student_in_ensemble AS stu
    ON ens.ensemble_id=stu.ensemble_id
    INNER JOIN time_slot AS tim
    ON ens.time_slot_id=tim.time_slot_id
    WHERE tim.date BETWEEN '2023-01-01' AND '2023-12-31'
    GROUP BY ens.ensemble_id, tim.date
) AS f
ORDER BY genre, day;

/*Ensembles next week*/
SELECT 
    id,
    CASE 
    WHEN genre=1 THEN 'Blues'
    WHEN genre=2 THEN 'Country'
    WHEN genre=3 THEN 'Electronic'
    WHEN genre=4 THEN 'Jazz'
    WHEN genre=5 THEN 'Hip Hop'
    WHEN genre=6 THEN 'Pop'
    WHEN genre=7 THEN 'Rock'
    ELSE 'X'
    END AS genre,
    day,
    CASE
    WHEN places-people= 0 THEN 'full'
    WHEN places-people < 2 THEN '1-2 seats left'
    ELSE '>2 seats left'
    END AS places_left
FROM 
(
SELECT
    ens.ensemble_id AS id,
    ens.genre_id AS genre,
    date_part('isodow', tim.date) AS day,
    ens.number_of_places AS places,
    COUNT(student_id) AS people
FROM
    ensemble AS ens INNER JOIN student_in_ensemble AS stu
    ON ens.ensemble_id=stu.ensemble_id
    INNER JOIN time_slot AS tim
    ON ens.time_slot_id=tim.time_slot_id
    WHERE tim.date BETWEEN current_date AND current_date + interval '7 days'
    GROUP BY ens.ensemble_id, tim.date
) AS f
ORDER BY genre, day; 


/*Using views*/



