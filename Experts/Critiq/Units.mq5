#include <Critiq/backend/ModelBackendNew.mqh>
#include <Critiq/Models/Dewa.mqh>
#include <Critiq/Models/Risk/ATR.mqh>

// int handle;
ModelBackend *modelBackend = new ModelBackend;
Dewa *dewa = new Dewa;
ATR *atr = new ATR;

int OnInit() {

    dewa.Init(14, 0.7, PRICE_CLOSE);
    atr.Init(28, 1.5);

    modelBackend.setModel(dewa);
    modelBackend.setRiskModel(atr);
    
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
    modelBackend.OnTick();
    // ENUM_ORDER_TYPE signal = dewa.GetSignal();
    // Print("Signal: ", signal);
    // if(signal == ORDER_TYPE_BUY) {
    //     Print("BUY");
    // } else if(signal == ORDER_TYPE_SELL) {
    //     Print("SELL");
    // }

}