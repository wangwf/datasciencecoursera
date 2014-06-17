library(datasets); data(swiss); require(stats); require(graphics)
pairs(swiss, panel=panel.smooth, main="Swiss data", col=3+(swiss$Catholic>50))