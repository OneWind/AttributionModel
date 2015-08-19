import pandas as pd
import re
from collections import Counter


data = pd.read_csv("externalRef2015.csv", header=None, error_bad_lines=False)

ref = list(data.ix[:, 0])

ref_counter = Counter()
unmatched = list()
tmp = list()
for i in xrange(len(ref)):
    if type(ref[i]) is str:
        m = re.match(r"[a-z]+://([a-zA-Z0-9.\-]+)/", ref[i])
        if m is not None:
            ref_counter[m.group(1)] += 1
        else:
            m2 = re.match(r"googleads.g.doubleclick.net", ref[i])
            if m2 is not None:
                ref_counter["googleads.g.doubleclick.net"] += 1
                tmp.append(ref[i])
            else:
                ref_counter["unmatched"] += 1
                unmatched.append(ref[i])

print len(ref)
print sum([v for v in ref_counter.viewvalues()])

ref_counter.most_common(10)

[('paid.outbrain.com', 1121440),
 ('my.xfinity.com', 831337),
 ('surnames.meaning-of-names.com', 574865),
 ('www.deathindexes.com', 442462),
 ('trc.taboola.com', 440869),
 ('search.aol.com', 385688),
 ('xfinity.comcast.net', 308424),
 ('search.ancestrylibrary.com', 277075),
 ('ancestryforums.custhelp.com', 241882),
 ('unmatched', 234842),
 ('ancestry.mycanvas.com', 228951),
 ('www.searchforancestors.com', 228399),
 ('ident.familysearch.org', 221640),
 ('www.cyndislist.com', 175666),
 ('www.censusfinder.com', 175594),
 ('boards.rootsweb.com', 113480),
 ('www.ancestrylibrary.com', 102883),
 ('thehuffingtonpost.trc.taboola.com', 102243),
 ('search.ancestryinstitution.com', 99358),
 ('secure.shopathome.com', 97128)]
