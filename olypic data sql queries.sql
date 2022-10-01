select * from dbo.athlete_events;
select * from noc_regions ;
--1. How many olympics games have been held?
select count(distinct (games)) as no_of_games from 
 dbo.athlete_events

 --2. List down all Olympics games held so far.

 select year,season,city 
 from  dbo.athlete_events
group by year,season,city
order by year 

--3. Mention the total no of nations who participated in each olympics game?
with gamess as 
(select e.games ,r.region --,e.noc,r.noc
from dbo.athlete_events e join noc_regions r
on e.noc = r.noc
group by games,r.region ,e.noc,r.noc)
select games,count(1) as counting  from gamess
group by games
order by games

--Which year saw the highest and lowest no of countries participating in olympics
select * from dbo.athlete_events;
select * from noc_regions ;
with countries_total as
(select a.games,r.region  from athlete_events  a join noc_regions r
on r.noc= a.noc
group by a.games,r.region),
tuming as
(select games,count(region) as counting from countries_total
group by games)
select DISTINCT concat(first_value(games) over(order by counting),'-',
        first_value(counting) over(order by counting)) as least_value ,
		concat(first_value(games) over(order by counting DESC),'-',
        first_value(counting) over(order by counting DESC)) as MAXIMUM
from tuming

--5. Which nation has participated in all of the olympic games
select * from dbo.athlete_events;
select * from noc_regions ;
 with countries as
(select count(distinct(games)) as total_countries from dbo.athlete_events),
countries_and_region as
(select e.games,d.region as summ
from dbo.athlete_events e join noc_regions d
on e.noc = d.noc
group by e.games,d.region),

countiries_participate  as 
(select summ,count(summ) as suming
from countries_and_region
group by summ)
select cp.* from countiries_participate cp join  countries c
on cp.suming = c.total_countries



--6. Identify the sport which was played in all summer olympics.

select * from dbo.athlete_events;
select * from noc_regions
with no_of_games as
(select count(distinct(games)) as total_num from dbo.athlete_events where season = 'summer'),
 distinct_games_sport as
(select distinct (games), sport  from dbo.athlete_events where season = 'summer'),
count_of_distinct_games_sport as 
(select sport,count(sport) no_of_element
from distinct_games_sport
group by sport),
camparison as
(select sport, c.no_of_element,n.total_num from no_of_games n join count_of_distinct_games_sport c
on n.total_num = c.no_of_element) 
SELECT * FROM camparison
--7. Which Sports were just played only once in the olympics.

with gs as 
(select distinct(games),sport from dbo.athlete_events
group by games, sport) ,
kk as
(select sport, count(sport) as no_of_sport
from gs
group by sport),
camprison  as
(select g.sport, k.no_of_sport, g.games from gs g join kk k on  k.sport = g.sport
where k.no_of_sport = 1)
select * from camprison
order by sport

select * from dbo.athlete_events;
select * from noc_regions 

--8. Fetch the total no of sports played in each olympic games.

select distinct(games) from dbo.athlete_events
select games,count (distinct (sport)) games_played
from dbo.athlete_events
group by games
order by games_played desc
