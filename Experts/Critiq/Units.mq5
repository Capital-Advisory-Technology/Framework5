#include <Critiq/Models/Dewa.mqh>

int handle;
Dewa *dewa = new Dewa;

int OnInit() {

    dewa.Init(14, 0.7, PRICE_CLOSE);

    // handle=iCustom(NULL, 0, "Critiq-Indicators\\GeneralizedDoubleDEMA", 14, 0,7, PRICE_CLOSE);

    return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Deinitialization function of the expert                          |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    // IndicatorRelease(handle);
}
//+------------------------------------------------------------------+
//| "Tick" event handler function                                    |
//+------------------------------------------------------------------+
void OnTick() {

    ENUM_ORDER_TYPE signal = dewa.GetSignal();
    Print("Signal: ", signal);
    if(signal == ORDER_TYPE_BUY) {
        Print("BUY");
    } else if(signal == ORDER_TYPE_SELL) {
        Print("SELL");
    }


//    double LTDindicator[];
//    ArraySetAsSeries(LTDindicator, true);
//    CopyBuffer(handle, 1, 0, 25, LTDindicator);

//    Print(LTDindicator[0]);

    return;
}