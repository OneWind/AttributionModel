import pandas as pd
import time
from datetime import datetime, timedelta
from pytz import timezone
from collections import defaultdict

###############################################################################
######### concatenate date and time, and then conver time to MST  #############
###############################################################################

data = pd.read_csv('/Users/fyi/Desktop/UK-TV/UKTV_2014Jan_2015Jun.csv',header=None)

def toMST(x):
    datetime_obj_naive = datetime.strptime(x, '%m/%d/%Y %H:%M:%S')
    datetime_obj_london = timezone('Europe/London').localize(datetime_obj_naive)
    datetime_obj_mst = datetime_obj_london.astimezone(timezone('US/Mountain'))
    return datetime_obj_mst.strftime('%Y-%m-%d %H:%M:%S')
    

data.columns = [str(i) for i in range(data.shape[1])]

data['1'] = data['1'].apply(lambda x: x+":00")
data['0'] = data['0'].apply(lambda x: x[3:6] + x[:3] + x[6:])
data['20'] = data['0'] + ' ' + data['1']
data['21'] = data['20'].apply(lambda x: toMST(x))


#data.drop('20', axis=1, inplace=True)

cols = data.columns.tolist()
cols = cols[-1:] + cols[:-1]
data = data[cols]

data.to_csv('/Users/fyi/Desktop/UK-TV/UKTV_2014Jan_2015Jun_MST.csv', header=False, index=False, quoting=1)


###############################################################################
################   tv data 5 minutes forward populated    #####################
###############################################################################

tvdata = pd.read_csv('/Users/fyi/Desktop/UK-TV/UKTV_2014Jan_2015Jun_MST.csv', header=None)

min_date = timezone('Europe/London').localize(datetime.strptime('2014-01-01 00:00:00', "%Y-%m-%d %H:%M:%S"))
min_date_mst = min_date.astimezone(timezone('US/Mountain'))
max_date = timezone('Europe/London').localize(datetime.strptime('2015-06-30 23:59:00', "%Y-%m-%d %H:%M:%S"))
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


def tvdataPopulate(tvdata, cols, all_minutes):
    segment_data = tvdata[cols]
    segment_data.columns = ['timemst', 'segment']
    segment_data_populated = pd.DataFrame(all_minutes)
    segment_data_populated.columns = ['timemst']
    segment = list(set(segment_data['segment']))
    segment.sort()

    segment_dict = dict((k, defaultdict(int)) for k in segment)
    for i in range(segment_data.shape[0]):
        if (i % 50000 == 0):
            print "This is iteration: " + str(i)
        i_time_str = segment_data['timemst'][i]
        i_time = timezone('US/Mountain').localize(datetime.strptime(i_time_str, "%Y-%m-%d %H:%M:%S"))
        i_segment = segment_data['segment'][i]
        time_list = [i_time_str]
        for j in range(4):
            i_time += step
            if (i_time <= max_date_mst):
                time_list.append(i_time.strftime("%Y-%m-%d %H:%M:%S"))
        for time_str in time_list:
            segment_dict[i_segment][time_str] +=1

    for key, value in segment_dict.iteritems():
        new_list = []
        for k, v in value.iteritems():
            tmp = [k, v]
            new_list.append(tmp)
        new_df = pd.DataFrame(new_list, columns=['timemst', key])
        segment_data_populated = segment_data_populated.merge(new_df, how='left', on='timemst')

    segment_data_populated = segment_data_populated.fillna(0)
    segment_data_populated[segment_data_populated.columns[1:]] = \
    segment_data_populated[segment_data_populated.columns[1:]].astype(int)
    return(segment_data_populated)

tv_platform = tvdataPopulate(tvdata, platform_cols, all_minutes)
tv_saleshouse = tvdataPopulate(tvdata, saleshouse_cols, all_minutes)
tv_length = tvdataPopulate(tvdata, length_cols, all_minutes)
tv_creative = tvdataPopulate(tvdata, creative_cols, all_minutes)

tv_data_populated = tv_platform.merge(tv_saleshouse, on="timemst").\
merge(tv_length, on='timemst').merge(tv_creative, on='timemst')

tv_data_populated.to_csv("UKTV_2014Jan_2015Jun_Populated.csv", index=False, header=True)





###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################
###############################################################################

### the following codes are very very slow ###

saleshouse_data = tvdata[saleshouse_cols]
saleshouse_data_populated = pd.DataFrame(all_minutes)
saleshouse_data_populated.columns = ['timemst']
saleshouse = list(set(tvdata[8]))
saleshouse.sort()


saleshouse_dict = dict((k, defaultdict(int)) for k in saleshouse)
for i in range(saleshouse_data.shape[0]):
    if (i % 10000 == 0):
        print "This is iteration: " + str(i)
    i_time_str = saleshouse_data[0][i]
    i_time = timezone('US/Mountain').localize(datetime.strptime(i_time_str, "%Y-%m-%d %H:%M:%S"))
    i_saleshouse = saleshouse_data[8][i]
    time_list = [i_time_str]
    for j in range(4):
        i_time += step
        if (i_time <= max_date_mst):
            time_list.append(i_time.strftime("%Y-%m-%d %H:%M:%S"))
    for time_str in time_list:
        saleshouse_dict[i_saleshouse][time_str] +=1

for key, value in saleshouse_dict.iteritems():
    new_list = []
    for k, v in value.iteritems():
        tmp = [k, v]
        new_list.append(tmp)
    new_df = pd.DataFrame(new_list, columns=['timemst', key])
    saleshouse_data_populated = saleshouse_data_populated.merge(new_df, how='left', on='timemst')

saleshouse_data_populated = saleshouse_data_populated.fillna(0)

###############################################################################
###############################################################################
###############################################################################

for i in range(saleshouse_data.shape[0]):
    if (i % 100 == 0):
        print "this is iteration: " + str(i)
    i_time_str = saleshouse_data[0][i]
    t1 = time.localtime()
    i_time = timezone('US/Mountain').localize(datetime.strptime(i_time_str, "%Y-%m-%d %H:%M:%S"))
    t2 = time.localtime()
    i_saleshouse = saleshouse_data[8][i]
    t3 = time.localtime()
    time_list = [i_time_str]
    t4 = time.localtime()
    for j in range(4):
        i_time += step
        if (i_time <= max_date_mst):
            time_list.append(i_time.strftime("%Y-%m-%d %H:%M:%S"))
    t5 = time.localtime()
    saleshouse_data_populated.loc[saleshouse_data_populated["timemst"] in time_list, i_saleshouse] += 1
    for time_str in time_list:
        saleshouse_data_populated[i_saleshouse][time_str] += 1
    t6 = time.localtime()
