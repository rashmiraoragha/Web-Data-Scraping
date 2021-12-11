# Web-Data-Scraping

In  this  project,  I have built  a  specialized  R  program  to  crawl,  parse  and  extract  useful 
information  from  online  website - https://gsejournal.biomedcentral.com
 
Given an input year, the objective is to extract all articles published in/after that year from 
your  selected  journal.  As  a  start  point,  I have extracted  the  following  9  fields  for 
each article: 
Title,  Authors,  Author  Affiliations,  Correspondence  Author,  Correspondence  Author's 
Email, Publish Date, Abstract, Keywords, Full Paper (Text format). 
Given  an  input  year,  the  program  crawls  the  journal’s 
website  automatically,  and  parse  and  extract  useful  fields  for  each  crawled  article.  The 
program  stores  the  extracted  information  into  a  plain  file  elegantly.  (One 
column for one field.) 
 
Finally, the program is encapsulated into a function which will take the 
year as a parameter. The code also makes  sure  the  stored  data  could  be  easily  read  into  R  again, as  the  extracted  text  may  contain some special characters. 
 
Given  a  journal,  the  R  code  fetches  html  pages  of  all  articles 
automatically. For each article, the program extracts the following 10 fields: 
DOI, Title, Authors, Author Affiliations, Corresponding Author, Corresponding 
Author's  Email,  Publication  Date,  Abstract,  Keywords,  Full  Text  (Textual  format). 
Extracted  information  is  written  into  a  plain  text  file  (one  row  per  article  and  one 
column  per  field).  If  any  columns  are  not  available,  please  mark  them  as  NA  (don’t  leave 
them blank). 

Please find below the implementation details of the r script 

Step 1: Loading all the necessary libraries

Step 2: Setting up the Base URL (Website URL of the selected Journal that should be crawled)

Step 3: Function which will take year as a parameter and crawl the journal’s website automatically, 
parse and extract useful fields for each crawled article of the given year.

Step 4: Construction of the website URL based on the input year 

Step 5: Checking if the constructed website URL has more than one page, 
If yes it constructs the website URL of the next page else it does nothing

Step 6: Initialization to empty vectors for further use in the program

Step 7: Repeat the scraping of the published articles in a given year for all pages,
Once there are no more pages left to be scraped, the repeat loop will be exited with an if condition
meaning the scraping of the webpages stop.

Step 8: Scraping Title, Author, Published date of the articles. 
These details are available on the page which lists all the articles of the given year.
These does not require to open every article and scrape the details.
    
Step 9: Here we list all the URLs of the individual articles in a given page

Step 10: Then we loop through all the URLs of the given page 

Step 11: Cleaning the data - Removing images and mathematical equations, whose texts are gibberish

Step 12: Inside the loop we scrape Author Affiliations, Correspondence Author, Abstract, Keywords, Full Paper for each article.
These details are not available on the page which lists all the articles of the given year.
To scrape these fields, it requires to open every article and scrape the details in each article.
We construct new URL for every article and scrape the above fields from it

Step 13: After scraping each field, the scraped data is appended and stored in a list.
If a field is empty, it returns a zero and continues scraping with the next article.

Step 14: If there are no pages left for scraping, stop the repeat function and stop scraping

Step 15: Build a dataframe from the lists created 

Step 16: Removing \n and \t -cleaning the data

Step 17: writing the dataframe into a text file 

 
