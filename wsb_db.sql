CREATE DATABASE wsb_db_grupa4 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE wsb_db_grupa4;

CREATE TABLE Placowka (
Id INT AUTO_INCREMENT PRIMARY KEY,
Nazwa VARCHAR(255) NOT NULL,
Adres VARCHAR(255),
Telefon VARCHAR(20),
Email VARCHAR(100),
Rektor VARCHAR(255),
Dziekan VARCHAR(255)
);

CREATE TABLE Pracownicy (
Id INT AUTO_INCREMENT PRIMARY KEY,
Imie VARCHAR(50) NOT NULL,
Nazwisko VARCHAR(50) NOT NULL,
Plec CHAR(1),
Numer_telefonu VARCHAR(20),
Adres_zamieszkania VARCHAR(255),
PESEL CHAR(11) UNIQUE NOT NULL,
Data_zatrudnienia DATE,
Data_ustania_stosunku_pracy DATE,
Numer_konta VARCHAR(26),
Placowka_Id INT,
FOREIGN KEY (Placowka_Id) REFERENCES Placowka(Id)
);

CREATE TABLE Przedmioty (
Id INT AUTO_INCREMENT PRIMARY KEY,
Nazwa VARCHAR(100) NOT NULL,
Wykladowca_Id INT,
FOREIGN KEY (Wykladowca_Id) REFERENCES Pracownicy(Id)
);

CREATE TABLE Studenci (
Id INT AUTO_INCREMENT PRIMARY KEY,
Imie  VARCHAR(50) NOT NULL,
Nazwisko VARCHAR(50) NOT NULL,
Plec CHAR(1),
PESEL CHAR(11) UNIQUE NOT NULL,
Data_urodzenia DATE
);

CREATE TABLE Grupy (
Id INT AUTO_INCREMENT PRIMARY KEY,
Nazwa VARCHAR(100) NOT NULL,
Rocznik INT NOT NULL,
Opiekun_Id INT,
FOREIGN KEY (Opiekun_Id) REFERENCES Pracownicy(Id)
);

CREATE TABLE Grupy_Studenci (
Grupa_Id INT,
Student_Id INT,
PRIMARY KEY (Grupa_Id, student_Id),
FOREIGN KEY (grupa_Id) REFERENCES Grupy(Id),
FOREIGN KEY (Student_Id) REFERENCES Studenci(Id)
);

CREATE TABLE Dziennik (
Id INT AUTO_INCREMENT PRIMARY KEY,
Student_Id INT,
Przedmiot_Id INT,
Ocena_czastkowa DECIMAL(5,2),
Ocena_koncowa DECIMAL(5,2),
Semestr INT NOT NULL,
FOREIGN KEY (Student_Id) REFERENCES Studenci(Id),
FOREIGN KEY (Przedmiot_Id) REFERENCES Przedmioty(Id)
);

INSERT INTO Placowka (Nazwa, Adres, Telefon, Email, Rektor, Dziekan)
VALUES
    ('Uniwersytet Warszawski', 'ul. Krakowskie Przedmieście 26/28, 00-927 Warszawa', '22 123 45 67', 'kontakt@uw.edu.pl', 'Prof. Jan Kowalski', 'Dr Anna Nowak'),
    ('Uniwersytet Jagielloński', 'ul. Gołębia 24, 31-007 Kraków', '12 234 56 78', 'kontakt@uj.edu.pl', 'Prof. Marek Wiśniewski', 'Dr Katarzyna Zielińska');

INSERT INTO Pracownicy (Imie, Nazwisko, Plec, Numer_telefonu, Adres_zamieszkania, PESEL, Data_zatrudnienia, Data_ustania_stosunku_pracy, Numer_konta, Placowka_Id)
VALUES
    ('Jan', 'Kowalski', 'M', '123456789', 'ul. Wiatraczna 15, 04-130 Warszawa', '85012345678', '2010-09-01', NULL, '12345678901234567890123456', 1),
    ('Anna', 'Nowak', 'K', '987654321', 'ul. Pięciomorgowa 25, 05-150 Kraków', '87023456789', '2015-03-15', NULL, '98765432109876543210987654', 2);

INSERT INTO Przedmioty (Nazwa, Wykladowca_Id)
VALUES
    ('Matematyka', 1),
    ('Fizyka', 2);

INSERT INTO Studenci (Imie, Nazwisko, Plec, PESEL, Data_urodzenia)
VALUES
    ('Piotr', 'Kaczmarek', 'M', '12345678901', '1998-04-12'),
    ('Magdalena', 'Wiśniewska', 'K', '98765432101', '2000-09-24');

INSERT INTO Grupy (Nazwa, Rocznik, Opiekun_Id)
VALUES
    ('Grupa A', 2021, 1),
    ('Grupa B', 2021, 2);

INSERT INTO Grupy_Studenci (Grupa_Id, Student_Id)
VALUES
    (1, 1),
    (2, 2);

INSERT INTO Dziennik (Student_Id, Przedmiot_Id, Ocena_czastkowa, Ocena_koncowa, Semestr)
VALUES
    (1, 1, 4.5, 5.0, 1),
    (2, 2, 3.0, 3.5, 1);
    
-- Simple Queries
-- Displaying all establishments:
SELECT * FROM Placowka;
-- Display all employees working at a specific facility (e.g., with Id=1):
SELECT * FROM pracownicy WHERE Placowka_Id = 1;
-- List of all students:
SELECT * FROM studenci;

-- Joining tables
-- List of employees and their facilities:
SELECT p.imie, p.nazwisko, pl.nazwa
FROM Pracownicy p
JOIN Placowka pl ON p.placowka_Id = pl.Id;
-- List of students and groups to which they belong:
SELECT s.imie, s.nazwisko, g.nazwa
FROM studenci s 
JOIN grupy_studenci gs on s.Id = gs.Student_Id
JOIN grupy g on gs.Grupa_Id = g.Id;
-- List of subjects and lecturers who teach them:
SELECT prz.nazwa, p.imie, p.nazwisko
FROM przedmioty prz
JOIN pracownicy p ON prz.Wykladowca_Id = p.Id;

-- Queries with filters
-- Students with a final grade higher than 4.0 in the journal:
SELECT d.Id, d.ocena_koncowa, s.imie, s.nazwisko
FROM dziennik d 
JOIN studenci s ON d.Student_Id = s.Id
WHERE d.Ocena_koncowa > 4.0;
-- Employees hired after 2020:
SELECT data_zatrudnienia
FROM pracownicy 
WHERE data_zatrudnienia > 2020-01-01;

-- Students who obtained a final grade higher than the average final grade in their group

SELECT s. imie, s.nazwisko, g.nazwa, d.ocena_koncowa
FROM dziennik d 
JOIN studenci s ON d.Student_Id = s.Id
JOIN grupy_studenci gs ON s.Id = gs.Student_Id
JOIN grupy g ON gs.Grupa_Id = g.Id
WHERE d.Ocena_koncowa > (
SELECT AVG(d1.Ocena_koncowa)
FROM Dziennik d1
JOIN grupy_studenci gs1 on d1.Student_Id = gs1.Student_Id
WHERE gs1.Student_Id = gs.Grupa_Id
);

-- List of all employees with the name of the facility where they work
SELECT p.imie, p.nazwisko, pl.nazwa
FROM pracownicy p 
JOIN placowka pl
ON p.Placowka_Id = pl.Id;

-- List of students who do not have grades
SELECT s.imie, s.nazwisko
FROM studenci s 
JOIN Dziennik D 
ON s.Id = d.student_Id
WHERE d.Id IS NULL;
    
