
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
           pages = 1:3, output = "TEST_LAST_FIRST_1234SSN.pdf")
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 4:5, output = "TEST_LAST_FIRST_1234SSN001.pdf")

pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 1:2, output = "TEST_LAST_FIRST_MIDDLE_2341SSN.pdf")
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 3:4, output = "TEST_LAST_FIRST_MIDDLE_2341SSN001.pdf")
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 5:5, output = "TEST_LAST_FIRST_MIDDLE_2341SSN002.pdf")

## SID
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 1:2, output = "TEST_LAST_FIRST_MIDDLE_23410SID.pdf")
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 3:4, output = "TEST_LAST_FIRST_MIDDLE_23410SID001.pdf")
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 5:5, output = "TEST_LAST_FIRST_MIDDLE_23410SID002.pdf")

## name only
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 1:2, output = "TEST_LAST_FIRST_MIDDLE.pdf")
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 3:4, output = "TEST_LAST_FIRST_MIDDLE001.pdf")
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 5:5, output = "TEST_LAST_FIRST_MIDDLE002.pdf")

## n of n file suffix
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 1:2, output = "TEST_LAST_FIRST_MIDDLE_1of3.pdf")
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 3:4, output = "TEST_LAST_FIRST_MIDDLE_2of3.pdf")
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 5:5, output = "TEST_LAST_FIRST_MIDDLE_3of3.pdf")

pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 1:2, output = "TEST-TYPE-B_LAST_FIRST_MIDDLE.pdf")
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 3:4, output = "TEST-TYPE-B_LAST_FIRST_MIDDLE_1of2.pdf")
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 5:5, output = "TEST-TYPE-B_LAST_FIRST_MIDDLE_2of2.pdf")


## n 0f n file suffix
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 1:2, output = "TEST_LAST_FIRST_MIDDLE_10f3.pdf")
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 3:4, output = "TEST_LAST_FIRST_MIDDLE_20f3.pdf")
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 5:5, output = "TEST_LAST_FIRST_MIDDLE_30f3.pdf")

pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 1:2, output = "TEST-TYPE-B_LAST_FIRST_MIDDLE.pdf")
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 3:4, output = "TEST-TYPE-B_LAST_FIRST_MIDDLE_10f2.pdf")
pdf_subset('https://cran.r-project.org/doc/manuals/r-release/R-intro.pdf',
           pages = 5:5, output = "TEST-TYPE-B_LAST_FIRST_MIDDLE_20f2.pdf")

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

toAppend_ssn <- dir(pattern = "(\\d{9}SSN\\d{3})", recursive = TRUE, all.files = TRUE, full.names = FALSE)
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


# Append name only copies -------------------------------------------------
toAppend <- dir(pattern = "(_[[:alpha:]]*\\d{3}.pdf$)", recursive = TRUE, all.files = TRUE, full.names = FALSE)
ogFiles <- unique(str_extract(toAppend, "(\\D*)"))

filesAppended_nameonly <- fileAppender(ogFiles, toAppend)
filesDeleted_SID <- fileDeleter(toAppend)


# n of n suffix -----------------------------------------------------------


fileAppender_nofn <- function(og, append) {
  tempdir <- paste(getwd(), "/temp/", sep = "") # temp output directory for the combined files
  
  # for loop for appending files
  for (fileName in og) {
    if(!file.exists(paste0(fileName, ".pdf"))){
      # file.create(paste0(fileName, ".pdf"))
      pdf_subset("resources/Office of records-simplecoverpage.pdf",
                 pages = 1:1, output = paste0(fileName, ".pdf"))
    }
    temp <- str_extract(append, paste(fileName, "_\\dof\\d.pdf$", sep = ""))
    temp <- temp[!is.na(temp)]
    fileName <- paste(fileName, ".pdf", sep = "")
    pdftools::pdf_combine(c(fileName, temp), output = paste(tempdir, fileName, sep = ""))
    appendedFiles <- append(appendedFiles, fileName)
  }
  
  # moves file to working directory
  filesstrings::move_files(paste(getwd(), "/temp/", appendedFiles, sep = ""), getwd(), overwrite = TRUE)
  return(appendedFiles)
}

toAppend <- dir(pattern = "(_\\dof\\d.pdf$)", recursive = TRUE, all.files = TRUE, full.names = FALSE)
ogFiles <- unlist(strsplit(unique(str_extract(toAppend, "(\\D*)")), ".+\\K_", perl = TRUE))

filesAppended_nofn <- fileAppender_nofn(ogFiles, toAppend)
filesDeleted_nofn <- fileDeleter(toAppend)


# 10f2 appender --------------------------------------------------------------------

fileAppender_n0fn <- function(og, append) {
  tempdir <- paste(getwd(), "/temp/", sep = "") # temp output directory for the combined files
  
  # for loop for appending files
  for (fileName in og) {
    if(!file.exists(paste0(fileName, ".pdf"))){
      # file.create(paste0(fileName, ".pdf"))
      pdf_subset("resources/Office of records-simplecoverpage.pdf",
                 pages = 1:1, output = paste0(fileName, ".pdf"))
    }
    temp <- str_extract(append, paste(fileName, "_\\d0f\\d.pdf$", sep = ""))
    temp <- temp[!is.na(temp)]
    fileName <- paste(fileName, ".pdf", sep = "")
    pdftools::pdf_combine(c(fileName, temp), output = paste(tempdir, fileName, sep = ""))
    appendedFiles <- append(appendedFiles, fileName)
  }
  
  # moves file to working directory
  filesstrings::move_files(paste(getwd(), "/temp/", appendedFiles, sep = ""), getwd(), overwrite = TRUE)
  return(appendedFiles)
}

toAppend <- dir(pattern = "(_\\d0f\\d.pdf$)", recursive = TRUE, all.files = TRUE, full.names = FALSE)
ogFiles <- unlist(strsplit(unique(str_extract(toAppend, "(\\D*)")), ".+\\K_", perl = TRUE))

filesAppended_n0fn <- fileAppender_n0fn(ogFiles, toAppend)
filesDeleted_n0fn <- fileDeleter(toAppend)


# Input GUI ---------------------------------------------------------------

user <- dlg_input("Who are you?", Sys.info()["user"])$res
if (!length(user)) {# The user clicked the 'cancel' button
  cat("OK, you prefer to stay anonymous!\n")
} else {
  cat("Hello", user, "\n")
}

