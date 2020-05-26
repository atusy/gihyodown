#' Gihyo Flavored Markdown
#' @inheritParams rmarkdown::md_document
#' @param ... Arguments passed to `md_document`
#' @export
gihyo_document <- function(
  md_extensions = NULL,
  pandoc_args = NULL,
  ...
) {
  base_format = rmarkdown::md_document(
    variant = "gfm",
    md_extensions = c("+ignore_line_breaks", ...),
    pandoc_args = c(
      "--template", system_file("template", "template.md"),
      "--wrap=none",
      "--lua-filter", system_file("lua", "crossref.lua")
    ),
    ...
  )

  knitr_options = rmarkdown::knitr_options(
    opts_chunk = list(
      fig.path = 'img/',
      prompt = TRUE,
      collapse = TRUE,
      comment = ''
    ),
    opts_hooks = list(
      fig.cap = function(options) {
        options$fig.cap = sprintf(
          "(#fig:%s) %s", options$label, options$fig.cap
        )
        options
      }
    )
  )

  rmarkdown::output_format(
    knitr = knitr_options,
    pandoc = NULL,
    clean_supporting = FALSE,
    base_format = base_format
  )
}

system_file = function(..., package = "gihyodown") {
  system.file(..., package = package)
}
