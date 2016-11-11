setwd('/Users/hannah/Dropbox/Westneat_Lab/RFishBase/')
# modifying search function to allow either for a list of species or a list of families
# uncomment if rfishbase is not installed:
# install.packages("rfishbase",
#                  repos = c("http://packages.ropensci.org", "http://cran.rstudio.com"),
#                  type="source")

# dependencies
library('rfishbase')

Labrid <- c(species_list(Family = "Labridae"), species_list(Family = "Scaridae"), species_list(Family = "Odacidae"))
Pomacentrid <- c(species_list(Family = "Pomacentridae"))
cladeList <- list(Labrid, Pomacentrid)
names(cladeList) <- c("Labridae", "Pomacentridae")

fishbase_search <- function(cladeList, save = FALSE) {
  # diet data is pulled from fooditems table, size and depth ranges are pulled from species table
  diet_fields <- c("FoodI", "FoodII", "FoodIII", "sciname", "PredatorStage", "Commoness")
  size_depth_fields <- c("DepthRangeShallow", "DepthRangeDeep", "Length", "CommonLength", "sciname") 
  
  diet_info <- list()
  size_depth_info <- list()
  species_info <- list()
  
  for (i in 1:length(cladeList)) {
    species_names <- cladeList[[i]]
    
    # store diet data in diet_info list, one element per family with rows as species
    # often has more than one row per species if there are multiple diet studies
    diet_info[[i]] <- fooditems(species_names, fields = diet_fields)
    
    # store size and depth info in size_depth_info list, similar
    # size_depth_info[[i]] <- species(species_names, fields = size_depth_fields)
    
    if (save == TRUE && is.null(names(cladeList)) == FALSE) {
      write.csv(diet_info[[i]], paste(names(cladeList)[i], 'Diet.csv', sep=""))
      # write.csv(size_depth_info[[i]], paste(names(cladeList)[i], 'SizeDepth.csv', sep=""))
    } else if (save == TRUE && is.null(names(cladeList)) == TRUE) {
      # write.csv(size_depth_info[[i]], paste('Output', i, 'SizeDepth.csv', sep=""))
      write.csv(diet_info[[i]], paste('Output', i, 'Diet.csv', sep=""))
      message("No names provided for CSV files; results saved with generic Output name")
    }
    
    # combine diet and size/depth info (will be longer than number of species due to diet data)
    # species_info[[i]] <- merge(diet_info[[i]], size_depth_info[[i]])
    
  }
  # return(species_info)
  # return(size_depth_info)
} 

test <- fishbase_search(cladeList, save = TRUE)
