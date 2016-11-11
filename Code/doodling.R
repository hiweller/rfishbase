setwd('/Users/hannah/Dropbox/Westneat_Lab/RFishBase/')
library(rfishbase)
# Aquarium? Captured or bred in captivity?
speciesFields <- c("Aquarium", "AquariumFishII", "Importance", 
                   "DepthRangeDeep", "DepthRangeShallow", 
                   "Length", "CommonLength", "BodyShapeI",
                   "DemersPelag", "Vulnerability", "LongevityWild", 
                   "Weight", "PriceCateg", "PriceReliability", "Comments")

# Endangered? Resilience?
stockFields <- c("IUCN_Code", "Resilience", "PriceCateg")

wrassFamilies <- c("Labridae", "Scaridae", "Odacidae")
wrasses <- lapply(wrassFamilies, function(x) species_list(Family = x))
wrasses <- unlist(wrasses)
getInfo <- function(speciesList) {
  speciesTable <- species(speciesList, fields = speciesFields)
  stockTable <- stocks(speciesList, fields = stockFields)
  outputTable <- merge(stockTable, speciesTable)
  return(outputTable)
}
wrasseData <- getInfo(wrasses)
write.csv(wrasseData, file = './Output/wrasseData_09-06-2016.csv')

depthDeep <- is.na(wrasseData$DepthRangeDeep)
depthShallow <- is.na(wrasseData$DepthRangeShallow)
lengths <- is.na(wrasseData$Length)

write.csv(x=wrasseData[(depthDeep | depthShallow | lengths), c(1, 7:8, 11)], file = './wrasseMissing.csv')

missingFound <- read.csv('./Output/wrasseMissing.csv')[,-1]
wrasseData <- read.csv('./Output/wrasseData_09-06-2016.csv')[,-1]
missingNames <- missingFound$sciname
allNames <- wrasseData$sciname
wrasseData$Source <- rep("Fishbase", dim(wrasseData)[1])

# sciname: 1
# DepthRangeShallow: 7
# DepthRangeDeep: 8
# Length: 11

matches <- which(allNames %in% missingNames)
for (i in 1:length(matches)) {
  j <- matches[i]
  wrasseData$DepthRangeShallow[j] <- missingFound$DepthRangeShallow[i]
  wrasseData$DepthRangeDeep[j] <- missingFound$DepthRangeDeep[i]
  wrasseData$Length[j] <- missingFound$Length[i]
  wrasseData$Source[j] <- missingFound$Source[i]
}
write.csv(wrasseData, file = './Output/wrasseData_09-12-2016.csv')

# for every match:
# replace col. 7 from wrasseData with col. 2 from missingFound
# replace col. 8 from wrasseData with col. 3 from missingFound
# replace col. 11 from wrasseData with col. 4 from missingFound
# replace wrasseData$Source with missingFound$Source

fam = "Sparidae"
spec <- species_list(Family = fam)
