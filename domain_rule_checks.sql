Detect invalid values or records violating business rules.
If query returns no rows:
Passed

If rows returned:
Failed

1. Negative scores
Score should never be negative.

SELECT *
FROM submissions
WHERE score < 0;
Why it matters

Negative marks are invalid and make score calculations incorrect.

2. Scores greater than maximum allowed marks

Example if max_score exists in problems:

SELECT s.submission_id,
       s.score,
       p.max_score
FROM submissions s
JOIN problems p
ON s.problem_id = p.problem_id
WHERE s.score > p.max_score;
Why it matters

A student cannot score above allowed marks.

3. Invalid difficulty values

Allowed:
easy, medium, hard

SELECT *
FROM problems
WHERE difficulty NOT IN ('easy', 'medium', 'hard');
Why it matters

Wrong difficulty values affect filtering and reports.

4. Invalid submission statuses

Example allowed:
pending, accepted, rejected

SELECT *
FROM submissions
WHERE submission_status NOT IN
('pending', 'accepted', 'rejected');
Why it matters

Invalid status breaks analytics.

5. Invalid programming language values

Example:

SELECT *
FROM submissions
WHERE language NOT IN
('python', 'java', 'javascript', 'cpp');
Why it matters

Unexpected values create inconsistent reports.

6. Invalid test-result statuses

Example:

SELECT *
FROM test_results
WHERE status NOT IN
('passed', 'failed');
Why it matters

Wrong status affects evaluation.

7. Invalid attendance statuses

From your attendance file.

Allowed:
present, absent

SELECT *
FROM attendance
WHERE attendance_status NOT IN
('present', 'absent');
Why it matters

Attendance percentage becomes inaccurate.

8. Invalid contest statuses

Example:

SELECT *
FROM contests
WHERE contest_status NOT IN
('scheduled', 'active', 'completed');
Why it matters

Contest reporting becomes unreliable.

9. Invalid operation request states

Example regrade requests.

SELECT *
FROM regrade_requests
WHERE request_status NOT IN
('pending', 'approved', 'rejected');
Why it matters

Workflow becomes inconsistent.

10. End time before start time

Contests
SELECT *
FROM contests
WHERE end_time < start_time;
Why it matters

Impossible timing.

11. Resolved time before requested time
SELECT *
FROM regrade_requests
WHERE resolved_at < requested_at;
Why it matters

Resolution cannot happen before request.

12. Executed time before requested time

Example operation logs.

SELECT *
FROM operation_requests
WHERE executed_at < requested_at;
Why it matters

Timeline invalid.

13. Submission timestamp before enrollment date
SELECT s.submission_id,
       s.submitted_at,
       e.enrolled_at
FROM submissions s
JOIN enrollments e
ON s.student_id = e.student_id
AND s.course_id = e.course_id
WHERE s.submitted_at < e.enrolled_at;
Why it matters

Student submitted before enrolling.

14. NULL or blank mandatory columns

Example students:

SELECT *
FROM students
WHERE student_id IS NULL
   OR full_name IS NULL
   OR full_name = '';

Attendance:

SELECT *
FROM attendance
WHERE attendance_id IS NULL
   OR session_id IS NULL
   OR student_id IS NULL
   OR attendance_status IS NULL
   OR attendance_status = '';

Submissions:

SELECT *
FROM submissions
WHERE submission_id IS NULL
   OR student_id IS NULL
   OR problem_id IS NULL;
Why it matters

Mandatory fields missing make joins fail.

Additional rule checks

These are good to include.

15. Duplicate email with blanks ignored
SELECT email, COUNT(*)
FROM students
WHERE email IS NOT NULL
AND email <> ''
GROUP BY email
HAVING COUNT(*) > 1;
16. Future attendance date

If marked_at should not be future:

SELECT *
FROM attendance
WHERE marked_at > CURRENT_TIMESTAMP;
17. Empty problem title
SELECT *
FROM problems
WHERE title IS NULL
OR title = '';
18. Score exists but submission pending

Example inconsistent state:

SELECT *
FROM submissions
WHERE submission_status = 'pending'
AND score IS NOT NULL;