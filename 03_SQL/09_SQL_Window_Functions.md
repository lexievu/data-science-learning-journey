Table schemas:

`patients`: (`patient_id`, `patient_name`, `age`, `gender`)
`lab_results`: (`patient_id`, `test_name`, `test_value`, `result_date`)
`medications`: (`patient_id`, `medication_name`, `dosage`, `start_date`, `end_date`)

---

### Ranking within Groups:
For each distinct `test_name` in the `lab_results` table, find the `patient_id`, `result_date`, and `test_value` for the top 3 highest `test_value`s.
Write an SQL query using a window function to rank the results, and then filter to get the top 3 within each test group.

```sql
WITH ranked_test_value AS (
    SELECT 
        test_name, 
        patient_id,
        result_date,
        test_value,
        RANK() OVER(PARTITION BY test_name ORDER BY test_value DESC) AS test_value_rank
    FROM lab_results
)
SELECT 
    patient_id,
    result_date,
    test_name,
    test_value,
    test_value_rank
FROM ranked_test_value
WHERE test_value_rank <= 3
```

---

### Running Totals:
For each `patient_id`, calculate a running total of dosage for all their medications, ordered by `start_date`. The total should accumulate as new medications are listed.
Write an SQL query to display `patient_id`, `medication_name`, `dosage`, `start_date`, and the `running_total_dosage` for each record.

---

```sql
SELECT
    patient_id,
    medication_name,
    dosage,
    start_date,
    SUM(dosage) OVER(PARTITION BY patient_id ORDER BY start_date) AS running_total_dosage
FROM medications
```

---

### Comparing to Previous/Lag:
You want to see how a patient's `test_value` for 'Marker_B' changes from one visit to the next.
Write an SQL query that displays the `patient_id`, `result_date`, `test_value`, and the `previous_test_value` (i.e., the test_value from the immediately preceding visit for that same patient and 'Marker_B'). Only consider 'Marker_B' tests.

---

```sql
SELECT
    patient_id,
    result_date,
    test_value, 
    LAG(test_value, 1) OVER  (
        PARTITION BY patient_id, test_name
        ORDER BY result_date ASC) AS previous_test_value
FROM lab_results
WHERE test_name = 'Marker_B'
ORDER BY patient_id, result_date
```

---

For each `patient_id` and each distinct `test_name`, identify the `test_value` from their first recorded test and their last recorded test for that specific test, based on the `result_date`.

Write an SQL query to display `patient_id`, `test_name`, `result_date`, `test_value`, and the calculated `first_test_value` and `last_test_value` for each record.

Table schemas:

`patients`: (`patient_id`, `patient_name`, `age`, `gender`)
`lab_results`: (`patient_id`, `test_name`, `test_value`, `result_date`)
`medications`: (`patient_id`, `medication_name`, `dosage`, `start_date`, `end_date`)

---

```sql
SELECT
    patient_id,
    test_name,
    result_date,
    test_value,
    FIRST_VALUE(test_value) OVER(
        PARTITION BY patient_id, test_name
        ORDER BY result_date ASC) AS first_test_value,
    LAST_VALUE(test_value) OVER(
        PARTITION BY patient_id, test_name
        ORDER BY result_date ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_test_value
FROM lab_results
```