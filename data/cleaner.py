import pandas as pd
import numpy as np

# Sample data
# bfd_src = 'phase1_sample_data/big_five_data.csv'
# whr_src = 'phase1_sample_data/world_happiness_report.csv'
# cotw_src = 'phase1_sample_data/country_info_data.csv'

# Actual data
bfd_src = 'big_five_scores.csv'
whr_src = 'happiness_scores.csv'
cotw_src = 'countries_info.csv'


# Helper Functions
def str_comma_to_decimal(s):
    if type(s) is str and ',' in s:
        return float(s.replace(',', '.'))


def drop_end_space(s):
    return s[:-1]


def country_format(str):
    if str == "UK":
        return "United Kingdom"
    elif str == "USA":
        return "United States"
    else:
        return str


bfd_df = pd.read_csv(bfd_src)
whr_df = pd.read_csv(whr_src)
cotw_df = pd.read_csv(cotw_src)

#convert cotw_df commas to period in birth rate

cotw_df["Birthrate"] = cotw_df["Birthrate"].apply(str_comma_to_decimal)
cotw_df["Country"] = cotw_df["Country"].apply(drop_end_space)
# print(len(cotw_df["Country"][1]), cotw_df["Country"][1][-1])

bfd_df["country"] = bfd_df["country"].apply(country_format)

country_df = cotw_df
country_df.rename(columns={
    "Country": "country_name",
    "GDP ($ per capita)": "gdp",
    "Birthrate": "birth_rate"
},
                  inplace=True)
country_df.drop([
    "Region", "Population", "Area (sq. mi.)", "Pop. Density (per sq. mi.)",
    "Coastline (coast/area ratio)", "Net migration",
    "Infant mortality (per 1000 births)", "Literacy (%)", "Phones (per 1000)",
    "Arable (%)", "Crops (%)", "Other (%)", "Climate", "Deathrate",
    "Agriculture", "Industry", "Service"
],
                inplace=True,
                axis=1)
country_df.reset_index(drop=True, inplace=True)
# country_df.to_csv('phase2/country.csv', index=False, header=False)
# country_df.to_csv('phase3/country.csv', index=False, header=False)

happiness_df = whr_df
happiness_df.rename(columns={
    "Country": "country_name",
    "Happiness Score": "happiness_score",
    "Economy (GDP per Capita)": "gdp",
    "Family": "family"
},
                    inplace=True)
happiness_df.drop([
    "Region", "Happiness Rank", "Standard Error", "Health (Life Expectancy)",
    "Freedom", "Trust (Government Corruption)", "Generosity",
    "Dystopia Residual"
],
                  inplace=True,
                  axis=1)
happiness_df.reset_index(drop=True, inplace=True)
# happiness_df.to_csv('phase2/happiness.csv', index=False, header=False)
happiness_df.to_csv('phase3/happiness.csv', index=False, header=False)

individual_df = bfd_df
individual_df.rename(columns={
    "case_id": "pID",
    "country_name": "country"
},
                     inplace=True)
individual_df.drop([
    "extraversion_score", "conscientiousness_score", "neuroticism_score",
    "openness_score", "agreeable_score"
],
                   inplace=True,
                   axis=1)

individual_df.replace('', np.nan, inplace=True)
individual_df.dropna(inplace=True)
individual_df.reset_index(drop=True, inplace=True)

individual_df = individual_df[individual_df.country != 'Yugoslavia']
# individual_df.to_csv('phase2/individual.csv', index=False, header=False)
individual_df.to_csv('phase3/individual.csv', index=False, header=False)

bfd_df = pd.read_csv(bfd_src)

personality_df = bfd_df
personality_df.rename(columns={
    "case_id": "pID",
    "extraversion_score": "extraversion",
    "extraversion_score": "openness",
    "conscientiousness_score": "conscientious",
    "neuroticism_score": "neuroticism"
},
                      inplace=True)
personality_df.drop(["country", "age", "sex"], inplace=True, axis=1)
personality_df.reset_index(drop=True, inplace=True)
# personality_df.to_csv('phase2/personality.csv', index=False, header=False)
personality_df.to_csv('phase3/personality.csv', index=False, header=False)
#print(whr_df.head())