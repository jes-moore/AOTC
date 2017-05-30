library(zoo)
library(data.table)
library(quantmod)
library(dplyr)
library(lubridate)
library(shiny)
library(DT)
library(reshape2)
library(xts)
library(curl)
library(dygraphs)
library(RMySQL)

shinyServer(function(input, output,session){
        #Loads the data based on selected share price and date range
        input_data <- reactive({
                withProgress(message = 'Downloading Stock Data', value = 0, {
                        for (i in 1:15) {
                                incProgress(1/15)
                                Sys.sleep(0.01)
                        }
                })
                apiCall <- paste("https://www.quandl.com/api/v3/datatables/WIKI/PRICES.csv?ticker=", input$ticker,
                                 "&qopts.columns=date,open,high,low,close,volume&api_key=Xa-XyezxZxsEZpmhKYkt",sep="")
                x <- fread(apiCall)
                #x$date <- as.Date(x$date)
                x
                })
        #Takes input data, runs through the creation of ma's and other trading indicators, outputs df
        cutdata <- reactive({
                x <- input_data()
                withProgress(message = 'Computing Indicators', value = 0, {
                        for (i in 1:15) {
                                incProgress(1/15)
                                Sys.sleep(0.01)
                        }
                })
                colnames(x) <- c("Date","Open","High","Low","Close","Volume")
                x$MA <- SMA(x = x$Close,n=input$smaval)
                x$MA <- round(x$MA,2)
                x$EMA <- EMA(x = x$Close,n=input$emaval)
                x$EMA <- round(x$EMA,2)
                #boll <- BBands(HLC = x[,c(3,4,5)],n = input$bollval)
                #x <- cbind(x,boll)
                x$RSI <- RSI(x$Close)
                x$EMA12 <- EMA(x = x$Close,n = 12)
                x$EMA26 <- EMA(x = x$Close,n = 26)
                x$MACD <- x$EMA12 - x$EMA26
                x$SIGNAL <- EMA(x = x$MACD,n = 9)
                mfi <- MFI(HLC = x[,c("High","Low","Close")],x[,"Volume"],n=14)
                x <- cbind(x,mfi)
                #cutdata <- x[(x$date >= as.Date(input$dates[1],format="%Y-%m-%d")) & (x$date <= as.Date(input$dates[2],format="%Y-%m-%d")),]
                x$Date <- as.Date(x$Date,format="%Y-%m-%d")
                x <- na.exclude(x)
                x <- xts(x,x$Date)
                x
                })
        
        # Stock Graphs
        output$candlestick<- renderDygraph({
                source('sharePricePlot.R')
                data <- cutdata()
                chart <- sharePricePlot(data)
                return(chart)
        })
        
        output$technicals<- renderDygraph({
                source('technicalChart.R')
                data <- cutdata()
                chart <- technicalChart(data)
                return(chart)
        })

        # Copper Graphs
        output$COTGraph<- renderDygraph({
                source('copperCOTC.R')
                chart <- COTGraph()
                return(chart)
        })
        output$LMEInvGraph<- renderDygraph({
                source('copperCOTC.R')
                chart <- LMEInvGraph()
                return(chart)
        })
        output$BackwardationGraph<- renderDygraph({
                source('copperCOTC.R')
                chart <- BackwardationGraph()
                return(chart)
        })
        #Copper News Analysis
        output$newsDF <- renderDataTable({
                source('copperNews.R')
                newsDF <- copperNewsDT()
                return(newsDF)
        })
        
        # Crude Oil GRaphs
        output$importsGraph<- renderDygraph({
                source('USCrudeGraphs.R')
                chart <- importsGraph()
                return(chart)
        })
        output$oilStocks<- renderDygraph({
                source('USCrudeGraphs.R')
                chart <- oilStocks()
                return(chart)
                })
        output$supplyGraph<- renderDygraph({
                source('USCrudeGraphs.R')
                chart <- supplyGraph()
                return(chart)
                })
        output$importsAvgGraph<- renderDygraph({
                source('USCrudeGraphs.R')
                chart <- importsAvgGraph()
                return(chart)
                })
        
})








