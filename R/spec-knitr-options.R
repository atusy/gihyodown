spec_knitr_options <- function() {
  rmarkdown::knitr_options(
    opts_chunk = list(
      fig.path = "img/",
      prompt = FALSE,
      collapse = FALSE,
      comment = "",
      class.output = "result",
      class.message = "result",
      class.warning = "result",
      class.error = "result",
      R.options = list(
        width = 72
      )
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
