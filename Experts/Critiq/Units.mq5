#include <Critiq/backend/ModelBackendNew.mqh>
#include <Critiq/Models/Dewa.mqh>
#include <Critiq/Models/Risk/Atr.mqh>

input double rpp = 1.0;                                                             
input double pos_ratio = 10.0;

input int atr_period = 14;                                              
input double atr_multiplier = 1.5;

input int dewa_period = 30;                                             
input double dewa_volume = 0.7;
input ENUM_APPLIED_PRICE dewa_price = PRICE_CLOSE;

ModelBackend *modelBackend = new ModelBackend;
Dewa *dewa = new Dewa;
Atr *atr = new Atr;

int OnInit() {

    atr.InitRisk(rpp, pos_ratio); 
    atr.InitParams(atr_period, atr_multiplier);
    dewa.Init(dewa_period, dewa_volume, dewa_price);

    modelBackend.setModel(dewa);
    modelBackend.setRiskModel(atr);

    return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {
    delete modelBackend;
}

void OnTick() {
    modelBackend.OnTick();
}