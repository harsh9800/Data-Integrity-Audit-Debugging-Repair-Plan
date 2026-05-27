1. Duplicate primary key values

A primary key should be unique.

Students
SELECT student_id, COUNT(*) AS duplicate_count
FROM students
GROUP BY student_id
HAVING COUNT(*) > 1;
Batches
SELECT batch_id, COUNT(*)
FROM batches
GROUP BY batch_id
HAVING COUNT(*) > 1;
Problems
SELECT problem_id, COUNT(*)
FROM problems
GROUP BY problem_id
HAVING COUNT(*) > 1;
Submissions
SELECT submission_id, COUNT(*)
FROM submissions
GROUP BY submission_id
HAVING COUNT(*) > 1;
Report note

If query returns no rows:

✅ Passed — no duplicate primary keys.

If rows appear:

❌ Failed — duplicate primary keys found.

2. Duplicate candidate key values

Candidate keys are fields expected to be unique.

Example: username

SELECT username, COUNT(*)
FROM students
GROUP BY username
HAVING COUNT(*) > 1;

Or course code:

SELECT course_code, COUNT(*)
FROM courses
GROUP BY course_code
HAVING COUNT(*) > 1;
3. Duplicate email values
SELECT email, COUNT(*)
FROM students
GROUP BY email
HAVING COUNT(*) > 1;
Result

No rows → Passed

Rows returned → Failed

4. Duplicate enrollment records

A student should not enroll twice in same course.

SELECT student_id, course_id, COUNT(*)
FROM enrollments
GROUP BY student_id, course_id
HAVING COUNT(*) > 1;
5. Duplicate contest-problem mappings

Same problem should not repeat in same contest.

SELECT contest_id, problem_id, COUNT(*)
FROM contest_problems
GROUP BY contest_id, problem_id
HAVING COUNT(*) > 1;
6. Duplicate test-case records

Example:

SELECT problem_id, test_case_id, COUNT(*)
FROM test_cases
GROUP BY problem_id, test_case_id
HAVING COUNT(*) > 1;
7. Duplicate test-result records

One test case per submission should appear once.

SELECT submission_id, test_case_id, COUNT(*)
FROM test_results
GROUP BY submission_id, test_case_id
HAVING COUNT(*) > 1;
8. Duplicate attendance records

Student attendance should be unique per session.

SELECT student_id, session_id, COUNT(*)
FROM attendance
GROUP BY student_id, session_id
HAVING COUNT(*) > 1;
Example report format
Check	Result
duplicate student_id	Passed
duplicate email	Passed
duplicate enrollment	Failed
duplicate contest-problem	Passed

1. Students linked to missing batches
SELECT s.student_id, s.batch_id
FROM students s
LEFT JOIN batches b
ON s.batch_id = b.batch_id
WHERE b.batch_id IS NULL;
Why it matters

If a student points to a batch that doesn’t exist:

student cannot be grouped correctly
batch-wise reports become incorrect
joins with batches return missing values
student may disappear from filtered reports
2. Enrollments linked to missing students
SELECT e.student_id
FROM enrollments e
LEFT JOIN students s
ON e.student_id = s.student_id
WHERE s.student_id IS NULL;
Why it matters

Enrollment belongs to no valid student:

invalid course enrollment
student count becomes wrong
impossible to track performance
3. Enrollments linked to missing courses
SELECT e.course_id
FROM enrollments e
LEFT JOIN courses c
ON e.course_id = c.course_id
WHERE c.course_id IS NULL;
Why it matters

Enrollment references a course that isn’t present:

course statistics become wrong
enrollment count inflated
student appears enrolled in invalid course
4. Problems linked to missing courses
SELECT p.problem_id
FROM problems p
LEFT JOIN courses c
ON p.course_id = c.course_id
WHERE c.course_id IS NULL;
Why it matters

Problem without valid course:

cannot map problem to curriculum
course-wise analytics break
reports become incomplete
5. Test cases linked to missing problems
SELECT t.test_case_id
FROM test_cases t
LEFT JOIN problems p
ON t.problem_id = p.problem_id
WHERE p.problem_id IS NULL;
Why it matters

A test case without parent problem:

evaluation becomes invalid
grading may fail
orphan data wastes storage
6. Contests linked to missing courses
SELECT contest_id
FROM contests ct
LEFT JOIN courses c
ON ct.course_id = c.course_id
WHERE c.course_id IS NULL;
Why it matters

Contest belongs to missing course:

contest cannot be grouped correctly
leaderboard/reporting affected
course contest count becomes wrong
7. Contest-problem mappings linked to missing contests
SELECT cp.contest_id
FROM contest_problems cp
LEFT JOIN contests c
ON cp.contest_id = c.contest_id
WHERE c.contest_id IS NULL;
Why it matters

Problem assigned to a contest that doesn’t exist:

invalid mapping
contest reports inaccurate
leaderboard may break
8. Contest-problem mappings linked to missing problems
SELECT cp.problem_id
FROM contest_problems cp
LEFT JOIN problems p
ON cp.problem_id = p.problem_id
WHERE p.problem_id IS NULL;
Why it matters

Contest references invalid problem:

broken contest questions
incorrect scoring
missing problem details
9. Submissions linked to missing students
SELECT submission_id
FROM submissions s
LEFT JOIN students st
ON s.student_id = st.student_id
WHERE st.student_id IS NULL;
Why it matters

Submission has no valid student:

impossible to identify submitter
marks may be counted incorrectly
analytics become unreliable
10. Submissions linked to missing problems
SELECT submission_id
FROM submissions s
LEFT JOIN problems p
ON s.problem_id = p.problem_id
WHERE p.problem_id IS NULL;
Why it matters

Submission references missing problem:

cannot evaluate correctly
score becomes meaningless
reporting breaks
11. Submissions linked to missing contests
SELECT submission_id
FROM submissions s
LEFT JOIN contests c
ON s.contest_id = c.contest_id
WHERE c.contest_id IS NULL;
Why it matters

Contest submission without contest:

leaderboard inaccurate
contest statistics wrong
orphan submission data
12. Test results linked to missing submissions
SELECT tr.submission_id
FROM test_results tr
LEFT JOIN submissions s
ON tr.submission_id = s.submission_id
WHERE s.submission_id IS NULL;
Why it matters

Test result has no submission:

evaluation invalid
scores unreliable
orphan records
13. Test results linked to missing test cases
SELECT tr.test_case_id
FROM test_results tr
LEFT JOIN test_cases tc
ON tr.test_case_id = tc.test_case_id
WHERE tc.test_case_id IS NULL;
Why it matters

Result references test case not present:

grading incomplete
pass/fail inaccurate
14. Sessions linked to missing courses
SELECT session_id
FROM sessions s
LEFT JOIN courses c
ON s.course_id = c.course_id
WHERE c.course_id IS NULL;
Why it matters

Session belongs to no course:

attendance reports affected
timetable inaccurate
15. Attendance linked to missing sessions
SELECT a.attendance_id
FROM attendance a
LEFT JOIN sessions s
ON a.session_id = s.session_id
WHERE s.session_id IS NULL;
Why it matters

Attendance for a class session that doesn’t exist:

attendance % becomes incorrect
reporting unreliable
16. Attendance linked to missing students
SELECT a.attendance_id
FROM attendance a
LEFT JOIN students s
ON a.student_id = s.student_id
WHERE s.student_id IS NULL;
Why it matters

Attendance belongs to unknown student:

invalid attendance
percentage inaccurate
17. Regrade requests linked to missing submissions
SELECT request_id
FROM regrade_requests r
LEFT JOIN submissions s
ON r.submission_id = s.submission_id
WHERE s.submission_id IS NULL;
Why it matters

Regrade request without submission:

cannot review anything
invalid workflow
18. Regrade requests linked to missing students
SELECT request_id
FROM regrade_requests r
LEFT JOIN students s
ON r.student_id = s.student_id
WHERE s.student_id IS NULL;
Why it matters

Request has no valid student:

cannot identify requester
tracking impossible
19. Plagiarism flags linked to missing submissions
SELECT flag_id
FROM plagiarism_flags p
LEFT JOIN submissions s
ON p.submission_id = s.submission_id
WHERE s.submission_id IS NULL;
Why it matters

Plagiarism flag without submission:

investigation impossible
audit unreliable