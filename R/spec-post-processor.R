html_preview <- function(
  gray_preview = TRUE,
  highlight = if (gray_preview) "monochrome" else "default",
  css = if (gray_preview) system_file("css", "html-preview.css"),
  toc = TRUE,
  pandoc_args = c(
    "--metadata", sprintf('title="%s"', metadata$title), "--mathjax",
    "--lua-filter", system_file("lua", "crossref.lua")
  ),
  ...
) {
  rmarkdown::html_document(
    highlight = highlight, css = css, toc = toc, pandoc_args = pandoc_args, ...
  )
}


spec_post_processor <- function(gray_preview, extra_args = list()) {
  force(gray_preview)
  force(extra_args)

  function(metadata, input_file, output_file, clean, verbose) {
    extra_args$pandoc_args <- c(
      extra_args$pandoc_args,
      "--metadata", sprintf('title="%s"', metadata$title),
      "--mathjax",
      "--lua-filter", system_file("lua", "crossref.lua")
    )

    rmarkdown::render(
      input_file,
      output_format = do.call(html_preview, extra_args),
      output_file = xfun::with_ext(output_file, "html")
    )

    output_file
  }
}
