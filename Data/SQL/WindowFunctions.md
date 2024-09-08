Let's create some sample tables and queries to demonstrate how the SQL window functions work.

---

### **Sample Table: `Employees`**

```sql
CREATE TABLE Employees (
    EmployeeID INT,
    EmployeeName VARCHAR(50),
    Department VARCHAR(50),
    Salary INT
);

INSERT INTO Employees (EmployeeID, EmployeeName, Department, Salary) VALUES
(1, 'Alice', 'HR', 5000),
(2, 'Bob', 'HR', 6000),
(3, 'Charlie', 'Engineering', 8000),
(4, 'David', 'Engineering', 7500),
(5, 'Eve', 'HR', 6000),
(6, 'Frank', 'Engineering', 8500);
```

---

### **1. RANK Function Example:**

The `RANK()` function assigns ranks to employees based on their salary in descending order, within each department. Ties will leave gaps in the ranking.

```sql
SELECT 
    EmployeeName, 
    Department, 
    Salary,
    RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS Rank
FROM Employees;
```

#### **Output:**

| EmployeeName | Department  | Salary | Rank |
|--------------|-------------|--------|------|
| Bob          | HR          | 6000   | 1    |
| Eve          | HR          | 6000   | 1    |
| Alice        | HR          | 5000   | 3    |
| Frank        | Engineering | 8500   | 1    |
| Charlie      | Engineering | 8000   | 2    |
| David        | Engineering | 7500   | 3    |

- Notice that `Bob` and `Eve` both have the same salary, so they both get a rank of 1, but Alice is ranked 3 (skipping rank 2).

---

### **2. DENSE_RANK Function Example:**

The `DENSE_RANK()` function works similarly to `RANK()`, but there are no gaps in ranking.

```sql
SELECT 
    EmployeeName, 
    Department, 
    Salary,
    DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS DenseRank
FROM Employees;
```

#### **Output:**

| EmployeeName | Department  | Salary | DenseRank |
|--------------|-------------|--------|-----------|
| Bob          | HR          | 6000   | 1         |
| Eve          | HR          | 6000   | 1         |
| Alice        | HR          | 5000   | 2         |
| Frank        | Engineering | 8500   | 1         |
| Charlie      | Engineering | 8000   | 2         |
| David        | Engineering | 7500   | 3         |

- `DENSE_RANK()` ranks `Bob` and `Eve` the same as before, but instead of skipping a rank, Alice is ranked 2.

---

### **3. ROW_NUMBER Function Example:**

The `ROW_NUMBER()` function assigns a unique sequential integer to each row within a partition.

```sql
SELECT 
    EmployeeName, 
    Department, 
    Salary,
    ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary DESC) AS RowNumber
FROM Employees;
```

#### **Output:**

| EmployeeName | Department  | Salary | RowNumber |
|--------------|-------------|--------|-----------|
| Bob          | HR          | 6000   | 1         |
| Eve          | HR          | 6000   | 2         |
| Alice        | HR          | 5000   | 3         |
| Frank        | Engineering | 8500   | 1         |
| Charlie      | Engineering | 8000   | 2         |
| David        | Engineering | 7500   | 3         |

- `ROW_NUMBER()` assigns a unique number to each row, regardless of ties in the salary.

---

### **4. LEAD and LAG Function Example:**

- **LEAD()**: Get the value from the next row in the result set.
- **LAG()**: Get the value from the previous row.

```sql
SELECT 
    EmployeeName, 
    Department, 
    Salary,
    LAG(Salary, 1) OVER (PARTITION BY Department ORDER BY Salary DESC) AS PreviousSalary,
    LEAD(Salary, 1) OVER (PARTITION BY Department ORDER BY Salary DESC) AS NextSalary
FROM Employees;
```

#### **Output:**

| EmployeeName | Department  | Salary | PreviousSalary | NextSalary |
|--------------|-------------|--------|----------------|------------|
| Bob          | HR          | 6000   | NULL           | 6000       |
| Eve          | HR          | 6000   | 6000           | 5000       |
| Alice        | HR          | 5000   | 6000           | NULL       |
| Frank        | Engineering | 8500   | NULL           | 8000       |
| Charlie      | Engineering | 8000   | 8500           | 7500       |
| David        | Engineering | 7500   | 8000           | NULL       |

- `LAG()` provides the previous salary, and `LEAD()` provides the next salary within each department.

---

### **5. CUME_DIST Function Example:**

The `CUME_DIST()` function calculates the cumulative distribution of a value within a partition.

```sql
SELECT 
    EmployeeName, 
    Department, 
    Salary,
    CUME_DIST() OVER (PARTITION BY Department ORDER BY Salary DESC) AS CumulativeDistribution
FROM Employees;
```

#### **Output:**

| EmployeeName | Department  | Salary | CumulativeDistribution |
|--------------|-------------|--------|------------------------|
| Bob          | HR          | 6000   | 0.6667                 |
| Eve          | HR          | 6000   | 0.6667                 |
| Alice        | HR          | 5000   | 1.0000                 |
| Frank        | Engineering | 8500   | 0.3333                 |
| Charlie      | Engineering | 8000   | 0.6667                 |
| David        | Engineering | 7500   | 1.0000                 |

- The cumulative distribution of the salary ranks each employee's position relative to others in their department.

---

### **6. NTH_VALUE Function Example:**

The `NTH_VALUE()` function returns the value of the nth row in a window.

```sql
SELECT 
    EmployeeName, 
    Department, 
    Salary,
    NTH_VALUE(Salary, 2) OVER (PARTITION BY Department ORDER BY Salary DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS SecondHighestSalary
FROM Employees;
```

#### **Output:**

| EmployeeName | Department  | Salary | SecondHighestSalary |
|--------------|-------------|--------|---------------------|
| Bob          | HR          | 6000   | 6000                |
| Eve          | HR          | 6000   | 6000                |
| Alice        | HR          | 5000   | 6000                |
| Frank        | Engineering | 8500   | 8000                |
| Charlie      | Engineering | 8000   | 8000                |
| David        | Engineering | 7500   | 8000                |

- `NTH_VALUE(Salary, 2)` returns the second-highest salary for each department.

---

This should give you a solid understanding of how window functions like `RANK`, `DENSE_RANK`, `ROW_NUMBER`, `LEAD`, `LAG`, `CUME_DIST`, and `NTH_VALUE` work with real data.