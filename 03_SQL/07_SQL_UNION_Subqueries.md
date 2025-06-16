**You have two tables: `patients_in_clinic_A` and `patients_in_clinic_B`, both with `patient_id`, `patient_name`, and `diagnosis`.**
**How would you write a single SQL query to get a list of all unique patients (ID, Name, Diagnosis) from both clinics?**
**What would be different if you wanted to see all patient entries, including duplicates if a patient appears in both clinics? (i.e., explain the difference between UNION and UNION ALL).**

Combines results and removes duplicate rows.

```
SELECT patient_id, patient_name, diagnosis
FROM patients_in_clinic_A
UNION
SELECT patient_id, patient_name, diagnosis
FROM patients_in_clinic_B
```

Combines results and keeps all rows

```
SELECT patient_id, patient_name, diagnosis
FROM patients_in_clinic_A
UNION ALL
SELECT patient_id, patient_name, diagnosis
FROM patients_in_clinic_B
```

**Imagine you have a `lab_results` table (`patient_id`, `test_name`, `test_value`) and a `patient_demographics` table (`patient_id`, `age`, `gender`). Write an SQL query using a subquery in the WHERE clause to find the `patient_id` and `test_value` for all patients whose age is above the average age of all patients in the `patient_demographics` table.**

```
SELECT l.patient_id, l.test_value
FROM lab_results l
JOIN patient_demographics p ON p.patient_id = l.patient_id
WHERE p.age > (
    SELECT AVG(age)
    FROM patient_demographics
)
```

**You have `experiment_data` (`experiment_id`, `gene_name`, `expression_level`) and `gene_annotations` (`gene_name`, `gene_function`). Describe how you could use a subquery in the SELECT clause (a scalar subquery) to add a new column to your `experiment_data` result that shows the `average_expression_for_gene` across all experiments for each specific `gene_name` in the main query. What are the limitations or potential performance considerations of this approach?**

```
SELECT 
    experiment_id,
    gene_name,
    expression_level,
    (SELECT AVG(expression_level)
    FROM experiment_data esub
    WHERE esub.gene_name = e.gene_name) AS average_expression_for_gene
FROM experiment_data e
```

This method, using a correlated subquery, can be inefficient on very large datasets. The database has to re-execute the inner AVG query for every single row in your experiment_data table. This can lead to significant processing time.

Approach using window function (more efficient):

```
SELECT 
    experiment_id,
    gene_name,
    expression_level,
    AVG(expression_level) OVER (PARTITION BY gene_name) AS average_expression_for_gene
FROM experiment_data e
```