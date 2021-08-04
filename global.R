library(rlist)
library(shiny)
library(shinyjs)
library(shinyBS)
library(rjson)
library(hash)
library(markdown)

AppInfo = R6::R6Class("APP.INFO"
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,portable   = FALSE
   ,public = list(
       valid = FALSE
      ,base  = NULL
      ,title = NULL
      ,icon = "img/default.jpg"
      ,groups = c("other")
      ,initialize = function(base, ignore.missing=FALSE) {
         self$base = base
         self$title = base
         json = paste0("../", base, "/", base, ".json")
         if (file.exists(json)) private$loadInfo(json)
      }
   )
   ,private = list(
      loadInfo = function(json) {
         self$valid = TRUE
         data = rjson::fromJSON(file=json)
         if (!is.null(data$ignore) && data$ignore) return()
         if (!is.null(data$draft)  && data$draft)  return()
         if (!is.null(data$title))  self$title=data$title
         if (!is.null(data$groups)) self$groups=data$groups
         private$validateIcon(data)
      }
      ,validateIcon = function(data) {
         fbase = paste0("../", base, "/www/img/")
         if (!is.null(data$icon) && file.exists(paste0(fbase, data$icon))) {
             self$icon = paste0("ext/", data$icon)
             file.copy(paste0(fbase, data$icon), paste0("www/", self$icon))
             return()
         }
         if (file.exists(paste0(fbase, base, ".png"))) {
             self$icon = paste0("ext/", base, ".png")
             file.copy(paste0(fbase, data$icon), paste0("www/", self$icon))
             return()
         }   
         if (file.exists(paste0(fbase, base, ".jpg"))) {
             self$icon = paste0("ext/", base, ".png")
             file.copy(paste0(fbase, data$icon), paste0("www/", self$icon))
             return()
         }   
      }
      # El JSON sera nombre_app.json y debe tener:
      # groups: la lista de bloques
      # icon: el icono que estara en www/img
      # title: el titulo
   )
)
   
HomePage = R6::R6Class("HOME.PAGE"
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,portable   = FALSE
   ,public = list(
      initialize = function(tabs) {
         private$panels = tabs
         nm = unlist(lapply(tabs, function(tab) tab$event))
         names(private$panels) = nm
         private$panels = list.append(private$panels, home=list(title="Home", loaded=TRUE))
         dirs = list.dirs("..", recursive=FALSE)
         private$apps = lapply(dirs, function(path) private$loadApp(path))
      }
      ,loadPanel = function(panel) {
         if (private$panels[[panel]]$loaded) return (NULL)
         private$panels[[panel]]$loaded = TRUE
         appOK = unlist(lapply(private$apps, function(app) panel %in% app$groups))
         private$apps[appOK]
      }

   )
   ,private = list(
       panels = NULL
      ,apps   = NULL
      # El JSON sera nombre_app.json y debe tener:
      # groups: la lista de bloques
      # icon: el icono que estara en www/img
      # title: el titulo
      ,loadApp = function(path) {
         toks = strsplit(path, "[/\\]")
         AppInfo$new(toks[[1]][[2]])
      }
      
   )
)
tabs = list(
   list(title="Books",     event="books",    icon="book01.jpg",      loaded=FALSE)
   ,list(title="Apps",     event="apps",     icon="code01.jpg",      loaded=FALSE)   
   ,list(title="Notes",    event="notes",    icon="notebook01.jpg",  loaded=FALSE)
   ,list(title="Articles", event="articles", icon="newspaper01.jpg", loaded=FALSE)
   ,list(title="Tools",    event="tools",    icon="wheels01.jpg",    loaded=FALSE)
   ,list(title="Others",   event="other",    icon="matrix02.jpg",    loaded=FALSE)
   )

home = HomePage$new(tabs)