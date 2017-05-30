sharePricePlot <- function(data){
        dyCrosshair <- function(dygraph, direction = c("both", "horizontal", "vertical")) {
                dyPlugin(
                        dygraph = dygraph,
                        name = "Crosshair",
                        path = system.file("plugins/crosshair.js", package = "dygraphs"),
                        options = list(direction = match.arg(direction))
                )
        }
        ohlc <- dyCandlestick(dygraph(x[,2:5]) ,compress=TRUE) %>%
                dyRangeSelector(height = 30,dateWindow = c(range(index(data))[2] - 180,range(index(data))[2])) %>%
                dyCSS("css/stocks.css") %>%
                dyShading(from = range(index(data))[1], to = range(index(data))[2]) %>%
                dyLegend(show = "always",width = 600) %>%
                dyAxis("y",drawGrid = FALSE) %>%
                dyCrosshair(direction = "vertical") 
        ohlc
        
        
        
}

