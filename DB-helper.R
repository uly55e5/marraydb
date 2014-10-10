writeTableToDB <- function(connection,table,data,overwrite=F)
{
  return(dbWriteTable(connection,table,data,append=T,row.names=F))
}