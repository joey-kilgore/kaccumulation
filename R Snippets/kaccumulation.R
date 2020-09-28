calcCol <- function(type, index){
  # given a compartment type and index
  #  return the column number of the KO data set
  
  # Compartment ordering is as follows
  # IS - IS - IS - PS - MS - Node - MS - PS - IS -IS -IS
  # and repeats 101 times total
  
  col = -1 # default invalid column
  if(type=="IS"){
    nodeNum = floor(index/6)+1 # for every 6 IS segments we have 1 node
    col = ((nodeNum-1)*11)+6
    if(index%%6<3){
      # left side of node
      col = col - 2 - (3-(index%%6))
    }else{
      col = col + 2 + (index%%6 -2)
    }
  }
  if(type=="PS"){
    nodeNum = floor(index/2)+1 # for every 6 IS segments we have 1 node
    col = ((nodeNum-1)*11)+6
    if(index%%2<1){
      # left side of node
      col = col - 2
    }else{
      col = col + 2
    }
  }
  if(type=="MS"){
    nodeNum = floor(index/2)+1 # for every 6 IS segments we have 1 node
    col = ((nodeNum-1)*11)+6
    if(index%%2<1){
      # left side of node
      col = col - 1
    }else{
      col = col + 1
    }
  }
  if(type=="Node"){
    col = ((index)*11)+6
  }
  
  #return column (offset for Time column)
  col+1
}

# Load data
source("UsefulFunctions.R")
ko <- csvToDF(read.csv("C:/Users/Joey/Desktop/TestData/kaccumulation/CathodicDC/1xBT/KO.csv"))
v <- csvToDF(read.csv("C:/Users/Joey/Desktop/TestData/kaccumulation/CathodicDC/1xBT/Voltage.csv"))

# check data set
head(ko)
plot(ko$Time, ko$Node548)

# load graphing libraries
library(ggplot2)
library(grid)
library(gridExtra)

print(calcCol("Node",10))
ggplot(data=ko)+
  geom_path(aes(x=Time,y=ko[,227]),color="green")+
  geom_path(aes(x=Time,y=ko[,226]),color="cyan")+
  geom_path(aes(x=Time,y=ko[,225]),color="blue")+
  geom_path(aes(x=Time,y=ko[,224]),color="purple")+
  geom_path(aes(x=Time,y=ko[,223]),color="red")

print(calcCol("Node",50))
ggplot(data=ko)+
  geom_path(aes(x=Time,y=ko[,557]),color="green")+
  geom_path(aes(x=Time,y=ko[,556]),color="cyan")+
  geom_path(aes(x=Time,y=ko[,555]),color="blue")+
  geom_path(aes(x=Time,y=ko[,554]),color="purple")+
  geom_path(aes(x=Time,y=ko[,553]),color="red")

print(calcCol("Node",90))
ggplot(data=ko)+
  geom_path(aes(x=Time,y=ko[,997]),color="green")+
  geom_path(aes(x=Time,y=ko[,996]),color="cyan")+
  geom_path(aes(x=Time,y=ko[,995]),color="blue")+
  geom_path(aes(x=Time,y=ko[,994]),color="purple")+
  geom_path(aes(x=Time,y=ko[,993]),color="red")


# looking at MS and PS segments
pm1 <- ggplot()+
  geom_abline(slope=1,color="#000000", linetype="dashed", size=1)+
  geom_path(aes(x=ko[,996],ko[,995]),color="blue")+
  xlab("PS [K]o (mM)")+
  ylab("MS [K]o (mM)")+
  ggtitle("Left Node 90")
  
pm2 <- ggplot()+
  geom_abline(slope=1,color="#000000", linetype="dashed", size=1)+
  geom_path(aes(x=ko[,556],ko[,555]), color="purple")+
  xlab("PS [K]o (mM)")+
  ylab("MS [K]o (mM)")+
  ggtitle("Left Node 50")

pm3 <- ggplot()+
  geom_abline(slope=1,color="#000000", linetype="dashed", size=1)+
    geom_path(aes(x=ko[,226],ko[,225]), color="red")+
  xlab("PS [K]o (mM)")+
  ylab("MS [K]o (mM)")+
  ggtitle("Left Node 10")

ps1 <- ggplot()+
  geom_path(aes(x=ko$Time,y=ko[,996]),color="blue")+
  geom_path(aes(x=ko$Time,y=ko[,556]),color="purple")+
  geom_path(aes(x=ko$Time,y=ko[,226]),color="red")+
  ylab("PS [K]o (mM)")+
  xlab("")

ms1 <- ggplot()+
  geom_path(aes(x=ko$Time,y=ko[,995]),color="blue")+
  geom_path(aes(x=ko$Time,y=ko[,555]),color="purple")+
  geom_path(aes(x=ko$Time,y=ko[,225]),color="red")+
  ylab("MS [K]o (mM)")+
  xlab("Time")

lay <- cbind(c(3,4,5),
             c(2,4,5),
             c(1,4,5))

p <- grid.arrange(pm1,pm2,pm3,ps1,ms1,layout_matrix=lay)
ggsave("C:/Users/Joey/Desktop/TestData/kaccumulation/CathodicDC/plots/psms1xBT.jpg", p, width=10, height=8)

# Basic Voltage plots
v10 <- ggplot()+
    geom_path(aes(x=v$Time,y=v$Node10))+
    xlab("")+
    ylab("Node 10 (mV)")

v51 <- ggplot()+
  geom_path(aes(x=v$Time,y=v$Node51))+
  xlab("")+
  ylab("Center Node (mV)")

v90 <- ggplot()+
  geom_path(aes(x=v$Time,y=v$Node90))+
  xlab("Time (ms)")+
  ylab("Node 90 (mV)")

vAll <- grid.arrange(v10,v51,v90, layout_matrix=cbind(c(1,2,3),c(1,2,3),c(1,2,3)))
ggsave("C:/Users/Joey/Desktop/TestData/kaccumulation/CathodicDC/plots/voltage1xBT.jpg", vAll, width=10, height=8)


# large rainow of values across time
psRainbow <- ggplot()+
  geom_path(aes(x=ko$Time,y=ko[,calcCol("PS",89)]),color="orange")+
  geom_path(aes(x=ko$Time,y=ko[,calcCol("PS",91)]),color="#ffa3f1")+
  geom_path(aes(x=ko$Time,y=ko[,calcCol("PS",93)]),color="red")+
  geom_path(aes(x=ko$Time,y=ko[,calcCol("PS",95)]),color="purple")+
  geom_path(aes(x=ko$Time,y=ko[,calcCol("PS",97)]),color="blue")+
  geom_path(aes(x=ko$Time,y=ko[,calcCol("PS",99)]),color="cyan")+
  geom_path(aes(x=ko$Time,y=ko[,calcCol("PS",101)]),color="green")+
  geom_path(aes(x=ko$Time,y=ko[,calcCol("PS",151)]),color="black")+
  ylab("PS [K]o (mM)")+
  xlab("")+
  xlim(549,650)
  ylim(3,6)
show(psRainbow)

vRainbow <- ggplot()+
  geom_path(aes(x=v$Time,y=v$Node45),color="orange")+
  geom_path(aes(x=v$Time,y=v$Node46),color="#ffa3f1")+
  geom_path(aes(x=v$Time,y=v$Node47),color="red")+
  geom_path(aes(x=v$Time,y=v$Node48),color="purple")+
  geom_path(aes(x=v$Time,y=v$Node49),color="blue")+
  geom_path(aes(x=v$Time,y=v$Node50),color="cyan")+
  geom_path(aes(x=v$Time,y=v$Node51),color="green")+
  geom_path(aes(x=v$Time,y=v$Node75),color="black")+
  xlab("Time (ms)")+
  ylab("Node Voltage (mV)")+
  xlim(549,650)
show(vRainbow)

gridRainbow <- grid.arrange(psRainbow,vRainbow, ncol=1)

ggsave("C:/Users/Joey/Desktop/TestData/kaccumulation/CathodicDC/plots/PSVoltageCarryover.jpg", gridRainbow, width=12, height=8)


# compare node voltage to PS potassium accumulation
plot(ko[,calcCol("PS",100)],v$Node51)

kNew <- ko[ko[,1]<550,]
plot(kNew[,1],kNew[,calcCol("Node",50)])

vNew <- v[v$Time<550,]
plot(vNew$Time,vNew$Node51)

vAndK <- ggplot()+
  geom_path(aes(x=kNew[,calcCol("PS",89)],y=vNew$Node45),color="orange")+
  geom_path(aes(x=kNew[,calcCol("PS",91)],y=vNew$Node46),color="#ffa3f1")+
  geom_path(aes(x=kNew[,calcCol("PS",93)],y=vNew$Node47),color="red")+
  geom_path(aes(x=kNew[,calcCol("PS",95)],y=vNew$Node48),color="purple")+
  geom_path(aes(x=kNew[,calcCol("PS",97)],y=vNew$Node49),color="blue")+
  geom_path(aes(x=kNew[,calcCol("PS",99)],y=vNew$Node50),color="cyan")+
  geom_path(aes(x=kNew[,calcCol("PS",101)],y=vNew$Node51),color="green")+
  geom_path(aes(x=kNew[,calcCol("PS",151)],y=vNew$Node75),color="black")+
  xlab("K Accumulation (mM)")+
  ylab("Voltage (mV)")

ggsave("C:/Users/Joey/Desktop/TestData/kaccumulation/CathodicDC/plots/VandPSBlock.jpg", vAndK, width=12, height=8)


# looking at pulse trains with 3.0mM potassium bath or 3.3mM bath

train30 <- csvToDF(read.csv("C:/Users/Joey/Desktop/TestData/kaccumulation/APTrain/K_3_0mM/KO.csv"))
train30v <- csvToDF(read.csv("C:/Users/Joey/Desktop/TestData/kaccumulation/APTrain/K_3_0mM/Voltage.csv"))
train33 <- csvToDF(read.csv("C:/Users/Joey/Desktop/TestData/kaccumulation/APTrain/K_3_3mM/KO.csv"))
train33v <- csvToDF(read.csv("C:/Users/Joey/Desktop/TestData/kaccumulation/APTrain/K_3_3mM/Voltage.csv"))

p <- ggplot()+
  geom_path(aes(x=train30$Time,y=train30[,calcCol("PS",101)], color="red"))+
  geom_path(aes(x=train33$Time,y=train33[,calcCol("PS",101)], color="blue"))+
  xlab("Time (ms)")+ ylab("PS K+ Concentration (mM)")+
  scale_color_identity(name = "Concentration",
                       breaks = c("blue","red"),
                       labels = c("+10%", "Normal"),
                       guide = "legend")+
  theme(legend.position = c(0.9,0.25))

v <- ggplot()+
  geom_path(aes(x=train30v$Time,y=train30v$Node51), color="red")+
  geom_path(aes(x=train33v$Time,y=train33v$Node51), color="blue")+
  xlab("Time (ms)")+ ylab("Node Voltage (mV)")
  scale_color_identity(name = "Concentration",
                       breaks = c("blue","red"),
                       labels = c("+10%", "Normal"),
                       guide = "legend")

trains <- grid.arrange(p,v,ncol=1, top=textGrob("Pulse Trains and Potassium Accumulation",gp=gpar(fontsize=20,font=1)))

ggsave("C:/Users/Joey/Desktop/TestData/kaccumulation/CathodicDC/plots/PulseTrains.jpg", trains, width=10, height=5)
