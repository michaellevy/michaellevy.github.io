# buildAll = function() {
#     lapply(files in _Rmd, knitPost, autoOverwrite = TRUE)
# }

knitPost <- function(file, ..., highlight = "pygments", sitePath = '~/Dropbox/website/') {
    
    require('knitr')
    # File is like "fileName", which should be a .Rmd in sitePath/_Rmd
    # Corresponding .md file will be placed in sitePath/_posts/blog, with date prepended

    oldwd = getwd()
    setwd(sitePath)
    
    ## Blog-specific directories.  This will depend on how you organize your blog.
    rmdPath <- paste0(sitePath, "_Rmd") # directory where your Rmd-files reside (relative to base)
    mdPath <- paste0(sitePath, "_posts/blog") # directory for converted markdown files
    figDir <- file.path("assets/Rfig", file, '/') # directory to save figures
    cachePath <- paste0(sitePath, "_cache") # necessary for plots
    
    # Make sure the .Rmd file is found
    if(!grepl('\\.Rmd', file))
        file = paste0(file, '.Rmd')
    if(!file %in% list.files(rmdPath))
        stop(paste(file, "not found in", rmdPath))
    
    render_jekyll(highlight)
    opts_knit$set(base.url = '/', baseDir = sitePath)
    opts_chunk$set(fig.path = figDir, cache.path = cachePath, 
                   fig.width=8.5, fig.height=5.25, dev='svg')
    # , cache=F, warning=F, message=F, tidy=F
    
    mdFile = paste0(format(Sys.time(), '%Y-%m-%d'), '-', gsub('\\.Rmd', '\\.md', file))
    
    # If the corresponding .md file is there, ask the user whether to overwrite
    if(mdFile %in% list.files(mdPath)) {
        ow = readline(prompt = paste(mdFile, 'exists. Overwrite? (y/n): '))
        if(!ow %in% c('y', 'yes', 'Y'))
            return(message('Okay, nothing written.'))
    }

    fileWritten = 
        knit(input = file.path(rmdPath, file),
             output = file.path(mdPath, mdFile),
             envir = parent.frame(), 
             quiet = TRUE)
    
    message(paste('File written:', fileWritten))
    setwd(oldwd)

}