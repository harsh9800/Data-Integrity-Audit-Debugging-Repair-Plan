1. Create staging copies of affected tables
CREATE TABLE students_staging AS
SELECT * FROM students;

CREATE TABLE submissions_staging AS
SELECT * FROM submissions;

CREATE TABLE contests_staging AS
SELECT * FROM contests;

CREATE TABLE attendance_staging AS
SELECT * FROM attendance;

CREATE TABLE batches_staging AS
SELECT * FROM batches;

Repair 1 — Negative score in submissions
Issue

Submission SUB000056 has score -10.

Repair
UPDATE submissions_staging
SET score = 0
WHERE submission_id = 'SUB000056';

Repair 2 — Student linked to missing batch
Issue

Student S0148 has invalid batch B999.

Repair

Move record to review list.

CREATE TABLE IF NOT EXISTS students_review AS
SELECT *
FROM students
WHERE 1 = 0;

INSERT INTO students_review
SELECT *
FROM students_staging
WHERE student_id = 'S0148';

DELETE FROM students_staging
WHERE student_id = 'S0148';

Repair 3 — Contest end time before start time
Issue

Contest CT005

End time earlier than start time.

Repair
UPDATE contests_staging
SET end_time = '2025-04-05 13:00:00'
WHERE contest_id = 'CT005';