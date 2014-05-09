library(lattice)
library(datasets)
xyplot(Ozone ~ Wind, data=airquality)

airquality <- transform(airquality, Month= factor(Month))
xyplot(Ozone ~ Wind | Month, data=airquality, layout=c(5,1))

#xyplot(y~x | f, panel = function(x, y, ...){
#    panel.xyplot(x,y,...) # First call
#    panel.abline(h=median(y), lty=2)
#})
model<- lm(Ozone ~ Wind, data=airquality)
xyplot(Ozone ~ Wind | Month, data=airquality,panel = function(x, y, ...){
         panel.xyplot(x,y,...) # First call
        # model<- lm(Ozone ~ Wind, data=airquality, subset=Month)
         panel.abline(model, lty=2)
       panel.lmline(x,y,col=2)
})


xyplot(hwy ~ displ | drv, data=mpg,panel = function(x, y, ...){
    panel.xyplot(x,y,...) # First call
     model<- lm(hwy~displ, data=mpg)
    panel.abline(model, lty=2)
    panel.lmline(x,y,col=2)
})


qplot(displ, hwy, data=mpg)
qplot(displ, hwy, data=mpg, col=drv)

qplot(displ, hwy, data=mpg, geom=c("point", "smooth"))
qplot(hwy, data=mpg, fill=drv)

#Facets
qplot(displ, hwy, data = mpg, facets =.~drv)
qplot(displ, hwy, data = mpg, facets =drv~., binwidth=2)


qplot()