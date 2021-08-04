# La idea
# Las app deben estar en el directorio
# creamos un json con la informacion:
#    Bloque: libro, articulo, etc.
#    Titulo: el titulo
#    imagen: la imagen
#    ....
#
# Leemos los directorios que seran los bloques
# Los metemos en la barra de navegacion
# Leemos los subdirectorios que son las aplicaciones

# # Define a location at the base URL of this 'server'
# location / {
#   # Redirect traffic from '/shinyApp1/' to 'http://server.com' temporarily.
#   location /shinyApp1 {
#     redirect "http://server.com" 302 true;
#   }
# }
function(input, output, session) {
  observeEvent(input$navtab, {

    apps = home$loadPanel(input$navtab)
    if (length(apps) == 0) {
       shinyjs::removeClass(id= paste0(input$navtab, "_nodata"), class="oculto")
       shinyjs::addClass(id=paste0(input$navtab, "_data"), class="oculto")
       return()
    }
    shinyjs::addClass(id=paste0(input$navtab, "_nodata"), class="oculto")
    shinyjs::removeClass(id=paste0(input$navtab, "_data"), class="oculto")
    data = lapply(apps, page)
    insertUI(selector=paste0("#", input$navtab, "_data"), where="afterBegin", immediate = TRUE, tagList(data))
    lapply(apps, function(app) tooltips(app, session))
  })
  
  observeEvent(input$block, {
    updateTabsetPanel(session, "navtab", selected = input$block)
  })
  observeEvent(input$app, {
    browser()
    
  })
  
}

