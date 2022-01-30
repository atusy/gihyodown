
# gihyodown

## Installation

``` r
remotes::install_github("atusy/gihyodown")
```

## Example

Write YAML front matter with following variables.

```yaml
---
section: 1
title: Title
author: Author
summary: Summary
output: gihyodown::gihyo_document
crossref:
  section: 2 # This will prepend section number to figure/table numbers (e.g., 図2.1)
---
```

