#Loading the Libraries

library(rvest)
library(tidyverse)
library(dplyr)
library(xml2)

#Setting up the Base URL (Website URL of the selected Journal that should be crawled)

base <- "https://gsejournal.biomedcentral.com"
url <- 'https://gsejournal.biomedcentral.com/articles'
webpage <- read_html(url)

#Function which will take year as a parameter and return the equivalent volume of that year

Project <- function(x){
  Year <- webpage %>% html_node(".c-form-field__select") %>% html_children() %>% html_text()
  input <- Year[grep(x,Year)]
  if (length(input) == 0){
    stop("There is no data for the Mentioned year")
  }
  else{
    Volume <- strsplit(input, split = " ")[[1]][2]
    return(Volume)
  }
}

#Function call 
#Enter the Year

yearURL2 <- Project(2006)

#Construction the URL based on the input year

yearURL1 <- "https://gsejournal.biomedcentral.com/articles?query=&volume="
yearURL3 <- "&searchType=&tab=keyword"
yearURL <- paste0(yearURL1,yearURL2,yearURL3)
inputURL <- read_html(yearURL)

#Scraping the pagination

pagination <- inputURL %>% html_nodes(".c-pagination__item") %>% html_children() %>% html_attr('href') 
pagination1 <- pagination[length(pagination)]

#Checking if there are more than single page
#if yes, does not enter the loop
#else enters the loop 

if (!(is.na(pagination1))){
nextURL1 <- paste0(base,pagination1)
nextURL <- read_html(nextURL1)
print("2006")
}

#Iniatializing 

    Title_html_list <- c()
    Author_html_list <- c()
    publishedDATE_list <- c()
    Author_Affi_list2 <- c()
    Co_Author_list2 <- c()
    Abstract_list2 <- c()
    Keywords_list <- c()
    FullText_list2 <- c()
    
#repeat scraping until if condition is true    
  
    repeat{  
    
#Scraping the Title of all the Articles,Checking if it is empty and
#Appending all the titles of all the articles into a vector  
      
    Title_html <- inputURL %>% html_nodes('.c-listing__title a') %>% html_text()
    if (length(Title_html)== 0){   Title_html <- 0  }
    Title_html_list <- append(Title_html_list,Title_html, after = length(Title_html_list))
    
#Scraping the Authors of all the Articles,Checking if it is empty and
#Appending all the Authors of all the articles into a vector  
    
    Author_html <- inputURL %>% html_nodes('.c-listing__authors') %>% html_text()
    if (length(Author_html)== 0){   Author_html <- "No Author"  }
    Author_html_list <- append(Author_html_list,Author_html, after = length(Author_html_list))
    
#Scraping the Published dates of all the Articles,Checking if it is empty and
#Appending all the Published dates of all the articles into a vector  
    
    published <- inputURL %>% html_nodes('.c-meta') %>% html_nodes('.c-meta__item') %>% html_nodes("span") %>% html_text()
    publishedDATE <- published[seq(2, length(published), 2)]
    if (length(publishedDATE)== 0){   publishedDATE <- 0  }
    publishedDATE_list <- append(publishedDATE_list,publishedDATE, after = length(publishedDATE_list))
    
#listing all the URLs of the individual articles in a given page
  
    Affiliation_html <- inputURL %>% html_nodes('.c-listing__title') %>% html_children() %>% html_attr('href')
    
#Looping all the articles in a page to extract different fields
    
    for (i in 1:length(Affiliation_html)) {
      
#Constructing the URLs for all the looped articles  
      
      join <- paste0(base, Affiliation_html[i])
      join_html <- read_html(join)
      
#crawled html pages of all articles, the name of each article is DOI.html
      
      DOI <- join_html %>% html_nodes(".c-bibliographic-information__list") %>% html_nodes(".c-bibliographic-information__list-item--doi") %>% html_nodes('a') %>% html_text()
      DOISUB <- gsub("https://doi.org/", " ",DOI)
      DOISUB1 <- gsub("/", "-",DOISUB)
      download_html(join, DOISUB1)
      
#Removing Mathematical Equations and Gibberish texts
      
      Math12 <- join_html %>% html_nodes(".c-article-section") %>% html_nodes("p>:not(.MathJax)") 
      xml_remove(Math12)
      
#Scraping the Author's Affiliations from all the articles, Checking if it is empty
#Appending all the Author's Affiliations into a vector  
      
      Affiliation <- join_html %>% html_nodes('.c-article-author-affiliation__list') %>% html_children() %>% html_text()
      Author_Affi <- paste(Affiliation,collapse=" ")
      if (length(Author_Affi)== 0){   Author_Affi <- 0  }
      Author_Affi_list2 <- append(Author_Affi_list2,Author_Affi, after = length(Author_Affi_list2))
      
#Scraping the Correspondence Authors  from all the articles, Checking if it is empty
#Appending all the Correspondence Authors into a vector  
      
      
      Co_Author <- join_html %>% html_nodes("#corresp-c1") %>%  html_text()
      if (length(Co_Author)== 0){   Co_Author <- "No Co-Author"  }
      Co_Author_list2 <- append(Co_Author_list2,Co_Author, after = length(Co_Author_list2))
      
#Scraping the Abstract from all the articles, Checking if it is empty
#Appending all the Abstract into a vector  
      
      Abstract <- join_html %>% html_node(".c-article-section__content") %>% html_text()
      if (length(Abstract)== 0){   Abstract <- 0  }
      Abstract_list2 <- append(Abstract_list2, Abstract, after = length(Abstract_list2))

#Scraping the Keywords from all the articles, Checking if it is empty
#Appending all the Keywords into a vector  
      
      Keywords <- join_html %>% html_node(".c-article-subject-list") %>% html_nodes(".c-article-subject-list__subject") %>% html_text() 
      Keywords_list2 <- paste(Keywords, collapse = "  ")
      if (length(Keywords)== 0){   Keywords <- "No Keywords"  }
      Keywords_list <- append(Keywords_list, Keywords_list2, after = length(Keywords_list))
      
#Scraping the Full Text of all the articles, Checking if it is empty
#Appending all the Full Text into a vector  
      
      header <- join_html %>% html_nodes(".c-article-header") %>%  html_text()
      FullText <- join_html %>% html_nodes(".c-article-section") %>% html_nodes("p") %>% html_text()
      FullTextFinal <- paste(FullText,collapse=" ")
      FullArticle <- paste(header,FullTextFinal,Keywords_list2)
      if (length(FullArticle)== 0){   FullTextFinal <- 0  }
      FullText_list2 <- append(FullText_list2, FullArticle, after = length(FullText_list2))
    }
    
#If there are no pages left for scraping, get out of the repeat loop
    
    if(is.na(pagination1)) {
          break
        }
    nextURL1 <- paste0(base,pagination1)
    nextURL <- read_html(nextURL1)
    inputURL <- nextURL
    }

#Construct the dataframe using all the extracted fields
    
data2<- data.frame("Title" = (Title_html_list),
                    "Authors" = (Author_html_list),
                    "Author_Affiliation" = (Author_Affi_list2),
                    "Correspondence_Author" = (Co_Author_list2),
                    "Publish_Date" = (publishedDATE_list),
                    "Abstract" =  (Abstract_list2),
                    "Keywords" = (Keywords_list),
                    "Full_Paper" = (FullText_list2))

#Removing \n and \t from tnhe dataframe

for (col in colnames(data2)){
  data2[,col] <- gsub("[\n,\t]", " ", data2[,col])
}

#Writing the data into a text file

write.table(data2, "C:/Users/arjun/Desktop/Rashmi/Courses/R-Programming/R_WD/Project1/ScrapedData.txt", sep = "\t", row.names = FALSE)

#save the dataframe 
save(data2, file = "C:/Users/arjun/Desktop/Rashmi/Courses/R-Programming/R_WD/Project1/Project1.Rdata")

#To load the dataframe in your environment 
#Optional
#load(file = "C:/Users/arjun/Desktop/Rashmi/Courses/R-Programming/R_WD/Project1/Project1.Rdata")

