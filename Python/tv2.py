import pandas as pd
import time
from datetime import datetime, timedelta
from pytz import timezone
from collections import defaultdict

###############################################################################
####### first use awk to duplicate each row for 5 times in terminal ###########
# awk '{for (i=0; i<5; i++) print}' UKTV_2014Jan_2015Jun_MST.csv > UKTV_2014Jan_2015Jun_MST_repeat.csv
###############################################################################


tvdata = pd.read_csv('/Users/fyi/Desktop/UK-TV/UKTV_2014Jan_2015Jun_MST_repeat.csv', header=None)
tvtime = [timezone('US/Mountain').localize(datetime.strptime(tm, "%Y-%m-%d %H:%M:%S")) for tm in tvdata[0]]
step = timedelta(minutes = 1)
steps = [step*i for i in range(5)] * (tvdata.shape[0] / 5)
newtvtime = [(tvtime[i] + steps[i]).strftime("%Y-%m-%d %H:%M:%S") for i in range(tvdata.shape[0])]
tvdata[0] = pd.Series(newtvtime)
tvdata.to_csv('/Users/fyi/Desktop/UK-TV/UKTV_2014Jan_2015Jun_MST_expand.csv', index=False, header=False)

###############################################################################
###############################################################################
########################## very slow do not run ###############################
###############################################################################
###############################################################################


tvdata = pd.read_csv('/Users/fyi/Desktop/UK-TV/UKTV_2014Jan_2015May_MST.csv', header=None)
tvdata[21] = pd.Series([timezone('US/Mountain').localize(datetime.strptime(tm, "%Y-%m-%d %H:%M:%S")) for tm in tvdata[0]])

min_date = timezone('Europe/London').localize(datetime.strptime('2014-01-01 00:00:00', "%Y-%m-%d %H:%M:%S"))
min_date_mst = min_date.astimezone(timezone('US/Mountain'))
max_date = timezone('Europe/London').localize(datetime.strptime('2015-05-31 23:59:00', "%Y-%m-%d %H:%M:%S"))
max_date_mst = max_date.astimezone(timezone('US/Mountain'))
step = timedelta(minutes = 1)
dt = min_date_mst
all_minutes = []
while dt <= max_date_mst:
    all_minutes.append(dt.strftime("%Y-%m-%d %H:%M:%S"))
    dt += step

platform_cols = [0, 7]
saleshouse_cols = [0, 8]
length_cols = [0, 13]
creative_cols = [0, 16]

tvdata_expand = pd.DataFrame(columns = tvdata.columns)

k = 0
for i in range(tvdata.shape[0]):
    if (i % 1000 == 0):
        print "This is iteration: " + str(i)
    tmp = tvdata.loc[i]
    tmp_time = tmp[21]
#    tmp_time = timezone('US/Mountain').localize(datetime.strptime(tmp[0], "%Y-%m-%d %H:%M:%S"))
    tvdata_expand.loc[k] = tmp
    k += 1
    for j in range(4):
        tmp_time += step
        tmp.set_value(0, tmp_time.strftime("%Y-%m-%d %H:%M:%S"))
        tvdata_expand.loc[k] = tmp
        k += 1

#tvdata_expand[21] = tvdata_expand[6] + "|" + tvdata_expand[7] + "|" + tvdata_expand[8] + "|" + \
#    tvdata_expand[9] + "|" + tvdata_expand[9] + "|" + tvdata_expand[13].map(str) + "|" + \
#    tvdata_expand[16] + "|" + tvdata_expand[19].map(str) + "|"  + tvdata_expand[20].map(str)

