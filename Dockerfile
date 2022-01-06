# get the base image, the rocker/verse has R, RStudio and pandoc
FROM rocker/verse:4.1.2

# required
MAINTAINER Isak Roalkvam <isak.roalkvam@iakh.uio.no>

COPY . /exploring-assemblages-se-norway

# go into the repo directory
RUN . /etc/environment \
  # Install linux depedendencies here
  # e.g. need this for ggforce::geom_sina
  && sudo apt-get update \
  && sudo apt-get install libudunits2-dev -y \
  # build this compendium package
  && R -e "devtools::install('/exploring-assemblages-se-norway', dep=TRUE)" \
  # render the manuscript into a docx, you'll need to edit this if you've
  # customised the location and name of your main Rmd file
  && R -e "rmarkdown::render('/exploring-assemblages-se-norway/analysis/paper/paper.Rmd')"
