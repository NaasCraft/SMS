library(utils)
library(zoo)
library(timeDate)
library(forecast)
library(urca)
library(tseries)
library(fUnitRoots)
library(stats)
library(nlme)
library(mgcv)



table_init<-read.table("C:/Users/Charles/Documents/ENSAE/Séminaire de modélisation statistique/alldata_sujet1.csv", sep=",",header=TRUE)
table_init$time<-as.POSIXlt(table_init$date, format="%Y-%m-%d")
table_init$day<-weekdays(table_init$time)
table_init$month<-months(table_init$time)
table_init$heure<-as.numeric(table_init$heure)
#table_init$time<-NULL
#table_init$date<-NULL
table<-table_init[35065:96408,]
table_train<-table[1:52584,]
table_test<-table[52585:61344,]
summary(table_init)

#Modele de regression MCO
conso<-as.ts(table$LOAD, start=c(2005,01,1,1), end=c(2011,12,31, 0))
plot(conso)
modele<-lm(LOAD~., data=table_train)
summary(modele)

#Courbe consommation par heure (tous les jours de la semaine superposes)
mean_hour<-c()
heures<-c()
for( j in c("lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi", "dimanche")){
  for( h in 0:23){
    mean_hour<-c(mean_hour,mean(table_train[table_train$heure==h & table_train$day==j,"LOAD"]))
    heures<-c(heures,h)
  }
}
plot(mean_hour~heures, main="Consommation horaire moyenne",
     sub="Tous les jours de la semaine sont superposés", xlab="Heure",
     ylab="Consommation d'électricité")

#Courbe consommation moyenne par mois
mean_month<-c()
for(m in c("janvier", "février", "mars", "avril", "mai", "juin", "juillet", "août", "septembre", "octobre", "novembre", "décembre")){
  mois<-c(mois,m)
  mean_month<-c(mean_month, mean(table_train[table_train$month==m ,"LOAD"]))
}
plot(mean_month, type="l",xaxt="n", main="Consommation mensuelle moyenne", xlab="Mois", ylab="Consommation d'électricité")
axis(1,at=c(1:12), labels=c("janvier", "février", "mars", "avril", "mai", "juin", "juillet", "août", "septembre", "octobre", "novembre", "décembre"))

#Courbe consommation moyenne par jour de la semaine
mean_weekday<-c()
for(j in c("lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi", "dimanche")){
  mean_weekday<-c(mean_weekday, mean(table_train[table_train$day==j , "LOAD" ]))
}
plot(mean_weekday, type="l",xaxt="n", main="Consommation hebdomadaire moyenne", xlab="Jour", ylab="Consommation d'électricité")
axis(1,at=c(1:7), labels=c("lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi", "dimanche"))

#Courbe consommation moyenne par jour
mean_day<-c()
for( j in unique(table_train$date)){
  mean_day<-c(mean_day, mean(table_train[table_train$date==j,"LOAD"]))
}
plot(mean_day, type="l", xaxt="n", main="Consommation journalière moyenne", xlab="Date", ylab="Consommation d'électricité")
axis(1,at=c(1:length(unique(table_train$date))), labels=unique(table_train$date))
abline(lm(mean_day~c(1:length(mean_day)))$coefficients)

#Variables retardées
n=length(table$LOAD)
#De 1 jour
vect<-rep(0,n)
for( i in 25:n){
  vect[i]<-table$LOAD[i-24]
}
table$LOAD_day_ret<-vect
#De 1 semaine
vect<-rep(0,n)
for( i in 169:n){
  vect[i]<-table$LOAD[i-168]
}
table$LOAD_week_ret<-vect
#De 1 an
vect<-rep(0,n)
for( i in 8761:n){
  vect[i]<-table$LOAD[i-8760]
}
table$LOAD_year_ret<-vect

#Variables de synthèse
#Variance sur les dernieres 24h
vect<-rep(0,n)
for( i in 25:n){
  vect[i]<-var(table$LOAD[i-24:i])
}
table$LOAD_var<-vect


table$day_num<-as.numeric(factor(table$day, levels=c("lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi", "dimanche")))
table$month_num<-as.numeric(factor(table$month, levels=c("janvier", "février", "mars", "avril", "mai", "juin", "juillet", "août", "septembre", "octobre", "novembre", "décembre")))
#GAM
modele <- bam( LOAD ~ w1+w2+w3+w4+w5+w6+w7+w8+w9+w10+w11+w12+w13+w14+w15+w16+w17+w18+w19+w20+w21+w22+
                 w23+w24+w25+ s(day_num, k = 7, bs="cc") +s(month_num, k = 4, bs="cc")+s(heure, k=20, bs="cc")+
                 LOAD_day_ret +s(LOAD_year_ret, k=20, bs="cr")+s(LOAD_week_ret, k=20, bs="cr") ,
                 data=table , family=Gamma(link=log), method="GCV.Cp")
summary(modele)
