1: Row count of each table

SELECT COUNT(*) AS student_count
FROM students;
SELECT COUNT(*) AS batch_count
FROM batches;
SELECT COUNT(*) AS problem_count
FROM problems;
SELECT COUNT(*) AS submission_count
FROM submissions;

2: Number of distinct primary key values in each table 
This helps detect duplicate primary keys.

Students
SELECT COUNT(DISTINCT student_id) AS distinct_students
FROM students;
Batches
SELECT COUNT(DISTINCT batch_id) AS distinct_batches
FROM batches;
Problems
SELECT COUNT(DISTINCT problem_id) AS distinct_problems
FROM problems;
Submissions
SELECT COUNT(DISTINCT submission_id) AS distinct_submissions
FROM submissions;

3: NULL or blank values in important columns
Check missing values.

Students
SELECT
    COUNT(*) FILTER (WHERE student_id IS NULL) AS null_student_id,
    COUNT(*) FILTER (WHERE full_name IS NULL OR full_name = '') AS blank_name,
    COUNT(*) FILTER (WHERE batch_id IS NULL) AS null_batch
FROM students;
Batches
SELECT
    COUNT(*) FILTER (WHERE batch_id IS NULL) AS null_batch_id,
    COUNT(*) FILTER (WHERE batch_name IS NULL OR batch_name = '') AS blank_batch_name
FROM batches;
Problems
SELECT
    COUNT(*) FILTER (WHERE problem_id IS NULL) AS null_problem_id,
    COUNT(*) FILTER (WHERE title IS NULL OR title = '') AS blank_title
FROM problems;
Submissions
SELECT
    COUNT(*) FILTER (WHERE submission_id IS NULL) AS null_submission_id,
    COUNT(*) FILTER (WHERE student_id IS NULL) AS null_student,
    COUNT(*) FILTER (WHERE problem_id IS NULL) AS null_problem,
    COUNT(*) FILTER (WHERE score IS NULL) AS null_score
FROM submissions;

4: Whether any expected table is empty

SELECT
    'students' AS table_name,
    COUNT(*) AS rows
FROM students

UNION ALL

SELECT
    'batches',
    COUNT(*)
FROM batches

UNION ALL

SELECT
    'problems',
    COUNT(*)
FROM problems

UNION ALL

SELECT
    'submissions',
    COUNT(*)
FROM submissions;

5: Verify imported counts match CSV files

After checking CSV manually:
Example:
table	CSV rows	DB rows
students	150	150
batches	5	5
problems	50	50
submissions	1200	1200

If numbers match:
import successful

If mismatch:
skipped rows
wrong delimiter
duplicate import
import failed