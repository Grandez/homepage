
tagList(includeCSS("www/home.css"),

navbarPage("Grandez", id="navtab"
#  ,tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "home.css"))  
  #,tabsetPanel(id="home"
  ,tabPanel("Home", value="home"
     ,tags$div(display="flex", lapply(tabs, bloque)
        # ,bloque("Books",    "books",     "book01.jpg")
        # ,bloque("Notes",    "notes",     "notebook01.jpg")
        # ,bloque("Articles", "articles",  "newspaper01.jpg")
        # ,bloque("Tools",    "tools",     "wheels01.jpg")
        # ,bloque("Others",   "other",     "matrix02.jpg")
     )
  )
  ,panel("Books")
  ,panel("Articles")
  ,panel("Apps")
  ,panel("Notes")
  ,panel("Tools")
  ,panel("Other")
  ,useShinyjs()
)

)