# CSV fajl betoltese
traffic <- read.csv("GY-call-log-csv.csv", header=TRUE, sep=",")

# hivasok kivalogatasa, elofizetonkenti osszegzes
calls_all <- subset(traffic, Type=='V')
calls_sum_customer <- aggregate(Length ~ UserID, calls_all, sum)
colnames(calls_sum_customer)[2]<-'Voice' # oszlopnev beallitasa

# sms-ek kivalogatasa, elifizetonkenti darabszam osszegzes
sms_all <- subset(traffic, Type=='T')
sms_all$Length <- 1 # NA ertekek lecserelese (maskulonben az aggregalas nem mukodik)
sms_sum_customer <- aggregate(Length ~ UserID, sms_all, length)
colnames(sms_sum_customer)[2]<-'Text' # oszlopnev beallitasa

# adatforgalmazasok kivalogatasa, elofizetonkenti osszegzes
data_all <- subset(traffic, Type=='D')
data_sum_customer <- aggregate(Length ~ UserID, data_all, sum)
colnames(data_sum_customer)[2]<-'Data' # oszlopnev beallitasa

# a harom adathalmaz osszefesulese egybe, az elofizeto azonositoja alapjan
data <- merge(calls_sum_customer, merge(sms_sum_customer, data_sum_customer))

# mentes CSV-be
write.csv(data, "GY-traffic-aggregate-csv.csv", quote=FALSE, row.names=FALSE)