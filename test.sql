-- 1. Find the lowest and highest ranking countries in each group
-- my answer
SELECT group_name, MIN(ranking) as low_country, MAX(ranking) as high_country GROUP BY group_name FROM countries;

-- answer
SELECT group_name AS グループ, MIN(ranking) AS ランキング最上位, MAX(ranking) AS ランキング最下位
FROM countries
GROUP BY group_name