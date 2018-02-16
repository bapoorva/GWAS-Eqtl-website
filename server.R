#library(shinyIncubator)
library(shiny)
library(shinyjs)
library(tidyr)
library(data.table)
library(ggplot2)
library(RColorBrewer)
library(NMF)
library(Biobase)
library(reshape2)
library(d3heatmap)
library(plotly)
library(shinyjs)
library(htmlwidgets)
library(DT)
library(FactoMineR)
library(factoextra)
library(shinyRGL)
library(rgl)
library(ReactomePA)
library(limma)
library(ggrepel)
library(dplyr)
library("motifbreakR")
library("openxlsx")
library("SNPlocs.Hsapiens.dbSNP142.GRCh37")
library("BSgenome.Hsapiens.UCSC.hg19")
library("MotifDb")


shinyServer(function(input, output,session) {
  
#Load data
  fileload <- reactive({
    inFile = "data/HERMES_MAGnet_eQTL_finresult.RData"
    load(inFile)
    return(fin_res)
  })

#Display rsid list
  rsid = reactive({
    rsid=fileload()
    file = rsid$snp
  })
  
  output$rsid = DT::renderDataTable({
    DT::datatable(rsid(),
                  extensions = c('Buttons','Scroller'),
                  options = list(dom = 'Bfrtip',
                                 searchHighlight = TRUE,
                                 pageLength = 10,
                                 lengthMenu = list(c(30, 50, 100, 150, 200, -1), c('30', '50', '100', '150', '200', 'All')),
                                 scrollX = TRUE,
                                 buttons = c('copy', 'print')
                  ),rownames=FALSE,caption= "snp list",selection = list(mode = 'single', selected =1))
  })
  
#for selected snp, display results
  res = reactive({
    results=fileload()
    s=input$rsid_rows_selected # get  index of selected row from table
    snp=rsid() #get datatable with snp data from reactive
    snp=snp[s, ,drop=FALSE]
    rsid=snp$SNP
    
    c=paste('results$res$',rsid,sep="")
    df=eval(parse(text = c))
  
    return(df) #return the results
  })
  
  output$res = DT::renderDataTable({
    DT::datatable(res(),
                  extensions = c('Buttons','Scroller'),
                  options = list(dom = 'Bfrtip',
                                 searchHighlight = TRUE,
                                 pageLength = 10,
                                 lengthMenu = list(c(30, 50, 100, 150, 200, -1), c('30', '50', '100', '150', '200', 'All')),
                                 scrollX = TRUE,
                                 buttons = c('copy', 'csv', 'print')
                  ),rownames=FALSE,escape=FALSE,caption="Results")
  })
  
  #create MB plot
  res = reactive({
    results=fileload()
    s=input$rsid_rows_selected # get  index of selected row from table
    snp=rsid() #get datatable with snp data from reactive
    snp=snp[s, ,drop=FALSE]
    rsid=snp$SNP
    
    c=paste('results$res$',rsid,sep="")
    df=eval(parse(text = c))
    
    return(df) #return the results
  })
})
