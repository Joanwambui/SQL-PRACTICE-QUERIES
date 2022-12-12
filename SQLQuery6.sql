SELECT * FROM olympicdata;

select * from olympicregions;

-- QUESTIONS

--  Find how many olympic games have been held
SELECT COUNT(DISTINCT Games)
FROM athletedata;

SELECT DISTINCT Games,
FROM athletedata;

-- Q 2. List Down all the olympic games held so far
SELECT year, season, city
FROM olympicdata
GROUP BY year, season, city
ORDER BY year;


--  Mention the total no of nations who participated in each olympics game?
with all_countries as 
	(select Games, nr.region
	from olympicdata od
	join olympicregions nr
	on od.NOC = nr.NOC
	group by Games, nr.region)
select Games, count(1) as no_countries
from all_countries
group by Games
order by Games;


--
select Games, nr.region
	from olympicdata od
	join olympicregions nr
	on od.NOC = nr.NOC
	group by Games, nr.region


-- Q 4. Which year saw the highest and lowest no of countries participating in olympics
WITH all_countries AS(
	SELECT Games, nr.region
	FROM olympicdata od
	JOIN olympicregions nr
	ON od.NOC = nr.NOC
	GROUP BY Games, nr.region
),
country_count AS(
	SELECT Games, COUNT(1) AS no_countries
	FROM all_countries
	GROUP BY Games
	ORDER BY Games
)
SELECT DISTINCT CONCAT(FIRST_VALUE(Games) OVER(ORDER BY no_countries), '-',
			  FIRST_VALUE(no_countries) OVER(ORDER BY no_countries)) AS lowest_countries,
	   CONCAT(FIRST_VALUE(Games) OVER(ORDER BY no_countries),'-',
			 FIRST_VALUE(no_countries) OVER(ORDER BY no_countries DESC)) AS highest_countries
FROM country_count
ORDER BY 1;

-- Q. 5. Which nation has participated in all of the olympic games

WITH all_countries AS (
	SELECT Games, nr.region
	FROM olympicdata od
	JOIN olympicregions nr
	ON od.NOC = nr.NOC
	GROUP BY Games, nr.region
	),
game_count_result AS
	(SELECT region, COUNT(Games) as game_count
	FROM all_countries
	GROUP BY region
	)
SELECT region AS Countries, game_count -- just for reference
FROM game_count_result
WHERE game_count >= (SELECT COUNT(DISTINCT games)
					FROM all_countries);

--Number of total gold medals won by athletes
SELECT Name,COUNT(1) AS total_medals
FROM olympicdata
WHERE Medal='Gold'
GROUP BY Name
ORDER BY COUNT(1) desc

---- counting number of games played in summer

SELECT Sport
FROM olympicdata
GROUP BY Sport
HAVING COUNT(DISTINCT Games) = (SELECT COUNT(DISTINCT Games)
								FROM olympicdata
								WHERE games LIKE '%Summer');

--. Write SQL query to fetch the total no of sports played in each olympics.
SELECT Games, COUNT(DISTINCT Sport) AS no_sports_played
FROM olympicdata
GROUP BY Games
ORDER BY no_sports_played;


--  Fetch oldest athletes to win a gold medal
Alter table olympicdata alter column Age nvarchar(50)

SELECT *
FROM olympicdata
WHERE Age = (SELECT MAX (Age)
			FROM olympicdata
			WHERE Medal ='Gold' AND Age <> 'NA')
AND medal = 'Gold';



--  In which Sport/event, India has won highest medals.
SELECT Sport, COUNT(Medal) AS total_medals
FROM olympicdata od
JOIN olympicregions nr
ON od.NOC = nr.NOC
WHERE Medal <> 'NA' AND nr.region = 'India'
GROUP BY od.Sport
ORDER BY total_medals DESC
--LIMIT 1;

-- Q.20. Break down all olympic games where India won medal for Hockey and how many medals in each olympic games

SELECT nr.region, od.Sport, od.Games, COUNT(od.Medal) AS total_medals
FROM olympicdata od
JOIN olympicregions nr
ON od.noc = nr.noc
WHERE Medal <> 'NA' AND nr.region = 'India' AND od.Sport = 'Hockey'
GROUP BY od.Games, nr.region, od.Sport
ORDER BY od.Games;