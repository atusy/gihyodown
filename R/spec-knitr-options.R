spec_knitr_options <- function() {
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
