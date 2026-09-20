CREATE DATABASE IF NOT EXISTS university_course_management;
USE university_course_management;

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    BirthDate DATE,
    EnrollmentDate DATE
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100),
    DepartmentID INT,
    Credits INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    DepartmentID INT,
    Salary DECIMAL(10, 2),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    EnrollmentDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (CourseID) REFERENCES Courses(CourseID)
);

INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'Computer Science'),
(2, 'Mathematics');

INSERT INTO Students (StudentID, FirstName, LastName, Email, BirthDate, EnrollmentDate) VALUES
(1, 'John', 'Doe', 'john.doe@email.com', '2000-01-15', '2022-08-01'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', '1999-05-25', '2021-08-01');

INSERT INTO Courses (CourseID, CourseName, DepartmentID, Credits) VALUES
(101, 'Introduction to SQL', 1, 3),
(102, 'Data Structures', 2, 4);

INSERT INTO Instructors (InstructorID, FirstName, LastName, Email, DepartmentID, Salary) VALUES
(1, 'Alice', 'Johnson', 'alice.johnson@univ.com', 1, 75000.00),
(2, 'Bob', 'Lee', 'bob.lee@univ.com', 2, 68000.00);

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, EnrollmentDate) VALUES
(1, 1, 101, '2022-08-01'),
(2, 2, 102, '2021-08-01');

INSERT INTO Departments (DepartmentID, DepartmentName) VALUES (3, 'Physics');
SELECT * FROM Departments;
UPDATE Departments SET DepartmentName = 'Applied Mathematics' WHERE DepartmentID = 2;
DELETE FROM Departments WHERE DepartmentID = 3;

INSERT INTO Students (StudentID, FirstName, LastName, Email, BirthDate, EnrollmentDate)
VALUES (3, 'Mira', 'Patel', 'mira.patel@email.com', '2001-03-10', '2023-08-01');
SELECT * FROM Students;
UPDATE Students SET Email = 'john.doe2@email.com' WHERE StudentID = 1;
DELETE FROM Students WHERE StudentID = 3;

INSERT INTO Courses (CourseID, CourseName, DepartmentID, Credits)
VALUES (103, 'Database Systems', 1, 3);
SELECT * FROM Courses;
UPDATE Courses SET Credits = 4 WHERE CourseID = 101;
DELETE FROM Courses WHERE CourseID = 103;

INSERT INTO Instructors (InstructorID, FirstName, LastName, Email, DepartmentID, Salary)
VALUES (3, 'Carol', 'Smith', 'carol.smith@univ.com', 1, 71000.00);
SELECT * FROM Instructors;
UPDATE Instructors SET DepartmentID = 2 WHERE InstructorID = 1;
DELETE FROM Instructors WHERE InstructorID = 3;

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, EnrollmentDate)
VALUES (3, 1, 102, '2023-01-10');
SELECT * FROM Enrollments;
UPDATE Enrollments SET EnrollmentDate = '2023-01-15' WHERE EnrollmentID = 3;
DELETE FROM Enrollments WHERE EnrollmentID = 3;

SELECT * FROM Students
WHERE EnrollmentDate > '2022-12-31';

SELECT c.*
FROM Courses c
JOIN Departments d ON c.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Mathematics'
LIMIT 5;

SELECT CourseID, COUNT(StudentID) AS student_count
FROM Enrollments
GROUP BY CourseID
HAVING COUNT(StudentID) > 5;

SELECT s.*
FROM Students s
WHERE s.StudentID IN (
    SELECT e.StudentID FROM Enrollments e
    JOIN Courses c ON e.CourseID = c.CourseID
    WHERE c.CourseName = 'Introduction to SQL'
)
AND s.StudentID IN (
    SELECT e.StudentID FROM Enrollments e
    JOIN Courses c ON e.CourseID = c.CourseID
    WHERE c.CourseName = 'Data Structures'
);

SELECT DISTINCT s.*
FROM Students s
JOIN Enrollments e ON s.StudentID = e.StudentID
JOIN Courses c ON e.CourseID = c.CourseID
WHERE c.CourseName IN ('Introduction to SQL', 'Data Structures');

SELECT AVG(Credits) AS avg_credits FROM Courses;

SELECT MAX(i.Salary) AS max_salary
FROM Instructors i
JOIN Departments d ON i.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Computer Science';

SELECT d.DepartmentName, COUNT(e.StudentID) AS student_count
FROM Departments d
JOIN Courses c ON d.DepartmentID = c.DepartmentID
JOIN Enrollments e ON c.CourseID = e.CourseID
GROUP BY d.DepartmentName;

SELECT s.FirstName, s.LastName, c.CourseName
FROM Students s
INNER JOIN Enrollments e ON s.StudentID = e.StudentID
INNER JOIN Courses c ON e.CourseID = c.CourseID;

SELECT s.FirstName, s.LastName, c.CourseName
FROM Students s
LEFT JOIN Enrollments e ON s.StudentID = e.StudentID
LEFT JOIN Courses c ON e.CourseID = c.CourseID;

SELECT *
FROM Students
WHERE StudentID IN (
    SELECT StudentID FROM Enrollments
    WHERE CourseID IN (
        SELECT CourseID FROM Enrollments
        GROUP BY CourseID
        HAVING COUNT(StudentID) > 10
    )
);

SELECT StudentID, FirstName, LastName, YEAR(EnrollmentDate) AS EnrollmentYear
FROM Students;

SELECT InstructorID, CONCAT(FirstName, ' ', LastName) AS FullName
FROM Instructors;

SELECT EnrollmentID, StudentID, CourseID, EnrollmentDate,
    COUNT(*) OVER (ORDER BY EnrollmentDate) AS running_total_students
FROM Enrollments;

SELECT StudentID, FirstName, LastName, EnrollmentDate,
    CASE
        WHEN EnrollmentDate <= DATE_SUB(CURDATE(), INTERVAL 4 YEAR) THEN 'Senior'
        ELSE 'Junior'
    END AS StudentLabel
FROM Students;