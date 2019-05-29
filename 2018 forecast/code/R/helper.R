# load ----
install.packages("devtools")
devtools::install_github("ben-williams/FNGr")
library("FNGr")
if(!require("mosaic"))   install.packages("mosaic") # derivedFactor, derivedVariable. masks over a lot of fxns, but generally only improves their utility
if(!require("tidyverse"))   install.packages("tidyverse") # dplyr, ggplot, etc.
if(!require("lubridate"))   install.packages("lubridate") # dates functions like yday, dmy/mdy
if(!require("data.table"))   install.packages("data.table") # dcast, foverlaps
if(!require("knitr"))   install.packages("knitr") # r markdown
if(!require("cowplot"))   install.packages("cowplot") # plot_grid and so much else
if(!require("R2admb"))   install.packages("R2admb") # run admb from r
if(!require("ggthemes"))   install.packages("ggthemes") # access to 150 colour palettes from canva.com design school, among other things
if(!require("scales"))   install.packages("scales") # add comma to ggplot axis with scale_y_countinuous(label = comma)
if(!require("ggrepel"))   install.packages("ggrepel") # readable labels with geom_text_repel()
if(!require("gridExtra"))   install.packages("gridExtra") #  arrange multiple grid-based plots on a page, and draw tables. 
if(!require("captioner"))   install.packages("captioner") #numbering, ordering, & creating captions for tables and figures
if(!require("reshape2"))   install.packages("reshape2") #transforms data
if(!require("ggplot2"))   install.packages("ggplot2") #ggplot
if(!require("grid"))   install.packages("grid") #grid graphics
if(!require("xlsx"))   install.packages("xlsx") # creates an excel workbook
if(!require("dplyr"))   install.packages("dplyr") #convenient way to manipulate dataframes 
if(!require("reshape"))   install.packages("reshape") #transforms data
if(!require("gtools"))   install.packages("gtools") #gplot
if(!require("extrafont"))   install.packages("extrafont") #allows greater choices for font
if(!require("stringi"))   install.packages("stringi") # allows for fast, correct, consistent, portable, as well as convenient character string/text processing 
if(!require("lattice"))   install.packages("lattice") #trellis graphics for R
if(!require("scales"))   install.packages("scales") #graphical scales map data to aesthetics, and provide methods for automatically determining breaks and labels for axes and legends
if(!require("plyr"))   install.packages("plyr") #
if(!require("tidyr"))   install.packages("tidyr")
if(!require("latticeExtra"))   install.packages("latticeExtra")
if(!require("MASS"))   install.packages("MASS")
if(!require("survival"))   install.packages("survival")
if(!require("scatterplot3d"))   install.packages("scatterplot3d")
if(!require("vcd"))   install.packages("vcd")
if(!require("grid"))   install.packages("grid")
if(!require("calibrate"))   install.packages("calibrate")
if(!require("RColorBrewer"))   install.packages("RColorBrewer")
if(!require("Hmisc"))   install.packages("Hmisc")

loadfonts(device="win")
windowsFonts(Times=windowsFont("Times New Roman"))
theme_set(theme_sleek())


# Depends on dplyr
tickr <- function(
  data, # dataframe
  var, # column of interest
  to # break point definition 
){
  
  VAR <- enquo(var) # makes VAR a dynamic variable
  
  data %>% 
    distinct(!!VAR) %>%
    ungroup(!!VAR) %>% 
    mutate(labels = ifelse(!!VAR %in% seq(to * round(min(!!VAR) / to), max(!!VAR), to),
                           !!VAR, "")) %>%
    select(breaks = UQ(VAR), labels)
}
