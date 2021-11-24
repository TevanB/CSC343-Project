import pandas as pd 
import numpy as np 

bfd_src = 'phase1/big_five_data.csv'
whr_src = 'phase1/world_health_report.csv'

bfd_df = pd.read_csv(bfd_src)
whr_df = pd.read_csv(whr_src)



country_df = None
individual_df = None
happiness_df = None 
personality_df = bfd_df
personality_df.rename(columns={"case_id": "pID","extraversion_score": "extraversion", "openness_score":"openness", "conscientiousness_score": "conscientious", "neuroticism_score":"neuroticism"}, inplace=True)
personality_df.drop(["country", "age", "sex"], inplace=True, axis=1)
personality_df.reset_index(drop=True, inplace=True)
personality_df.to_csv('phase1/personality.csv')
print(personality_df.head())
#print(whr_df.head())