INSERT INTO student(student_id, first_name, last_name, person_number, address, zip, city)
SELECT student_id, first_name, last_name, person_number, address, zip, city
FROM dblink('dbname=newsgms user=postgres password=password',
'SELECT student_id, first_name, last_name, person_number, address, zip, city FROM person INNER JOIN student ON person.person_id=student.person_id')
AS student(student_id INT, first_name VARCHAR(50), last_name VARCHAR(50), person_number VARCHAR(12), address VARCHAR(100), zip CHAR(5), city VARCHAR(100));

INSERT INTO lesson(type, date, lesson_id, student_id, start_time, end_time, price)
SELECT type, date, lesson_id, student_id, start_time, end_time, price
FROM dblink('dbname=newsgms user=postgres password=password',
'SELECT
    ''individual_lesson'' AS type,
    tim.date, 
    ind.individual_lesson_id AS lesson_id, 
    ind.student_id, 
    tim.start_time AS start_time, 
    tim.end_time AS end_time,
    pri.price AS price
FROM
    individual_lesson AS ind 
    INNER JOIN time_slot AS tim
    ON ind.time_slot_id=tim.time_slot_id
    INNER JOIN lesson_price AS pri ON
    ind.lesson_price_id=pri.lesson_price_id')
AS lesson(type VARCHAR(50), date DATE, lesson_id INT, student_id INT, start_time TIME, end_time TIME, price INT);

INSERT INTO lesson(type, date, lesson_id, student_id, start_time, end_time, price)
SELECT type, date, lesson_id, student_id, start_time, end_time, price
FROM dblink('dbname=newsgms user=postgres password=password',
'SELECT
    ''group_lesson'' AS type,
    tim.date,
    gro.group_lesson_id AS lesson_id,
    stu.student_id,
    tim.start_time,
    tim.end_time,
    pri.price AS price
FROM
    group_lesson AS gro INNER JOIN time_slot AS tim
    ON gro.time_slot_id=tim.time_slot_id
    INNER JOIN student_in_group_lesson AS stu 
    ON gro.group_lesson_id=stu.group_lesson_id
    INNER JOIN lesson_price AS pri
    ON gro.lesson_price_id=pri.lesson_price_id')
AS lesson(type VARCHAR(50), date DATE, lesson_id INT, student_id INT, start_time TIME, end_time TIME, price INT);


INSERT INTO lesson(type, date, lesson_id, student_id, start_time, end_time, price)
SELECT type, date, lesson_id, student_id, start_time, end_time, price
FROM dblink('dbname=newsgms user=postgres password=password',
'SELECT
    ''ensemble'' AS type,
    tim.date,
    ens.ensemble_id AS lesson_id,
    stu.student_id,
    tim.start_time,
    tim.end_time,
    pri.price AS price
FROM
    ensemble AS ens INNER JOIN time_slot AS tim
    ON ens.time_slot_id=tim.time_slot_id
    INNER JOIN student_in_ensemble AS stu
    ON ens.ensemble_id=stu.ensemble_id
    INNER JOIN lesson_price AS pri
    ON ens.lesson_price_id=pri.lesson_price_id')
AS lesson(type VARCHAR(50), date DATE, lesson_id INT, student_id INT, start_time TIME, end_time TIME, price INT);