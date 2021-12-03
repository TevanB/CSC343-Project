-- Standard three lines
drop schema if exists projectschema cascade;
create schema projectschema;
set search_path to projectschema;

-- For Cathy
-- Schema Info taken from Phase 1 Report
-- Consider using real vs double precision (cannot find a better data type for float between 0-1)
-- Check out TA comment from Phase 1 Justification annotation and change the relation design if you want
-- We had an IC from personality country to happiness country but theres no country inside personality? i removed the IC for now from personality schema

-- A country in the world with basic information. 
-- country_name is the name of the country in English
-- gdp is the gross domestic product (GDP) per capita (country's GDP divided by its total population)
-- birth_rate is the birth rate in each country

create table Country(
    country_name varchar(30) primary key,
    gdp double precision NOT NULL,
    birth_rate double precision NOT NULL
);

-- The happiness score and related statistics to happiness for each country. 
-- country_name is the name of the country in English
-- happiness_score is the numerical score that reflects the happiness measure of each country based on poll answers to the main life evaluation questions
-- gdp is the extent to which gross domestic product (GDP) contributes to the calculation of the happiness score the country
-- family is the extent to which family contributes to the calculation of the happiness the country

create table Happiness(
    country_name varchar(30) primary key,
    happiness_score double precision NOT NULL,
    gdp double precision NOT NULL,
    family double precision NOT NULL
    -- foreign key (country_name) references Country
);

-- An individual that participated in the personality survey.  
-- pID is the unique ID of the individual whose personality traits are measured, 
-- country_name is the country the individual is from
-- age is the age of the individual
-- sex is the biological sex of the individual (1 = male, 2 = female)

create table Individual(
    pID integer primary key,
    country_name varchar(30) NOT NULL,
    age integer NOT NULL,
    sex integer NOT NULL
    -- foreign key (country_name) references Country
);

-- The personality scores in each category for each individual. 
-- openness is the measure of the individual’s openness to a variety of new experiences
-- conscientious is the measure of the individual’s tendency to display self-discipline
-- extraversion is the measure of how much the individual's energy creation is from external means
-- agreeableness is the measure of how well the individual gets along with other people
-- neuroticism is hte measure of the individual’s stability and their tendency to experience negative emotions

create table Personality(
    pID integer primary key,
    openness double precision NOT NULL,
    conscientious double precision NOT NULL,
    extraversion double precision NOT NULL,
    agreeableness double precision NOT NULL,
    neuroticism double precision NOT NULL
    -- foreign key (pID) references Individual
);

