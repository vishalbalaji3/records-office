# records-office
These are all the files and code related to the managment of the Millsaps College Office of Records digital vault file/records.

Important things to note:
- the folder 'user friendly' contains all the final code that is meant for use. 
- the resources file is required to be in the same directory as the working directory for proper usage. (This will changed later on to depend on the file located in this repository)

## What files does it currently fix?
- file-name-modifier
  - Changes .PDF extension to .pdf
  - Adds SSN to certain file name formats
  - Adds SID to certain file name formats
- pdf-appender
  - Appends the following file name formats:
    - FILENAME_123456789SSN.pdf, FILENAME_123456789SSN001, ...
    - FILENAME_654321SID.pdf, FILENAME_654321SID001, ...
    - FILENAME.pdf, FILENAME001, ...
    - FILENAME.pdf, FILENAME_1of3, ...
    - FILENAME.pdf, FILENAME_10f3, ...
    - FILENAME.pdf, FILENAME_1Of3, ...
    

## Upcoming

- Instructions on how to properly use the script
