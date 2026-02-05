-----------------------------------------------------------------------------------------
-- Data Cexploratory Analysis 
-----------------------------------------------------------------------------------------

/* Step 1: inspect null fields 
    result: age, 
            quantity, 
            price_per_unit,
            cogs,
            total_sale 
    has nulls
*/

SELECT 
    SUM(CASE WHEN transactions_id IS NULL THEN 1 ELSE 0 END) AS transactions_id_null_count,
    SUM(CASE WHEN sale_date IS NULL THEN 1 ELSE 0 END) AS sale_date_null_count,
    SUM(CASE WHEN sale_time IS NULL THEN 1 ELSE 0 END) AS sale_time_null_count,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id_null_count,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS gender_null_count,
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS age_null_count,
    SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS category_null_count,
    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS quantity_null_count,
    SUM(CASE WHEN price_per_unit IS NULL THEN 1 ELSE 0 END) AS price_per_unit_null_count,
    SUM(CASE WHEN cogs IS NULL THEN 1 ELSE 0 END) AS cogs_null_count,
    SUM(CASE WHEN total_sale IS NULL THEN 1 ELSE 0 END) AS total_sale_null_count

FROM dbo.retail_sales;

/* Step 2: Inpsect the null rows 
    Result: I think it is safe to drop these rows
*/
SELECT * 
FROM dbo.retail_sales
WHERE age IS NULL
OR quantity IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

/* Step 3: Drop null rows */
DELETE FROM dbo.retail_sales
WHERE age IS NULL
OR quantity IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

/* Step 4: How many transactions we have?
-> 1987
 */
SELECT COUNT(distinct(transactions_id)) FROM dbo.retail_sales

/* Step 5: How many customers we have?
-> 155
 */
SELECT COUNT(distinct(customer_id)) FROM dbo.retail_sales


/* Step 6: What categories we have?
-> Beauty, Electronics, Clothing
 */
SELECT distinct(category) FROM dbo.retail_sales


-----------------------------------------------------------------------------------------
-- Analysis & Findings 
-----------------------------------------------------------------------------------------

-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT * FROM dbo.retail_sales WHERE sale_date = '2022-11-05'

-- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT *
FROM dbo.retail_sales
WHERE 
    category = 'Clothing' 
    AND 
    sale_date >= '2022-11-01' 
    AND 
    sale_date < '2022-12-01'
    AND 
    quantity >= 4

-- Q3. Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT 
    category as category,
    CAST(SUM(total_sale) AS INT) AS total_sales
FROM dbo.retail_sales
GROUP BY category

-- Q4: Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT 
    category,
    AVG(age) as avg_customer_age
FROM dbo.retail_sales
WHERE category = 'Beauty'
GROUP BY category

-- Q5: Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT 
    *
FROM dbo.retail_sales
WHERE total_sale > 1000

-- Q6: Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT 
    gender,
    category,
    count(distinct(transactions_id)) as transaction_count
FROM dbo.retail_sales
GROUP BY category, gender

-- Q7: Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
WITH monthly_sales AS (
    SELECT 
        YEAR(sale_date)  AS sale_year,
        MONTH(sale_date) AS sale_month,
        AVG(total_sale)  AS avg_sales
    FROM dbo.retail_sales
    GROUP BY
        YEAR(sale_date),
        MONTH(sale_date)
),
ranked_sales AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY sale_year
               ORDER BY avg_sales DESC
           ) AS rn
    FROM monthly_sales
)
SELECT
    sale_year,
    sale_month,
    avg_sales
FROM ranked_sales
WHERE rn = 1
ORDER BY sale_year;


-- Q8: Write a SQL query to find the top 5 customers based on the highest total sales:
SELECT TOP 5
    customer_id,
    SUM(total_sale) as customer_total_spend

FROM dbo.retail_sales
GROUP BY customer_id
ORDER BY customer_total_spend DESC 

-- Q9: Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT 
    category,
    COUNT(DISTINCT(customer_id)) as customer_count
FROM dbo.retail_sales
GROUP BY category 
ORDER BY customer_count DESC

-- Q10: Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH shift_added AS (SELECT 
    *,
    CASE 
    WHEN sale_time < '12:00:00' AND sale_time > '00:00:0' THEN 'Morning' 
    WHEN sale_time BETWEEN '12:00:00' AND '17:00:00' THEN 'Afternon' 
    ELSE 'Evening' 
    END as 'Shift'

FROM dbo.retail_sales)

SELECT 
    shift,
    COUNT(DISTINCT(transactions_id)) as total_orders
FROM shift_added 
GROUP BY shift
ORDER BY total_orders DESC

