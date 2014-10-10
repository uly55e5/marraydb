textareaInput <- function(inputId, value="", nrows=3, ncols=80) {
  tagList(
    singleton(tags$head(tags$script(src = "js/textarea.js"))),
    tags$textarea(id = inputId,
                  class = "textarea",style="width:auto;",
                  rows = nrows,
                  cols = ncols,
                  as.character(value))
  )
}