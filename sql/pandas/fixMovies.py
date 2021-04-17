import pandas as pd
import numpy as np

dfIMDB = pd.read_csv("C:\\docker356\\project\\MoviesIMDBFixed.csv", sep=",")
dfTMDB = pd.read_csv("C:\\docker356\\project\\MoviesTMDB.csv", sep=",")
dfLinks = pd.read_csv("C:\\docker356\\project\\links.csv", sep=",")

dfMerge1 = dfIMDB.merge(dfLinks, on="imdbID", how="left")
dfMerge1 = dfMerge1.drop("movieId", axis=1)

dfMerge2 = dfTMDB.merge(dfLinks, on="tmdbID", how="left")
dfMerge2 = dfMerge2.drop("movieId", axis=1)

dataFrames = [dfMerge1, dfMerge2]

dfAppend = dfMerge1.append(dfMerge2)

dfAppend["imdbID"] = dfAppend["imdbID"].astype("Int64")
dfAppend["tmdbID"] = dfAppend["tmdbID"].astype("Int64")

subset = ["imdbID", "tmdbID"]



dfAppend = dfAppend.drop_duplicates(subset=subset)
print(dfAppend)

dfAppend.to_csv("C:\\docker356\\project\\AllMovies.csv", sep=",")