-- Standard three lines
drop schema if exists projectschema cascade;
create schema projectschema;
set search_path to projectschema;

-- For Cathy
-- Schema Info taken from Phase 1 Report
-- Consider using real vs double precision (cannot find a better data type for float between 0-1)
-- Check out TA comment from Phase 1 Justification annotation and change the relation design if you want
-- We had an IC from personality country to happiness country but theres no country inside personality? i removed the IC for now from personality schema

-- Our responses to TA feedback from Phase 1
-- Design decisions from Phase 1: decided to remove Individual[pID] subset Personality[piD] IC by TA reccomendation, made more sense than the latter being removed due to nature of our Individual table

create table Country(
    country varchar(20) primary key,
    gdp double precision,
    family double precision
);

create table Individual(
    pID integer primary key,
    country varchar(20),
    age integer,
    sex integer,
    foreign key (country) references Country
);

create table Happiness(
    country varchar(20) primary key,
    happiness_score double precision,
    foreign key (country) references Country
);

create table Personality(
    pID integer primary key,
    openness double precision,
    conscientious double precision,
    extraversion double precision,
    agreeableness double precision,
    neuroticism double precision,
    foreign key (pID) references Individual
);

