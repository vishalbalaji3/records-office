
# Introduction ------------------------------------------------------------

# Scanner info:
#   if duplicate, following options:
#     Add numbers (000, 001, 002, ...)
#     Add date time (YYYYMMDDhhmmss)

# Existing naming scheme:
# LAST_FIRST_MIDDLE_SSN
# LAST_FIRST_MIDDLE_SIDnnnnn

# New naming scheme:
# LAST_FIRST_MIDDLE_nnnnSSN
# LAST_FIRST_MIDDLE_nnnnnnnnnSSN
# LAST_FIRST_MIDDLE_nnnnnSID

# Setup -------------------------------------------------------------------

# Install packages if not previously installed
# install.packages(c("tidyverse", "pdftools", "filesstrings"))

library("tidyverse")
library("pdftools")
library("filesstrings")

# The path for the working directory is where all the scanned files exist
setwd("data/")
dir.create("temp/") # Ignore warning about 'temp' already existing


# Test file generator -----------------------------------------------------
# The test files will be generated in the newly set working directory

## SSN
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 1:3, output = "LAST_FIRST_IGNORE_5555SSN.pdf")

pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 1:3, output = "LAST_FIRST_1234SSN.pdf")
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 4:5, output = "LAST_FIRST_1234SSN001.pdf")

pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 1:2, output = "LAST_FIRST_MIDDLE_2341SSN.pdf")
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 3:4, output = "LAST_FIRST_MIDDLE_2341SSN001.pdf")
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 5:5, output = "LAST_FIRST_MIDDLE_2341SSN002.pdf")

## SID
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 1:2, output = "LAST_FIRST_MIDDLE_23410SID.pdf")
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 3:4, output = "LAST_FIRST_MIDDLE_23410SID001.pdf")
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 5:5, output = "LAST_FIRST_MIDDLE_23410SID002.pdf")

# Initialization of the Appender --------------------------------------------------------

# Run this section in the given order

appendedFiles <- rep(NA, 0) # initializes an empty list
deletedFiles <- rep(NA, 0) # initializes an empty list

fileAppender <- function(og, append) {
  tempdir <- paste(getwd(), "/temp/", sep = "") # temp output directory for the combined files
  
  # for loop for appending files
  for (fileName in og) {
    temp <- str_extract(append, paste(fileName, "\\d{3}.pdf", sep = ""))
    temp <- temp[!is.na(temp)]
    fileName <- paste(fileName, ".pdf", sep = "")
    pdftools::pdf_combine(c(fileName, temp), output = paste(tempdir, fileName, sep = ""))
    appendedFiles <- append(appendedFiles, fileName)
  }
  
  # moves file to working directory
  filesstrings::move_files(paste(getwd(), "/temp/", appendedFiles, sep = ""), getwd(), overwrite = TRUE)
  return(appendedFiles)
}

# Deletes all the copy files.
fileDeleter <- function(toAppend) {
  for (fn in toAppend) {
    if (file.exists(fn)) {
      file.remove(fn)
      deletedFiles <- append(deletedFiles, fn)
    }
  }
  filesDeleted_success <- identical(deletedFiles, toAppend)
  if (filesDeleted_success) {
    message("Successfully deleted files")
  }
  return(deletedFiles)
}



# Append SSN files --------------------------------------------------------

# toAppend_ssn is a list that contains the names of all the files that need to be appended (copies ending with the 001, 002,...) to the original/root file.
# ogFiles_ssn is a list that contains the names of all the original/root files. It is obtained from the toAppend_ssn list.
# filesAppended_SSN and filesDeleted_SSN are lists that show what files have been combined and what files have been deleted, respectively.

toAppend_ssn <- dir(pattern = "(\\d{4}SSN\\d{3})", recursive = TRUE, all.files = TRUE, full.names = FALSE)
ogFiles_ssn <- unique(str_extract(toAppend_ssn, "(^.*SSN)"))

filesAppended_SSN <- fileAppender(ogFiles_ssn, toAppend_ssn)

# RUN ONLY AFTER APPENDING #
filesDeleted_SSN <- fileDeleter(toAppend_ssn)
# RUN ONLY AFTER APPENDING #



# Append SID files --------------------------------------------------------

# same variable naming format as Append SSN files section

toAppend_sid <- dir(pattern = "(\\d{5}SID\\d{3})", recursive = TRUE, all.files = TRUE, full.names = FALSE)
ogFiles_sid <- unique(str_extract(toAppend_sid, "(^.*SID)"))

filesAppended_SID <- fileAppender(ogFiles_sid, toAppend_sid)

# RUN ONLY AFTER APPENDING #
filesDeleted_SID <- fileDeleter(toAppend_sid)
# RUN ONLY AFTER APPENDING #


