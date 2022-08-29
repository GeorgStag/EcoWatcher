world <- ne_countries(scale = "medium", returnclass = "sf")
class(world)


server <- function(input, output) {
  
  output$logo <- renderImage({ list(
    src = "logo.jpg",
    contentType = "image/jpg",
    alt = "Logo"
  ) 
  })
  
  output$print <- renderText({ paste(input$area_txt, ' ', input$plot_si[1], '-', input$plot_si[2], sep='') })
  
  output$print2 <- renderText({ paste(input$area_txt, ' ', input$plot_si[1], '-', input$plot_si[2], sep='') })
  
  output$print3 <- renderText({ paste(input$area_txt, ' ', input$comp1_si[1], '-', input$comp1_si[2], '(black line) vs ', input$comp2_si[1], '-', input$comp2_si[2], "(blue line)", sep='') })
  
  
  output$table <- renderTable({ 
    temp = data[which(data$Country == input$area_txt ),]
    start = paste(input$plot_si[1], "-01-01", sep='')
    end = paste(input$plot_si[2], "-01-01", sep='')
    temp = temp[temp$dt > start  & temp$dt < end,]
    temp[,1] = as.character(temp[,1])
    return(temp) })
  
  
  output$plot <- renderPlotly({ 
    temp = data[which(data$Country == input$area_txt ),]
    start = paste(input$plot_si[1], "-01-01", sep='')
    end = paste(input$plot_si[2], "-01-01", sep='')
    temp = temp[temp$dt > start  & temp$dt < end,]
    fig <- plot_ly()%>%
      add_trace(data = temp, type = 'scatter', mode = 'lines', fill = 'tozeroy', x = ~dt, y = ~AverageTemperature, name = 'GOOG')%>%
      layout(showlegend = F, yaxis = list(range = c(-50,50),
                                          zerolinecolor = '#ffff',
                                          zerolinewidth = 2,
                                          gridcolor = 'ffff'),
             xaxis = list(zerolinecolor = '#ffff',
                          zerolinewidth = 2,
                          gridcolor = 'ffff'),
             plot_bgcolor='#e5ecf6')
    options(warn = -1)
    fig <- fig %>%
      layout(
        xaxis = list(zerolinecolor = '#ffff',
                     zerolinewidth = 2,
                     gridcolor = 'ffff'),
        yaxis = list(zerolinecolor = '#ffff',
                     zerolinewidth = 2,
                     gridcolor = 'ffff'),
        plot_bgcolor='#e5ecf6', width = 900)
    return(fig) })
  
  output$test <- renderPrint({ 
    temp = data[which(data$Country == input$area_txt ),]
    start = paste(input$plot_si[1], "-01-01", sep='')
    end = paste(input$plot_si[2], "-01-01", sep='')
    temp = temp[temp$dt > start  & temp$dt < end,]  
    temp_ts =  xts(temp[,2], order.by=temp[,1])
    return(print(adf.test(temp_ts))) })
  
  output$plot2 <- renderPlot({
    temp = data[which(data$Country == input$area_txt ),]
    start = paste(input$comp1_si[1], "-01-01", sep='')
    end = paste(input$comp1_si[2], "-01-01", sep='')
    temp1 = temp[temp$dt > start  & temp$dt < end,]  
    start = paste(input$comp2_si[1], "-01-01", sep='')
    end = paste(input$comp2_si[2], "-01-01", sep='')
    temp2 = temp[temp$dt > start  & temp$dt < end,]   
    par(mfrow=c(2,1))
    plot(temp1[,2], type='l', col='black', ylab='Av_Temp per mnth', xlab='months from starting year', main = "Black vs Blue Temperatures")
    lines(temp2[,2], col='blue')
    plot(temp1[,2]-temp2[,2], type='l', col='red', ylab='Difference per month', xlab='months from starting year', main = "Black - Blue Temperatures")
    abline(h=0, col='black')
  })
  
  output$print4 <- renderText({ 
    temp = data[which(data$Country == input$area_txt ),]
    start = paste(input$comp1_si[1], "-01-01", sep='')
    end = paste(input$comp1_si[2], "-01-01", sep='')
    temp1 = temp[temp$dt > start  & temp$dt < end,]  
    start = paste(input$comp2_si[1], "-01-01", sep='')
    end = paste(input$comp2_si[2], "-01-01", sep='')
    temp2 = temp[temp$dt > start  & temp$dt < end,]  
    result = paste( 'The mean of difference is ', mean(temp1[,2]-temp2[,2]), '\n and the standard deviation ', sqrt(var(temp1[,2]-temp2[,2])), '.', sep='')
    return( result) })
  
  output$map1 <- renderPlot({ 
    temp = data[which(data$dt == as.POSIXct(paste(input$date_txt,"-01",sep=""), format="%Y-%m-%d", tz="UTC") ), ]
    for (i in 1:241){
      name = world$name_sort[i]
      if (name=='United States of America'){name='North America'}
      ind = temp[,4]==name
      if (sum(ind)==0){world$pop_est[i] = -100}
      if (sum(ind)==1){world$pop_est[i] = temp[ind,2]}
    }
    ggplot(data = world) +
      geom_sf( aes(fill = pop_est) ) +
      xlab("Longitude") + ylab("Latitude") +
      theme(legend.title= element_blank() )+
      scale_fill_gradient2(low="grey", mid="blue", high="red", 
                           midpoint=0,    
                           breaks=seq(-60,60,20),
                           limits=c(-100 ,60))
  })
  
  output$map2 <- renderPlot({ 
    temp = data[which(data$dt == as.POSIXct(paste(input$date_txt,"-01",sep=""), format="%Y-%m-%d", tz="UTC") ), ]
    for (i in 1:241){
      name = world$name_sort[i]
      if (name=='United States of America'){name='North America'}
      ind = temp[,4]==name
      if (sum(ind)==0){world$pop_est[i] = -100}
      if (sum(ind)==1){world$pop_est[i] = temp[ind,2]}
    }
    
    crs_txt = paste("+proj=laea +lat_0=", input$la_si, " +lon_0=", input$lo_si, " +x_0=4321000 +y_0=3210000 +ellps=GRS80 +units=m +no_defs ", sep="")
    
    ggplot(data = world) +
      geom_sf( aes(fill = pop_est)) +
      coord_sf(crs = crs_txt)+
      theme(legend.title= element_blank() )+
      scale_fill_gradient2(low="grey", mid="blue", high="red", 
                           midpoint=0,    
                           breaks=seq(-60,60,20),
                           limits=c(-100 ,60))  })
  
  output$printm <- renderText({ input$date_txt })
  
  
  output$dt <- downloadHandler(
    filename = function() {
      paste('data-', Sys.Date(), '.csv', sep='')
    },
    content  = function(con) {
      write.csv(data, con)
    }
  )
  
}

print('Server Loaded...')