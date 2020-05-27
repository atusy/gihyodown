#' Gihyo Flavored Markdown
#'
#' This R Markdown format is based on `rmarkdown::github_document`.
#' Main changes are
#' (1) usage of custom tempalte,
#' (2) line breaks are ignored instead of treated as hard line breaks,
#' (3) support cross reference like bookdown,
#' (4) echoes and results are styled by REPL-like format,
#' (5) figures are saved under img directory
#'
#' Cross reference can be configured via YAML frontmatter.
#' For example, if `(#fig:foo)` should be rendered as `Figure 2.1`,
#' then setup the YAML below. Keys for `labels` can be any.
#' In other words, users can define original ones.
#'
#' ``` yaml
#' output: gihyodown::gihyo_document
#' crossref:
#'   section: 2
#'   labels:
#'     fig: "Figure "
#'     tab: "Table "
#'     eqn: "Equation "
#' ```
#'
#' @inheritParams rmarkdown::github_document
#' @param ... Arguments passed to `md_document`
#' @export
gihyo_document <- function(
  md_extensions = NULL,
  pandoc_args = NULL,
  html_preview = TRUE,
  ...
) {
  base_format = rmarkdown::github_document(
    md_extensions = c("+ignore_line_breaks", md_extensions),
    pandoc_args = c(
      "--wrap=none",
      "--lua-filter", system_file("lua", "crossref.lua")
    ),
    hard_line_breaks = FALSE,
    html_preview = TRUE,
    ...
  )

  # substitute template
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
