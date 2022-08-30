ui <- fluidPage(
  
  titlePanel("EcoWatcher"),
  
  sidebarLayout(
    
    sidebarPanel(
      sliderInput("plot_si", "Years to Plot:",
                  min = 1744, max = 2013, value = c(1970,2010)),
      textInput("area_txt", "Choose Country/Continent:", value = "Europe"),
      sliderInput("comp1_si", "Years for comparison (black line):",
                  min = 1744, max = 2013, value = c(1800,1900)),
      sliderInput("comp2_si", "Years for comparison (blue line):",
                  min = 1744, max = 2013, value = c(1900,2000)),
      textInput("date_txt", "Input Year and Month for map:", value = "2000-01"),
      sliderInput("lo_si", "Longitude for Globe Map:",
                  min = -180, max = 180, value = 10),
      sliderInput("la_si", "Latitude for Globe Map:",
                  min = -90, max = 90, value = 52),
    ),
    
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Welcome", p('-') , p('Welcome to EcoWatcher, The WebApp for the analysis of global warming'), 
                           p('-'), imageOutput("logo", width=100, height=150) ),
                  
                  
                  tabPanel("List of Country/Continents names", p('-'),
                           'The names below can be used in Inputs. \n', 
                           p('-'),'As you are in browser feel free to use CTRL+F to search for your preference below. \n', 
                           p('-'), paste(countries, collapse = '\n') ),
                  
                  
                  tabPanel("Temperature Plot", p('-'), 
                           p( 'Plot for,'),
                           verbatimTextOutput('print'),  p('-'), 
                           plotlyOutput("plot") %>% withSpinner(color="#0dc5c1")
                  ),
                  
                  tabPanel("Stationarity Test", p('-'), 
                           p( 'Test Results for,'),
                           verbatimTextOutput('print2'),  p('-'), 
                           verbatimTextOutput("test")),
                  
                  tabPanel("Temperature Table", p('-'), downloadLink('dt', 'Download Data'), p('-'), tableOutput("table")),
                  
                  tabPanel("Temperature Comparison", p('-'),
                           p( 'Plot for,'), 
                           verbatimTextOutput('print3'),  
                           p('-'),
                           plotOutput('plot2'),
                           p('-'),
                           verbatimTextOutput('print4')),
                  
                  tabPanel("Temperature Map", p('-'), 
                           p( 'Average Month Temperature World Maps for,'),
                           verbatimTextOutput('printm'),  p('-'), 
                           plotOutput("map2")  %>% withSpinner(color="#0dc5c1"), plotOutput("map1")  %>% withSpinner(color="#0dc5c1")),
                  
                  tabPanel("Please Check", p('-') , 
                           p('Things to know while using the App:'),
                           p('- All the temperatures shown are in Celsius degrees:'),
                           p('- All types of text that are printed can be copied.'),
                           p('- All types of image that are printed can be saved with right click, especially the temperature plot that provides widgets on top right.'),
                           p("- You can use all of browser's utilities to the App, such as CTRL+F and CTRL+A."),
                           p("- If you click at slider button choice in the middle, you can move the choice without changing ranges."),
                           p("- For the stationarity test (in case you are not familiar with Hypothesis Testing), check p-value, if it is less than 0.05 you reject the hypothesis for statistically significant temperature differences."),
                           p('- The regions in grey in maps are regions for which we have no data.'),
                           p('- The data are from kaggle: Map of temperatures and analysis of global warming.'),
                           p('- If you reload the app, it will start with default choices.'),
                           
                  ),
      ))
    
  ))

print('UI loaded...')