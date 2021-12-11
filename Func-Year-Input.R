#Read all the delivered text file
years <- 1969:2020

for (j in years){
x <- "C:/Users/arjun/Desktop/Rashmi/Courses/R-Programming/R_WD/Project1/Genetics Selection Evolution/"  
y <- paste0(x, j, ".txt")
print(read.table(y, sep="\t"))
}
