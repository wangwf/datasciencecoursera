
pollution <- read.csv("data/avgpm25.csv", colClasses=c("numeric", "character", "factor", "numeric", "numeric"))
head(pollution)

summary(pollution$pm25)

hist(pollution$pm25, col="green")
rug(pollution$pm25)

# breaks
hist(pollution$pm25, col="green", breaks=100)
abline( v=12, lwd=2)
abline( v = median(pollution$pm25), col="magenta", lwd=4)

#Overlay
boxplot(pollution$pm25, col="blue")
abline( h=12)

barplot(table(pollution$region), col="wheat", main = "Number of Countie in Each Regaion")


#multiple Boxplots
boxplot(pm25 ~ region, data = pollution, col="red")

par(mfrow = c(2, 1), mar = c(4, 4,2, 1))
hist(subset(pollution, region="east")$pm25, col= "green")
hist(subset(pollution, region="west")$pm25, col= "green")

#Scatterplot
with(pollution, plot(lattitude, pm25))
abline(h = 12, lwd = 2, lty =2)


par(mfrow = c(1, 2), mar( 5, 4, 2, 1))
with(subset(pollution, region=="west"), plot(latitude, pm25, main = "West"))
with(subset(pollution, region=="east"), plot(latitude, pm25, main = "East"))


#### Base plotting system
library(datasets)
data(cars)
with(cars, plot(speed, dist))

## lattice plot
library(lattice)
state <- data.frame(state.x77, region = state.region)
xyplot( Life.Exp ~ Income | region,  data = state, layout=c(4,1))


# ggplot
library(ggplot2)
data(mpg)
qplot( displ, hwy, data = mpg)


#### base plotting
library(datasets)
hist(airquality$Ozone)
with(airquality, plot(Wind, Ozone))
title( main = "Ozone and wind in New York City")

airquality <- transform(airquality, Month = factor(Month))
boxplot(Ozone ~ Month, airquality, xlab = "Month", ylab ="Ozone (ppb)")


with(airquality, plot(Wind, Ozone, main = "Ozone and Wind in New York City"))
with(subset(airquality, Month ==5), points(Wind, Ozone, col="blue"))
with(subset(airquality, Month !=5), points(Wind, Ozone, col="red"))
legend("topright", pch=1, col=c("blue", "red"), legend=c("May", "Other Months"))

model <- lm(Ozone ~ Wind, airquality)
abline(model, lwd =2)


#Multiple base plot
par(mfrow = c(1,2))
with(airquality, {
  plot(Wind, Ozone, main = "Ozone and Wind")
  plot(Solar.R, Ozone, main = "Ozone and Solar Radiation")
})


par(mfrow= c(1, 3), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))
with(airquality, {
  plot(Wind, Ozone, main = "Ozone and Wind")
  plot(Solar.R, Ozone, main = "Ozone and Solar Radiation")
  plot(Temp, Ozone, main = "Ozone and Temperature")
  mtext("Ozone and Weather in New York City", outer =TRUE)
})


