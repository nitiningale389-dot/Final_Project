🎓 University Course Management System

A relational database project built with MySQL 8.0+ for managing core university academic operations. The system models students, courses, departments, instructors, and course registrations while demonstrating practical SQL concepts ranging from database design and constraints to advanced analytical queries.






📖 About the Project

The University Course Management System is designed to represent the academic operations of a university using a structured relational database.

It provides a centralized way to store and analyze information related to:

🎓 Students

📚 Courses

🏛️ Academic departments

👨‍🏫 Instructors

📝 Student course enrollments

The project was created to demonstrate how SQL can be used not only for storing data, but also for maintaining data integrity and generating meaningful reports from multiple related tables.

🎯 Project Goals

The main objectives of this project are to:

Design a normalized relational database.

Establish relationships between academic entities.

Maintain data consistency through primary and foreign keys.

Perform complete CRUD operations.

Retrieve information using different types of joins.

Generate departmental and course-level statistics.

Work with nested and correlated filtering logic.

Apply SQL window functions for analytical reporting.

Use string, date, aggregate, and conditional functions.

Build a foundation that can be extended into a larger university management system.

🏛️ Database Design

The database consists of five main tables:

Table	Purpose
Departments	Stores university departments
Students	Maintains student information
Courses	Contains the course catalog
Instructors	Stores faculty information and salaries
Enrollments	Connects students with the courses they take
🔗 Relationship Overview

The relationships between the entities are:

Departments
   │
   ├───────────────> Courses
   │                    │
   │                    │
   └───────────────> Instructors
                       

Students ────────────> Enrollments <──────────── Courses


A department can offer multiple courses and employ multiple instructors.

Students and courses have a many-to-many relationship, which is implemented through the Enrollments table.

🧩 Entity Relationship Diagram
erDiagram

    DEPARTMENTS ||--o{ COURSES : offers
    DEPARTMENTS ||--o{ INSTRUCTORS : employs

    STUDENTS ||--o{ ENROLLMENTS : creates
    COURSES ||--o{ ENROLLMENTS : receives

    DEPARTMENTS {
        INT DepartmentID PK
        VARCHAR DepartmentName
    }

    STUDENTS {
        INT StudentID PK
        VARCHAR FirstName
        VARCHAR LastName
        VARCHAR Email UK
        DATE BirthDate
        DATE EnrollmentDate
    }

    COURSES {
        INT CourseID PK
        VARCHAR CourseName
        INT DepartmentID FK
        INT Credits
    }

    INSTRUCTORS {
        INT InstructorID PK
        VARCHAR FirstName
        VARCHAR LastName
        VARCHAR Email UK
        INT DepartmentID FK
        DECIMAL Salary
    }

    ENROLLMENTS {
        INT EnrollmentID PK
        INT StudentID FK
        INT CourseID FK
        DATE EnrollmentDate
    }

🗂️ Database Schema
Departments

Contains information about academic departments.

Field	Type	Key / Constraint
DepartmentID	INT	Primary Key
DepartmentName	VARCHAR(50)	NOT NULL
Students

Stores student identity and university enrollment information.

Field	Type	Key / Constraint
StudentID	INT	Primary Key
FirstName	VARCHAR(50)	NOT NULL
LastName	VARCHAR(50)	NOT NULL
Email	VARCHAR(100)	UNIQUE, NOT NULL
BirthDate	DATE	—
EnrollmentDate	DATE	NOT NULL
Courses

Represents the university's available courses.

Field	Type	Key / Constraint
CourseID	INT	Primary Key
CourseName	VARCHAR(100)	NOT NULL
DepartmentID	INT	Foreign Key
Credits	INT	NOT NULL

DepartmentID references:

Departments(DepartmentID)

Instructors

Stores faculty details and departmental assignments.

Field	Type	Key / Constraint
InstructorID	INT	Primary Key
FirstName	VARCHAR(50)	NOT NULL
LastName	VARCHAR(50)	NOT NULL
Email	VARCHAR(100)	UNIQUE, NOT NULL
DepartmentID	INT	Foreign Key
Salary	DECIMAL(10,2)	NOT NULL
Enrollments

Acts as the junction table between students and courses.

Field	Type	Key / Constraint
EnrollmentID	INT	Primary Key
StudentID	INT	Foreign Key
CourseID	INT	Foreign Key
EnrollmentDate	DATE	NOT NULL

This table makes it possible for:

One student to register for multiple courses.

One course to have multiple students.

⚙️ SQL Concepts Demonstrated

This project covers several important areas of SQL and relational database management.

1. Database & Table Creation

The SQL script includes database and table creation with appropriate constraints.

Examples of concepts used:

CREATE DATABASE IF NOT EXISTS university_course_management;


Primary keys, foreign keys, NOT NULL, and UNIQUE constraints are used to protect data integrity.

2. CRUD Operations

The project demonstrates the four fundamental database operations:

Create

Adding new students, courses, instructors, departments, and enrollment records.

Read

Retrieving individual records or generating reports from multiple tables.

Update

Examples include:

Changing student email addresses.

Modifying course credits.

Updating department information.

Reassigning instructors.

Delete

Removing temporary or test records while respecting relational dependencies.

3. Relational Joins

Multiple tables can be combined to answer real-world academic questions.

Example

Retrieve students and the courses they are registered for:

SELECT
    s.FirstName,
    s.LastName,
    c.CourseName
FROM Students s
JOIN Enrollments e
    ON s.StudentID = e.StudentID
JOIN Courses c
    ON e.CourseID = c.CourseID;


A LEFT JOIN can also be used to identify students who currently have no course registrations.

4. Aggregation & Reporting

Aggregate functions are used to transform raw records into useful statistics.

Functions demonstrated include:

COUNT()
AVG()
MAX()


For example, enrollment totals can be grouped by department:

SELECT
    d.DepartmentName,
    COUNT(e.StudentID) AS TotalEnrollments
FROM Departments d
JOIN Courses c
    ON d.DepartmentID = c.DepartmentID
JOIN Enrollments e
    ON c.CourseID = e.CourseID
GROUP BY d.DepartmentName;


The project also demonstrates filtering grouped results with HAVING.

5. Subqueries

Nested queries are used when information needs to be filtered based on another query.

For example, students enrolled in both Introduction to SQL and Data Structures can be identified using separate subqueries.

SELECT s.*
FROM Students s
WHERE s.StudentID IN (
    SELECT e.StudentID
    FROM Enrollments e
    JOIN Courses c
        ON e.CourseID = c.CourseID
    WHERE c.CourseName = 'Introduction to SQL'
)
AND s.StudentID IN (
    SELECT e.StudentID
    FROM Enrollments e
    JOIN Courses c
        ON e.CourseID = c.CourseID
    WHERE c.CourseName = 'Data Structures'
);


This demonstrates how multiple query results can be used as filtering conditions.

6. Window Functions

The project also introduces analytical SQL through window functions.

For example, a cumulative enrollment count can be generated with:

SELECT
    EnrollmentID,
    StudentID,
    CourseID,
    EnrollmentDate,
    COUNT(*) OVER (
        ORDER BY EnrollmentDate
    ) AS RunningEnrollmentTotal
FROM Enrollments;


Unlike a normal GROUP BY, the window function keeps individual enrollment records while adding an analytical value to each row.

7. Conditional Logic

CASE expressions are used to dynamically categorize records.

Example:

SELECT
    StudentID,
    FirstName,
    LastName,
    EnrollmentDate,
    CASE
        WHEN EnrollmentDate <= DATE_SUB(CURDATE(), INTERVAL 4 YEAR)
            THEN 'Senior'
        ELSE 'Junior'
    END AS StudentStatus
FROM Students;


This demonstrates how SQL can be used to transform raw database values into meaningful categories.

8. String & Date Functions

The project also uses built-in SQL functions for data transformation.

Full Name
CONCAT(FirstName, ' ', LastName)

Enrollment Year
YEAR(EnrollmentDate)

Date Comparison
DATE_SUB(CURDATE(), INTERVAL 4 YEAR)


These functions make it possible to create more useful reports without changing the underlying data.

📊 Example Business Questions

The database can be used to answer questions such as:

Which students are enrolled in a particular course?

How many students are registered in each course?

How many enrollments does each department have?

Which students are taking multiple specified courses?

Which students have no current course registrations?

What is the average number of credits offered?

What is the highest instructor salary within each department?

How have enrollments accumulated over time?

Which students meet a particular academic classification?

Which instructors belong to each department?

🛠️ Technology Stack
Technology	Usage
MySQL 8.0+	Database engine
SQL	Database queries and analytics
MySQL Workbench	Database development/testing
DBeaver	Optional database client
DataGrip	Optional SQL IDE
Mermaid	ER diagram visualization
🚀 Installation & Setup
Prerequisites

Before running the project, make sure you have:

MySQL Server 8.0 or newer

A MySQL-compatible client

The project SQL file

You can use MySQL Workbench, DBeaver, DataGrip, or the MySQL CLI.

1. Clone the Repository
git clone https://github.com/your-username/university-course-management.git


Move into the project directory:

cd university-course-management

2. Run the SQL Script

Using the MySQL command line:

mysql -u your_username -p < "final project.sql"


Alternatively, open final project.sql in your preferred SQL client and execute the complete script.

3. Verify the Database

After execution, the following database should be available:

university_course_management


You can then inspect the tables and execute the included queries.

📁 Project Structure
university-course-management/
│
├── final project.sql
├── README.md
└── LICENSE

File Description

final project.sql

Contains the database creation script, table definitions, sample data, CRUD operations, joins, aggregations, subqueries, window functions, and analytical queries.

README.md

Project documentation, database architecture, setup instructions, and SQL feature overview.

LICENSE

Contains the licensing terms for the project.

🔐 Data Integrity

The database uses relational constraints to reduce invalid or inconsistent data.

Key integrity mechanisms include:

Primary key constraints for unique record identification.

Foreign keys for relationships between tables.

Unique constraints for email addresses.

NOT NULL constraints for required attributes.

Structured relationships between departments, courses, instructors, students, and enrollments.

🔮 Possible Improvements

The current system provides a foundation that can be expanded with additional functionality.

Potential future additions include:

Performance

Add indexes to frequently searched columns.

Analyze query execution plans.

Optimize complex joins and subqueries.

Database Automation

Add triggers for enrollment validation.

Automatically enforce course capacity limits.

Record changes using audit tables.

Reusable SQL Logic

Create stored procedures for student registration.

Add procedures for generating student transcripts.

Create functions for calculating academic classifications.

Reporting

Create SQL views for commonly requested reports.

Add GPA and grade management.

Build semester-wise enrollment reports.

Introduce dashboards using tools such as Power BI or Tableau.

Expanded Academic Model

Future versions could introduce:

Students
    │
    ├── Programs
    ├── Semesters
    ├── Grades
    ├── Attendance
    └── Fees

Courses
    │
    ├── Sections
    ├── Prerequisites
    └── Schedules


This would allow the database to evolve from a course registration system into a more complete academic management platform.

🧠 Learning Outcomes

By completing this project, the following SQL and database concepts are demonstrated:

Relational database modeling

Entity relationships

Primary and foreign keys

Data normalization

DDL and DML

CRUD operations

Inner and outer joins

Aggregate functions

GROUP BY and HAVING

Nested subqueries

Conditional expressions

String functions

Date functions

Window functions

Analytical reporting

Referential integrity




📄 License


You are free to use, modify, and distribute the project according to the terms of the license.

⭐ Project Summary

The University Course Management System demonstrates how a properly structured relational database can be used to manage academic information and produce meaningful analytical reports.

From basic CRUD operations to joins, subqueries, aggregations, and window functions, the project provides practical examples of SQL techniques commonly used in real-world database applications.
