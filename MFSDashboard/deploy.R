library(RODBC)
library(shiny)
library(shinyapps)
shinyapps::setAccountInfo(name='wdfw', token='FAA9F62F4EE9FF3ED8015BC6D399B0BD', secret='P/p+NZNX3avKX3gpq+0RI37QnYQvbxXofk/FRBDp')

deployApp("C:/data/R Projects/ShinyApps/MFSDashboard", account = "wdfw", appName = "MFSReporting")
