-- 1. Exploring high neuroticism countries
DROP VIEW IF EXISTS CountryAverage CASCADE;
DROP VIEW IF EXISTS HighNeuroticism CASCADE;
DROP VIEW IF EXISTS HighNHappiness CASCADE;
DROP VIEW IF EXISTS HighNInfo CASCADE;

-- Average personality scores for each country
CREATE VIEW CountryAverage AS 
SELECT country_name, avg(openness) as O, avg(conscientious) as C, avg(extraversion) as E, avg(agreeableness) as A, avg(neuroticism) as N
FROM Individual, Personality
WHERE Individual.pID = Personality.pID
GROUP BY Individual.country_name;

-- Countries with an average neuroticism score higher than median
CREATE VIEW HighNeuroticism AS 
SELECT country_name, N
FROM CountryAverage
WHERE N > (SELECT PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY N) FROM CountryAverage)
ORDER BY N DESC;

-- Happiness scores for countries with a high average neuroticism score
CREATE VIEW HighNHappiness AS 
SELECT Happiness.country_name, N, happiness_score
FROM Happiness, HighNeuroticism
WHERE Happiness.country_name = HighNeuroticism.country_name
ORDER BY N DESC;

-- GDP & birth rate of countries with high neuroticism
CREATE VIEW HighNInfo AS 
SELECT Country.country_name, N, gdp, birth_rate
FROM Country, HighNeuroticism
WHERE Country.country_name = HighNeuroticism.country_name
ORDER BY N DESC;



-- 2. Exploring sex differences on personality
DROP VIEW IF EXISTS MaleAvg CASCADE;
DROP VIEW IF EXISTS FemaleAvg CASCADE;
DROP VIEW IF EXISTS HighBirth CASCADE;
DROP VIEW IF EXISTS HighBMale CASCADE;
DROP VIEW IF EXISTS HighBFemale CASCADE;

-- Average personality trait scores for all males
CREATE VIEW MaleAvg AS
SELECT avg(openness) as O, avg(conscientious) as C, avg(extraversion) as E, avg(agreeableness) as A, avg(neuroticism) as N
FROM Personality, Individual
WHERE Personality.pID = Individual.pID and sex = 1;

-- Average personality trait scores for all females
CREATE VIEW FemaleAvg AS
SELECT avg(openness) as O, avg(conscientious) as C, avg(extraversion) as E, avg(agreeableness) as A, avg(neuroticism) as N
FROM Personality, Individual
WHERE Personality.pID = Individual.pID and sex = 2;
-- openness, conscientious, extraversion, agreeableness, neuroticism

-- Countries with high birth rate
CREATE VIEW HighBirth AS 
SELECT country_name, birth_rate
FROM Country
WHERE birth_rate > (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY birth_rate) FROM Country)
ORDER BY birth_rate DESC;

-- Average personality trait scores for all males in countries with high birth rate
CREATE VIEW HighBMale AS 
SELECT avg(openness) as O, avg(conscientious) as C, avg(extraversion) as E, avg(agreeableness) as A, avg(neuroticism) as N
FROM HighBirth, Personality, Individual
WHERE Personality.pID = Individual.pID and sex = 1 and
HighBirth.country_name = Individual.country_name;

-- Average personality trait scores for all females in countries with high birth rate
CREATE VIEW HighBFemale AS 
SELECT avg(openness) as O, avg(conscientious) as C, avg(extraversion) as E, avg(agreeableness) as A, avg(neuroticism) as N
FROM HighBirth, Personality, Individual
WHERE Personality.pID = Individual.pID and sex = 2 and
HighBirth.country_name = Individual.country_name;



