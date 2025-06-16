Assume you have the following tables:

- `patients`: (`patient_id` VARCHAR, `patient_name` VARCHAR, `age` INT, `gender` VARCHAR)
- `lab_results`: (`patient_id` VARCHAR, `test_name` VARCHAR, `test_value` DECIMAL, `result_date` DATE)
- `medications`: (`patient_id` VARCHAR, `medication_name` VARCHAR, `dosage` DECIMAL, `start_date` DATE, `end_date` DATE)

### Basic CTE for Multi-Step Filtering:

You want to identify all patients who have a `test_value` for 'Marker_A' that is above the overall average `test_value` for 'Marker_A' across all patients.
Write an SQL query using a Common Table Expression (CTE) to first calculate the overall average, and then use that CTE to filter the lab_results table.

---

```
WITH cte(avg_test_value) AS (
    SELECT AVG(l.test_value)
    FROM lab_results l
    WHERE l.test_name = 'Marker_A'
)
SELECT DISTINCT p.patient_id
FROM patients p
JOIN lab_results l ON p.patient_id = l.patient_id
WHERE l.test_name = 'Marker_A'
AND l.test_value > cte.avg_test_value
```

---

### CTEs for Readability and Staging Data:

You need to find the `patient_id` and the total dosage of 'Medication_X' prescribed to each patient, but only for patients who were prescribed 'Medication_X' for more than 30 days.
Write an SQL query using at least two CTEs. The first CTE should calculate the duration of each 'Medication_X' prescription, and the second should use the first to filter for long durations and then calculate total dosage.

---

- `patients`: (`patient_id` VARCHAR, `patient_name` VARCHAR, `age` INT, `gender` VARCHAR)
- `lab_results`: (`patient_id` VARCHAR, `test_name` VARCHAR, `test_value` DECIMAL, `result_date` DATE)
- `medications`: (`patient_id` VARCHAR, `medication_name` VARCHAR, `dosage` DECIMAL, `start_date` DATE, `end_date` DATE)

With 2 CTEs:

```
WITH individual_duration(patient_id, medication_name, dosage, duration_days) AS (
    SELECT
        patient_id,
        medication_name,
        dosage,
        DATEDIFF(DAY, start_date, end_date) 
    FROM medications
    WHERE medication_name = 'Medication_X'
),
patient_total(patient_id, total_dosage, total_duration) AS (
    SELECT 
        patient_id,
        SUM(dosage),
        SUM(duration_days)
    FROM individual_duration i
    GROUP BY patient_id
)
SELECT 
    patient_id,
    total_dosage
FROM patient_total
WHERE total_duration > 30
```

With 1 CTE

```
WITH cte(patient_id, total_dosage, total_duration) AS
(
    SELECT 
        patient_id,
        SUM(m.dosage),
        SUM(DATEDIFF(DAY, m.start_date, m.end_date))
    FROM medications m
    WHERE medication_name = 'Medication_X'
    GROUP BY m.patient_id
)
SELECT
    patient_id,
    total_dosage
FROM cte
WHERE cte.total_duration > 30
```

---

### Comparing CTEs vs. Subqueries (Conceptual):

You've used subqueries previously. For a complex query that involves multiple intermediate steps or calculations (e.g., finding the average of a filtered subset, then comparing individual values to that average, then joining with another table), explain the advantages of using CTEs over nested subqueries for:

- Readability
- Maintainability
- Debugging 

Provide a concise explanation for each point.

---

**Readability**
CTEs allow you to break down a complex query into smaller, logical, named and sequential steps. This makes complex SQL queries significantly easier to understand. 

**Maintainability**
When changes are needed in an intermediate calculation, you only need to modify the specific CTE responsible for that step. This isolates the change and reduces the risk of breaking other parts of a large query.

**Debugging**
Each CTE can be individually executed as a standalong query. This allows you to inspect the intermediate results at each step, helping you pinpoint where an error occurs. 