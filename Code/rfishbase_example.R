library("ape")
library("phytools")
install.packages("rfishbase", 
                 repos = c("http://packages.ropensci.org", "http://cran.rstudio.com"), 
                 type="source")
library('rfishbase')

# Make a list of species to use in FishBase search

specieslist <- c("Acanthochaenus luetkenii", "Acanthurus nigricans" )

    # OR 

specieslist <- tree$tip.label
specieslist <- gsub("_"," ",specieslist) 

# Download all of the data in the "Species Table" on FishBase for each species

fbdata <- species(specieslist) # This took ~3 mins to run with 265 taxa
fbdata

# Extract whatever data you need from the table

ls(fbdata) # List of things you can export for each species

marine <- fbdata$Saltwater # As an example, this tells you whether the fish is found in saltwater (0 = no, -1 = yes)

# If you're mapping data to a tree, here's how to reformat for most character analyses

genus_species <- paste(fbdata$Genus, '_', fbdata$Species, sep="")
names(marine) <- genus_species
marine

# e.g., a stochastic character map

simmap <- make.simmap(tree,marine)
plotSimmap(simmap)

