create database social_media_analytics;
use social_media_analytics;

create table PopStats (
CountryCode varchar(10) PRIMARY KEY,
CountryName varchar(100),
Population INTEGER,
AverageIncome INTEGER
);

CREATE TABLE FansPerCountry (
    Date DATE,
    CountryCode VARCHAR(10),
    NumberOfFans INT,
    FOREIGN KEY (CountryCode) REFERENCES PopStats(CountryCode)
);

CREATE TABLE FansPerCity (
    Date DATE,
    City VARCHAR(20),
    CountryCode VARCHAR(20),
    NumberOfFans INTEGER,
    FOREIGN KEY (CountryCode) REFERENCES PopStats(CountryCode)
);

CREATE TABLE FansPerGenderAge (
    Date DATE,
    Gender VARCHAR(10),
    AgeGroup VARCHAR(20),
    NumberOfFans INTEGER
);

CREATE TABLE GlobalPage (
    Date DATE,
    CountryCode VARCHAR(20),
    NewLikes INTEGER,
    DailyPostReach INTEGER,
    DailyPostShares INTEGER,
    DailyPostActions INTEGER,
    DailyPostImpressions INTEGER,
    FOREIGN KEY (CountryCode) REFERENCES PopStats(CountryCode)
);

CREATE TABLE PostInsights (
    CreatedTime VARCHAR(20),
    EngagedFans VARCHAR(20),
    Impressions INTEGER,
    NegativeFeedback INTEGER,
    NonViralImpressions INTEGER,
    NonViralReach INTEGER,
    PostActivity INTEGER,
    PostActivityUnique INTEGER,
    PostClicks INTEGER,
    UniquePostClicks INTEGER,
    PostReactionsAnger INTEGER,
    PostReactionsHaha INTEGER,
    PostReactionsLike INTEGER,
    PostReactionsLove INTEGER,
    PostReactionsSorry INTEGER,
    PostReactionsWow INTEGER,
    Reach INTEGER
);

SHOW Tables;
