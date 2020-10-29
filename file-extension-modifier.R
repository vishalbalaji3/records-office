
# Setup -------------------------------------------------------------------

# The path for the working directory is where all the scanned files 
# that need to have their extensions replaced exist
setwd("data/")

library("tidyverse")
library("pdftools")
library("filesstrings")

# Change extension from .PDF to .pdf ------------------------------------------------

files <- list.files(pattern="*.PDF") # Gets the names of the files with .PDF extensions
newfiles <- gsub(".PDF$", ".pdf", files) # Creates new file names with replaced .pdf extension
file.rename(files, newfiles) # renames the files


# Test file generator -----------------------------------------------------

#SSN
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 1:2, output = "LAST_FIRST_MIDDLE_555444333.pdf")
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 3:4, output = "LAST_FIRST_MIDDLE_555444333001.pdf")
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 5:5, output = "LAST_FIRST_MIDDLE_555444333002.pdf")

#SID 
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 1:2, output = "LAST_FIRST_MIDDLE_SID23410.pdf")
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 3:4, output = "LAST_FIRST_MIDDLE_SID23410001.pdf")
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 5:5, output = "LAST_FIRST_MIDDLE_SID23410002.pdf")

pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 5:5, output = "LAST_FIRST_SIDDHART_SID23410.pdf")

# add SSN to file name ----------------------------------------------------

library("stringi")

## Add SSN after SSN number
files <- list.files(pattern="(*_\\d{9}.pdf)")
newfiles <- gsub(".pdf$", "SSN.pdf", files)
file.rename(files, newfiles)

## ADD SSN after SSN number and before copy number
files <- list.files(pattern="(*_\\d{12}.pdf)")
newfiles <- files
stri_sub(newfiles, -7, -8) <- c("SSN")
file.rename(files, newfiles)


# Change SID position to last ---------------------------------------------

## Change "SID" from before SID number to after SID number
files <- list.files(pattern="(*_SID\\d{5}.pdf)")
newfiles <- sub("(SID)(\\d{5})", "\\2\\1", files)
file.rename(files, newfiles)

## Change "SID" from before SID number to 'after SID number and before copy number'
files <- list.files(pattern="(*_SID\\d{8}.pdf)")
newfiles <- sub("(SID)(\\d{5})(\\d{3})", "\\2\\1\\3", files)
file.rename(files, newfiles)
