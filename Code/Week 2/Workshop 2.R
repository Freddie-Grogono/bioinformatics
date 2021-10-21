```{r}
# this code will be run AND shown in you Rmarkdown

my_vec <- c(1,5,3,6,1)
my_vec
```

```{r, echo = FALSE}
# this code will run but NOT shown in your Rmarkdown
my_vec-c(1,5,3,6,1)
my_vec 
```

```r{r, eval = FLASE
#this code will NOT be run but will be shown
my_vec <- c(1,5,3,6,1)
my_vec
```


