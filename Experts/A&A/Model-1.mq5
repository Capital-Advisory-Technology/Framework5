#include <A&A/main/Frame.mqh>

#include <A&A/signal/custom/LinearRegression.mqh>
#include <A&A/risk/custom/Atr.mqh>

input int lrPeriod = 25;
input ENUM_APPLIED_PRICE lrPrice = PRICE_HIGH;

input int atrPeriod = 14;
input double atrMult = 1.5;

RiskManager *riskManager = new RiskManager;
Frame *frame = new Frame;

LinearRegression *linearRegression = new LinearRegression;
Atr *atr = new Atr;

int OnInit() {
    
    // init signal model
    linearRegression.Init(lrPeriod, lrPrice);

    // init custom risk and set it
    atr.Init(atrPeriod, atrMult);
    riskManager.Init(atr);
    
    // init execution model
    
    frame.setSignal(linearRegression);
    frame.setRisk(riskManager);
    
    // add both Frame
    // Frame.setSignal(linearRegression);

    return(INIT_SUCCEEDED);
}


void OnTick() {
    frame.Run();
}

