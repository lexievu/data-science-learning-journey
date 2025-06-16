**Imagine you have two tables: patients (with patient_id, name, age) and lab_results (with patient_id, test_name, test_value). Write an SQL query (mentally or on paper) to retrieve the patient_name, age, test_name, and test_value only for patients who have submitted lab results. What type of JOIN would you use and why?**

```
SELECT p.name AS patient_name,
    p.age,
    l.test_name,
    l.test_value
FROM patients p
INNER JOIN lab_results l ON p.patient_id = l.patient_id
```

**Now, using the same two tables (patients and lab_results), write an SQL query to retrieve the patient_name, age, test_name, and test_value for all patients, including those who have not yet submitted any lab results. What type of JOIN would you use, and how would the test_name and test_value appear for patients without results?**

```
SELECT p.name AS patient_name,
    p.age,
    l.test_name,
    l.test_value
FROM patients p
LEFT JOIN lab_results l ON p.patient_id = l.patient_id
```

For any patient who exists in the patients table but does not have a corresponding record (i.e., no matching `patient_id`) in the `lab_results` table, the `test_name` and `test_value` columns (which originate from the `lab_results` table) will appear as NULL.

This NULL value explicitly indicates that there is no data available for those specific columns for that particular patient from the `lab_results` table.

**Explain the key difference in the output (number of rows and presence of NULLs) between an INNER JOIN and a LEFT JOIN when a record in one table does not have a match in the other.**

| Feature | INNER JOIN | LEFT JOIN |
| ------- | ---------- | --------- |
| Rows returned | Only matching rows from both tables | All rows from left table, and matching right rows |
| NULLs introduced | No | Yes, for columns from right table where no match exists |
| Purpose | To find common, intersecting data | To retrieve all data from a primary table and supplement it with related data if available |