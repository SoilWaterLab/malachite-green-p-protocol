# README for malachite-green-p-protocol #
Last updated: Oct. 2, 2016<br>
Contact: Sheila Saia<br>
Email: sms493@cornell.edu<br>
Contents: Protocol document (malachite\_green\_protocol.docx) and directory (malachite\_calibration\_test\_Rscript) with example R script for calibration of plate reader data.

## Protocol Document ##
File name: malachite\_green\_protocol.docx<br>
Description: This document describes the step by step malachite green protocol for analysis of phosphate (as P) in a soil sample using a plate reader. This method can also be used for analysis of water samples.

## Example Calibration Script Directory ##
Directory name: malachite\_green\_protocol.docx
Directory contents: malachite\_calibration\_Rscript.R, test\_malachite\_rawdata.xlsx, test\_malachite\_data.csv, test\_soil\_weights.txt, malachite\_test\_calibrated.txt

### malachite\_calibration\_Rscript.R file ##
Description: This file takes in the raw plate reader data (test\_malachite\_data.csv), calculates the standard curve, calibrates the raw data, takes in the soil weight data (test\_soil\_weights.txt), and exports a table (malachite\_test\_calibrated.txt) with data in units of ppm of P, mg/kg of P, and umols of P for each sample. The calculation of umols of P for each samples is needed for downstream 18O-analysis of soil P extractions.

### test\_malachite\_rawdata.xlsx file ###
Description: Example output file from the plate reader.

### test\_malachite\_data.csv file ###
Description: Raw data taken taken directly from the plate reader output file (test\_malachite\_rawdata.xlsx) and saved in the csv format. There are no column or row names in this file.

### test\_soil\_weights.txt file ###
Description: Text file that includes the mass of soil used for each extraction. **If users are measuring phosphate in water samples** this file should include the assay_ID and SampleID columns, where the assay_ID indicates the integer number of the sample on the plate and the SampleID indicates the code the researchers descriptive identifier (e.g. treatment or site identification number).

### malachite\_test\_calibrated.txt file ###
Description: Sample text file exported to directory after calibration analysis.

## Errors in the Code ##
Please contact Sheila Saia (sms493@cornell.edu) to report errors in the R script.

## Licensing ##
Please be sure to contact Sheila Saia at sms493@cornell.edu if you use or modify any aspects of this program. This repository is made available under the Open Data Commons Attribution License: http://opendatacommons.org/licenses/by/1.0. For the human readable version of the Open Data Commons Attribution License: http://opendatacommons.org/licenses/by/summary/.