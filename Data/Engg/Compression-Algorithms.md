### Compression Algorithms in Data Storage Formats

Data compression is essential in reducing storage costs and speeding up data transmission. It is widely used in data storage formats like **Parquet**, **Avro**, **ORC**, **CSV**, and **JSON**. Each compression algorithm has different strengths depending on the type of data and its structure. Below are detailed notes on some commonly used compression algorithms:

---

### 1. **Snappy**
   - **Developed by**: Google
   - **Features**:
     - Focuses on fast compression and decompression speeds.
     - Not the most space-efficient, but the speed is a priority.
     - Suitable for real-time applications or situations where the speed of data access is crucial.
   - **Use Case**: Often used in **Big Data** systems like Hadoop and Spark. It’s the default compression in Parquet.
   - **Trade-offs**: 
     - Sacrifices some compression ratio for speed.
     - Decompression is very fast.
   - **Compression Ratio**: Medium (~2x-3x reduction).
   
---

### 2. **GZIP**
   - **Developed by**: Jean-loup Gailly and Mark Adler
   - **Features**:
     - Offers high compression ratios, but slower speeds compared to Snappy.
     - Based on the **DEFLATE** algorithm (a combination of LZ77 and Huffman Coding).
     - Widely used for compressing files on the web (e.g., HTTP compression).
   - **Use Case**: Best when you need a smaller file size and speed is not a priority, such as archival storage.
   - **Trade-offs**:
     - **Slower** compression and decompression times.
     - High CPU usage due to its complex compression techniques.
   - **Compression Ratio**: High (~5x-6x reduction).
   
---

### 3. **LZO**
   - **Developed by**: Markus F. X. J. Oberhumer
   - **Features**:
     - Extremely fast compression and decompression.
     - Uses less CPU compared to algorithms like GZIP.
     - The compression ratio is lower but prioritizes speed.
   - **Use Case**: Used in low-latency applications, where data must be compressed and decompressed in real-time (e.g., **HBase**).
   - **Trade-offs**: 
     - Lower compression ratio compared to GZIP and BZIP2.
   - **Compression Ratio**: Low (~2x reduction).

---

### 4. **Brotli**
   - **Developed by**: Google
   - **Features**:
     - Strikes a good balance between compression ratio and speed.
     - Often used for web assets like CSS, HTML, and JavaScript.
     - Designed to compress smaller files efficiently.
   - **Use Case**: Web compression for faster page loads.
   - **Trade-offs**: Slower than Snappy, but better compression ratio.
   - **Compression Ratio**: High (~20%-30% better than GZIP).

---

### 5. **LZ4**
   - **Developed by**: Yann Collet
   - **Features**:
     - A very fast, lightweight algorithm designed for speed over compression ratio.
     - Compression and decompression speeds are among the fastest.
     - Performs well for real-time applications where data speed is critical.
   - **Use Case**: Used in high-performance applications, distributed databases like **Cassandra**, and **Kafka**.
   - **Trade-offs**: 
     - Achieves lower compression ratios but extremely fast.
   - **Compression Ratio**: Low (~2x-3x reduction).

---

### 6. **BZIP2**
   - **Developed by**: Julian Seward
   - **Features**:
     - Uses the **Burrows-Wheeler transform** followed by Huffman coding.
     - Produces smaller files than GZIP but is much slower.
     - Has high memory requirements.
   - **Use Case**: Best for compressing very large files where storage space is more critical than processing time (e.g., backups).
   - **Trade-offs**: 
     - Very slow compression and decompression times.
     - Heavy CPU usage.
   - **Compression Ratio**: Very High (~7x reduction or more).
   
---

### 7. **Zstandard (ZSTD)**
   - **Developed by**: Yann Collet at Facebook
   - **Features**:
     - A newer compression algorithm designed to be a faster alternative to GZIP and BZIP2.
     - Adjustable compression levels, allowing you to optimize between speed and compression ratio.
     - High decompression speed, even at higher compression levels.
   - **Use Case**: Growing popularity in distributed systems like Kafka, where speed and moderate compression ratios are required.
   - **Trade-offs**: 
     - Flexible tuning but slightly slower than Snappy at the fastest levels.
   - **Compression Ratio**: Adjustable; ranges from low to high (2x-8x).
   
---

### Comparison Table of Compression Algorithms:

| Algorithm   | Compression Ratio | Compression Speed | Decompression Speed | Use Case                                 |
|-------------|-------------------|-------------------|---------------------|------------------------------------------|
| **Snappy**  | Medium (2x-3x)     | Very Fast         | Very Fast           | Real-time data pipelines, Spark, Hadoop  |
| **GZIP**    | High (5x-6x)       | Medium            | Medium              | Archiving, web compression               |
| **LZO**     | Low (~2x)          | Very Fast         | Very Fast           | Low-latency systems, HBase               |
| **Brotli**  | High (5x-7x)       | Medium-Fast       | Medium              | Web assets, HTTP compression             |
| **LZ4**     | Low (2x-3x)        | Very Fast         | Very Fast           | High-performance apps, Kafka             |
| **BZIP2**   | Very High (7x+)    | Slow              | Slow                | Archival, backups                        |
| **Zstandard**| Adjustable (2x-8x)| Fast              | Fast                | Kafka, distributed systems               |

---

### Compression in **Parquet**:
- **Snappy**: Default compression algorithm in Parquet due to its balance between speed and compression ratio.
- **GZIP**: Frequently used when compression ratio is more important than speed.
- **LZ4**: Sometimes used for its high decompression speed in real-time applications.
- **Zstandard**: An emerging choice for Parquet due to its flexibility in balancing speed and compression.

---
