#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(ggplot2)
library(DT)

l <- readRDS('./data/l.rds')

todosmarkups <- NULL
grupos <- list('Industry' = "4781400" , 'Service' = "4691500" , 'Tecnology' = "4754701" , 
               'Sales' = "4711301" , 'Finance' = "4711302" , 'Sales' = "4744099" , 
               'Food' = "4772500" , 'Entertainment' = "4712100")
for (grupo in grupos){
  todosmarkups <- rbind(todosmarkups, data.frame(grupo = grupo, markup = l[[grupo]]$markup_aparado))
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$dados <- renderDataTable({datatable(l[[grupos[[input$grupo]]]]$df[-1]) %>%
      formatCurrency(c(2:4, 6, 7)) %>% formatRound(columns = 5, digits = 4)
  }
  )
  
  
  output$boxplot <- renderPlot({
    p <- ggplot(todosmarkups, aes(x=grupo, y=markup, fill = grupo)) 
    p <- p + coord_flip()
    p <- p + geom_boxplot()
    p <- p + labs(x = 'Group', title = 'Markup/Group Boxplot')
    p <- p + scale_fill_discrete(name=NULL, 
                                 breaks = c("4781400", "4691500", "4754701", "4711301", "4711302", "4744099", "4772500", "4712100"),
                                 labels=names(grupos))
    p <- p + theme(axis.text.x = element_blank(),
                   axis.text.y = element_blank(),
                   axis.ticks = element_blank())
    p
  })
  
  output$scatterent <- renderPlotly({
    maxent <- max(l[[grupos[[input$grupo]]]]$df$income)
    p<- plot_ly(l[[grupos[[input$grupo]]]]$df, x = ~income, y = ~outcome, 
                type = 'scatter', mode = 'markers',
                hoverinfo = 'text+x+y',
                text =  ~paste(ie, ' - ', name)) %>%
      add_trace(x = c(0, maxent), y = l[[grupos[[input$grupo]]]]$markup*c(0, maxent), mode = 'lines', name = 'markup',
                hoverinfo = 'text', marker = NULL,
                text = ~paste('markup : ', round(l[[grupos[[input$grupo]]]]$markup, 4))) %>%
      layout(showlegend = FALSE, xaxis = list(title = 'Income'),
             yaxis = list(title = 'Outcome'))
    p$elementId <- NULL
    p
  })
  
  output$markup1 <- renderText({
    paste('Markup of the sector: ', round(l[[grupos[[input$grupo]]]]$markup, 4))
  })
  output$markup2 <- renderText({
    paste('Markup mean: ', round(mean(l[[grupos[[input$grupo]]]]$markup_aparado), 4))
  })
  output$markup3 <- renderText({
    paste('Markup sd: ', round(sd(l[[grupos[[input$grupo]]]]$markup_aparado), 4))
  })
  output$oportunidade <- renderText({
    paste('Oportunity: ', format(sum(l[[grupos[[input$grupo]]]]$df$oportunity), big.mark = ',', decimal.mark = '.', nsmall = 2))
  })
  output$carga <- renderText({
    paste('Tax: ', sprintf("%1.2f%%", 100*l[[grupos[[input$grupo]]]]$carga))
  })
  
})
