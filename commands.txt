-- Load in schema
\i schema.ddl 
-- Populate tables with sample data
\COPY Country from data/phase3/country.csv with csv
\COPY Individual from data/phase3/individual.csv with csv
\COPY Personality from data/phase3/personality.csv with csv
\COPY Happiness from data/phase3/happiness.csv with csv