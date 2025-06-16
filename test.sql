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


-- 3. Average height of each country, from tallest to oldest
-- my answer
SELECT countries.name as 国名, AVG(players.height) as 平均身長 FROM countries
INNER JOIN players ON countries.id = players.country_id
GROUP BY countries.name
ORDER BY players.height DESC;

-- answer
SELECT c.name AS 国名, AVG(p.height) AS 平均身長
FROM countries c
JOIN players p ON p.country_id = c.id
GROUP BY c.id, c.name
ORDER BY AVG(p.height) DESC;
-- テーブル定義でcountries.nameは一意と保証されていないので、idでグループ化している
-- その上で、idだけでグループ化するとSELECTでnameが使えないので、idとnameでグループ化する


-- 4. Average height of each country, from tallest to oldest(not JOIN)
-- my answer
SELECT
  (
    SELECT name FROM countries WHERE id = players.country_id
  ) as 国名,
  AVG(players.height) as 平均身長
FROM players
GROUP BY players.country_id
ORDER BY players.height DESC;

-- answer
SELECT (SELECT c.name FROM countries c WHERE p.country_id = c.id) AS 国名, AVG(p.height) AS 平均身長
FROM players p
GROUP BY p.country_id
ORDER BY AVG(p.height) DESC