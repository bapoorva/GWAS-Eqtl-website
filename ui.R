library(shinydashboard)
#library(shinyIncubator)
library(shiny)
library(plotly)
library(d3heatmap)
library(shinyjs)

dashboardPage(
  dashboardHeader(title = "GWAS-eQTL",titleWidth = 300),
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
                fluidRow(
                  column(6,uiOutput("dwldgenelist")),
                  column(6,uiOutput("dwldsnplist"))
                )
              ),
              box(
                width = 12, status = "primary",solidHeader = TRUE,
                title = "Gene list",DT::dataTableOutput('genelist')
              ),
              box(
                width = 12, status = "primary",solidHeader = TRUE,
                title = "SNP list",DT::dataTableOutput('snps')
              )
      )
      )))
