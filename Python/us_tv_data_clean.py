
import pandas as pd
import math
import re
import csv


### step 1: xlsx saved as csv ###
# in excel #

### step 2: only keep the data with clearance = 'cleared' ###

data = pd.read_csv("2014_2015 Ancestry US Master Spot Log FINANCE2.csv")
data_useful = data[["Property", "Length", "Full Rate", "Rate", " Imps (000) ", "Date", "Time",
"Clearance", "Network", "Uniform Network", "ISCI", "ISCI Adjusted", "Creative Title"]]

### step 3: split data into commercial and wdytya, using "wdytya" in "property" ###

### step 4: 



data['Length'] = [i if i in [':15', ':20', ':30'] else 'unknown' for i in data['Length']]
data['Full Rate'] = [i if not math.isnan(i) else -1 for i in data['Full Rate']]

data['Imps (000)'] = [re.sub(r"[, ]+", "", i) if type(i) == str else i for i in data['Imps (000)']]
data['Imps (000)'] = [re.sub(r"-", "-1", i) if type(i) == str else i for i in data['Imps (000)']]
data['Imps (000)'] = [float(i) if type(i) == str and len(i) > 0 else -1 for i in data['Imps (000)']]

data.to_csv("us_tv_cleaned.csv", quoting=csv.QUOTE_ALL, index=False)
