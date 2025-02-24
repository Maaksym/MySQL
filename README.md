# MySQL
This database models a university system where institutions, teachers, students, groups, and subjects are connected.

Institutions - universities that have a rector, dean, and contact information.
Employees - the faculty and administration who work at a particular institution.
Students - people who study at the university, have a date of birth and a unique PESEL.
Groups - study groups with a specific year of entry and a tutor.
Subjects - disciplines taught by teachers.
Grades Journal - contains students' grades for the semesters.

Main connections:
Lecturers are assigned to institutions.
Students are organized into groups.
Each subject has a teacher.
Grades are linked to students and subjects.
