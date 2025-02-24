CREATE DATABASE university_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE university_db;

CREATE TABLE Institution (
Id INT AUTO_INCREMENT PRIMARY KEY,
Name VARCHAR(255) NOT NULL,
Address VARCHAR(255),
Phone VARCHAR(20),
Email VARCHAR(100),
Rector VARCHAR(255),
Dean VARCHAR(255)
);

CREATE TABLE Employees (
Id INT AUTO_INCREMENT PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Gender CHAR(1),
PhoneNumber VARCHAR(20),
HomeAddress VARCHAR(255),
PESEL CHAR(11) UNIQUE NOT NULL,
HireDate DATE,
EndDate DATE,
BankAccount VARCHAR(26),
Institution_Id INT,
FOREIGN KEY (Institution_Id) REFERENCES Institution(Id)
);

CREATE TABLE Subjects (
Id INT AUTO_INCREMENT PRIMARY KEY,
Name VARCHAR(100) NOT NULL,
Lecturer_Id INT,
FOREIGN KEY (Lecturer_Id) REFERENCES Employees(Id)
);

CREATE TABLE Students (
Id INT AUTO_INCREMENT PRIMARY KEY,
FirstName  VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Gender CHAR(1),
PESEL CHAR(11) UNIQUE NOT NULL,
BirthDate DATE
);

CREATE TABLE Groups (
Id INT AUTO_INCREMENT PRIMARY KEY,
Name VARCHAR(100) NOT NULL,
Year INT NOT NULL,
Supervisor_Id INT,
FOREIGN KEY (Supervisor_Id) REFERENCES Employees(Id)
);

CREATE TABLE Groups_Students (
Group_Id INT,
Student_Id INT,
PRIMARY KEY (Group_Id, Student_Id),
FOREIGN KEY (Group_Id) REFERENCES Groups(Id),
FOREIGN KEY (Student_Id) REFERENCES Students(Id)
);

CREATE TABLE Gradebook (
Id INT AUTO_INCREMENT PRIMARY KEY,
Student_Id INT,
Subject_Id INT,
PartialGrade DECIMAL(5,2),
FinalGrade DECIMAL(5,2),
Semester INT NOT NULL,
FOREIGN KEY (Student_Id) REFERENCES Students(Id),
FOREIGN KEY (Subject_Id) REFERENCES Subjects(Id)
);

-- Inserting sample data
INSERT INTO Institution (Name, Address, Phone, Email, Rector, Dean)
VALUES
    ('University of Warsaw', 'ul. Krakowskie Przedmieście 26/28, 00-927 Warsaw', '22 123 45 67', 'contact@uw.edu.pl', 'Prof. John Smith', 'Dr. Anna Brown'),
    ('Jagiellonian University', 'ul. Gołębia 24, 31-007 Krakow', '12 234 56 78', 'contact@uj.edu.pl', 'Prof. Mark Wilson', 'Dr. Catherine Green');

INSERT INTO Employees (FirstName, LastName, Gender, PhoneNumber, HomeAddress, PESEL, HireDate, EndDate, BankAccount, Institution_Id)
VALUES
    ('John', 'Smith', 'M', '123456789', 'ul. Wiatraczna 15, 04-130 Warsaw', '85012345678', '2010-09-01', NULL, '12345678901234567890123456', 1),
    ('Anna', 'Brown', 'F', '987654321', 'ul. Pięciomorgowa 25, 05-150 Krakow', '87023456789', '2015-03-15', NULL, '98765432109876543210987654', 2);

INSERT INTO Subjects (Name, Lecturer_Id)
VALUES
    ('Mathematics', 1),
    ('Physics', 2);

INSERT INTO Students (FirstName, LastName, Gender, PESEL, BirthDate)
VALUES
    ('Peter', 'Kaczmarek', 'M', '12345678901', '1998-04-12'),
    ('Magdalena', 'Wilson', 'F', '98765432101', '2000-09-24');

INSERT INTO Groups (Name, Year, Supervisor_Id)
VALUES
    ('Group A', 2021, 1),
    ('Group B', 2021, 2);

INSERT INTO Groups_Students (Group_Id, Student_Id)
VALUES
    (1, 1),
    (2, 2);

INSERT INTO Gradebook (Student_Id, Subject_Id, PartialGrade, FinalGrade, Semester)
VALUES
    (1, 1, 4.5, 5.0, 1),
    (2, 2, 3.0, 3.5, 1);

-- Queries
-- Displaying all institutions:
SELECT * FROM Institution;
-- Display all employees working at a specific institution (e.g., with Id=1):
SELECT * FROM Employees WHERE Institution_Id = 1;
-- List of all students:
SELECT * FROM Students;

-- Joining tables
-- List of employees and their institutions:
SELECT e.FirstName, e.LastName, i.Name
FROM Employees e
JOIN Institution i ON e.Institution_Id = i.Id;
-- List of students and groups they belong to:
SELECT s.FirstName, s.LastName, g.Name
FROM Students s 
JOIN Groups_Students gs on s.Id = gs.Student_Id
JOIN Groups g on gs.Group_Id = g.Id;
-- List of subjects and lecturers who teach them:
SELECT sub.Name, e.FirstName, e.LastName
FROM Subjects sub
JOIN Employees e ON sub.Lecturer_Id = e.Id;

-- Queries with filters
-- Students with a final grade higher than 4.0 in the gradebook:
SELECT g.Id, g.FinalGrade, s.FirstName, s.LastName
FROM Gradebook g 
JOIN Students s ON g.Student_Id = s.Id
WHERE g.FinalGrade > 4.0;
-- Employees hired after 2020:
SELECT HireDate
FROM Employees 
WHERE HireDate > '2020-01-01';

-- Students who obtained a final grade higher than the average final grade in their group
SELECT s.FirstName, s.LastName, g.Name, gr.FinalGrade
FROM Gradebook gr 
JOIN Students s ON gr.Student_Id = s.Id
JOIN Groups_Students gs ON s.Id = gs.Student_Id
JOIN Groups g ON gs.Group_Id = g.Id
WHERE gr.FinalGrade > (
SELECT AVG(gr1.FinalGrade)
FROM Gradebook gr1
JOIN Groups_Students gs1 on gr1.Student_Id = gs1.Student_Id
WHERE gs1.Student_Id = gs.Group_Id
);

-- List of all employees with the name of the institution where they work
SELECT e.FirstName, e.LastName, i.Name
FROM Employees e 
JOIN Institution i
ON e.Institution_Id = i.Id;

-- List of students who do not have grades
SELECT s.FirstName, s.LastName
FROM Students s 
LEFT JOIN Gradebook g 
ON s.Id = g.Student_Id
WHERE g.Id IS NULL;
