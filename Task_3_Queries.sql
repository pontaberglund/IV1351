/*
Show the number of lessons given per month during a specified year. 
This query is expected to be performed a few times per week. 
It shall be possible to retrieve the total number of lessons per month (just one number per month)
and the specific number of individual lessons, group lessons and ensembles (three numbers per month). 
It's not required that all four numbers (total plus one per lesson type) for a particular month are on the same row;
 you're allowed to have one row for each number as long as it's clear to which month each number belongs. However,
it's most likely easier to understand the result if you do place all numbers for a particular month on the same row,
and it's an interesting exercise, therefore you're encouraged to try.
*/

/*Amount of individual lessons in 2023*/
SELECT COUNT(*) FROM (SELECT ind.individual_lesson_id FROM individual_lesson AS ind INNER JOIN instructor_availability AS ins ON 
ins.individual_lesson_id=ind.individual_lesson_id WHERE (ins.date BETWEEN '2023-01-01' AND '2023-12-31')) AS foo1;

/*Ind lessons per month using GROUP BY*/
SELECT COUNT(*) FROM (SELECT ind.individual_lesson_id FROM individual_lesson AS ind INNER JOIN instructor_availability AS ins ON 
ins.individual_lesson_id=ind.individual_lesson_id WHERE (ins.date BETWEEN '2023-01-01' AND '2023-12-31') GROUP BY ins.date) AS foo1;

/*Amount of group lessons in 2023*/
SELECT COUNT(*) FROM (SELECT gro.group_lesson_id FROM group_lesson AS gro INNER JOIN time_slot AS tim1 ON 
tim1.time_slot_id=gro.time_slot_id WHERE (tim1.date BETWEEN '2023-01-01' AND '2023-12-31')) AS foo2;

/*Individual lessons per month using GROUP BY*/
SELECT
    date_part('month', DATE) AS month,
    COUNT(*) AS individual_lesson
FROM
    instructor_availability AS ins INNER JOIN individual_lesson AS ind
    ON ins.individual_lesson_id=ind.individual_lesson_id
    WHERE ins.date BETWEEN '2023-01-01' AND '2023-12-31'
    GROUP BY 
    date_part('month', DATE) 
    ORDER BY date_part('month', DATE);

/*Group lessons per month using GROUP BY*/
SELECT 
    date_part('month', DATE) AS month,
    COUNT(*) AS group_lesson
FROM
    time_slot AS tim1 INNER JOIN group_lesson AS gro
    ON tim1.time_slot_id=gro.time_slot_id
    WHERE tim1.date BETWEEN '2023-01-01' AND '2023-12-31'
    GROUP BY 
    date_part('month', DATE)
    ORDER BY date_part('month', DATE);

/*Ensembles per month using GROUP BY*/
SELECT 
    date_part('month', DATE) AS month,
    COUNT(*) AS ensemble
FROM
    time_slot AS tim2 INNER JOIN ensemble AS ens
    ON tim2.time_slot_id=ens.time_slot_id
    WHERE tim2.date BETWEEN '2023-01-01' AND '2023-12-31'
    GROUP BY 
    date_part('month', DATE)
    ORDER BY date_part('month', DATE);

/*Group lessons and ensembles per month*/
SELECT
    date_part('month', tim1.date) AS month,
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

/*Individual, group and ensemble lessons per month*/
SELECT
    COUNT(individual_lesson_id) AS individual_lesson,
    COUNT(group_lesson_id) AS group_lesson,
    COUNT(ensemble_id) AS ensemble
FROM
        time_slot AS tim FULL OUTER JOIN group_lesson AS gro
        ON tim.time_slot_id=gro.time_slot_id
        FULL OUTER JOIN ensemble AS ens
        ON tim.time_slot_id=ens.time_slot_id
        FULL OUTER JOIN individual_lesson AS ind FULL OUTER JOIN instructor_availability AS ins
        ON ind.individual_lesson_id=ins.individual_lesson_id;
    UNION
    (
        instructor_availability AS ins INNER JOIN individual_lesson AS ind
        ON ins.individual_lesson_id=ind.individual_lesson_id
    )
    GROUP BY date_part('month', tim.date)
    GROUP BY date_part('month', ins.date);

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




