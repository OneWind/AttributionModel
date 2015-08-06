import time
from datetime import datetime, timedelta
from pytz import timezone


f = open('/Users/fyi/Desktop/UK-TV/ukfactvisitstest.csv')
g = open('/Users/fyi/Desktop/Uk-TV/uktvtest.csv')

h = open('/Users/fyi/Desktop/UK-TV/uk_visitstv.csv', 'w')

min_date = timezone('Europe/London').localize(datetime.strptime('2014-01-01 00:00:00', "%Y-%m-%d %H:%M:%S"))

g_line = g.readline()
g_time = timezone('US/Mountain').localize(datetime.strptime(g_line.split(",")[0][1:-1], "%Y-%m-%d %H:%M:%S"))
g_length = int(g_line.split(",")[13][1:-1])

def subline(line):
    tmp = line.strip().split(",")
    return ",".join(tmp[0:3] + tmp[7:9] + [tmp[13]] + [tmp[16]] + tmp[19:21])
    
g_newline = subline(g_line)

for line in f:
    f_line = line.strip()
    f_time = timezone('US/Mountain').localize(datetime.strptime(f_line.split(",")[0][1:-1], "%Y-%m-%d %H:%M:%S"))
    td = (f_time - g_time).total_secounds()
    if td > g_length and (f_time - g_time).total_seconds() <= 300:
        f_line = f_line + "," + subline(g_line)
