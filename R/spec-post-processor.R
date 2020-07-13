spec_post_processor <- function(gray_preview) {
  force(gray_preview)

  function(metadata, input_file, output_file, clean, verbose) {
    preview_format <- rmarkdown::html_document(
      highlight = if (gray_preview) "monochrome" else "default",
      css = if (gray_preview) system_file("css", "html-preview.css"),
      pandoc_args = c(
        "--metadata", sprintf('title="%s"', metadata$title)
      )
    )

    rmarkdown::render(
      output_file,
      output_format = preview_format,
      output_file = xfun::with_ext(output_file, "html")
    )

    output_file
  }
}
