library(finreportr)
AnnualReports('fb')

GetBalanceSheet("FB",c(2017,2016,2015,2014))


library(tidyquant)
my.ticker <- 'AAPL'
my.df <- tq_get(my.ticker,get = "stock.prices")

print(tail(my.df))
df.key.ratios <- tq_get("AAPL",get = "key.ratios")
df.profitability <- df.key.ratios$data[[2]]
