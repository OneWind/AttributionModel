import pandas as pd
from collections import defaultdict
import re

data0 = pd.read_csv("/Users/fyi/Desktop/uk_visitandsignup.csv")
data1 = data0.sort(["ucdmid", "signupcreatedate", "servertimemst"])
data1.index = range(data1.shape[0])

visitPaths = defaultdict(int)

previousUCDMID = '0'
previousSUDATE = '0'
visitPathSeq = []
for i in range(data1.shape[0]):
#for i in range(10):
    if i % 10000 == 0:
        print "obs " + str(i) + " ... ..."
    if data1.ix[i]['ucdmid'] != previousUCDMID or data1.ix[i]['signupcreatedate'] != previousSUDATE:
        if len(visitPathSeq) > 0:
            visitPaths[str(visitPathSeq)] += 1
        visitPathSeq = [data1.ix[i]['subchannel']]
    else:
        visitPathSeq.append(data1.ix[i]['subchannel'])
    previousUCDMID = data1.ix[i]['ucdmid']
    previousSUDATE = data1.ix[i]['signupcreatedate']

visitPaths[str(visitPathSeq)] += 1


visitPathsTuple = [(key, visitPaths[key]) for key in visitPaths]
visitPathsTuple.sort(key=lambda x: x[1], reverse=True)



def lastNVisits(visitPathsList, N):
    visitPathsN = defaultdict(int)
    for item in visitPathsList:
        path = item[0]
        freq = item[1]
        visits = path.split(",")
        if len(visits) >= N:
            visitsCleaned = [re.sub(r"[\W]+", "", item) for item in visits]
            visitPathsN[str(visitsCleaned[-N:])] += freq
    visitPathsNTuple = [(key, visitPathsN[key]) for key in visitPathsN]
    visitPathsNTuple.sort(key=lambda x:x[1], reverse=True)
    return visitPathsNTuple


def firstNVisits(visitPathsList, N):
    visitPathsN = defaultdict(int)
    for item in visitPathsList:
        path = item[0]
        freq = item[1]
        visits = path.split(",")
        if len(visits) >= N:
            visitsCleaned = [re.sub(r"[\W]+", "", item) for item in visits]
            visitPathsN[str(visitsCleaned[:N])] += freq
    visitPathsNTuple = [(key, visitPathsN[key]) for key in visitPathsN]
    visitPathsNTuple.sort(key=lambda x:x[1], reverse=True)
    return visitPathsNTuple

def toDF(visitPathsLength, top=10, savingDir="./", name="paths.csv"):
    toList = []
    N = len(visitPathsLength[0][0].split(","))
    for item in visitPathsLength:
        path = item[0]
        freq = item[1]
        visits = [re.sub(r"[\W]+", "", item) for item in path.split(",")]
        visits.append(freq)
        toList.append(visits)
    df = pd.DataFrame(toList)
    df.columns = ["visit " + str(i+1) for i in range(N)] + ["frequency"]
    df.to_csv(savingDir + name, index=False)
    print df.iloc[:top]

visitPathsLength1 = lastNVisits(visitPathsTuple, 1)
toDF(visitPathsLength1, name="visitPathsLength1.csv")
visitPathsLength2 = lastNVisits(visitPathsTuple, 2)
toDF(visitPathsLength2, name="visitPathsLength2.csv")
visitPathsLength3 = lastNVisits(visitPathsTuple, 3)
toDF(visitPathsLength3, name="visitPathsLength3.csv")
visitPathsLength4 = lastNVisits(visitPathsTuple, 4)
toDF(visitPathsLength4, name="visitPathsLength4.csv")
visitPathsLength5 = lastNVisits(visitPathsTuple, 5)
toDF(visitPathsLength5, name="visitPathsLength5.csv")


visitPathsLength1 = firstNVisits(visitPathsTuple, 1)
toDF(visitPathsLength1, name="firstVisitPathsLength1.csv")
visitPathsLength2 = firstNVisits(visitPathsTuple, 2)
toDF(visitPathsLength2, name="firstVisitPathsLength2.csv")
visitPathsLength3 = firstNVisits(visitPathsTuple, 3)
toDF(visitPathsLength3, name="firstVisitPathsLength3.csv")
visitPathsLength4 = firstNVisits(visitPathsTuple, 4)
toDF(visitPathsLength4, name="firstVisitPathsLength4.csv")
visitPathsLength5 = firstNVisits(visitPathsTuple, 5)
toDF(visitPathsLength5, name="firstVisitPathsLength5.csv")
