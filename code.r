library(utils)
library(zoo)
library(timeDate)
library(forecast)
library(urca)
library(tseries)
library(fUnitRoots)
library(stats)
table_init<-read.table("C:/Users/Charles/Documents/ENSAE/Séminaire de modélisation statistique/alldata_sujet1.csv", sep=",",header=TRUE)
table_init$time<-strsplit(as.character(table_init$date),split="-")[0]
table_init$time[2000]
table_init$time<-ISOdate(strsplit(as.character(table_init$date),split="-"),hour=table_init$heure)
strsplit(as.character(table_init$date[2000]),split="-")
table_init$day<-weekdays(table_init$time)
table_init$month<-months(table_init$time)
table_init$heure<-as.numeric(table_init$heure)
table_init$time<-NULL
table_init$date<-NULL
table<-table_init[35065:96408,]
table_train<-table[1:52584,]
for(i in 1:length(table_train$LOAD)){
  if(is.na(table_train[i,"day"])){
    print(table_train[i,"date"])
    print(table_train[i,"heure"])
  }
}
table_train[,"date"]
table_test<-table[52585:61344,]
conso<-as.ts(table$LOAD, start=c(2005,01,1,1), end=c(2011,12,31, 0))
plot(conso)
modele<-lm(LOAD~., data=table_train)
summary(modele)

#Courbe consommation par heure (tous les jours de la semaine superposes)
mean_hour<-c()
heures<-c()
jours=c()
for( j in c("lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi", "dimanche")){
  for( h in 0:23){
    mean_hour<-c(mean_hour,mean(table_train[table_train$heure==h & table_train$day==j,"LOAD"]))
    heures<-c(heures,h)
  }
  jours=c(jours,j)
}
plot(mean_hour~heures)



mois=c()
jours=c()
mean_month<-c()
for(m in c("janvier", "février", "mars", "avril", "mai", "juin", "juillet", "août", "septembre", "octobre", "novembre", "décembre")){
  mois<-c(mois,m)

}
plot(mean_month)

mean_day<-c()
for(j in c("lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi", "dimanche")){
  mean_day<-c(mean_day, mean(table_train[table_train$day==j , "LOAD" ]))
}

test<-c()
for( i in 1:length(table_train$LOAD)){
  print(table_train[i,"day"])
  if(table_train[i,"day"]=="lundi"){
    test<-c(test,table_train$LOAD[i])
  }
}
table_test2<-table_test
table_test2$LOAD<-NULL
table_test$LOAD_pred<-predict(modele, newdata=table_test,se.fit=TRUE)
table_test$LOAD_pred[5]
err<-table_test$LOAD_pred-table_test$LOAD
