** This repo is when i read 'SQL QUERIES FOR MERE MORETALS' and practice;
I created local databases based on CSVs file downloaded from Kaggle. 
The SQL files in this folder contain the queries used for practicing with SQL Server.**


below is how to set up local database for it:

# Step 1 — Copy the CSV into the running container

RUN BELOW IN TERMINAL: 

docker cp \
Data-Analyst-Fundamentals/sql/data/netflix_titles.csv \
sqlserver2022:/var/opt/mssql/data/netflix_titles.csv

# Step 2 — Create the target table in SQL Server

RUN BELOW IN sqlcmd:

CREATE TABLE dbo.netflix_titles_raw (
    show_id VARCHAR(50),
    type VARCHAR(50),
    title VARCHAR(500),
    director VARCHAR(500),
    [cast] VARCHAR(MAX),
    country VARCHAR(500),
    date_added VARCHAR(100),
    release_year VARCHAR(50),
    rating VARCHAR(50),
    duration VARCHAR(50),
    listed_in VARCHAR(500),
    description VARCHAR(MAX)
);


# Step 3 - INSERT CSV CONTENT INTO THE DB

sqlcmd -S localhost,1433 -U sa -P 'StrongPassw0rd!' -C -Q "
USE RetailPractice;

BULK INSERT dbo.netflix_titles_raw
FROM '/var/opt/mssql/data/netflix_titles.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    TABLOCK
);
"

# Step 4: run sql command to practice via answering questions below
1. Count the Number of Movies vs TV Shows
2. Find the Most Common Rating for Movies and TV Shows
3. List All Movies Released in a Specific Year (e.g., 2020)
4. Find the Top 5 Countries with the Most Content on Netflix
5. Identify the Longest Movie
6. Find Content Added in the Last 5 Years
7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
8. List All TV Shows with More Than 5 Seasons
9. Count the Number of Content Items in Each Genre
10. Find each year and the average numbers of content release in India on netflix.
11. List All Movies that are Documentaries
12. Find All Content Without a Director
13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
