-- Q1. Count the Number of Movies vs TV Shows
SELECT 
Type,
COUNT(DISTINCT(show_id)) AS Distinct_Count
FROM dbo.netflix_titles_raw
GROUP BY Type

-- Q2. Find the Most Common Rating for Movies and TV Shows
WITH rating_counts as (

    SELECT
        type,
        rating,
        count(*) as rating_count
    FROM dbo.netflix_titles_raw
    WHERE rating IS NOT NULL
    GROUP BY type, rating
) ,
ranked_ratings as (
    SELECT 
        type,
        rating,
        rating_count,
        ROW_NUMBER() OVER (
            PARTITION BY type
            ORDER BY rating_count DESC
        ) AS rn
    FROM rating_counts
)
SELECT 
    type,
    rating as most_common_rating,
    rating_count 
FROM ranked_ratings
WHERE rn = 1
ORDER BY Type


-- Q3. List All Movies Released in a Specific Year (e.g., 2020)
SELECT 
    DISTINCT(title)

FROM dbo.netflix_titles_raw
WHERE 
release_year = 2021
AND 
type = 'Movie'

-- Q4. Find the Top 5 Countries with the Most Content on Netflix
SELECT TOP 5
    country,
    COUNT(*) as content_count

FROM dbo.netflix_titles_raw
WHERE country IS NOT NULL
GROUP BY country
ORDER BY content_count DESC

-- Q5. Identify the Longest Movie
SELECT TOP 5
type,
    title,
    LEFT(duration, CHARINDEX(' ', duration) -1) as duration_mins

FROM dbo.netflix_titles_raw
WHERE type = 'Movie'
ORDER BY duration_mins DESC

-- Q6. Find Content Added in the Last 5 Years
SELECT TOP 10 *
FROM dbo.netflix_titles_raw 
WHERE TRY_CONVERT(date,date_added) >= DATEADD(YEAR,-5,CAST(GETDATE() AS date))

-- Q7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
SELECT 
    DISTINCT(title)
from dbo.netflix_titles_raw 
WHERE director = 'Rajiv Chilaka'

-- Q8. List All TV Shows with More Than 5 Seasons

SELECT *
FROM (
    SELECT 
      type,
    title,
        TRY_CAST(
            LEFT(duration, CHARINDEX(' ', duration + ' ') - 1)
            AS INT
        ) AS num_seasons
    FROM dbo.netflix_titles_raw
    WHERE type = 'TV Show'
) t
WHERE num_seasons >= 5;

-- Q9. Count the Number of Content Items in Each Genre
SELECT 
genre,
count(*) as item_count

FROM 
(SELECT
    show_id,
    LTRIM(RTRIM(value)) AS genre
FROM dbo.netflix_titles_raw
CROSS APPLY STRING_SPLIT(listed_in, ',')) t

GROUP BY genre

-- Q10. Find each year and the average numbers of content release in India on netflix.
WITH india_yearly_release_count AS 

(
    SELECT 
    release_year,
    COUNT(*) as release_count_yrl
    FROM dbo.netflix_titles_raw
    WHERE country = 'India'
    GROUP BY release_year
)
SELECT 
    AVG(release_count_yrl) AS avg_titles_per_year
FROM india_yearly_release_count

-- Q11. List All Movies that are Documentaries
SELECT
    title,
    listed_in
FROM dbo.netflix_titles_raw
WHERE listed_in LIKE '%Documentaries%'

-- Q12. Find All Content Without a Director
SELECT
    title
FROM dbo.netflix_titles_raw
WHERE Director IS NULL


-- Q13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT
   COUNT(*) as SK_A
FROM dbo.netflix_titles_raw
WHERE [cast] LIKE '%Salman Khan%'
    AND CAST(release_year AS INT) >= CAST(FORMAT(DATEADD(YEAR,-10,GETDATE()),'yyyy')AS INT)

-- Q14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

SELECT TOP 10
    actor, 
    COUNT(*) as movie_count

FROM
(
SELECT 
    title,
    RTRIM(LTRIM(value)) as actor
FROM dbo.netflix_titles_raw
CROSS APPLY STRING_SPLIT([cast],',') 
) t
GROUP BY actor
ORDER BY movie_count DESC

-- Q15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
SELECT 
    title,
    CASE 
        WHEN description_keyword LIKE '%Kill%' THEN 'Violence' 
        WHEN description_keyword LIKE '%Violence%' THEN 'Violence' 
        ELSE 'Non-Violence' 
    END AS category,
    *

FROM
(
SELECT 
*,
RTRIM(LTRIM(value)) as description_keyword
FROM dbo.netflix_titles_raw
CROSS APPLY STRING_SPLIT(description,' ')
) t


/* 
it seems very complex to write sql but it makes me feel good after getting it right 
.... insteresting ... 
*/

