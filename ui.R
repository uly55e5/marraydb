
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

source("input.R")

options(shiny.maxRequestSize=30*1024^2)


shinyUI(
  navbarPage("Microarray database",
  tabPanel("Home"),
  
  navbarMenu("Add to Database",
    
    tabPanel("Add GPR File",
      
      fileInput("gprFileInput","Select GPR file"),
      
      wellPanel(
        h5("Required Input"),
        flowLayout(
          numericInput("gprSeriesInput","Series",0001,1,10000,1),
          numericInput("gprSlideInput","Slide",1,1,10000,1),
          numericInput("gprRevisionInput","Revision",1,1,1000,1)
        )
      ),
      wellPanel(
        h5("Optional Input"),
        flowLayout(
          dateInput("gprDateInput","Date",Sys.Date()),
          textInput("gprOperatorInput","Operator",""),
          textInput("gprShortnameInput","Short name","")
        ),
        tags$label("Description", `for` = "gprDescriptionInput"),
        textareaInput("gprDescriptionInput","",3,80)
      ),
      h4("Preview"),
      tabsetPanel(
        tabPanel("Table",
          dataTableOutput("gprDataTable")),
        tabPanel("Attributes",
          dataTableOutput("gprAttrTable"))
      )
    ),
    tabPanel("Add GAL File",
      
      fileInput("galFileInput","Select GAL file"),
      
      wellPanel(
        h5("Required Input"),
        flowLayout(
          numericInput("galSeriesInput","Series",0,0,10000,1),
          numericInput("galRevisionInput","Revision",1,1,1000,1)
        )
      ),
      wellPanel(
        h5("Optional Input"),
        flowLayout(
          dateInput("galDateInput","Date",Sys.Date()),
          textInput("galProviderInput","Provider","JPT"),
          textInput("galShortnameInput","Short name","")
        ),
        tags$label("Description", `for` = "galDescriptionInput"),
        textareaInput("galDescriptionInput","",3,80),
        uiOutput("galSeqColSelect")
      ),
      actionButton("galSubmitButton","Save to Database"),
      checkboxInput("galOverwriteCheckbox","Overwrite entries (if exist)"),
      textOutput("galDbStatusText"),
      h4("Preview"),
      tabsetPanel(
        tabPanel("Table",
          dataTableOutput("galDataTable")),
        tabPanel("Blocks",
          dataTableOutput("galBlockTable")),
        tabPanel("Attributes",
          dataTableOutput("galAttrTable")),
        tabPanel("Image",
          absolutePanel(wellPanel(textOutput("galPosOutput"),textOutput("galIDOutput"),textOutput("galNameOutput")),fixed=T,draggable=T),
          uiOutput("galPlotTab"))
      )
      #fixedPanel()#galInfo")#,
          # draggable = T,width = "10%",height = "10%")
    )
  )
)
)
