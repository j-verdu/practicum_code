# heavytails output test to check outlier frequency estimation
# Joan Verdu

# libraries
library(ggplot2)

# Load data
data<-read.csv('heavytails_output.csv')
data<-data[,c('net_id','vertex_id','return','volatility')]

# Extract day
data$date<-substr(data$net_id,12,21)
data$date<-as.Date(data$date,"%Y-%m-%d")

# Outlier classification
data$outlier<-abs(data$return/data$volatility)>1.645

# Total tickers
n_tickers<-length(unique(data$vertex_id))
# Days by ticker
n_days<-aggregate(date~vertex_id,data=data,function(x) length(unique(x)))
# Outliers by ticker
out<-aggregate(outlier~vertex_id,data=data,sum)
# Percent outliers by ticker
out$percent<-out$outlier/n_days$date
# Deviation from theoretical 10%
out$dev<-100*(out$percent-0.1)

summary(out$dev)
qplot(main="Avg deviation from 10%",dev, data=out, geom="histogram",binwidth=0.25)+ geom_vline(colour="red",xintercept = mean(out$dev))

# Mean returns by ticker
ret<-aggregate(return~vertex_id,data=data,mean)
qplot(main="Avg returns",return, data=ret,geom="histogram")+ geom_vline(colour="red",xintercept = mean(ret$return))

