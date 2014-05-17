My First knitr Document
===============================================

library(knitr)
knit2html("myDoc.Rmd")
browseURL("myDoc.html")

This is some "text chunk".


```r
set.seed(1)
x <- rnorm(100)
mean(x)
```

```
## [1] 0.1089
```




The current time is Fri May $d 03:52:23 PM 2014. My favorite random number is -0.6204.
