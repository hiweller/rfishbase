setwd('/Users/hannah/Dropbox/Westneat_Lab/FishImages/')

# uncomment if rfishbase is not installed:
# install.packages("rfishbase",
#                  repos = c("http://packages.ropensci.org", "http://cran.rstudio.com"),
#                  type="source")

# dependencies
library('rfishbase')

# set fish families
# families <- c("Chaetodontidae", "Pomacentridae", "Labridae")
families <- c("Scaridae", "Odacidae")

fishbase_search <- function(families, save = FALSE) {
  # diet data is pulled from fooditems table, size and depth ranges are pulled from species table
  diet_fields <- c("FoodI", "FoodII", "FoodIII", "sciname", "PredatorStage", "Commoness")
  size_depth_fields <- c("DepthRangeShallow", "DepthRangeDeep", "Length", "CommonLength", "sciname") 
  
  species_names <- list()
  diet_info <- list()
  size_depth_info <- list()
  species_info <- list()
  
  for (i in 1:length(families)) {
    # get names of species for specified family
    species_names[[i]] <- species_list(Family = families[i])
    
    # store diet data in diet_info list, one element per family with rows as species
    # often has more than one row per species if there are multiple diet studies
    diet_info[[i]] <- fooditems(species_names[[i]], fields = diet_fields)
    
    # store size and depth info in size_depth_info list, similar
    size_depth_info[[i]] <- species(species_names[[i]], fields = size_depth_fields)
    
    # combine diet and size/depth info (will be longer than number of species due to diet data)
    species_info[[i]] <- merge(diet_info[[i]], size_depth_info[[i]])
    
    # save one csv per family in current working directory
    if (save == TRUE) {write.csv(species_info[[i]], paste(families[i], ".csv", sep=""))}
  }
  return(species_info)
} 

fishbase_search(families = families, save = TRUE)
