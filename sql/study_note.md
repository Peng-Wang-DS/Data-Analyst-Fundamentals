# SQL Learning Journey

## Overview

This guide documents my systematic approach to learning SQL and build a good foundation. As a data scientist working on end-to-end global demand forecasting products, I recognised that learning SQL properly would help me build faster, more efficient data pipelines, move feature engineering transformations upstream into the data pipeline, and manage project teams better with data engineers.

**Starting Point:** Complete beginner (only knew `SELECT * FROM database;`)

**Goal:** Build practical SQL skills to enhance ML pipeline development, data engineering capabilities, and facilitate team management better while communicating with data engineers

---

## Sprint 1: Build Theoretical Foundation

### Milestone 1: Systematic Learning
- **Resource:** *SQL Queries for Mere Mortals* (4th Edition)
- **Objective:** Develop a comprehensive theoretical understanding of SQL fundamentals
- **Outcome:** Strong conceptual foundation for practical application

---

## Sprint 2: Multimodal Practice & Application

### Milestone 1: Core Concepts (45 mins)
**Video:** [SQL Crash Course for Beginners](https://www.youtube.com/watch?v=ULdVndYtdYs)

**Key Learnings:**
1. Foundational SQL concepts and relational databases
2. The Big 6 SQL clauses: `SELECT`, `FROM`, `WHERE`, `GROUP BY`, `HAVING`, `ORDER BY`
3. Syntax basics for immediate practical application
4. Strategic focus areas for maximising learning outcomes

**Insight:** it's interesting to learn that besides Pyspark, pandas supports SQL queries:

```python
# Running SQL queries with pandas
import sqlite3
import pandas as pd

conn = sqlite3.connect('my_new_db.db')  # Connect to database
df = pd.read_sql('''SELECT * FROM test;''', conn) 
print(df.head())
```

### Milestone 2: Advanced Concepts (~37 mins total)
Master essential intermediate SQL techniques:

- **JOINs** (7 mins): [SQL Joins Tutorial](https://www.youtube.com/watch?v=FjxtntY5sO0)
- **UNION & UNION ALL** (10 mins): [Joins vs Union vs Union All](https://www.youtube.com/watch?v=dPYHNsZEuuQ)
- **WITH Clause (CTEs)** (13 mins): [Common Table Expressions](https://www.youtube.com/watch?v=LJC8277LONg)
- **Window Functions** (7 mins): [Window Functions Explained](https://www.youtube.com/watch?v=rIcB4zMYMas)

### Milestone 3: Hands-On Projects
**The most important phase** – applying knowledge through real-world practice.

#### Project 1: Spotify Data Analysis
- **Video Guide:** [Advanced SQL Project: Spotify Analysis](https://www.youtube.com/watch?v=nHjIsKZ79-M&t=70s)
- **My Approach:** Downloaded the dataset, used the suggested questions as practice prompts, and developed my own solutions
- **My Code:** [spotify_practice.sql](https://github.com/Peng-Wang-DS/Data-Analyst-Fundamentals/blob/main/sql/retail_practice.sql)

#### Project 2: Retail Sales Analysis
- **Video Guide:** [Advanced SQL Project: Retail Sales Analysis](https://www.youtube.com/watch?v=ChIQjGBI3AM&t=1936s)
- **My Approach:** Downloaded the dataset, used the suggested questions as practice prompts, and developed my own solutions
- **My Code:** [netflix_titles_practice.sql](https://github.com/Peng-Wang-DS/Data-Analyst-Fundamentals/blob/main/sql/netflix_titles_practice.sql)

---

## Summary & Reflection

### My Motivation
Working as a data scientist on end-to-end global demand forecasting products, I realised that systematic SQL knowledge would enable me to:
- Build faster, more efficient data pipelines
- Reduce ML pipeline complexity by moving feature engineering transformations upstream
- Improve overall data engineering capabilities

### My Learning Philosophy
I favor a **pragmatic, top-down approach**: build first, learn what you need, iterate. There's always more to learn—the key is knowing what's "enough for now" to make meaningful progress.

**My Journey:**
1. Read *SQL Queries for Mere Mortals* for theoretical foundation
2. Completed hands-on projects (Sprint 2, Milestone 3)
3. Watched targeted YouTube videos to reinforce commonly-used syntax
4. Asked AI assistants to explain concepts when stuck

---

## Alternative Learning Paths

### Path 1: Structured Approach -> 10 days
Sprint 1 → Sprint 2 (all milestones in order)

### Path 2: Accelerated Track -> 3 days
If you're in a rush:
1. Start with **Sprint 2, Milestone 2** (advanced concepts videos)
2. Jump to **Sprint 2, Milestone 3** (hands-on projects)
3. Use ChatGPT to explain syntax as you encounter it
4. Fill in theoretical gaps as needed

### Path 3: Project-First Approach (my path) -> 6 days
1. Scan through the book
1. Choose 2-3 projects that interests you, you could use the two projects i did.
2. Start coding immediately
3. Look up syntax and concepts on-demand with ChatGPT
4. Watch the youtube videos i selected to recap.

---

## Encouragement

**You can do this!** Everthing starts difficult but we will make it eventually, think about there are so many people know how to code SQL, why can't you?

---

*— Peng*  
*February 6, 2026*  
*England*