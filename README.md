
# gihyodown

## Installation

1. Setup Personal Access Token (cf. <https://usethis.r-lib.org/articles/articles/usethis-setup.html#get-and-store-a-github-personal-access-token-1>)

2. Run

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
---
```

