# %%
from pyspark.sql import functions as F, Window
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
spark = SparkSession.builder.appName("pipeline").getOrCreate()

df = spark.read.format('csv').load('data/netflix_titles.csv',header=True)
df.show(3,truncate=False)

# %%
# Q1. Count the Number of Movies vs TV Shows
df.groupby('type').agg(F.countDistinct('title')).show()


# 2. Find the Most Common Rating for Movies and TV Shows

w = Window.partitionBy("type").orderBy(F.desc("count"))

(
    df.filter(F.col("rating").isNotNull())
      .groupBy("type", "rating")
      .count()
      .withColumn("rn", F.row_number().over(w))
      .filter("rn = 1")
      .select("type", F.col("rating").alias("most_common_rating"))
      .show(truncate=False)
)

# compare with pandas
import pandas as pd
t = pd.read_csv('data/netflix_titles.csv')
t.groupby('type')['rating'].value_counts().groupby(level=0).head(1)


# 3. List All Movies Released in a Specific Year(e.g., 2020)
# 4. Find the Top 5 Countries with the Most Content on Netflix
# 5. Identify the Longest Movie
# 6. Find Content Added in the Last 5 Years
# 7. Find All Movies / TV Shows by Director 'Rajiv Chilaka'
# 8. List All TV Shows with More Than 5 Seasons
# 9. Count the Number of Content Items in Each Genre
# 10. Find each year and the average numbers of content release in India on netflix.
# 11. List All Movies that are Documentaries
# 12. Find All Content Without a Director
# 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
# 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
# 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

# %%
