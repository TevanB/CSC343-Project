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

-- 3. Exploring the mitigating effect other personality traits have on neuroticism in the case of high neuroticism
DROP VIEW IF EXISTS HighNeuroticismCountryIndiv CASCADE;
DROP VIEW IF EXISTS HighNeuroticismHappiness CASCADE;
DROP VIEW IF EXISTS HighNeuroticismAvgTraits CASCADE;
DROP VIEW IF EXISTS LowNeuroticismCountryIndiv CASCADE;
DROP VIEW IF EXISTS LowNeuroticismHappiness CASCADE;
DROP VIEW IF EXISTS LowNeuroticismAvgTraits CASCADE;
DROP VIEW IF EXISTS TraitCorrelation CASCADE;

-- Getting Individual and Country information for people with high neuroticisim (>0.7)
CREATE VIEW HighNeuroticismCountryIndiv AS 
SELECT t1.pID, t2.country_name, t1.openness, t1.conscientious, t1.extraversion, t1.agreeableness, t1.neuroticism 
FROM Personality as t1, Individual as t2
WHERE t1.pID = t2.pID and t1.neuroticism > 0.7;

-- Add Happiness score to above table (note: there is one happiness score per country)
CREATE VIEW HighNeuroticismHappiness AS 
SELECT t1.pid, t1.country_name, t1.openness, t1.conscientious, t1.extraversion, t1.agreeableness, t1.neuroticism, t2.happiness_score
FROM HighNeuroticismCountryIndiv as t1, Happiness as t2
WHERE t1.country_name = t2.country_name;

-- Get avg of each trait and happiness score for high neuroticism subset of data
CREATE VIEW HighNeuroticismAvgTraits AS 
SELECT avg(openness) as o, avg(conscientious) as c, avg(extraversion) as e, avg(agreeableness) as a, avg(neuroticism) as n, avg(happiness_score) as h 
FROM HighNeuroticismHappiness;

-- Getting Individual and Country information for people with low neuroticisim (>0.7)
CREATE VIEW LowNeuroticismCountryIndiv AS 
SELECT t1.pID, t2.country_name, t1.openness, t1.conscientious, t1.extraversion, t1.agreeableness, t1.neuroticism 
FROM Personality as t1, Individual as t2
WHERE t1.pID = t2.pID and t1.neuroticism <= 0.7;

-- Add Happiness score to above table (note: there is one happiness score per country)
CREATE VIEW LowNeuroticismHappiness AS 
SELECT t1.pid, t1.country_name, t1.openness, t1.conscientious, t1.extraversion, t1.agreeableness, t1.neuroticism, t2.happiness_score
FROM LowNeuroticismCountryIndiv as t1, Happiness as t2
WHERE t1.country_name = t2.country_name;

-- Get avg of each trait and happiness score for low neuroticism subset of data
CREATE VIEW LowNeuroticismAvgTraits AS 
SELECT avg(openness) as o, avg(conscientious) as c, avg(extraversion) as e, avg(agreeableness) as a, avg(neuroticism) as n, avg(happiness_score) as h 
FROM LowNeuroticismHappiness;

-- See general correlation of traits between High and Low Neuroticism 
CREATE VIEW TraitCorrelation AS 
SELECT (t1.o-t2.o) as o, (t1.c-t2.c) as c, (t1.e-t2.e) as e, (t1.a-t2.a) as a, (t1.n-t2.n) as n 
FROM HighNeuroticismAvgTraits as t1, LowNeuroticismAvgTraits as t2;

-- 4. Explore average happiness score for countries with average agreeableness score above average extraversion score 
--      above those with the former lower than the latter (q3 in pdf)
DROP VIEW IF EXISTS CountryIndiv CASCADE;
DROP VIEW IF EXISTS CountryHappinessTraits CASCADE;
DROP VIEW IF EXISTS AvgAgreeOverAvgExtraversion CASCADE;
DROP VIEW IF EXISTS AvgAgreeUnderAvgExtraversion CASCADE;
DROP VIEW IF EXISTS OverResults CASCADE;
DROP VIEW IF EXISTS UnderResults CASCADE;

-- Getting Individual and Country information for people with high neuroticisim (>0.7)
CREATE VIEW CountryIndiv AS 
SELECT t1.pID, t2.country_name, t1.openness, t1.conscientious, t1.extraversion, t1.agreeableness, t1.neuroticism 
FROM Personality as t1, Individual as t2
WHERE t1.pID = t2.pID and t1.neuroticism > 0.7;

-- Add Happiness score to above table (note: there is one happiness score per country)
CREATE VIEW CountryHappinessTraits AS 
SELECT t1.pid, t1.country_name, t1.openness, t1.conscientious, t1.extraversion, t1.agreeableness, t1.neuroticism, t2.happiness_score
FROM CountryIndiv as t1, Happiness as t2
WHERE t1.country_name = t2.country_name;

-- Find average agreeableness over average extraversion score by country
CREATE VIEW AvgAgreeOverAvgExtraversion AS 
SELECT avg(happiness_score) as happiness_score, country_name 
FROM CountryHappinessTraits
GROUP BY country_name
HAVING avg(agreeableness) > avg(extraversion);

-- Find average agreeableness under average extraversion score by country
CREATE VIEW AvgAgreeUnderAvgExtraversion AS 
SELECT avg(happiness_score) as happiness_score, country_name 
FROM CountryHappinessTraits
GROUP BY country_name
HAVING avg(agreeableness) < avg(extraversion);

-- Display results of over vs under above simply - display this in pdf file tomorrow!

CREATE VIEW OverResults AS
SELECT avg(happiness_score) as happiness, count(happiness_score) as count
FROM AvgAgreeOverAvgExtraversion;

CREATE VIEW UnderResults AS
SELECT avg(happiness_score) as happiness, count(happiness_score) as count
FROM AvgAgreeUnderAvgExtraversion;
