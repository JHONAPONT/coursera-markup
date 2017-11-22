#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(DT)

grupos <- list('Industry' = "4781400" , 'Service' = "4691500" , 'Tecnology' = "4754701" , 
               'Sales' = "4711301" , 'Finance' = "4711302" , 'Sales' = "4744099" , 
               'Food' = "4772500" , 'Entertainment' = "4712100")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Sector Economy Analysis"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       selectInput("grupo", label = "Choose the Sector:", names(grupos)),
       textOutput('markup1'),
       textOutput('markup2'),
       textOutput('markup3'),
       textOutput('carga'),
       textOutput('oportunidade'),
       plotOutput('boxplot')
    ),
    # Show a plot of the generated distribution
    mainPanel(
      plotlyOutput('scatterent'),
      dataTableOutput("dados")
    )
  )
)
)
