import pandas as pd
import numpy as np

colList = ["alpha2", "English"]
dfISO = pd.read_csv("C:\\docker356\\project\\scripts\\languageCodes.csv", sep=",", usecols=colList)
dfISO = dfISO.rename(columns = {"alpha2" : "ISO"})
print(dfISO)

colList = ["tmdbID", "language1", "language2", "language3", "language4"]

dfTMDB = pd.read_csv("C:\\docker356\\project\\MovieLanguageTMDB.csv", sep=",", usecols=colList)

dfL1 = dfTMDB.merge(dfISO, left_on="language1", right_on="ISO")
dfL2 = dfTMDB.merge(dfISO, left_on="language2", right_on="ISO")
dfL3 = dfTMDB.merge(dfISO, left_on="language3", right_on="ISO")
dfL4 = dfTMDB.merge(dfISO, left_on="language4", right_on="ISO")

dfL1 = dfL1.drop(["language1", "language2", "language3", "language4", "ISO"], axis=1)
dfL1 = dfL1.rename(columns = {"English" : "Language1"})

dfL2 = dfL2.drop(["language1", "language2", "language3", "language4", "ISO"], axis=1)
dfL2 = dfL2.rename(columns = {"English" : "Language2"})

dfL3 = dfL3.drop(["language1", "language2", "language3", "language4", "ISO"], axis=1)
dfL3 = dfL3.rename(columns = {"English" : "Language3"})

dfL4 = dfL4.drop(["language1", "language2", "language3", "language4", "ISO"], axis=1)
dfL4 = dfL4.rename(columns = {"English" : "Language4"})

df = dfL1
df = df.merge(dfL2, left_on="tmdbID", right_on="tmdbID", how="outer")
df = df.merge(dfL3, left_on="tmdbID", right_on="tmdbID", how="outer")
df = df.merge(dfL4, left_on="tmdbID", right_on="tmdbID", how="outer")

df.to_csv("C:\\docker356\\project\\MovieLanguageTMDBFixed.csv", sep=",")
#print(dfTMDB)
