
######## INSTALLING PACKAGES TO GET MYRMIDON API - R BINDINGS

# R bindings are located in bindings/R. There are two options to install them in your local R installation. 
# Both of them required the devtools R package. Install from github:
# install.packages("devtools", lib="~/R/lib")

# install.packages("libssh2")
# devtools::install_git("https://github.com/formicidae-tracker/studio.git",subdir = "bindings/R/FortMyrmidon")

library("devtools")
library("FortMyrmidon")
packageVersion("FortMyrmidon") # check that version is ‘0.4.1’
?FortMyrmidon 

######## DOCUMENTATION

# https://formicidae-tracker.github.io/studio/docs/latest/api/


getwd()
setwd("/home/adriano/Desktop/")
rm (list=ls())

######## PLAYING WITH DATA

# opens an experiment in read-only mode
e <- fmExperimentOpenReadOnly("Starvation_exp_11_02_2020_AW.myrmidon")

# Statistics about a fort::myrmidon::TagID in the experiment.
tagStats <- fmQueryComputeTagStatistics(e)

# To compute the tag rate detection:
  e <- fmExperimentOpenReadOnly(experiment)
nbFrames <- e$getDataInformations()$frames

tagStats$CountRate <- tagStats$Count / nbFrames
# rm(e); gc(); #close experiment

# gets all Ant positionS from the specified date until the end of the experiment
# the output is a list structured in sublists, one per each frame, containing a dataframe ("data") with all the ants tracked in that specific frame
positions <- fmQueryIdentifyFrames(e,
                                  start = fmTimeParse("2020-02-11T13:58:49.706453Z"))

#access lists of frame 20 from time start
positions[[20]] # double bracket to access the elements of the list
positions[[20]]@data # The @ operator is used to access named slots in an S4 type object.
positions[[1]]@frameTime-positions[[9]]@frameTime

angles  <- lapply( positions , function(x) `@`( x , data)[[4]] ) #gets list of fourth column of data -angle- per each frame
angles[[1]]




# Computes interactions for fort::myrmidon::Ant. Those will be reported ordered by ending time.
interactions <- fmQueryComputeAntInteractions(e,
                                              #  start = "2020-02-11T11:53:26.790610Z", #atm it works only without the start and stop
                                              # end = "2020-02-11T12:53:52.685287Z",
                              maximumGap = fmSecond(1),
                              matcher = NULL,
                              singleThreaded = FALSE,
                              showProgress = FALSE,
                              reportTrajectories = TRUE) #when TRUE, the file size doubles
rm(e); gc(); #close experiment

head(interactions)
plot(interactions[["trajectories"]][[7]]@positions[["X"]], interactions[["trajectories"]][[7]]@positions[["Y"]],type = "b")
  
# antID seems to be reported in decimal rather then hex
install.packages("broman")
library("broman")

hex2dec(0x003)
dec2hex(63)

# attempt to access interactions[["interactions"]][[1]]@ant1Trajectory@positions[["X"]] in every list
test.1  <- lapply( interactions[["interactions"]] , function(x) `@`( x , start)[[1]] )
test.1a  <- lapply( interactions[["interactions"]]$positions , function(x) `@`( x , X)[[1]] ) #why it doesn't work???

test.2 <- sapply(unlist(interactions[["interactions"]]$ant1Trajectory, recursive = FALSE), `[[`, "ant")
