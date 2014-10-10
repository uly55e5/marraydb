read.Genepix <- function (file.name = "", isGal=F)
{
  result <- list()
  
  if (!nchar(file.name)) 
    return()
  
  sizeLine <- scan(file.name, integer(), 2, skip = 1, sep = "\t")
  
  headCount <- sizeLine[1]
  columnCount <- sizeLine[2]
  
  head <- scan(file.name,list("",""),nmax=headCount,skip=2,sep="=",quote="")
  
  attrib <- grep("^Block[0-9]+$",head[[1]],invert = T)
  result$attr = data.frame(attr=gsub("\"","",head[[1]][attrib]),value=gsub("\"","",head[[2]][attrib]))
  if(isGal)
  {
    blockidx <- grep("^Block[0-9]+$",head[[1]])
    block <- regmatches(head[[1]][blockidx],regexpr("[0-9]+",head[[1]][blockidx]))
    blockdef <- data.frame(scan(text=head[[2]][blockidx],sep=",",what=list("integer","integer","integer","integer","integer","integer","integer")))
    names(blockdef) <- c("x","y","dia","nx","dx","ny","dy")
    result$blocks <- cbind(block,blockdef)
  }
  
  result$data <- read.delim(file.name, skip = headCount + 2)
  
  return(result)
  
  
}