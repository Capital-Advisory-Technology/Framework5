#include <A&A/main/Frame.mqh>

#include <A&A/signal/custom/LinearRegression.mqh>
#include <A&A/risk/custom/Atr.mqh>

input group "Frame" 
input double riskPerPos = 2;        // risk per deal
input double riskMax = 25;          // exposure max
input int posMax = 10;              // position count max
input double riskToReward = 5;      // r:r

input group "Signal Model"
input int lrPeriod = 25;
input ENUM_APPLIED_PRICE lrPrice = PRICE_HIGH;

input group "Risk Model"
input int atrPeriod = 14;
input double atrMult = 1.5;

input group "Limits"
input int timeFrom = 8;
input int timeTo = 18;

input group "ProfitSystem"
input double beTarget = 0.5;
input double target1 = 0.5;
input double target2 = 0.8;
input double stop1 = 0.5;
input double stop2 = 0.8;
 
Frame *frame = new Frame;

LinearRegression *linearRegression = new LinearRegression;
Atr *atr = new Atr;
// Execution *execution = new Execution;

int OnInit() {
    
    frame.init(riskPerPos, riskMax, riskToReward);
    
    linearRegression.init(lrPeriod, lrPrice);
    atr.init(atrPeriod, atrMult);
    // passiveExecution.Init(var1, var2, var3, var4);

    frame.setSignal(linearRegression);
    frame.setRisk(atr);
    frame.setLimits(timeFrom, timeTo);
    frame.setProfitSystem(beTarget, target1, target2, stop1, stop2);

    return(INIT_SUCCEEDED);
}


void OnTick() {
    frame.Run();
}

