data <- read.csv("\\\\CLBIT03SQLD101A\\Matrix\\Load\\Feng\\CAstates.csv")
write.csv(data, file="CAstates.csv", quote=T, row.names=F)


tmp <- read.csv("\\\\CLBIT03SQLD101A\\Matrix\\Load\\Feng\\AUstates.csv")
write.csv(tmp, file="AUstates.csv", quote=T, row.names=F)
