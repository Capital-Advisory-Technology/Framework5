#include <Critiq/backend/ModelBackend.mqh>

#include <Critiq/Models/Dewa.mqh>
#include <Critiq/Models/AdaptiveATR.mqh>

input double rpp = 1.0;                                                 // Base params.            
input int posRatio = 10;

input int period_atr = 14;                                              // Risk params.
input double multiplier_atr = 1.5;

input int dewa_period = 30;                                             // Model params.
input double dewa_volume = 0.7;
input ENUM_APPLIED_PRICE dewa_price = PRICE_CLOSE;

Dewa *dewa = new Dewa;                                                  // new model
ModelBackend *modelBackend = new ModelBackend;                          // new backend


int OnInit() {
    modelBackend.Init();                                                // Init backend
    modelBackend.risk.initRisk(rpp, posRatio);                          // Init risk base 
    modelBackend.risk.init_atr_model(period_atr, multiplier_atr);       // Init risk model

    dewa.Init(dewa_period, dewa_volume, dewa_price);                    // Init model
    modelBackend.InitModel(dewa);                                       // Add model to backend                              
    
    return(INIT_SUCCEEDED);
}

void OnTick() {
    modelBackend.OnTick();
}

void OnDeinit(const int reason) {
    delete dewa;
    delete modelBackend;
}