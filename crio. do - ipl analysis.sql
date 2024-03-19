create database IPL;
use IPL;


/*1. List out the names of the bowlers who have bowled a maiden over in the IPL 2016 tournament.Also, add the count of maiden 
overs bowled by each bowler.*/

select  distinct (p.Player_Name), COUNT(*) as overs
from batsman_scored as bs 
join matches as m on bs.Match_Id = m.Match_Id
join player_match as pm on pm.Match_Id = m.Match_Id
join player as p on p.Player_Id = pm.Player_Id
where bs.runs_scored = 0
and m.Season_Id = 9
group by p.Player_Name;

/* 2. Rank the batsmen that participated in IPL 2016 tournament based on their Runs Above Average. */

select p.player_name,m.Season_Id,
(select avg(Runs_Scored) from batsman_scored where Runs_Scored > 0) as batsman_out_rate, 
(select avg(Runs_Scored) / count(ball_id) from batsman_scored where Runs_Scored > 0 ) as avg_out_rate,
(sum(bs.Runs_Scored) - avg(bs.Runs_Scored) * count(bs.ball_id)) + (avg(bs.Runs_Scored)) * (count(bs.ball_id)) * ((select avg(Runs_Scored) / count(ball_id) from batsman_scored where Runs_Scored > 0 )  - (select avg(Runs_Scored) from batsman_scored where Runs_Scored > 0)) as RAA
from batsman_scored as bs
join matches as m on m.match_id = bs.match_id
join player_match as pm on pm.Match_Id = m.match_id
join player as p on p.player_id = pm.player_id
where m.Season_Id = 9
group by p.player_name, m.Season_Id
order by RAA desc;