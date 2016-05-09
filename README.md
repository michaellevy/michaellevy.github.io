# My site

This is my personal professional website, rendered at [michaellevy.name](michaellevy.name), and built on the [skinny bones](https://mmistakes.github.io/skinny-bones-jekyll/) foundation.

## Notes to self

- Blog teaser images should be 1.5:1 width:height. These are used in Twitter cards.

- For local build: Comment out the url in `_config.yml`

**MathJax**: 

- Inline: \\(x + 1\\)
- Display mode: \\[x + 1\\] or $$x + 1$$

### RMarkdown blogging

- .Rmd files go in _Rmd
- source Rutils/knitpost
- call knitpost('file-name') or knitAll()
- .md file should land in _posts/blog/
- On `bundle exec jekyll build`, .html should end up in _site/blog/new-post_title/index.html
- image paths are specified as images/, so specify, e.g. as blog/my-image.png