**How would you count the number of samples collected from each distinct tissue type in a samples table using SQL, and what aggregate function would you use?**

Table Name: `samples`

Schema (Table Columns & Data Types):

| Column Name           | Data Type | Description                                         |
| :-------------------- | :-------- | :-------------------------------------------------- |
| `sample_id`           | VARCHAR | Primary Key, unique identifier for each sample  |
| `patient_id`          | VARCHAR | Identifier for the patient the sample belongs to    |
| `tissue_type`         | VARCHAR | The type of tissue collected (e.g., 'Blood', 'Biopsy', 'Bone Marrow', 'Lymph Node') |
| `date_collected`      | DATE    | The date the sample was collected                   |
| `processing_status`   | VARCHAR | Current processing status (e.g., 'Processed', 'Pending', 'Failed') |
| `num_cells_isolated`  | INT     | Number of cells isolated from the sample            |

```
SELECT tissue_type, COUNT(sample_id)
FROM samples
GROUP BY tissue_type
```

**What is the key conceptual difference between the WHERE clause and the HAVING clause in SQL, and when would you use each?**

WHERE filters rows, HAVING filters groups.

WHERE clause: Filters individual rows before they are grouped by the GROUP BY clause. Therefore, you cannot use aggregate functions (like COUNT(), SUM(), AVG()) in a WHERE clause, because the aggregation hasn't happened yet.

HAVING clause: Filters groups after the rows have been grouped by GROUP BY and after aggregate functions have been calculated. Therefore, you can (and often must) use aggregate functions in a HAVING clause.

**Write an SQL query (mentally or on paper) to find the average expression level of 'ImmuneMarker_X' for each immune cell type, but only for cell types with more than 50 recorded instances of this marker.**

Table Name: `immune_cell_expression`

Schema (Table Columns & Data Types):

| Column Name |	Data Type |	Description |
| ----------- | --------- | ----------- |
| `measurement_id` |	VARCHAR |	Primary Key, unique ID for each individual cell measurement |
| `patient_id` |	VARCHAR |	Identifier for the patient the cell belongs to |
| `immune_cell_type` |	VARCHAR	| The specific type of immune cell (e.g., 'T cell', 'B cell', 'Macrophage', 'NK cell') |
| `ImmuneMarker_X_Expression` |	DECIMAL |	The measured expression level of 'ImmuneMarker_X' (a numerical value) |
| `date_measured`	| DATE |	The date the measurement was taken |

```
SELECT immune_cell_type, AVG(ImmuneMarker_X_Expression)
FROM immune_cell_expression
GROUP BY immune_cell_type
HAVING COUNT(measurement_id) > 50
```