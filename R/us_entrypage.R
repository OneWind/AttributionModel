query <- "select * from a.feng_us_unique_entrypagename"

entrypage <- sqlQuery(.dwMatrix, query=query)
entrypage$entrypagenamedescription <- as.character(entrypage$entrypagenamedescription)
entrypage <- entrypage[order(entrypage$cnt, decreasing=T), ]

entrypage.splited <- strsplit(entrypage$entrypagenamedescription, "[:]")
first <- sort(unique(sapply(entrypage.splited, function(x) x[1])))
second <- sort(unique(sapply(entrypage.splited, function(x) x[2])))
