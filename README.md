[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/EducationalSciences693/socqe_datachallenge/HEAD)

# socqe_datachallenge
Team 3 COVID 19 data challenge

This repo represents work that Team 3 is doing in tackling the socqe data challenge.

Original dataset obtained through webhose.io:
DATASET3: ENGLISH NEWS ARTICLES THAT MENTION "CORONA VIRUS" OR "CORONAVIRUS" OR "COVID" (BY WEBHOSE.IO)
Link: https://webhose.io/free-datasets/news-articles-that-mention-corona-virus/

AllSides data (bias data) obtained using work by harry-wood and sautumn:
https://github.com/harry-wood/AllSides-Scraper/tree/update-scraper

*NOTE:* you must update the paths in order for this to work. This includes the input and output paths!

Order of the scripts used to clean the data:
1. `rename.rb`
2. `clean.rb`
3. create a postgres database
4. I ran the code from `create_table.sql` command by command in the `psql` UNIX utility.


To get access to the transformed main data, you should the csv data.

