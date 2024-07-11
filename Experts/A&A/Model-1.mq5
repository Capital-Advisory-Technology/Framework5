#include <A&A/main/Frame.mqh>

#include <A&A/signal/custom/LinearRegression.mqh>
#include <A&A/risk/custom/Atr.mqh>

input group "Frame" 
input double riskPerPos = 2;
input double riskMax = 25;
input double riskToReward = 5;

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

/* 
we call all custom objects here
run init for each in OnInit()
    1. signal
    2. risk model
    3. execution
    4. 
*/
LinearRegression *linearRegression = new LinearRegression;
Atr *atr = new Atr;
// Execution *execution = new Execution;

int OnInit() {
    
    frame.init(riskPerPos, riskMax, riskToReward);
    
    linearRegression.Init(lrPeriod, lrPrice);
    atr.Init(atrPeriod, atrMult);
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

