### How Data is Stored in PostgreSQL

PostgreSQL internally organizes and stores data in a structured way using several data structures and storage techniques. At the core of this storage are **tables** and **indexes**, and PostgreSQL uses specific strategies for each, including **B-trees**, **heap files**, and more specialized index types. It is important to note that PostgreSQL does **not have a pluggable storage engine** like MySQL (which supports engines like InnoDB or MyISAM). Instead, PostgreSQL manages its own storage directly, using a system that is deeply integrated with its architecture.

### 1. **Heap Storage (Tables)**

PostgreSQL stores table data using a **heap storage** mechanism. 
- This means that rows (tuples) are stored in no particular order within **heap files** (also known as "relation files"). 
- Each table in PostgreSQL is associated with a physical file (or multiple files if the table grows large), where rows are stored.

#### a. **Heap Organization**

- A **heap** is a file consisting of **8KB pages** by default.
- Each **page** stores multiple **rows** (tuples).
- When a new row is inserted, it is added to the first available empty space in any of the pages (hence the term "heap").
  
This heap storage is efficient for general-purpose data retrieval but does not guarantee any order. To speed up searches or ensure specific data retrieval paths, PostgreSQL uses **indexes**, which we'll explore shortly.

#### b. **Row Structure in Heap**

Each row (tuple) in a heap consists of:
- **Header**: Contains metadata like transaction IDs, xmin/xmax (MVCC-related visibility information), row length, and other attributes.
- **Tuple Data**: The actual data for each column in the table.
  
PostgreSQL's **Multi-Version Concurrency Control (MVCC)** system allows multiple versions of a row to coexist in the heap. This means that old versions of rows are not immediately removed after an update or delete, but are kept for other transactions that might still need to read them. These "dead tuples" are eventually cleaned up by the **autovacuum** process.

### 2. **Indexes in PostgreSQL**

Indexes are used to speed up data retrieval, and PostgreSQL supports multiple types of indexes, each suited for different use cases. The most common type of index in PostgreSQL is the **B-tree index**, but other types like **hash indexes**, **GIN**, **GiST**, and **BRIN** indexes also exist.

#### a. **B-tree Index (Balanced Tree)**

- **B-tree (Balanced Tree)** is the **default and most commonly used index type** in PostgreSQL.
- It is highly efficient for queries that involve comparisons (`<`, `<=`, `>`, `>=`, `=`, `BETWEEN`), and it maintains sorted data.
- **Structure**:
  - B-tree indexes are organized into a balanced tree structure where each node represents a block (or page) that contains keys (index values) and pointers to child nodes.
  - **Root node**: Top of the B-tree, containing pointers to child nodes.
  - **Leaf nodes**: The bottom of the tree, containing the actual indexed values and pointers to the table rows (heap tuples).
  
B-trees are self-balancing, ensuring that each lookup operation (whether it's an insert, update, or search) takes logarithmic time, making them suitable for a wide range of queries.

#### b. **Other Index Types**

In addition to B-tree indexes, PostgreSQL supports other index types, which are specialized for different kinds of data and queries:

- **Hash Index**: Used for equality searches (`=`). While B-trees can also handle equality, hash indexes are more efficient for this specific purpose, but they are less commonly used due to limitations (such as not supporting range queries).

- **GIN (Generalized Inverted Index)**: Suitable for multi-value fields like **arrays**, **full-text search**, and **jsonb**. It allows fast lookups for specific elements within complex structures.

- **GiST (Generalized Search Tree)**: A flexible indexing mechanism used for geometric data types, full-text search, and other custom indexing needs (e.g., **PostGIS** for geographic data).

- **BRIN (Block Range INdex)**: A lightweight, low-cost index that works well for large, naturally ordered tables. It only stores summaries of ranges of pages and is useful for tables with sequential data (e.g., time-series data).

---

### 3. **PostgreSQL Storage Engine**

Unlike databases like MySQL, which have pluggable storage engines (InnoDB, MyISAM), PostgreSQL has **one monolithic storage engine** that integrates with its overall architecture. The default storage mechanism involves the heap-based file structure for tables and various indexing mechanisms for fast retrieval. Here's an overview of the main components of the PostgreSQL storage engine:

#### a. **File Structure**
- PostgreSQL stores each database object (tables, indexes) in its own **file on the filesystem**. These files are located under the `data/base/` directory of the PostgreSQL data directory.
- Files are split into **8KB pages** by default, which are the basic unit of storage.
- When a table grows large, it is divided into multiple files (known as segments) each 1GB in size to accommodate large datasets.
  
#### b. **Page Structure**
Each page in PostgreSQL has a well-defined structure:
- **Header**: Contains metadata such as the page number, checksum, and the location of free space.
- **Data**: Stores rows (tuples) or index entries.
- **Free Space**: Pages can have empty space after rows are deleted or updated.

#### c. **Tuple Visibility and MVCC**
PostgreSQL uses **MVCC (Multi-Version Concurrency Control)**, which allows multiple versions of a row to exist at the same time. When a row is updated, a new version is created and the old version is marked as obsolete. The **vacuum** process eventually removes these old rows.

The MVCC system is key to PostgreSQL's **non-blocking** reads, enabling transactions to view a consistent snapshot of the data without locking.

#### d. **Buffer Management**
- PostgreSQL uses **shared buffers** to cache data in memory before writing it to disk.
- The **background writer** and **checkpointer** processes manage how and when modified pages are written back to disk.
  
---

### 4. **Write-Ahead Logging (WAL) and Storage**

PostgreSQL uses **Write-Ahead Logging (WAL)** to ensure durability. Before any changes are made to data files, the changes are first logged in the WAL. WAL logs are sequential files that record every change made to the database, ensuring that in the event of a crash, PostgreSQL can recover to a consistent state.

- WAL files are stored separately from the heap and index files, in the `pg_wal` directory.
- WAL is crucial for replication, crash recovery, and ensuring that changes are durable.

---

### 5. **Table and Index Storage Internals**

- **Tables**: Tables are stored as heap files, and rows are placed in pages. Tables do not have any inherent ordering, which is why indexes are needed to efficiently retrieve data.
  
- **Indexes**: Indexes are stored as **B-trees** (for the default type) or other specialized index structures. An index consists of the key values and pointers to the actual table rows, enabling efficient lookups.

---

### 6. **Data Storage and Retrieval Process**

#### a. **Insert Process**
1. A new row (tuple) is created and stored in the **heap** in the next available space in one of the heap pages.
2. The row is added to the appropriate **indexes** (if any) for fast retrieval.

#### b. **Select (Query) Process**
1. If there’s an **index** on the column(s) being queried, the index is scanned first to locate the relevant rows.
2. The index points to the **heap** location, where the actual row data is stored.
3. The row is then fetched from the heap.

#### c. **Update Process**
1. PostgreSQL uses an **MVCC-based approach** for updates. Instead of modifying the existing row, it creates a new version of the row in the heap.
2. The old row version is marked as obsolete but remains in the heap for other transactions to read until they are finished (this is why vacuuming is needed to clean up dead tuples).

#### d. **Delete Process**
1. Deleting a row marks it as **deleted** in the heap but does not remove it immediately.
2. As with updates, the row will be removed later by the **vacuum** process, which reclaims space.

---

### 7. **AutoVacuum and Dead Tuple Management**

Since PostgreSQL’s MVCC system creates multiple versions of rows (for updates and deletes), the **autovacuum** process is critical for cleaning up **dead tuples** that are no longer visible to any active transaction.

- **AutoVacuum** periodically scans tables to remove old versions of rows (i.e., "dead tuples") and reclaim storage space.
- Without autovacuum, tables could grow indefinitely, leading to performance degradation.

---

### Conclusion

PostgreSQL uses a **heap-based storage system** for tables, with various index types (primarily **B-trees**) to provide efficient data retrieval. Unlike systems like MySQL, PostgreSQL has a single, monolithic storage engine integrated with the core of the database, managing both table data and indexes directly.
