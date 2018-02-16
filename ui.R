library(shinydashboard)
#library(shinyIncubator)
library(shiny)
library(plotly)
library(d3heatmap)
library(shinyjs)
library("motifbreakR")
library("openxlsx")
library("SNPlocs.Hsapiens.dbSNP142.GRCh37")
library("BSgenome.Hsapiens.UCSC.hg19")
library("MotifDb")

dashboardPage(
  dashboardHeader(title = "STAR summary",titleWidth = 300),
  dashboardSidebar(width = 300,
                   div(style="overflow-y: scroll"),
                   tags$head(tags$style(HTML(".sidebar { height: 90vh; overflow-y: auto; }" ))),
                   sidebarMenu(
                     menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")))
        
                   
  ),
  
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
    ),
    useShinyjs(),
    tabItems(
      tabItem(tabName = "dashboard",
              box(
                width = 12, status = "primary",solidHeader = TRUE,
                title = "SNP list",DT::dataTableOutput('rsid')
              ),
              box(
                width = 12, status = "primary",solidHeader = TRUE,
                title = "Motifbreaker results",DT::dataTableOutput('res'),plotOutput('img')
              )
      )
      )))
