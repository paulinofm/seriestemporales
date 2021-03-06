#################################Carga de librerias#########################################

library(TSA)
library(tseries)
library(forecast)



###################################Carga de datos###########################################

data(AirPassengers) #Se cargan los datos
str(AirPassengers) 

#Se convierten los datos en serie de tiempo



#############Clase de los datos y muestra de los datos y el periodo al que pertenecen#######

class(AirPassengers)
print(AirPassengers)
cycle(AirPassengers)



##########################Ploteo gr�fico de los datos######################################

plot(AirPassengers, ylab="Pasajeros", xlab="A�o")
plot(AirPassengers, type="o", ylab="Pasajeros", xlab="A�o")



#######################Ploteo gr�fico de los correlogramas#################################

par(mfrow=c(1,2))
acf(AirPassengers)
pacf(AirPassengers)

plot(acf(AirPassengers)) #Paquete stats
plot(pacf(AirPassengers))
plot(Acf(AirPassengers)) #Paquete forecast
plot(Pacf(AirPassengers))



#################Descomposici�n y graficaci�n de los componentes de la serie###############

decompose.AirPassenger <- decompose(AirPassengers, type=c("multiplicative"))
plot(decompose.AirPassenger)

decompose2.AirPassenger <- stl(AirPassengers, s.window="period")
plot(decompose2.AirPassenger)



###############################Estimaci�n de la tendencia##################################

#Estimaci�n lineal

lm.AirPassengers <- lm(AirPassengers~time(AirPassengers)) #Modelo lineal
summary(lm.AirPassengers)

plot(AirPassengers, ylab="Pasajeros", xlab="A�o")
abline(lm.AirPassengers, col="red")

lm.predict.AirPassenger<-predict(lm.AirPassengers) #Predicci�n de la tendencia ajustada por el modelo lineal
plot(AirPassengers, ylab="Pasajeros", xlab="A�o")
lines(c(time(AirPassengers)),lm.predict.AirPassenger,col="red",lty="dashed")

par(mfcol=c(2,2))
plot(lm.AirPassengers) #Gr�fico de los residuos

plot(AirPassengers-lm.predict.AirPassenger) #Eliminaci�n de la tendencia de la serie



#Estimaci�n polin�mica

lm2.AirPassengers <- lm(AirPassengers~time(AirPassengers)+I(time(AirPassengers)^2)) #Modelo polin�mico de orden 2
summary(lm2.AirPassengers)

lm2.predict.AirPassenger<-predict(lm2.AirPassengers) #Predicci�n de la tendencia ajustada por el modelo polin�mico
plot(AirPassengers, ylab="Pasajeros", xlab="A�o")
lines(c(time(AirPassengers)),lm2.predict.AirPassenger,col="orange",lty="dashed")

par(mfcol=c(2,2))
plot(lm2.AirPassengers) #Gr�fico de los residuos

plot(AirPassengers-lm2.predict.AirPassenger) #Eliminaci�n de la tendencia de la serie



#Estimaci�n mediante filtros (medias m�viles)

mm3.AirPassenger <- filter(AirPassengers,filter=rep(1/3,3),sides=2,method="convolution") #Media m�vil de orden 3
plot(AirPassengers, ylab="Pasajeros", xlab="A�o")
lines(c(time(AirPassengers)),mm3.AirPassenger,col="purple",lty="dashed")

mm6.AirPassenger <- filter(AirPassengers,filter=rep(1/6,6),sides=2,method="convolution") #Media m�vil de orden 6
plot(AirPassengers, ylab="Pasajeros", xlab="A�o")
lines(c(time(AirPassengers)),mm6.AirPassenger,col="purple",lty="dashed")

mm12.AirPassenger <- filter(AirPassengers,filter=rep(1/12,12),sides=2,method="convolution") #Media m�vil de orden 12
plot(AirPassengers, ylab="Pasajeros", xlab="A�o")
lines(c(time(AirPassengers)),mm12.AirPassenger,col="purple",lty="dashed")

plot(AirPassengers-mm12.AirPassenger) #Eliminaci�n de la tendencia de la serie



#Eliminaci�n por diferenciaci�n

diff1.AirPassenger <- diff(AirPassengers) #Diferenciaci�n regular para eliminar la tendencia

plot(AirPassengers, ylab="Pasajeros", xlab="A�o")
lines(c(time(AirPassengers)),c(NaN,diff1.AirPassenger),col="blue",lty="dashed") #No lo pinta

plot(diff1.AirPassenger)



##############################Estimaci�n de la estacionalidad#############################

#Estimaci�n lineal

month <- season(AirPassengers) #Se obtienen los meses para cada observaci�n

lm.AirPassengers <- lm(AirPassengers~month) #Modelo lineal
lm.AirPassengers <- lm(AirPassengers~month-1) #Modelo lineal (sin intercepto)
summary(lm.AirPassengers)



#Eliminaci�n por diferenciaci�n

diff12.AirPassenger <- diff(AirPassengers,lag=12) #Diferenciaci�n estacional para eliminar la estacionalidad



####################Test de Dickey-Fuller para estacionalidad##############################

adf.test(AirPassengers)



######################################Modelos ARIMA#######################################

auto.arima(AirPassengers) #Estimaci�n autom�tica del modelo ARIMA

arima.AirPassengers <- arima(AirPassengers, order=c(1,0,0)) #Paquete stats
arima.AirPassengers <- Arima(AirPassengers, order=c(1,0,0)) #Paquete forecast

AIC(arima.AirPassengers)
BIC(arima.AirPassengers)
Box.test(arima.AirPassengers$residuals)
jarque.bera.test(arima.AirPassengers$residuals)
shapiro.test(rstandard(arima.AirPassengers))

pred.AirPassengers <- predict(arima.AirPassengers,n.ahead=12)
plot(AirPassengers, ylab="Pasajeros", xlab="A�o")
lines(pred.AirPassengers$pred,col="red")
lines(pred.AirPassengers$pred+2*pred.AirPassengers$se,col="red",lty=3)
lines(pred.AirPassengers$pred-2*pred.AirPassengers$se,col="red",lty=3)

pred2.AirPassengers <- forecast(arima.AirPassengers,12)
plot(pred2.AirPassengers, ylab="Pasajeros", xlab="A�o")

