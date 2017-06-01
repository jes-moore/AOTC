library(tidyquant)
library(lubridate)
library(DT)
library(scales)
ticker <- 'FB'
#Stock Prices
prices <- tq_get(ticker,'stock.price')
#Ratios
df.key.ratios <- tq_get(ticker,get = "key.ratios")
profitability <- df.key.ratios$data[[2]]
#Statistics (EPS,P/E,etc)
df.stats <- tq_get(ticker,get='key.stats',from = '2014-01-01')
#Financials
df.financials <- tq_get(ticker,get = 'financials')


#Financials Quarterly
df.Qfinancials <- df.financials$quarter
QincomeStatement <- na.exclude(df.Qfinancials[[3]])
QRevenue <- QincomeStatement[QincomeStatement$category == 'Revenue',3:4]
colnames(QRevenue) <- c('Date','Revenue')
QOpIncome <- QincomeStatement[QincomeStatement$category == 'Operating Income',3:4]
colnames(QOpIncome) <- c('Date','Operating Income')
QNetProfit <- QincomeStatement[QincomeStatement$category == 'Net Income',3:4]
colnames(QOpIncome) <- c('Date','Net Profit')
Qeps <- QincomeStatement[QincomeStatement$category == 'Diluted Normalized EPS',3:4]
colnames(Qeps) <- c('Date','EPS')
#QincomeStatement <- na.exclude(df.Yfinancials[[3]])
merge.all <- function(by, ...) {
        frames <- list(...)
        return (Reduce(function(x, y) {merge(x, y, by = by, all = TRUE)}, frames))
}  # end merge.all
QfinIndicators <-tail(merge.all(by = 1, QRevenue, QOpIncome, QNetProfit,Qeps),4)


keyFinancials <- function(df.financials) {
        #Financials Yearly
        df.Yfinancials <- df.financials$annual
        YincomeStatement <- na.exclude(df.Yfinancials[[3]])
        
        YRevenue <- YincomeStatement[YincomeStatement$category == 'Revenue',3:4]
        colnames(YRevenue) <- c('Date','Revenue')
        YRevenue$Date <- year(YRevenue$Date)
        YRevenue$Revenue <- paste0("<span style='font-family: sans-serif;font-size: 11px;text-align: center; text-decoration: none; color:#2F2F2F'>$",format(YRevenue$Revenue,big.mark = ','),"</span>")
        
        YOpIncome <- YincomeStatement[YincomeStatement$category == 'Operating Income',3:4]
        colnames(YOpIncome) <- c('Date','Operating Income')
        YOpIncome$Date <- year(YOpIncome$Date)
        YOpIncome$`Operating Income` <- paste0("<span style='font-family: sans-serif;text-align: center;font-size: 11px; text-decoration: none; color:#2F2F2F'>$",format(YOpIncome$`Operating Income`,big.mark = ','),"</span>")
        
        YNetProfit <- YincomeStatement[YincomeStatement$category == 'Net Income',3:4]
        colnames(YNetProfit) <- c('Date','Net Profit')
        YNetProfit$Date <- year(YNetProfit$Date)
        YNetProfit$`Net Profit` <- paste0("<span style='font-family: sans-serif;font-size: 11px;text-align: center; text-decoration: none; color:#2F2F2F'>$",format(YNetProfit$`Net Profit` ,big.mark = ','),"</span>")
        
        Yeps <- YincomeStatement[YincomeStatement$category == 'Diluted Normalized EPS',3:4]
        colnames(Yeps) <- c('Date','EPS')
        Yeps$`EPS YOY (%)` <- 0
        for(i in 1:nrow(Yeps)-1){
                Yeps$`EPS YOY (%)`[i] <- percent(round((Yeps$EPS[i] - Yeps$EPS[i+1])/Yeps$EPS[i+1],digits = 4))
                        }
        Yeps$Date <- year(Yeps$Date)
        Yeps$EPS <- paste0("<span style='font-family: sans-serif;font-size: 11px;text-align: center; text-decoration: none; color:#2F2F2F'>$",format(Yeps$EPS ,big.mark = ','),"</span>")
        Yeps$`EPS YOY (%)` <- paste0("<span style='font-family: sans-serif;font-size: 11px;text-align: center; text-decoration: none; color:#2F2F2F'>",Yeps$`EPS YOY (%)`,"</span>")
        
        Ype <- df.key.ratios$data[[7]]
        Ype <- na.exclude(Ype[Ype$category == 'Price to Earnings',c(4,5)])
        colnames(Ype) <- c('Date','P/E')
        Ype$Date <- as.Date(gsub(pattern = '30',x = Ype$Date,replacement = '31'))
        Ype$Date <- year(Ype$Date)
        Ype$`P/E` <- round(Ype$`P/E`,digits = 1)
        Ype$`P/E` <- paste0("<span style='font-family: sans-serif;font-size: 11px;text-align: center; text-decoration: none; color:#2F2F2F'>",Ype$`P/E`,"</span>")
        
        YfinIndicators <-tail(merge.all(by = 1, YRevenue, YOpIncome, YNetProfit,Yeps,Ype),3)
        YfinIndicators$Date <- paste0("<span style='font-family: sans-serif;font-size: 11px;text-align: center; text-decoration: none; color:#2F2F2F'>",YfinIndicators$Date,"</span>")
        colnames(YfinIndicators) <- paste0('<span style="font-family: sans-serif;text-align: center; color:',c("#697068;","#697068;"),"font-size:11px",'">',colnames(YfinIndicators),'</span>')
        
        datatable(YfinIndicators,escape = FALSE,
                  options = list(autowidth=T,
                                 order = list(list(1, 'des')),
                                 columnDefs = list(list(className = 'dt-center', targets = 0:5)),
                                 sDom  = '<"top">lrt<"bottom">ip',  
                                 dom='ptl',
                                 "bLengthChange" = FALSE,
                                 "bInfo"=FALSE,
                                 "DataTables_Table_0_paginate"=FALSE,
                                 scrollY = 300,
                                 bPaginate = FALSE),
                  rownames= FALSE
                  
                  
                  )
}





