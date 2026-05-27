The following repair plan explains how issues found during validation should be handled. Depending on the type of issue, records may be corrected, deleted, moved to a staging table, manually verified, or left unchanged with justification.

Issue Category	Example ID	Problem Found	Repair Action	Reason
Negative score	SUB000056	score = -10	Correct value → change to 0	Scores cannot be negative. This appears to be an invalid mark entry. Since submission exists and all other fields are valid (student_id S0148, problem_id P0056, contest_id CT012, language Java), the safest repair is correcting score to 0 instead of deleting the row.
Detailed explanation

1. Negative score — SUB000056

Record:

SUB000056 | S0148 | P0056 | CT012 | Java | 2025-06-17 10:16:00 | Wrong Answer | -10 | 4614
Issue

The score is negative:

-10

which violates the domain rule.

Repair action

Correct the value

Example:

-10 → 0
Why
submission is valid
student exists
problem exists
language is valid
status is valid
only score is invalid

Deleting would remove valid submission history.

Manual verification usually isn’t needed because negative marks are clearly invalid.

2. Issue: Student linked to missing batch (B999 not found in batches table)

Student belongs to an invalid/nonexistent batch.
Batch-wise reports become inaccurate.
Cannot reliably track the student’s program.
Breaks referential integrity between students and batches.
Repair plan example
Issue	Example ID	Action	Reason
Student linked to missing batch	student S0148 → batch B999	Ask for manual verification	We don’t know the correct batch. Could be typing error or missing batch record.


3. contest_id	course_id	contest_name	start_time	end_time	status
   CT005	C005	CS202 Weekly Challenge 5	2025-04-05 12:00:00	2025-04-05 11:00:00	completed
Why this is invalid

The contest ends before it starts:

Start → 12:00 PM
End → 11:00 AM

That’s impossible.

Why it matters
Contest duration becomes negative.
Students may appear late/early incorrectly.
Reports like “contest time taken” become wrong.
Any submission timestamps checked against contest time may fail.
Scheduling systems cannot trust this record.
For your Task 4 report

Check: End time before start time

SQL query

SELECT *
FROM contests
WHERE end_time < start_time;

Status: Failed

Issue found:

CT005

Explanation:
Contest CT005 has end_time earlier than start_time, which violates time-order rules.

Repair plan example (Task 5)
Issue	Record ID	Action	Reason
Contest end time before start time	CT005	Ask for manual verification	Could be typo in start or end time. Need correct schedule before updating.