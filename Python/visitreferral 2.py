import pandas as pd
import re
from collections import Counter


data = pd.read_csv("externalRef2015.csv", header=None, error_bad_lines=False)

ref = list(data.ix[:, 0])

ref_counter = Counter()
unmatched = list()
for i in xrange(len(ref)):
    if type(ref[i]) is str:
        m = re.match(r"[a-z]+://([a-zA-Z0-9._%\-]+)[?:/]", ref[i])
        m1 = re.match(r"[a-z]+://([a-zA-Z0-9._%\-]+)$", ref[i])
        m2 = re.match(r"([a-zA-Z0-9._%\-]+)$", ref[i])
        m3 = re.search(r"googleads.g.doubleclick.net", ref[i])
        if m is not None:
            ref_counter[m.group(1)] += 1
        elif m1 is not None:
            ref_counter[m1.group(1)] += 1
        elif m2 is not None:
            ref_counter[m2.group(1)] += 1
        elif m3 is not None:
            ref_counter["googleads.g.doubleclick.net"] += 1
        else:
            ref_counter["unmatched"] += 1
            unmatched.append(ref[i])

print len(ref)
print sum([v for v in ref_counter.viewvalues()])

print ref_counter.most_common(10)
print unmatched[:10]

top_ref_list = [[key, value] for (key, value) in ref_counter.most_common(50)]
top_ref = pd.DataFrame(top_ref_list, columns=["site", "counts"], index=[i+1 for i in range(50)])
print top_ref

###########################################################
###                                  site  counts       ###
###  1                     my.xfinity.com  831337       ###
###  2      surnames.meaning-of-names.com  243925       ###
###  3               www.deathindexes.com  231521       ###
###  4                     search.aol.com  168605       ###
###  5                xfinity.comcast.net  163101       ###
###  6        ancestryforums.custhelp.com  116945       ###
###  7              secure.shopathome.com  115361       ###
###  8         search.ancestrylibrary.com  109801       ###
###  9         www.searchforancestors.com  104791       ###
###  10                   trc.taboola.com   88875       ###
###  11                 paid.outbrain.com   88398       ###
###  12             ancestry.mycanvas.com   88206       ###
###  13               boards.rootsweb.com   85789       ###
###  14                www.cyndislist.com   68380       ###
###  15           www.ancestrylibrary.com   64896       ###
###  16                    duckduckgo.com   62089       ###
###  17      ancestrylibrary.proquest.com   61060       ###
###  18              www.censusfinder.com   60752       ###
###  19  search.ancestryheritagequest.com   60157       ###
###  20                     192.168.64.25   53087       ###
###########################################################


ref_counter = Counter()
unmatched = list()

with open("internalRef2015.csv", "r") as f:
#with open("internalRef2015test.csv", "r") as f:
    for line in f:
        tmp = [x[1:-1] for x in line.strip().split(",")]
        ref = tmp[0]
        m = re.match(r"[a-z]+://([a-zA-Z0-9._%\-]+)[?:/]", ref)
        m1 = re.match(r"[a-z]+://([a-zA-Z0-9._%\-]+)$", ref)
        m2 = re.match(r"([a-zA-Z0-9._%\-]+)$", ref)
        if m is not None:
            ref_counter[m.group(1)] += 1
        elif m1 is not None:
            ref_counter[m1.group(1)] += 1
        elif m2 is not None:
            ref_counter[m2.group(1)] += 1
        else:
            ref_counter["unmatched"] += 1
            unmatched.append(ref)
print len(ref)
print sum([v for v in ref_counter.viewvalues()])

print unmatched[:10]

top_ref_list = [[key, value] for (key, value) in ref_counter.most_common(20)]
top_ref = pd.DataFrame(top_ref_list, columns=["site", "counts"], index=[i+1 for i in range(20)])
print top_ref


######################################################################
###                                           site    counts       ###
###  1                          trees.ancestry.com  16000248       ###
###  2                         search.ancestry.com   9189213       ###
###  3                             sm.ancestry.com   4398744       ###
###  4                           home.ancestry.com   2346486       ###
###  5                            www.ancestry.com   1782681       ###
###  6                            dna.ancestry.com    933516       ###
###  7                         person.ancestry.com    655304       ###
###  8                         secure.ancestry.com    529803       ###
###  9                          blogs.ancestry.com    521539       ###
###  10                       connect.ancestry.com    490203       ###
###  11                          wiz2.ancestry.com    487905       ###
###  12                   wc.rootsweb.ancestry.com    335488       ###
###  13                        boards.ancestry.com    314210       ###
###  14                    www.familytreemaker.com    291438       ###
###  15                         hints.ancestry.com    252968       ###
###  16                     community.ancestry.com    213963       ###
###  17  freepages.genealogy.rootsweb.ancestry.com    212002       ###
###  18                   interactive.ancestry.com    209899       ###
###  19                  www.rootsweb.ancestry.com    209019       ###
###  20                       records.ancestry.com    179960       ###
######################################################################


ref_counter = Counter()
unmatched = list()

with open("directnohp2015.csv", "r") as f:
#with open("internalRef2015test.csv", "r") as f:
    for line in f:
        tmp = [x[1:-1] for x in line.strip().split(",")]
        ref = tmp[0]
        m = re.match(r"[a-z]+://([a-zA-Z0-9._%\-]+)[?:/]", ref)
        m1 = re.match(r"[a-z]+://([a-zA-Z0-9._%\-]+)$", ref)
        m2 = re.match(r"([a-zA-Z0-9._%\-]+)$", ref)
        if m is not None:
            ref_counter[m.group(1)] += 1
        elif m1 is not None:
            ref_counter[m1.group(1)] += 1
        elif m2 is not None:
            ref_counter[m2.group(1)] += 1
        else:
            ref_counter["unmatched"] += 1
            unmatched.append(ref)
f.close()
print len(ref)
print sum([v for v in ref_counter.viewvalues()])

print unmatched[:10]

top_ref_list = [[key, value] for (key, value) in ref_counter.most_common(50)]
top_ref = pd.DataFrame(top_ref_list, columns=["site", "counts"], index=[i+1 for i in range(50)])
print top_ref
