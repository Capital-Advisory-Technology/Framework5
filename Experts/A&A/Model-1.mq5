#include <A&A/main/Frame.mqh>

#include <A&A/signal/custom/LinearRegression.mqh>
#include <A&A/risk/custom/Atr.mqh>

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
 
Frame *frame = new Frame;

LinearRegression *linearRegression = new LinearRegression;
Atr *atr = new Atr;

int OnInit() {
    
    linearRegression.Init(lrPeriod, lrPrice);
    atr.Init(atrPeriod, atrMult);

    frame.initRiskParams(riskPerPos, 0, 5);
    frame.setSignal(linearRegression);
    frame.setRisk(atr);
    frame.setLimits(timeFrom, timeTo);

    return(INIT_SUCCEEDED);
}


void OnTick() {
    frame.Run();
}

