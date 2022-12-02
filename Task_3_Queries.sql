/*Individual, group and ensemble lessons per month*/
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




