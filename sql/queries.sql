-- Netflix BigQuery SQL Queries

-- 1) Movies vs TV Shows
SELECT type, COUNT(1) AS Total_count
FROM `netflix-analysis-data.netflix.titles_raw`
GROUP BY type
ORDER BY total_count DESC;

-- 2) Top 10 Countries by Number of Titles
SELECT country, COUNT(1) AS total_titles 
FROM `netflix-analysis-data.netflix.titles_raw` 
WHERE country IS NOT NULL AND country != ''
GROUP BY country
ORDER BY total_titles DESC
LIMIT 10;


-- 3) Content Growth Over Time (by Year Added)
SELECT EXTRACT(YEAR FROM PARSE_DATE('%B %e, %Y', date_added))  AS year_added,  
       COUNT(1) AS titles_added
FROM `netflix-analysis-data.netflix.titles_raw`
WHERE date_added IS NOT NULL
GROUP BY year_added
ORDER BY year_added;

-- 4) Ratings Breakdown
SELECT rating, COUNT(*) AS total
FROM `netflix-analysis-data.netflix.titles_raw`
WHERE rating IS NOT NULL AND rating != ''
GROUP BY rating
ORDER BY total DESC;

-- 5) Top 15 Genres (split listed_in)
WITH exploded AS (
  SELECT TRIM(genre) AS genre
  FROM `netflix-analysis-data.netflix.titles_raw`,
  UNNEST(SPLIT(listed_in, ',')) AS genre
)
SELECT genre, COUNT(*) AS total
FROM exploded
WHERE genre IS NOT NULL AND genre != ''
GROUP BY genre
ORDER BY total DESC
LIMIT 15;


-- 6) Average Release Year by Genre

WITH exploded AS
 (
  SELECT TRIM(genre) AS genre, release_year
  FROM `netflix-analysis-data.netflix.titles_raw`,
  UNNEST(SPLIT(listed_in, ',')) AS genre
	)
SELECT genre, AVG(release_year) AS avg_release_year
FROM exploded
WHERE genre IS NOT NULL AND genre != '' AND release_year IS NOT NULL
GROUP BY genre
ORDER BY avg_release_year DESC;

-- 7) Top 10 Directors
SELECT director, COUNT(*) AS total_titles
FROM `netflix-analysis-data.netflix.titles_raw`
WHERE director IS NOT NULL AND director != ''
GROUP BY director
ORDER BY total_titles DESC
LIMIT 10;
