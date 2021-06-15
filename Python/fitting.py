import numpy as np
from scipy.optimize import curve_fit
import matplotlib.pyplot as plt
from numpy import genfromtxt
from scipy.sparse import data
import math
import seaborn as sn

my_data = genfromtxt('./Python/all_carryover.csv', delimiter=',')

#x_data = np.array([40,50,60,70,80,160,250])
data_without_nan = my_data[1:,0:10]
x_data = data_without_nan[0:,[0,1,2,3,4,5,7,8,9]]
xT = x_data.T
x_tuples = list(zip(xT[0],xT[1],xT[2],xT[3],xT[4],xT[5],xT[6],xT[7],xT[8]))
x_data_tuples = np.array(x_tuples)
y_data = data_without_nan[0:,-4]
params = np.array([1,1])

#fit = np.polyfit(np.log(x_data), y_data)
#print(fit)

def getx(yelec=1000, stimFreq=40, kBath=1, pump=1, testAmp=-350000, testDur=1000, xBT=1, numElec=1, dist=0):
    return (yelec, stimFreq, kBath, pump, testAmp, testDur, xBT, numElec, dist)

def funcinv(x, a, b, c, d, e, f, g, h, i):
    # The inverse funciton
    # the function is the sum of the following components
    #   blocking amplitude (nA) * a
    #   blocking duration (ms) * c
    #   c
    (yelec, stimFreq, kBath, pump, testAmp, testDur, xBT, numElec, dist) = x
    return a*np.log(yelec) + b*stimFreq + c*(kBath**d) + e*(pump) + f*np.log(abs(testAmp)) + g*(np.log(testDur)) + h*np.log(abs(testAmp))/xBT + i*numElec*dist 

# popt - optimal params after least squares
# pcov - estimated covariance of popt
# for more information see docs https://docs.scipy.org/doc/scipy/reference/generated/scipy.optimize.curve_fit.html
popt, pcov = curve_fit(funcinv, (xT[0],xT[1],xT[2],xT[3],xT[4],xT[5],xT[6],xT[7],xT[8]), y_data, maxfev=10000)
print(popt)
print(pcov)

# r squared calculation 
# see https://stackoverflow.com/questions/19189362/getting-the-r-squared-value-using-curve-fit
residuals = y_data - funcinv((xT[0],xT[1],xT[2],xT[3],xT[4],xT[5],xT[6],xT[7],xT[8]), *popt)
ss_res = np.sum(residuals**2)
ss_tot = np.sum((y_data-np.mean(y_data))**2)
r_squared = 1 - (ss_res / ss_tot)
print("R^2 : " + str(r_squared))

yDatDefault = funcinv(getx(testDur=3000,  kBath=1.09), *popt)
print("y defualt: " + str(yDatDefault))

sn.heatmap(pcov, annot=True, fmt='g')
plt.show()


# tStop = 300
# t = np.linspace(30, tStop, tStop*10)
yelec = np.linspace(900, 1100)
stimFreq = np.linspace(5,50)
kBath = np.linspace(0.5, 1.1)
pump = np.linspace(0,1)
testAmp = np.linspace(-700000,-200000)
testDur = np.linspace(10, 8000)
xBT = np.linspace(0,3)
numElec = np.linspace(1,5,num=5)
dist = np.linspace(0,3000)

fig,axs = plt.subplots(3,3)

y=[]
for x in yelec:
    y.append(funcinv(getx(yelec=x), *popt))
axs[0,0].plot(yelec,y)
axs[0,0].set_title("yelec")

y=[]
for x in stimFreq:
    y.append(funcinv(getx(stimFreq=x), *popt))
axs[0,1].plot(stimFreq,y)
axs[0,1].set_title("stimFreq")

y=[]
for x in kBath:
    y.append(funcinv(getx(kBath=x), *popt))
axs[0,2].plot(kBath,y)
axs[0,2].set_title("kBath")

y=[]
for x in pump:
    y.append(funcinv(getx(pump=x), *popt))
axs[1,0].plot(pump,y)
axs[1,0].set_title("pump")

y=[]
for x in testAmp:
    y.append(funcinv(getx(testAmp=x), *popt))
axs[1,1].plot(testAmp,y)
axs[1,1].set_title("testAmp")


y=[]
for x in testDur:
    y.append(funcinv(getx(testDur=x), *popt))
axs[1,2].plot(testDur,y)
axs[1,2].set_title("testDur")

y=[]
for x in xBT:
    y.append(funcinv(getx(xBT=x), *popt))
axs[2,0].plot(xBT,y)
axs[2,0].set_title("xBT")

y=[]
for x in numElec:
    y.append(funcinv(getx(numElec=x), *popt))
axs[2,1].plot(numElec,y)
axs[2,1].set_title("numElec")

y=[]
for x in dist:
    y.append(funcinv(getx(dist=x), *popt))
axs[2,2].plot(dist,y)
axs[2,2].set_title("dist")

plt.show()
# # Plot the data on three separate curves for S(t), I(t) and R(t)
# plt.plot(x_data,y_data, 'ro', t, funcinv(t, *popt), "b")

# plt.show()