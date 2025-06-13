-- 1. Find the lowest and highest ranking countries in each group
-- my answer
SELECT group_name, MIN(ranking) as low_country, MAX(ranking) as high_country GROUP BY group_name FROM countries;

-- answer
SELECT group_name AS グループ, MIN(ranking) AS ランキング最上位, MAX(ranking) AS ランキング最下位
FROM countries
GROUP BY group_name

-- 2. Find the average height and weight of goalkeepers
-- my answer
SELECT AVG(height), AVG(weight) FROM players WHERE position = 'GK';

-- answer
SELECT AVG(height) AS 平均身長, AVG(weight) AS 平均体重
FROM players
WHERE position = 'GK';