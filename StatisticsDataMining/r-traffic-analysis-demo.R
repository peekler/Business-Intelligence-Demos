# CSV fajl betoltese
traffic <- read.csv("GY-call-log-csv.csv", header=TRUE, sep=",")
# a beolvasott adat egy data.frame tipusu valtozo
# minden oszlop a nevevel indexelheto, es sajat tipusa van (mintavetel alapjan)
# pl. a UserGender oszlop a traffic$UserGender kifejezessel elheto el, es factor tipusu

# hany elofizetorol van adat
elofizetok_szama <- length( unique(traffic$UserID) )

# ferfiak vagy a nok telefonalnak tobbet
# szurjuk le a rekordokat a nemekre a subset fuggvennyel
hivasok_ffi <- subset(traffic, UserGender=='M' & Type=='V')
hivasok_no <- subset(traffic, UserGender=='F' & Type=='V')
# vegyuk az atlagat a szurt rekordokbol a Length erteknek
atlag_ffi <- mean( hivasok_ffi$Length )
atlag_no <- mean( hivasok_no$Length )
# szurjuk ki az outliereket, a felso es also 5%-ot, ehhey szamoljuk ki a szorast
sd_ffi <- sd(hivasok_ffi$Length)
sd_no <- sd(hivasok_ffi$Length)
# az atlagtol ketszeres szorasnal hosszabb hivasokat szurjuk ki
hivasok_ffi_szurt <- subset( hivasok_ffi, Length < atlag_ffi + 2*sd_ffi )
hivasok_no_szurt <- subset( hivasok_no, Length < atlag_no + 2*sd_no )
# szamoljuk ki igy a leghosszabb hivasokat
leghosszabb_ffi <- max(hivasok_ffi_szurt$Length)
leghosszabb_no <- max(hivasok_no_szurt$Length)

# mas modszer a szuresre: kvantilis hasznalataval
# https://www.mathsisfun.com/data/quartiles.html
qnt <- quantile(hivasok_ffi$Length, probs=c(.95))
H <- 1.5 * IQR(hivasok_ffi$Length)
leghosszabb_ffi <- max(subset(hivasok_ffi, Length < qnt[1] + H)$Length)