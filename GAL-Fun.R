output$galDataTable <- renderDataTable({
  validate(need(input$galFileInput,"Select a file to preview it"))
  galDataFile()$data
})  

output$galBlockTable <- renderDataTable(galDataFile()$blocks)

output$galAttrTable <- renderDataTable(galDataFile()$attr)

output$galSeqColSelect <- renderUI({
  validate(need(input$galFileInput,""))
  selectInput("galSeqColInput","Sequence column",choices = names(galDataFile()$data),selected = "ID")
})

output$galPlotTab <- renderUI({
  plotOutput("galPlot",width="auto",height="100%",hoverId = "galPos",clickId = "galClick")
})

curGalItem <- reactive({
  getItemForPos(galPlotData(),input$galPos$x,input$galPos$y)
})

output$galPosOutput <- renderText({
  d <- curGalItem()
  paste("Blk: ",d$Block[1]," Col: ",d$Column[1], " Row: ", d$Row[1])
})

output$galIDOutput <- renderText({
  d <- getItemForPos(galPlotData(),input$galPos$x,input$galPos$y)
  paste("ID: ",curGalItem()$ID[1])
})

output$galNameOutput <- renderText({
  paste("ID: ",curGalItem()$Name[1])
})

output$galPlot <- renderPlot({
  plotSymbols(galPlotData(), galPlotLimit())
},height=galPlotHeight,width=galPlotWidth)
