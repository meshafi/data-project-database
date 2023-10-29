-- 1.number of matches per year-  

select season,count(season) from matches group by season order by season asc;




-- 2.Number of matches won per year- 

select winner as winning_team,season, count(*) from matches group by winner,season order by season,winner asc;




-- 3.Extra run conceded by the team in the year 2016- 

select bowling_team,season,sum(extra_runs) from deliveries  join matches on  matches.id = deliveries.match_id  where season='2016' group by bowling_team,season;



-- 4. Top 10 economical bowler in the year 2015-

 select bowler,
round(
(sum(batsman_runs)+sum(wide_runs)+sum(noball_runs))*6.00/
COUNT(CASE WHEN wide_runs = 0 AND noball_runs=0 THEN 1 ELSE NULL END) 
	,2)
	AS bowler_economy

   from deliveries b
   join matches m on m.id=b.match_id
   where season='2015'
   group by bowler
   order by bowler_economy asc
   limit 10;
   
   
   

-- 5.Number of times each team won toss and won- 

select winner,count(*) from matches where (toss_winner=winner) group by winner;



-- 6.Maximum number of times a player has won 'POTM' for each season- 

SELECT   season, player_of_match, count_potm
FROM (
    SELECT
        season,
        player_of_match,
        COUNT(player_of_match) AS count_potm,
        DENSE_RANK() OVER (PARTITION BY season ORDER BY COUNT(player_of_match) DESC) AS ranking
    FROM matches
    GROUP BY season, player_of_match
) AS ranked_data
WHERE ranking = 1
ORDER BY season ASC, count_potm DESC;




-- 7.Strike rate of a batsman for each season-  

SELECT batsman, season,
Round(
SUM(batsman_runs)*100.00/
count(CASE WHEN wide_runs = 0 THEN 1 END)
	,2)
AS batting_average
FROM deliveries
JOIN matches ON matches.id = deliveries.match_id
where batsman='V Kohli'
GROUP BY batsman,season
order by season asc; 




-- 8.Maximum number of times a player got dismissed by another player-

 SELECT batsman,bowler, max_dismissals
FROM (
    SELECT bowler, batsman, COUNT(*) as max_dismissals,
           DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM deliveries
    WHERE dismissal_kind != 'run out'
    GROUP BY bowler, batsman
) AS ranked_data
WHERE rnk = 1;



-- 9. Bowler with best economy in super overs-

select bowler,
Round(
(sum(batsman_runs)+sum(wide_runs)+sum(noball_runs))*6.00/
count(CASE WHEN wide_runs=0 AND noball_runs=0 THEN 1 ELSE NULL END)
	,2) as min_economy
from deliveries where is_super_over=true
group by bowler
order by min_economy asc
limit 1;
