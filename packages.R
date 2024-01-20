# packages.R
install_and_load <- function(package) {
  if (!require(package, character.only = TRUE)) {
    install.packages(package, dependencies = TRUE)
    library(package, character.only = TRUE)
  }
}

# List of required packages
packages <- c(
  "shiny",
  "shinythemes",
  "shinyWidgets",
  "shinyTime",
  "DT",
  "tidyverse",
  "stringr",
  "lubridate",
  "shinydashboard",
  "shinyjs",
  "plotly",
  "ggplot2",
  "shinyFiles"
)

# Install and load each package
lapply(packages, install_and_load)