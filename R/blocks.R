bloque = function(lbl, evt, img) {
   width="128px"
   if (is.list(lbl)) {
      img = lbl$icon
      evt = lbl$event
      lbl = lbl$title
   }
   if (missing(evt) || is.null(evt)) evt=lbl
   msg = paste0("Shiny.setInputValue('block', '", evt, "', {priority:'event'});")
    tags$div( class="bloque"
             ,img(src=paste0("img/", img), class="icono", onclick=msg)
             ,tags$p(class="titulo", lbl)
    )

}
panel = function(label, value) {
   if (is.list(label)) {
      value = label$event
      label = label$title
   }
   if (missing(value) || is.null(value)) value = tolower(label)
   tabPanel(label, value=value
      ,tags$div(id=paste0(value, "_nodata"), h3("No hay datos"))
      ,tags$div(id=paste0(value, "_data"), class="oculto")
   )   
}
page = function(app) {
    msg = paste0("Shiny.setInputValue('app', '", app$base, "', {priority:'event'});")
    id = paste0("app_", app$base)
    tags$div(class="bloque"
             ,img(id=id, inputId=id, src=app$icon, class="icono", onclick=msg)
             ,tags$p(class="titulo", app$title)
    )
}

tooltips = function(app,session) {
    id = paste0("app_", app$base)
    
   text = ifelse (is.null(app$description),"No hay informacion",app$description)
      shinyBS::addTooltip(session=session,id=id,title=text) 
}
