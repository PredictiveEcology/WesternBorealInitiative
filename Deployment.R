# 1. make changes to the source files in the ./website folder
# 2. render the R Markdown pages
od <- setwd("website")
rmarkdown::render_site()
setwd(od)
# 3. check the site (./docs folder) in the browser
browseURL("docs/index.html")
# 4. if all looks good, commit the changes
# 5. this will trigger the GitHub action that deploys the content
