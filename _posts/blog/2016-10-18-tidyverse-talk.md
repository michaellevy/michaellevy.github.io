---
layout: media
title: "Tidyverse Tutorial"
excerpt: "Talk walking through features of the tidyverse packages for R. Plus R Notebooks."
modified: 2016-10-18
categories: blog
tags: [teaching, rstats, D-RUG]
comments: true
image:
  feature:
  teaser: blog/tidyverse/augment.png
---

Last week, I gave an overview of bunch of tidyverse packages (tibble, dplyr, tidyr, ggplot, readr, purrr) to the [Davis R-Users' Group](https://d-rug.github.io/). Here is that talk (and since videos don't display everywhere this blog is syndicated, [here is the YouTube link](https://www.youtube.com/watch?v=9q7gssUP8UA)). 

I mention early in the talk that the `github_markdown` specification in the YAML header produces a conveniently GitHub-renderable markdown file -- [here that is if you'd like to follow along](https://github.com/michaellevy/tidyverse_talk/blob/master/tidyverse.md), or you can download the [rendered R Notebook (nb.html) file](https://github.com/michaellevy/tidyverse_talk/blob/master/tidyverse.nb.html), which itself includes the R Markdown file (Awesome! In the upper right of the html file, click "Code" -> "Download Rmd").

<iframe width="560" height="315" src="https://www.youtube.com/embed/9q7gssUP8UA" frameborder="0" allowfullscreen></iframe>


One final note, on the speed of tidyverse functions. Some tidyverse functions really do offer a speed advantage over base R (e.g. `read_csv` and `filter`), but the `map` speed advantage I mention here over `lapply` seems to be an artifact of both being wrapped in a `map2` call in a `data_frame` call. They are actually equally fast. In my mind, the benefit of the tidyverse is that it makes R easier to write and read, which makes it less bug-prone and more approachable for beginners. It does that without imposing a speed penalty, and in some cases provides a little acceleration as a bonus. 
