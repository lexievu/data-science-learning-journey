**Question 1: "Write an SQL query to select patient IDs and diagnosis dates for all patients diagnosed after January 1, 2024."**

Table Name: `patients`

Schema (Table Columns & Data Types):

-`patient_id` (VARCHAR or INT - Primary Key, unique identifier for each patient)
diagnosis_date (DATE - The date of the patient's diagnosis)
-`patient_age` (INT - The age of the patient)
gender (VARCHAR - Gender of the patient, e.g., 'Male', 'Female', 'Other')
-`diagnosis_description` (VARCHAR - A textual description of the diagnosis)

```
SELECT patient_id, diagnosis_date
FROM patients
WHERE diagnosis_date > '2024-01-01';
```

**Question 2: Explain the purpose of ORDER BY and LIMIT (or FETCH FIRST / TOP) in an SQL query.**

ORDER BY sorts the output by a column, in an ascending or descending order. You can sort by multiple columns (e.g., `ORDER BY column1 ASC, column2 DESC`) and that `ASC` (ascending) is usually the default if not specified.

LIMIT specifies the number of rows to output. The most common use cases are finding the "top N" results or for pagination (e.g., `LIMIT 10 OFFSET 20` to get rows 21-30).

**Question 3: How would you filter for patients with a specific immune cell marker expression value AND a particular treatment outcome using SQL?**

Table Name: `patient_outcomes`

This table stores patient-specific information, including their treatment outcome.
| Column Name         | Data Type | Description                                     |
| :------------------ | :-------- | :---------------------------------------------- |
| `patient_id`        | VARCHAR | Primary Key, unique ID for each patient   |
| `treatment_outcome` | VARCHAR | The result of the treatment (e.g., 'Responder', 'Non-Responder', 'Partial Response') |
| `diagnosis_date`    | DATE    | Date of diagnosis (as used in Q1)               |
| `patient_age`       | INT     | Age of the patient                              |

Table Name: `immune_marker_data`

This table stores the expression values for various immune cell markers for each patient. For simplicity in this example, we'll assume specific marker names are columns.
| Column Name         | Data Type | Description                                     |
| :------------------ | :-------- | :---------------------------------------------- |
| `patient_id`        | VARCHAR | Foreign Key, links to patient_outcomes.patient_id |
| `CD3_expression`    | DECIMAL | Expression value of CD3 immune marker (e.g., a numerical score or concentration) |
| `CD8_expression`    | DECIMAL | Expression value of CD8 immune marker           |
| `cytokine_IL6`      | DECIMAL | Level of Interleukin-6 cytokine                 |
| `date_measured`     | DATE    | Date the marker data was collected              |

Relationship:
The two tables (`patient_outcomes` and `immune_marker_data`) are related by the `patient_id` column. 

Write an SQL query that identifies patients who are 'Responder's AND have a CD3_expression value greater than 10.5.

```
SELECT *
FROM patient_outcomes p
JOIN immune_marker_data i
  ON p.patient_id = i.patient_id
WHERE i.CD3_expression > 10.5
  AND p.treatment_outcome = 'Responder';
```