---
title       : Correlation Matrix in mtcars dataset
subtitle    : Developing Data Products Course Project
author      : Wenfeng Wang
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
---

## Using corrplot package to visualize correlation matrix

1. Corrplot package
2. visualization options: circle, square, ellipse, number, col and pie

--- .class #id 

## Slide 2

```r
library(corrplot)
library(datasets)
data(mtcars)
corMat <- cor(mtcars) # correlation matrix
diag(corMat) <- 0 # remove diagonal items
corrplot(corMat, "circle")
```

![plot of chunk generat matrix](assets/fig/generat matrix.png) 

--- .class #id 

## Slide 3

```r
corrplot(corMat, "square")
```

![plot of chunk square](assets/fig/square.png) 

--- .class #id 

## Slide 4

```r
corrplot(corMat, "number")
```

![plot of chunk number](assets/fig/number.png) 
--- .class #id 

## Slide 5


```r
corrplot(corMat, "pie")
```

![plot of chunk pie](assets/fig/pie.png) 
--- .class #id 
