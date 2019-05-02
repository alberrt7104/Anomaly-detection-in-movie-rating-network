import time, csv
from igraph import *
c0=2
tagList = dict()
tagDict = dict()
tagSeq = 0
filename = "movies.csv"
with open(filename,encoding='UTF-8') as f:
    reader = csv.reader(f)
    for line in reader:
        if line[0].isnumeric():
            tags = line[2].split('|')
            temp = []
            for tag in tags:
                temp.append(tag)
                if tag not in tagDict:
                    tagDict[tag] =tagSeq
                    tagSeq += 1
            tagList[line[0]] = temp

userList = []
for i in range (1996, 2019):
    userList.append(dict())
filename = "ratings.csv"
with open(filename) as f:
    reader = csv.reader(f)
    for line in reader:
        if line[0].isnumeric():
            user = line[0]
            tags = tagList[line[1]]
            rate = float(line[2])
            location = time.localtime(int(line[3]))
            year = location.tm_year
            if user not in userList[year - 1996]:
                userList[year - 1996][user] = [0 for _ in range(20)]
            for tag in tags:
                userList[year - 1996][user][tagDict[tag]] += rate

graphList = []
for i in range (1996, 2019):
    graphList.append([])
    for j in range(len(tagDict)):
        graphList[i - 1996].append(dict())
y = 0
for year in userList:
    for user in year:
        m = 0
        o = 0
        for key, value in enumerate(year[user]):
            if value > m:
                m = value
                o = key
        graphList[y][o][user] = m
    y += 1

for year in range(1997, 2018):
    i = year - 1996
    for j in range(20):
        if (len(graphList[i + 1][j]) - len(graphList[i][j])) - (len(graphList[i][j]) - len(graphList[i - 1][j])) > c0:
            print(year, list(tagDict.keys())[list(tagDict.values()).index(j)], 'increase')
        elif (len(graphList[i][j]) - len(graphList[i + 1][j])) - (len(graphList[i - 1][j]) - len(graphList[i][j])) > c0:
            print(year, list(tagDict.keys())[list(tagDict.values()).index(j)], 'decrease')        
numnode=610
edge=[]
first=0
count=0
emptyv=[]
vertex=[]
for i in range(611):
    emptyv.append(i)
#print(emptyv)
#print(graphList[0][0].keys())
for k in range(23):
    for j in range(20):
        for i in graphList[k][j].keys():
            if count==0:
                first=i
                count=1
            else:
                edge.append((int(first),int(i)))            
                
                

        count=0
    edge=list(set(edge))
    vertex=list(set(vertex))
    
    g=Graph(edge,n=numnode,directed=False)
    g.vs['color']='blue'  
    # if k==0 or k==1 or k==3 or k==5 or k==10 or k==12 or k==17 or k==18:
    #     plot(g)
    plot(g)
