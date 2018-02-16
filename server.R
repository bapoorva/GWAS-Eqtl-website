#library(shinyIncubator)
library(shiny)
library(shinyjs)
library(tidyr)
library(data.table)
library(RColorBrewer)
library(NMF)
library(Biobase)
library(reshape2)
library(d3heatmap)
library(plotly)
library(shinyjs)
library(htmlwidgets)
library(DT)
library(shinyRGL)
library(rgl)
library(limma)
library(ggrepel)
library(dplyr)



shinyServer(function(input, output,session) {
  
#Load data
  fileload <- reactive({
    d = read.csv("data/GWAS_summary.csv")
    geneid=d$eQTL_gene
    url= paste("http://www.genecards.org/cgi-bin/carddisp.pl?gene=",geneid,sep = "")
    d$link=paste0("<a href='",url,"'target='_blank'>","Link to GeneCard","</a>")
    d=as.data.frame(d) 
    return(d)
  })

#Display gene list
  output$genelist = DT::renderDataTable({
    DT::datatable(fileload(),
                  extensions = c('Buttons','Scroller'),
                  options = list(dom = 'Bfrtip',
                                 searchHighlight = TRUE,
                                 pageLength = 10,
                                 lengthMenu = list(c(30, 50, 100, 150, 200, -1), c('30', '50', '100', '150', '200', 'All')),
                                 scrollX = TRUE,
                                 buttons = list()
                  ),rownames=FALSE,caption= "Gene list",selection = list(mode = 'single', selected =1),escape = FALSE)
  })
  
#for selected gene, display snp results
  snps = reactive({
    genes=fileload()
    s=input$genelist_rows_selected # get  index of selected row from table
    genes=genes[s, ,drop=FALSE]
    gene=genes$eQTL_gene
    
    snp=read.csv("data/GWAS_merged_allresults.csv")
    snp=snp[snp$eQTL_gene==gene,]
    
    rsid=snp$snp
    url= paste("https://www.ncbi.nlm.nih.gov/SNP/snp_ref.cgi?rs=",rsid,sep = "")
    snp$link=paste0("<a href='",url,"'target='_blank'>","Link to dbSNP","</a>")
    snp=as.data.frame(snp)
    
    return(snp) #return the results
  })
  
  output$snps = DT::renderDataTable({
    DT::datatable(snps(),
                  extensions = c('Buttons','Scroller'),
                  options = list(dom = 'Bfrtip',
                                 searchHighlight = TRUE,
                                 pageLength = 10,
                                 lengthMenu = list(c(30, 50, 100, 150, 200, -1), c('30', '50', '100', '150', '200', 'All')),
                                 scrollX = TRUE,
                                 buttons = list()
                  ),rownames=FALSE,escape=FALSE,caption="SNP list")
  })
  
  output$dwldgenelist = renderUI({
    downloadButton('genedwld','Download Gene Information')
  }) 
  
  output$genedwld <- downloadHandler(
    filename = function() { 'genelist.csv' },
    content = function(file) {
      write.csv(fileload(), file,row.names=FALSE)
    })
  
  output$dwldsnplist = renderUI({
    downloadButton('snpdwld','Download SNP Data')
  }) 
  
  output$snpdwld <- downloadHandler(
    filename = function() { 'SNPdata.csv' },
    content = function(file) {
      write.csv(snps(), file,row.names=FALSE)
    })
  
  
})
