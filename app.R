library(jpeg)
library(shiny)
library(shinycssloaders)
library(plotly)
library(tseries)
library(xts)
library(ggplot2)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
theme_set(theme_bw())


source("app/data_load.R")
source("app/ui.R")
source("app/server.R")


shinyApp(ui, server)
