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


-- 5. Kick-off times and names of the competing countries are displayed in order from earliest kick-off time to latest kick-off time.
-- my answer
SELECT t1.kickoff, t2.name AS 対戦国1, t3.name AS 対戦国2 FROM pairings t1
INNER JOIN countries t2 ON t1.my_country_id = t2.id
INNER JOIN countries t3 ON t1.my_country_id = t3.id
ORDER BY t1.kickoff ASC;

-- answer
SELECT kickoff AS キックオフ日時, c1.name AS 国名1, c2.name AS 国名2
FROM pairings p
LEFT JOIN countries c1 ON p.my_country_id = c1.id
LEFT JOIN countries c2 ON p.enemy_country_id = c2.id
ORDER BY kickoff


-- 6. Kick-off times and names of the competing countries are displayed in order from earliest kick-off time to latest kick-off time.
-- my answer
SELECT
  name AS 名前,
  position AS ポジション,
  club AS 所属クラブ,
  (SELECT COUNT(goal_time) FROM goals WHERE player_id = players.id) AS ゴール数
FROM players
ORDER BY ゴール数 DESC;

-- answer
SELECT p.name AS 名前, p.position AS ポジション, p.club AS 所属クラブ,
    (SELECT COUNT(id) FROM goals g WHERE g.player_id = p.id) AS ゴール数
FROM players p
ORDER BY ゴール数 DESC;


-- 7. Kick-off times and names of the competing countries are displayed in order from earliest kick-off time to latest kick-off time.(JOIN)
-- my answer
SELECT
  t1.name AS 名前,
  t1.position AS ポジション,
  t1.club AS 所属クラブ,
  SELECT COUNT(t2.id) AS ゴール数
FROM players t1
LEFT JOIN goals t2 ON t1.id = t2.player_id
ORDER BY ゴール数 DESC;

--answer
SELECT p.name AS 名前, p.position AS ポジション, p.club AS 所属クラブ,
    COUNT(g.id) AS ゴール数
FROM players p
LEFT JOIN goals g ON g.player_id = p.id
GROUP BY p.id, p.name, p.position, p.club
ORDER BY ゴール数 DESC
-- 選手ごとの得点を表示するためにはgroup byする必要がある
-- groupにする場合は、select句のカラムは全て書く（構文上のルール）


-- 8. Shows total points scored by each position
-- my answer
SELECT
  t1.position AS ポジション,
  COUNT(t2.id) AS ゴール数
FROM players t1
LEFT JOIN goals t2 ON t1.id = t2.player_id
GROUP BY t1.position
ORDER BY ゴール数 DESC;

--answer
SELECT p.position AS ポジション, COUNT(g.id) AS ゴール数
FROM players p
LEFT JOIN goals g ON g.player_id = p.id
GROUP BY p.position
ORDER BY ゴール数 DESC


-- 9. Shows the age of each player at the time of the World Cup (2014-06-13)
-- my answer
SELECT
  birth,
  IIF(
    DATEADD(yyyy, DATEDIFF(yyyy, birth, '2014-06-13'), birth) <= '2014-06-13',
    DATEDIFF(yyyy, birth, '2014-06-13'),
    DATEDIFF(yyyy,birth, '2014-06-13') - 1
  ) AS age,
  name,
  position
FROM players
ORDER BY birth;

--answer
SELECT birth, TIMESTAMPDIFF(YEAR, birth, '2014-06-13') AS age, name, position
FROM players
ORDER BY age DESC;
-- my answerのクエリの方が正確な気はする


-- 10. Shows the age of each player at the time of the World Cup (2014-06-13)
-- my answer
SELECT COUNT(id)
FROM goals
WHERE player_id IS NULL
GROUP BY id;

--answer
SELECT COUNT(g.goal_time)
FROM goals  g
WHERE g.player_id IS NULL;


-- 11. Shows the age of each player at the time of the World Cup (2014-06-13)
-- my answer
SELECT t1.group_name, COUNT(t1.id)
FROM goals t1
LEFT JOIN players t2 ON t2.id = t1.player_id
LEFT JOIN countries t3 ON t3.id = t2.country_id
WHERE t1.goal_time BETWEEN '2014-06-13' AND '2014-06-27'
GROUP BY t1.id;

--answer
SELECT c.group_name, COUNT(g.id)
FROM goals g
LEFT JOIN pairings p ON p.id = g.pairing_id
LEFT JOIN countries c ON p.my_country_id = c.id
WHERE p.kickoff BETWEEN '2014-06-13 0:00:00' AND '2014-06-27 23:59:59'
GROUP BY c.group_name;


-- 12. Showing the goal times of Colombia's goals in the Japan vs Colombia match (pairings.id = 103)
-- my answer
SELECT g.goal_time
FROM goals g
LEFT JOIN pairings p ON g.pairing_id = p.id
LEFT JOIN players pl ON g.player_id = pl.id
LEFT JOIN countries c ON pl.country_id = c.id
WHERE g.pairing_id = 103 AND c.name = 'コロンビア'

--answer
SELECT goal_time
FROM goals
WHERE pairing_id = 103


-- 13. Showing the result of Japan vs Colombia match. Japan's goals are pairings.id = 39, Colombia's goals are pairings.id = 103.
-- my answer
SELECT p.name, COUNT(g.goal_time)
FROM pairings p
LEFT JOIN goals g ON p.id = g.pairing_id
WHERE p.enemy_country_id = 103 AND p.my_country_id = 39

--answer
SELECT c.name, COUNT(g.goal_time)
FROM goals g
LEFT JOIN pairings p ON p.id = g.pairing_id
LEFT JOIN countries c ON p.my_country_id = c.id
WHERE p.id = 103 OR p.id = 39
GROUP BY c.name


-- 14. Show the number of goals scored in each match of Group C.
-- my answer
SELECT p.kickoff, myc.name as my_country, ec.name as enemy_country, myc.ranking as my_ranking, ec.ranking as enemy_ranking, COUNT(g.goal_time) as my_goals
FROM pairings p
LEFT JOIN countries as myc ON p.my_country_id = myc.id
LEFT JOIN countries as ec ON p.enemy_country_id = ec.id
LEFT JOIN goals g ON p.id = g.pairing_id
GROUP BY p.kickoff

--answer
SELECT p1.kickoff, c1.name AS my_country, c2.name AS enemy_country,
    c1.ranking AS my_ranking, c2.ranking AS enemy_ranking,
    COUNT(g1.id) AS my_goals
FROM pairings p1
LEFT JOIN countries c1 ON c1.id = p1.my_country_id
LEFT JOIN countries c2 ON c2.id = p1.enemy_country_id
LEFT JOIN goals g1 ON p1.id = g1.pairing_id
WHERE c1.group_name = 'C' AND c2.group_name = 'C'
GROUP BY p1.kickoff, c1.name, c2.name, c1.ranking, c2.ranking
ORDER BY p1.kickoff, c1.ranking
-- GROUP BY句にSELECT句で指定したカラムを全て列挙する
-- 決勝リーグの結果が含まれないように自国と対戦国がどちらもCグループという条件を付ける


-- 15. Show the number of goals scored in each match of Group C.
-- my answer
SELECT
  p.kickoff,
  (
    SELECT name FROM countries WHERE id = p.my_country_id AND group_name = 'C'
  ) as my_country,
  (
    SELECT name FROM countries WHERE id = p.enemy_country_id AND group_name = 'C'
  ) as enemy_country,
  (
    SELECT ranking FROM countries WHERE id = p.my_country_id AND group_name = 'C'
  ) as my_ranking,
  (
    SELECT ranking FROM countries WHERE id = p.enemy_country_id AND group_name = 'C'
  ) as enemy_ranking,
  (
    SELECT COUNT(id) FROM goals WHERE pairing_id = p.id
  ) as my_goals,
FROM pairings p
ORDER BY p.kickoff, my_ranking

--answer
SELECT p1.kickoff, c1.name AS my_country, c2.name AS enemy_country,
    c1.ranking AS my_ranking, c2.ranking AS enemy_ranking,
    (SELECT COUNT(g1.id) FROM goals g1 WHERE p1.id = g1.pairing_id) AS my_goals
FROM pairings p1
LEFT JOIN countries c1 ON c1.id = p1.my_country_id
LEFT JOIN countries c2 ON c2.id = p1.enemy_country_id
WHERE c1.group_name = 'C' AND c2.group_name = 'C'
ORDER BY p1.kickoff, c1.ranking


-- 16. Show the number of goals scored in each match of Group C.
-- my answer
SELECT p1.kickoff, c1.name AS my_country, c2.name AS enemy_country,
    c1.ranking AS my_ranking, c2.ranking AS enemy_ranking,
    (SELECT COUNT(g1.id) FROM goals g1 WHERE p1.id = g1.pairing_id) AS my_goals,
    (SELECT COUNT(g2.id) FROM goals g2 WHERE p2.id = g2.pairing_id) AS enemy_goals
FROM pairings p1
LEFT JOIN countries c1 ON c1.id = p1.my_country_id
LEFT JOIN countries c2 ON c2.id = p1.enemy_country_id
LEFT JOIN pairings p2 ON c1.id = p2.enemy_country_id
WHERE c1.group_name = 'C' AND c2.group_name = 'C'
ORDER BY p1.kickoff, c1.ranking

--answer
SELECT p1.kickoff, c1.name AS my_country, c2.name AS enemy_country,
    c1.ranking AS my_ranking, c2.ranking AS enemy_ranking,
    (SELECT COUNT(g1.id) FROM goals g1 WHERE p1.id = g1.pairing_id) AS my_goals,
    (
        SELECT COUNT(g2.id)
        FROM goals g2
        LEFT JOIN pairings p2 ON p2.id = g2.pairing_id
        WHERE p2.my_country_id = p1.enemy_country_id AND p2.enemy_country_id = p1.my_country_id
    ) AS enemy_goals
FROM pairings p1
LEFT JOIN countries c1 ON c1.id = p1.my_country_id
LEFT JOIN countries c2 ON c2.id = p1.enemy_country_id
WHERE c1.group_name = 'C' AND c2.group_name = 'C'
ORDER BY p1.kickoff, c1.ranking


-- 17. Show the number of goals scored in each match of Group C.
-- my answer
SELECT p1.kickoff, c1.name AS my_country, c2.name AS enemy_country,
    c1.ranking AS my_ranking, c2.ranking AS enemy_ranking,
    (SELECT COUNT(g1.id) FROM goals g1 WHERE p1.id = g1.pairing_id) AS my_goals,
    (
        SELECT COUNT(g2.id)
        FROM goals g2
        LEFT JOIN pairings p2 ON p2.id = g2.pairing_id
        WHERE p2.my_country_id = p1.enemy_country_id AND p2.enemy_country_id = p1.my_country_id
    ) AS enemy_goals,
    my_goals - enemy_goals AS goal_diff
FROM pairings p1
LEFT JOIN countries c1 ON c1.id = p1.my_country_id
LEFT JOIN countries c2 ON c2.id = p1.enemy_country_id
WHERE c1.group_name = 'C' AND c2.group_name = 'C'
ORDER BY p1.kickoff, c1.ranking

--answer
SELECT p1.kickoff, c1.name AS my_country, c2.name AS enemy_country,
    c1.ranking AS my_ranking, c2.ranking AS enemy_ranking,
    (SELECT COUNT(g1.id) FROM goals g1 WHERE p1.id = g1.pairing_id) AS my_goals,
    (
        SELECT COUNT(g2.id)
        FROM goals g2
        LEFT JOIN pairings p2 ON p2.id = g2.pairing_id
        WHERE p2.my_country_id = p1.enemy_country_id AND p2.enemy_country_id = p1.my_country_id
    ) AS enemy_goals,
    (SELECT COUNT(g1.id) FROM goals g1 WHERE p1.id = g1.pairing_id) - 
    (
        SELECT COUNT(g2.id)
        FROM goals g2
        LEFT JOIN pairings p2 ON p2.id = g2.pairing_id
        WHERE p2.my_country_id = p1.enemy_country_id AND p2.enemy_country_id = p1.my_country_id
    ) AS goal_diff
FROM pairings p1
LEFT JOIN countries c1 ON c1.id = p1.my_country_id
LEFT JOIN countries c2 ON c2.id = p1.enemy_country_id
WHERE c1.group_name = 'C' AND c2.group_name = 'C'
ORDER BY p1.kickoff, c1.ranking
-- サブクエリの結果のカラムを使った計算はできない（構文エラー）
-- なので、サブクエリを2回書くことになる


-- 18. Show the number of goals scored in each match of Group C.
-- my answer
SELECT kickoff, (DATE_SUB(kickoff, INTERVAL 12 HOUR)) AS kickoff_jp
FROM pairings
WHERE my_country_id = 1 AND enemy_country_id = 4

--answer
SELECT p.kickoff, DATE_SUB(p.kickoff, INTERVAL '12' HOUR) AS kickoff_jp
FROM pairings p
WHERE p.my_country_id = 1 AND p.enemy_country_id = 4;


-- 19. Show number of players by age.
-- my answer
SELECT
  IIF(
    DATEADD(yyyy, DATEDIFF(yyyy, birth, '2014-06-13'), birth) <= '2014-06-13',
    DATEDIFF(yyyy, birth, '2014-06-13'),
    DATEDIFF(yyyy,birth, '2014-06-13') - 1
  ) AS age,
  COUNT(id) AS player_count
FROM players
GROUP BY age

--answer
SELECT TIMESTAMPDIFF(YEAR, birth, '2014-06-13') AS age, COUNT(id) AS player_count
FROM players
GROUP BY age


-- 20. Show number of players by age.
-- my answer
SELECT
  IIF(
    DATEADD(yyyy, DATEDIFF(yyyy, birth, '2014-06-13'), birth) <= '2014-06-13',
    DATEDIFF(yyyy, birth, '2014-06-13'),
    DATEDIFF(yyyy,birth, '2014-06-13') - 1
  ) AS age,
  COUNT(id) AS player_count
FROM players
WHERE age = 10 OR age = 20 OR age = 30 OR age = 40 OR age = 50 OR age = 60
GROUP BY age

--answer
SELECT TRUNCATE(TIMESTAMPDIFF(YEAR, birth, '2014-06-13'), -1) AS age, COUNT(id) AS player_count
FROM players
GROUP BY age


-- 21. Show number of players by age.
-- my answer
SELECT age DIV 5 as age, COUNT(id) AS player_count
FROM players
GROUP BY age

--answer
SELECT FLOOR(TIMESTAMPDIFF(YEAR, birth, '2014-06-13') / 5) * 5   AS age, COUNT(id) AS player_count
FROM players
GROUP BY age


-- 22
-- my answer
SELECT
  FLOOR(TIMESTAMPDIFF(YEAR, birth, '2014-06-13') / 5) * 5   AS age,
  position,
  COUNT(id) AS player_count,
  AVG(height),
  AVG(weight)
FROM players
GROUP BY age, position
ORDER BY age, position

--answer
SELECT FLOOR(TIMESTAMPDIFF(YEAR, birth, '2014-06-13') / 5) * 5   AS age, COUNT(id) AS player_count
FROM players
GROUP BY age


-- 23
-- my answer
SELECT
  TOP 3 (name, height, weight)
FROM players
ORDER BY height DESC

--answer
SELECT name, height, weight
FROM players
ORDER BY height DESC
LIMIT 5


-- 24
-- my answer
SELECT name, height, weight
FROM players
ORDER BY height DESC
LIMIT 15
OFFSET 5

--answer
SELECT name, height, weight
FROM players
ORDER BY height DESC
LIMIT 5, 15
-- my answerでも同じ結果になるので、ここは好みの問題（MYSQL以外の場合はLIMIT OFFSETの方がいいかも）


-- 25
-- my answer
SELECT uniform_num, name, club
FROM players

--answer
SELECT uniform_num, name, club
FROM players
-- ただの射影


-- 26
-- my answer
SELECT id, name, ranking, group_name
FROM countries
WHERE group_name = 'C'

--answer
SELECT * 
FROM countries
WHERE group_name = 'C'
-- ただの選択


-- 27
-- my answer
SELECT *
FROM countries
WHERE group_name != 'C'

--answer
SELECT *
FROM countries
WHERE group_name <> 'C'
-- ただの選択


-- 28
-- my answer
SELECT *
FROM players
WHERE TIMESTAMPDIFF(YEAR, birth, '2016-01-13') >= 40

--answer
SELECT *
FROM players
WHERE birth <= '1976-1-13'
-- ただの選択


-- 29
-- my answer
SELECT *
FROM players
WHERE height < 170

--answer
SELECT *
FROM players
WHERE height < 170

