#' Gihyo Flavored Markdown
#' @inheritParams rmarkdown::md_document
#' @param ... Arguments passed to `md_document`
#' @export
gihyo_document <- function(
  md_extensions = NULL,
  pandoc_args = NULL,
  ...
) {
  base_format = rmarkdown::github_document(
    md_extensions = c("+ignore_line_breaks", md_extensions),
    pandoc_args = c(
      "--wrap=none",
      "--lua-filter", system_file("lua", "crossref.lua")
    ),
    hard_line_breaks = FALSE,
    ...
  )

  index_template = which(base_format$pandoc$args == "--template")
  template = system_file("template", "template.md")
  if (length(index_template) == 1L) {
    base_format$pandoc$args[index_template + 1L] = template
  } else {
    base_format$pandoc$args = c(base_format$pandoc$args, "--template", template)
  }

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
