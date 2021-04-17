import pandas as pd
import numpy as np

colList = ["tmdbID", "rating"]
df = pd.read_csv("C:\\docker356\\project\\UserRatings.csv", sep=",", usecols=colList)

df1 = df.groupby("tmdbID").count()
df2 = df.groupby("tmdbID").mean()
df3 = df.groupby("tmdbID").median()

df1 = df1.rename(columns = {"rating" : "totalVotes"})
df2 = df2.rename(columns = {"rating" : "meanVote"})
df3 = df3.rename(columns = {"rating" : "medianVote"})

frames = [df1, df2, df3]

dfOut = pd.concat(frames, axis=1)
print(dfOut)

dfOut.to_csv("C:\\docker356\\project\\UserRatingsAggregated.csv", sep=",")


