
library(data.table)
library(quantmod)
library(ggplot2)
library(dplyr)
library(lubridate)
library(shiny)
library(DT)
library(dygraphs)
library(curl)
# ui.R
shinyUI(navbarPage(
        title = "AOTC",
        tabPanel(
                title = "Technical Analysis",
                value = "TA",
                sidebarLayout(
                        fluid = TRUE,
                        sidebarPanel(
                                width = 3,
                                textInput(
                                        "ticker",
                                        label = h5("Stock Ticker"),
                                        value = "fb"
                                ),
                                conditionalPanel(
                                        "input.tab==1 || input.tab==2 || input.tab==3",
                                        dateRangeInput(
                                                "dates",
                                                h5("Date range"),
                                                min = Sys.Date() - years(5),
                                                max = Sys.Date(),
                                                start = "2017-01-01",
                                                end = as.character(Sys.Date())
                                        )
                                ),
                                conditionalPanel(
                                        "input.tab==1 || input.tab==2",
                                        sliderInput(
                                                "smaval",
                                                label = h5("Simple Moving Average Days"),
                                                min = 1,
                                                max = 100,
                                                value = 100
                                        )
                                ),
                                conditionalPanel(
                                        "input.tab==1 || input.tab==2",
                                        sliderInput(
                                                "emaval",
                                                label = h5("Exponential MA Days"),
                                                min = 1,
                                                max = 100,
                                                value = 100
                                        )
                                ),
                                conditionalPanel(
                                        "input.tab==1",
                                        checkboxGroupInput(
                                                "price",
                                                selected = c(1, 2, 3),
                                                inline = TRUE,
                                                h5("Indicators"),
                                                c(
                                                        "MACD" = 1,
                                                        "Elder" = 2,
                                                        "Chai" = 3
                                                )
                                        )
                                ),
                                conditionalPanel("input.tab==1",
                                                 checkboxGroupInput("indicators",selected = c(1,2),inline = TRUE, h5("Indicators"),
                                                                    c("MACD" = 1,
                                                                      "Bollinger Bands" = 2)
                                                 )
                                ),
                                textOutput("txt")
                                

                        ),
                        mainPanel(tabsetPanel(type = "tabs", id = "tab",
                                tabPanel("Candlestick",value = 1,
                                         dygraphOutput('candlestick', width ='100%')),
                                tabPanel("Candlestick",value = 2)
                                )#Close tabsetPanel
                        )##Close Mainpanel
                )##Close Sidebar Layout
        ),
        #Close tabPanel
        tabPanel(
                title = "Copper",
                value = "cu",
                bootstrapPage(mainPanel(
                        width = 12,
                        tabsetPanel(
                                type = "tabs",
                                id = "fa",
                                tabPanel("LME Data",value = 1,
                                                div(style = "padding-bottom: 5px; border-bottom: 1px solid silver;", dygraphOutput('COTGraph',height = '275',width ='100%')),
                                                div(style = "padding-bottom: 5px; border-bottom: 1px solid silver;",dygraphOutput('LMEInvGraph',height='275', width ='100%'))
                                        ),
                                        tabPanel(
                                                "News Analysis",
                                                value = 2,
                                                div(style="width: 500px",dataTableOutput("newsDF"))
                                                )
                                        )#Close tabsetPanel
                                )#Close Copper mainPanel
                        )##Close Copper bootstrapPage
                ),##Close Copper tabPanel
        tabPanel(
                title = "Crude Oil",
                value = "oil",
                bootstrapPage(mainPanel(
                        width = 12,
                        tabsetPanel(
                                type = "tabs",
                                id = "fa",
                                tabPanel("Crude Supply", value = 1,
                                        div(style = "padding-bottom: 5px; border-bottom: 1px solid silver;",dygraphOutput('oilStocks',height=125,width ='100%')),
                                        div(style = "padding-bottom: 5px; border-bottom: 1px solid silver;",dygraphOutput('supplyGraph',height=125, width ='100%')),
                                        div(style = "padding-bottom: 5px; border-bottom: 1px solid silver;",dygraphOutput('importsGraph',height=125, width ='100%')),
                                        div(style = "padding-bottom: 5px; border-bottom: 1px solid silver;",dygraphOutput('importsAvgGraph',height=125, width ='100%')))
                        )#Close tabsetPanel
                )#Close Copper mainPanel
                )##Close Copper bootstrapPage
        )##Close Copper tabPanel
        )##Close Navbar Page
        )##Close Shiny UI
        