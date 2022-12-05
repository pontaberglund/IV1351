CREATE TABLE student (
    student_id INT NOT NULL,
    PRIMARY KEY(student_id), 
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    person_number VARCHAR(12) NOT NULL,
    address VARCHAR(100) NOT NULL,
    zip CHAR(5) NOT NULL,
    city VARCHAR(100) NOT NULL
);

CREATE TABLE lesson (
    type VARCHAR(50) NOT NULL, 
    date DATE NOT NULL,
    lesson_id INT NOT NULL,
    student_id INT REFERENCES student(student_id) ON DELETE NO ACTION NOT NULL,
    PRIMARY KEY(student_id, lesson_id, type),
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    price INT NOT NULL
);

CREATE extension dblink;