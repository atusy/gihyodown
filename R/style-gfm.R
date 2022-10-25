#' Style R code blocks in gihyo-flavored markdown file
#'
#' @param path Paths to markdown files
#' @param ... Arguments passed to `styler::style_file()`
#'
#' @export
style_gfm <- function(path, ...) {
  lapply(path, style_gfm_one)
  return(path)
}

style_pandoc <- function(input, output, ...) {
  rmarkdown::pandoc_convert(
    input, to = "gfm", from = "gfm", output = output,
    options = c(..., "--wrap=none")
  )
}

style_gfm_one <- function(path, ...) {
  md <- tempfile(fileext = ".Rmd")
  file.copy(path, md, overwrite = TRUE)
  style_pandoc(
    md, md,
    "--lua-filter", system_file("lua", "chunkify.lua")
  )
  styler::style_file(md, ...)
  style_pandoc(
    md, md,
    "--lua-filter", system_file("lua", "unchunkify.lua")
  )
  file.copy(md, path, overwrite = TRUE)
}
