CREATE TABLE popstats (
    countrycode TEXT PRIMARY KEY,
    countryname TEXT,
    population INTEGER,
    averageincome INTEGER
);
CREATE TABLE fanspercountry (
    date TEXT,
    countrycode TEXT,
    numberoffans INTEGER,
    FOREIGN KEY (countrycode) REFERENCES popstats(countrycode)
);
CREATE TABLE fanspercity (
    date TEXT,
    city TEXT,
    countrycode TEXT,
    numberoffans INTEGER,
    FOREIGN KEY (countrycode) REFERENCES popstats(countrycode)
);
CREATE TABLE fansperlanguage (
    date TEXT,
    language TEXT,
    countrycode TEXT,
    numberoffans INTEGER,
    FOREIGN KEY (countrycode) REFERENCES popstats(countrycode)
);
CREATE TABLE fanspergenderage (
    date TEXT,
    gender TEXT,
    agegroup TEXT,
    numberoffans INTEGER
);
CREATE TABLE globalpage (
    date TEXT,
    countrycode TEXT,
    newlikes INTEGER,
    dailypostsreach INTEGER,
    dailypostshares INTEGER,
    dailypostactions INTEGER,
    dailypostimpressions INTEGER,
    FOREIGN KEY (countrycode) REFERENCES popstats(countrycode)
);
CREATE TABLE postinsights (
	    createdtime TEXT,
	    engagedfans INTEGER,
	    impressions INTEGER,
	    negativefeedback INTEGER,
	    nonviralimpressions INTEGER,
	    nonviralreach INTEGER,
	    postactivity INTEGER,
	    postactivityunique INTEGER,
	    postclicks INTEGER,
	    uniquepostclicks INTEGER,
	    postreactionsanger INTEGER,
	    postreactionshaha INTEGER,
	    postreactionslike INTEGER,
	    postreactionslove INTEGER,
	    postreactionssorry INTEGER,
	    postreactionswow INTEGER,
	    reach INTEGER
);
SELECT * FROM popstats; 
SELECT * FROM fanspercountry;
SELECT * FROM fanspercity;
SELECT *FROM fansperlanguage;
SELECT * FROM fanspergenderage;
SELECT * FROM globalpage;
SELECT * FROM postinsights;

/* Question 1: Unique Countries
How many unique countries are there? */

SELECT count(distinct CountryName) 
FROM PopStats;

/* Question 2: Unique Cities
How many unique cities are there? */

SELECT count(distinct City) 
FROM FansPerCity; 

/* Question 03: How many unique languages are there? */

SELECT COUNT(DISTINCT language) AS unique_languages
FROM fansperlanguage;

/* Question 04: What is the daily average reach of the posts (i.e. DailyPostsReach) on the global page over the period? */

select round(avg(dailypostsreach), 2) as daily_average_reach from globalpage;

/* Question 05: What is the daily average engagement rate (i.e. NewLikes) on the global page over the period?  Round the result to 2 decimal places. */

select round(avg(newlikes),2) as daily_average_engagement_rate from globalpage;

/* Question 06: What are the top 10 countries (considering the number of fans)?  Show a table of results containing the following columns:

●	CountryCode
●	Country Name
●	NumberOfFans. */

SELECT
    fanspercountry.countrycode,
    popstats.countryname,
    fanspercountry.numberoffans
FROM fanspercountry 
join popstats on fanspercountry.countrycode=popstats.countrycode
WHERE date = (SELECT MAX(date) FROM fanspercountry)
ORDER BY numberoffans DESC
LIMIT 10;


/* Question 07: What are the top 10 countries by penetration ratio (i.e. the % of the country population that are fans)?  Show a table of results containing the following columns:

●	CountryName
●	PenetrationRatio
●	NumberOfFans
●	Population  */

select 
     popstats.countryname,
     
     round(
     (sum(fanspercountry.numberoffans)*100.0)/popstats.population,2) as Penetration_Ratio,
     
     sum(fanspercountry.numberoffans) as numberoffans,
    
     popstats.population
     
 from fanspercountry 
     
     join popstats on fanspercountry.countrycode=popstats.countrycode
    
     where 
          popstats.population > 0
     group by 
          popstats.countryname, popstats.population
     order by 
          round(
         (sum(fanspercountry.numberoffans)*100.0)/popstats.population,2)  desc
     limit 10;

/*Question 8: Bottom 10 Cities by Number of Fans
What are the bottom 10 cities (considering the number of fans) among countries with a population over 20 million?

This could be considered our growth potential.

Show a table of results containing the following columns:

●	CountryName
●	City
●	NumberOfFans
●	Population */

SELECT
    popstats.countryname ,
    fanspercity.city ,
    sum(fanspercity.numberoffans ) as NumberOfFans,
    popstats.population 
FROM fanspercity 
JOIN popstats 
    ON fanspercity.countrycode = popstats.countrycode
WHERE popstats.population > 20000000
group by    
 popstats.countryname ,fanspercity.city,popstats.population 
ORDER BY  sum(fanspercity.numberoffans )ASC
LIMIT 10;

/* Question 09: What is the split of page fans across age groups (in %)?

Show a table of results containing the following columns:

●	AgeGroup
●	PercentageOfFans */

select agegroup, 
round(
sum(numberoffans)*100.00/
(select sum(numberoffans) from fanspergenderage), 2 ) as PercentageOfFans
from fanspergenderage
group by agegroup 
order by PercentageOfFans desc;

/* Question 10: What is the split of page fans by gender (in %)?

Show a table of results containing the following columns:

●	Gender
●	PercentageOfFans */

select gender,
round(
sum(numberoffans)*100.0/
(select sum(numberoffans) from fanspergenderage),2) as PercentageOfFans
from fanspergenderage
group by gender
order by PercentageOfFans;

/* Question 11: What is the number of the fans that have declared English as their primary language ? */

 select sum(numberoffans)  as English_Fans from fansperlanguage 
 where language = 'en';

/* Question 12: What is the percentage of the fans that have declared English as their primary language? */
select sum(numberoffans) as English_Fans,
round(
sum(numberoffans)*100.0/
(select sum(numberoffans) from fansperlanguage),2) as English_Fans_Percentage
from fansperlanguage
where LANGUAGE= 'en' ;

/* Question 13: Based on the number of fans who have declared English as their primary language and living in the US, what is the potential buying
power that can be accessed? (Please use the average income data per country for this question. It is estimated that on average,
0.01% of the annual income is dedicated to online magazine subscriptions in the US). */

SELECT
    ROUND(SUM(f.NumberOfFans * p.AverageIncome * 0.0001), 2)
    AS PotentialBuyingPower
FROM FansPerLanguage f
JOIN PopStats p
    ON f.CountryCode = p.CountryCode
WHERE f.Language = 'en'
  AND p.CountryName = 'United states';

/* Question 14: Engagement per day of the week
What is the split of the EngagedFans across the days of the week (monday, tuesday,...)?

Give the result as a table with the following columns:

●	DayOfWeek
●	PercentageSplit

Based on the results, what is the best day of the week to publish posts? */

SELECT
    TO_CHAR(createdtime::timestamp, 'Day') AS dayofweek,
    ROUND(
        SUM(engagedfans) * 100.0 /
        (SELECT SUM(engagedfans) FROM postinsights),
        2
    ) AS percentagesplit
FROM postinsights
GROUP BY dayofweek
ORDER BY percentagesplit DESC;


/* Question 15: Engagement per time of day
What is the split of the EngagedFans by time of the day?  Split the day into the following time ranges (call the column TimeRange):

●	05:00 - 08:59
●	09:00 - 11:59
●	12:00 - 14:59
●	15:00 - 18:59
●	19:00 - 21:59
●	22:00 or later

Give the result as a table with the following columns:

●	TimeRange
●	Precentage

Based on the results, what is the best time of the day to publish posts? */

SELECT
    CASE
        WHEN SUBSTRING(createdtime FROM 12 FOR 2)::INT BETWEEN 5 AND 8 THEN '05:00 - 08:59'
        WHEN SUBSTRING(createdtime FROM 12 FOR 2)::INT BETWEEN 9 AND 11 THEN '09:00 - 11:59'
        WHEN SUBSTRING(createdtime FROM 12 FOR 2)::INT BETWEEN 12 AND 14 THEN '12:00 - 14:59'
        WHEN SUBSTRING(createdtime FROM 12 FOR 2)::INT BETWEEN 15 AND 18 THEN '15:00 - 18:59'
        WHEN SUBSTRING(createdtime FROM 12 FOR 2)::INT BETWEEN 19 AND 21 THEN '19:00 - 21:59'
        ELSE '22:00 or later'
    END AS timerange,
    ROUND(SUM(engagedfans) * 100.0 /
         (SELECT SUM(engagedfans) FROM postinsights), 2)
         AS percentage
FROM postinsights
GROUP BY timerange
ORDER BY percentage DESC;

/* Question 16: Month to month change in engagement
Compute the change in PostClicks, EngagedFans and Reach from one month to the next.
Give the result as a table with the following columns:

●	FromMonth
●	ToMonth
●	DeltaPostClicks
●	DeltaEngagedFans
●	DeltaReach

Where the deltas are the percentage differences between a month and its previous month. */

WITH monthly AS (
    SELECT
        SUBSTRING(createdtime, 1, 7) AS month,
        SUM(postclicks) AS postclicks,
        SUM(engagedfans) AS engagedfans,
        SUM(reach) AS reach
    FROM postinsights
    GROUP BY month
)
SELECT
    LAG(month) OVER (ORDER BY month) AS frommonth,
    month AS tomonth,
    ROUND((postclicks - LAG(postclicks) OVER (ORDER BY month)) * 100.0 /
          LAG(postclicks) OVER (ORDER BY month), 2) AS deltapostclicks,
    ROUND((engagedfans - LAG(engagedfans) OVER (ORDER BY month)) * 100.0 /
          LAG(engagedfans) OVER (ORDER BY month), 2) AS deltaengagedfans,
    ROUND((reach - LAG(reach) OVER (ORDER BY month)) * 100.0 /
          LAG(reach) OVER (ORDER BY month), 2) AS deltareach
FROM monthly
OFFSET 1;


