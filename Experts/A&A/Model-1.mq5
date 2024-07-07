#include <A&A/main/Frame.mqh>
#include <A&A/signal/custom/LinearRegression.mqh>

input int lrPeriod = 25;
input ENUM_APPLIED_PRICE lrPrice = PRICE_HIGH;

Frame *frame = new Frame;
LinearRegression *linearRegression = new LinearRegression;

int OnInit() {
    
    // init signal model
    linearRegression.Init(lrPeriod, lrPrice);
    
    // init execution model
    frame.setSignal(linearRegression);
    
    // add both Frame
    // Frame.setSignal(linearRegression);


    return(INIT_SUCCEEDED);
}


void OnTick() {
    frame.Run();
}

