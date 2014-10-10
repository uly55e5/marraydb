getItemForPos <- function(data,cx,cy)
{
  subset(data,y-r<=cy & y+r>=cy & x-r<=cx & x+r>=cx)
}