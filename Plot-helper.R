getItemForPos <- function(data,cx,cy)
{
  subset(data,y-r<=cy & y+r>=cy & x-r<=cx & x+r>=cx)
}

plotSymbols <- function(data,limits)
{
  symbols(data$x,data$y,data$r,inches = F,xlim=limits$x,ylim=limits$y,xaxt="n",yaxt="n",xlab="",ylab="",mar=c(0,0,0,0),fg=data$c,asp=1)
}