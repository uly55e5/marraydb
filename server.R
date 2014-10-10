
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(RODBC)

source("GPR-helper.R")
source("DB-helper.R")
source("Plot-helper.R")

dbDriver <- "MySQL"
database <- "ma-test"
dbUser <- "ma_user"
dbPwd <- "micro"

shinyServer(function(input, output, session) {

  galDataFile <- reactive({
    read.Genepix(input$galFileInput[1,"datapath"],T)
  })


  
  mysession <-reactiveValues()
  mysession$galZoom <- F
  
  
  gprDataFile <- reactive({
    read.Genepix(input$gprFileInput[1,"datapath"])
  })
  
  
  
  output$gprDataTable <- renderDataTable({
    validate(need(input$gprFileInput,"Select a file to preview it"))
    gprDataFile()$data
  })
  
  galPlotData <- reactive({
    b <- galDataFile()$blocks
    d <- galDataFile()$data
    x <-as.integer(as.character(b$x[d$Block])) + as.integer(as.character(b$dx[d$Block])) * (d$Column-1)
    y <-as.integer(as.character(b$y[d$Block])) + as.integer(as.character(b$dy[d$Block])) * (d$Row-1)
    r <-as.integer(as.character(b$dia[d$Block]))/2
    c <- ifelse(d$ID=="empty","#777777","#000000")
    cbind(x,y,r,c,d)
  })
  
  galPlotWidth <- function(){
    1000
  }
  
  galPlotHeight <- function(){
    if(!mysession$galZoom)
      return(max(galPlotData()$y)/max(galPlotData()$x)*galPlotWidth())
    return(galPlotWidth())
  }
  
  galPlotLimit <- reactive({
    x <- input$galClick$x
    y <- input$galClick$y
    d <- galPlotData()
    if(!isolate(mysession$galZoom) & !is.null(x) & !is.null(y))
    {
      isolate(mysession$galZoom <<- T)
      return(list(x=c(x-10*max(d$r),x+10*max(d$r)),y=c(y+10*max(d$r),y-10*max(d$r))))
    }
    isolate(mysession$galZoom <<- F)
    return(list(x=c(min(d$x)-max(d$r),max(d$x)+max(d$r)),y=c(max(d$y)+max(d$r),min(d$y)-max(d$r))))
    
  })
  
  source("GAL-Fun.R",local=T)
  
  gprAttrTable <- renderDataTable(gprDataFile()$attr)
  
  
  output$galDbStatusText <- renderText({
    input$galSubmitButton
    
    isolate({
      validate(need(input$galSeriesInput > 0,"Please enter a valid series number"))
      galId <- 1      
      dbConn <- dbConnect(dbDriver,username=dbUser,password=dbPwd,dbname=database)
      if(dbExistsTable(dbConn,"gal_metadata"))
      {
        res <- dbSendQuery(dbConn,"SELECT MAX(gal_id) AS id FROM gal_metadata")
        galId <- fetch(res,1)$id[1]+1
        dbClearResult(res)
        q <- paste("SELECT gal_id,series, revision FROM gal_metadata WHERE series=",input$galSeriesInput," AND revision=",input$galRevisionInput,sep="")
        res <- dbSendQuery(dbConn,q)
        oldgal <- fetch(res)
        if(dbGetRowCount(res)>0)
        {
          dbClearResult(res)
          if(input$galOverwriteCheckbox)
          {
            for(id in oldgal$gal_id)
            {
              q <- paste("DELETE FROM gal_metadata,gal_data,gal_blocks,gal_attr WHERE gal_id=",id,sep="")
              res <- dbSendQuery(dbConn,q)
              dbClearResult(res)
            }
          }
          else
          {
            dbDisconnect(dbConn)
            return("Series and Revision are already in Database (check overwrite if necessesary)")
          }
        }
      }
      metadata = data.frame(gal_id=galId,series=input$galSeriesInput,revision=input$galRevisionInput,date=input$galDateInput,provider=input$galProviderInput,shortname=input$galShortnameInput,description=input$galDescriptionInput,seqCol=input$galSeqColInput)
      writeTableToDB(dbConn,"gal_metadata",metadata)
      writeTableToDB(dbConn,"gal_data",data.frame(galDataFile()$data,gal_id=galId))
      writeTableToDB(dbConn,"gal_blocks",data.frame(galDataFile()$blocks,gal_id=galId))
      writeTableToDB(dbConn,"gal_attr",data.frame(galDataFile()$attr,gal_id=galId))
      dbDisconnect(dbConn)
      return("Galfile added to DB")
    })
  })
  
})
