-- Student Database Management System
-- Q2: MySQL SQL-based exercise
-- Run in MySQL Workbench

-- 1. Create and select database
CREATE DATABASE IF NOT EXISTS student_db;
USE student_db;

-- 2. Create students table
CREATE TABLE IF NOT EXISTS students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    course_name VARCHAR(100),
    programming_score INT CHECK (programming_score BETWEEN 0 AND 100),
    mathematics_score INT CHECK (mathematics_score BETWEEN 0 AND 100)
);

-- 3. Create technical_skills table
CREATE TABLE IF NOT EXISTS technical_skills (
    student_id INT,
    skill VARCHAR(50),
    PRIMARY KEY (student_id, skill),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- 4. Insert sample students
INSERT INTO students (student_id, student_name, email, course_name, programming_score, mathematics_score)
VALUES
(101, 'Aman', 'aman@example.com', 'CSIT', 90, 80),
(102, 'Riya', 'riya@example.com', 'CSIT', 45, 85),
(103, 'Rahul', 'rahul@example.com', 'CSIT', 65, 60),
(104, 'Neha', 'neha@example.com', 'CSIT', 40, 78),
(105, 'Karan', 'karan@example.com', 'CSIT', 75, 90);

-- 5. Insert technical skills
INSERT INTO technical_skills (student_id, skill)
VALUES
(101, 'Java'), (101, 'Python'), (101, 'SQL'),
(102, 'Python'), (102, 'SQL'),
(103, 'Java'), (103, 'C++'),
(104, 'Python'), (104, 'SQL'),
(105, 'Java'), (105, 'Python');

-- 6. Calculate average score for each student
SELECT student_id, student_name,
       (programming_score + mathematics_score) / 2 AS average_score
FROM students;

-- 7. Classify performance using CASE
SELECT student_id, student_name,
       (programming_score + mathematics_score) / 2 AS average_score,
       CASE
           WHEN (programming_score + mathematics_score) / 2 >= 80 THEN 'Excellent'
           WHEN (programming_score + mathematics_score) / 2 >= 60 THEN 'Good'
           WHEN (programming_score + mathematics_score) / 2 >= 40 THEN 'Average'
           ELSE 'Needs Improvement'
       END AS performance
FROM students;

-- 8. Find stronger subject for each student
SELECT student_id, student_name,
       CASE
           WHEN programming_score > mathematics_score THEN 'Programming'
           WHEN mathematics_score > programming_score THEN 'Mathematics'
           ELSE 'Equal'
       END AS stronger_subject
FROM students;

-- 9. Search by student ID
SELECT * FROM students WHERE student_id = 101;

-- 10. Search by email
SELECT * FROM students WHERE email = 'riya@example.com';

-- 11. Search by course
SELECT * FROM students WHERE course_name = 'CSIT';

-- 12. Merit list (highest average first)
SELECT student_id, student_name,
       (programming_score + mathematics_score) / 2 AS average_score
FROM students
ORDER BY average_score DESC;

-- 13. Find skills shared by multiple students
SELECT skill, COUNT(DISTINCT student_id) AS student_count
FROM technical_skills
GROUP BY skill
HAVING COUNT(DISTINCT student_id) > 1;

-- 14. Display students and their skills
SELECT s.student_name, ts.skill
FROM students s
JOIN technical_skills ts ON s.student_id = ts.student_id
ORDER BY s.student_id, ts.skill;

-- 15. Find students with programming score below 50
-- and mathematics score at least 75
SELECT * FROM students
WHERE programming_score < 50
  AND mathematics_score >= 75;

-- 16. Validation test: duplicate student ID
-- Uncomment to test PRIMARY KEY validation (will produce an error)
-- INSERT INTO students VALUES (101, 'Duplicate', 'duplicate@example.com', 'CSIT', 50, 50);

-- 17. Validation test: score outside range
-- Uncomment to test CHECK validation (will produce an error on supported MySQL versions)
-- INSERT INTO students VALUES (106, 'Test', 'test@example.com', 'CSIT', 110, 50);
