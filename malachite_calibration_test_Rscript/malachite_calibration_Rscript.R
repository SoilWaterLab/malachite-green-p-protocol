# Malachite Green Calibration Script
# Last updated Oct 2, 2016
# Contact: Sheila Saia (sms493@cornell.edu)
#
#
# load libraries
library(dplyr)
#
# set working directory (windows compatable)
setwd("C://Users//sheila//Dropbox//PhD//O18isotopes//malachite_calibration_test_Rscript")
#
# reformat data from Tecan plate reader by copying/pasting (without headers or row names) it into a csv file and loading into R
data=read.table("test_malachite_data.csv",sep=",",header=F)
#
# standards (assumes standards are in wells A1-A8)
standardslots=8 #number of standards
stand.data=data.frame(stdabs=rep(0,standardslots),voladded_ul=rep(0,standardslots)) #create data frame for standards
stand.data$stdabs=t(data[1,1:standardslots]) #standard abs values (Tecan reports the mean of 10 readings)
stand.data$voladded_ul=c(0,20,40,60,80,100,120,200) #known volume of 1ppm standard added then topped off to 200 ul
stand.data$conc_ppmP=c(0,0.1,0.2,0.3,0.4,0.5,0.6,1) #known concentrations of standards
#
# fit standards with a linear model
lm=lm(conc_ppmP~stdabs,data=stand.data)
#
# print summary to check
summary(lm)
#
# save linear model parameters for plotting
intercept=summary(lm)$coefficients[1,1]
slope=summary(lm)$coefficients[2,1]
rsquared=summary(lm)$r.squared #should be 0.999 or better
#
# plot line and observations for standard curve
plot(conc_ppmP~stdabs,data=stand.data,pch=16,xlab="Absorbance",ylab="Known PO4 as P Concentration (ppm)",
        main=paste("y =",round(slope,4),"x + ",round(intercept,4),", r-squared =",round(rsquared,4), sep=" "))
abline(a=intercept,b=slope,col="red",lwd=3)
#
# select all code from lines 41 to 53 and run to save the funcditon reformat.samp.data into memory
# NOTE: this script assumes standards will fill the first row (A1-A12) and all samples are read in triplicate across the row, 
# please plan ahead to follow this organization
reformat.samp.data=function(mydata,numsampslots) {
    samp.data=data.frame(assay_id=rep(0,numsampslots),abs=rep(0,numsampslots)) #create data frame for sample data
    datatransp=as.data.frame(t(mydata)) #transpose dataframe if samples are across rows
    samp.data=data.frame(assay_id=rep(0,numsampslots),abs=rep(0,numsampslots)) #create data frame for sample data
    strt=1 #start iterator outside loop to keep track of samples
    for (i in 2:dim(datatransp)[2]) { #start with 2 because we assume the first transposed column is all standards
      end=strt+11
      samp.data$abs[strt:end]=datatransp[,i]
      strt=strt+12 #add 12 to iterator
    }
    return(samp.data)
}
#
# use function now with data
sampslots=96-12 # just assume standards take up the whole row (if not then use next line below)
#sampslots=96-standardslots #for a ninety-six well plate minus the number of standards
samp.data=reformat.samp.data(data,sampslots) #set number of standards to 12 because just assume the whole first row is taken up
#
# define assay_num in samp.data (need to link samp.data and soilwts using assay_id)
numofsamp=30 # number of samples goes here
assayidlst=seq(1:numofsamp)
numofreps=3 # number of times you read the sample (i.e., technical replicates - at least three are recommended)
numrepspersamp=c(rep(c(3,3,2),numofsamp/numofreps)) # number of repititions you analyze each sample (A and B have 3 reps, C has 2 reps)
#
# need to define assay_id for samp.data
strt=1
for (i in 1:numofsamp) {
  end=strt+numrepspersamp[i]-1
  samp.data$assay_id[strt:end]=rep(assayidlst[i],numrepspersamp[i])
  strt=strt+numrepspersamp[i]
}
#
# calculate raw concentration
samp.data$raw_conc_ppmP=samp.data$abs*slope+intercept
#
# set working directory for soil weights data (if necessary)
setwd("C://Users//sheila//Dropbox//PhD//O18isotopes//bonn_soil_analysis")
#
# load in soil weight data
# note: If users are measuring phosphate in water samples this file only needs to include the assay_ID and
# SampleID columns, where the assay_ID indicates the integer number of the sample on the plate and the
# SampleID indicates the code the researchers descriptive identifier (e.g. treatment or site identification number).
soilwts=read.table("bonn_hedley1_soil_weights.txt",sep="\t",header=T)
#
# join soilwts and samp.data
joindata=left_join(samp.data,soilwts,by="assay_id")
#
# calculate P in mg/kg using soil weight data
volsolnadded=30 #volume of solution added for extraction (ml)
dilution=200 #dilution multiple i.e. 10x dilution is represented as 10
joindata$Pconc_mgperkg=joindata$raw_conc_ppmP*(volsolnadded/joindata$dry_soil_added_g)*dilution
#
# calc umol for 18O isolation of soil P extractions (need at least 30 umol for downstream analysis)
# note: If users are measuring phosphate in water samples they can skip this step
phosphatemolwt=95 #95 g of phosphate = 1 mol
joindata$Pconc_umol=(joindata$Pconc_mgperkg*joindata$dry_soil_added_g)/phosphatemolwt
#
# summarize by averaging technical replicates for each sample
# note: If users are measuring phosphate in water samples they may only want to average raw_conc_ppmP
avgdata=joindata %>% group_by(bonn_sample_id,SampleID,SiteID,Rep) %>% na.omit() %>%
  summarize(avgPconc_ppm=mean(raw_conc_ppmP),stdPconc_ppm=sd(raw_conc_ppmP),
            avgPconc_mgperkg=mean(Pconc_mgperkg),stdPconc_mgperkg=sd(Pconc_mgperkg),avgPconc_umol=mean(Pconc_umol))
#
# export avgdata for further analysis
setwd("C://Users//sheila//Dropbox//PhD//O18isotopes//malachite_calibration_test_Rscript") # change directory back to print here
write.table(avgdata,file="malachite_test_calibrated.txt",sep="\t")

