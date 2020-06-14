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
#' @param gray_preview Whether to preview in gray scale.
#' @param ... Arguments passed to `md_document`
#' @export
gihyo_document <- function(
                           md_extensions = NULL,
                           pandoc_args = NULL,
                           html_preview = TRUE,
                           gray_preview = TRUE,
                           ...) {
  base_format <- rmarkdown::md_document(
    md_extensions = c("+ignore_line_breaks", md_extensions),
    pandoc_args = c(
      "--wrap=none",
      "--lua-filter", system_file("lua", "crossref.lua"),
      "--template", system_file("template", "template.md")
    ),
    variant = "gfm",
    ...
  )

  rmarkdown::output_format(
    knitr = knitr_gihyo_options(),
    pandoc = NULL,
    clean_supporting = FALSE,
    post_processor =
      if (html_preview) post_processor(keep_html, gray_preview),
    base_format = base_format
  )
}

knitr_gihyo_options <- function() {
  rmarkdown::knitr_options(
    opts_chunk = list(
      fig.path = "img/",
      prompt = TRUE,
      collapse = TRUE,
      comment = ""
    ),
    knit_hooks = list(
      plot = function(x, options) {
        options$fig.cap <-
          sprintf("(#fig:%s) %s", options$label, options$fig.cap)
        knitr::hook_plot_md(x, options)
      }
    )
  )
}

post_processor <- function(keep_html, gray_preview) {
  force(keep_html)

  function(metadata, input_file, output_file, clean, verbose) {
    rmarkdown::render(
      output_file,
      output_format = rmarkdown::html_document(
        highlight = if (gray_preview) "monochrome" else "default",
        css = if (gray_preview) system_file("css", "html-preview.css")
      ),
      output_file = xfun::with_ext(output_file, "html")
    )

    output_file
  }
}

system_file <- function(..., package = "gihyodown") {
  system.file(..., package = package)
}
