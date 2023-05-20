#include <Critiq/backend/ModelBackend.mqh>

#include <Critiq/Models/Dewa.mqh>
#include <Critiq/Models/AdaptiveATR.mqh>

input double rpp = 1.0;                                                             
input int posRatio = 10;

input int period_atr = 14;                                              
input double multiplier_atr = 1.5;

input int dewa_period = 30;                                             
input double dewa_volume = 0.7;
input ENUM_APPLIED_PRICE dewa_price = PRICE_CLOSE;

ModelBackend *modelBackend = new ModelBackend;                         

int OnInit() {
    modelBackend.Init();                                                
    modelBackend.risk.initRisk(rpp, posRatio);                           
    modelBackend.risk.init_atr_model(period_atr, multiplier_atr);       
                                  
    dewa.Init(dewa_period, dewa_volume, dewa_price);                  
    modelBackend.setModel(dewa);
                                           
    return(INIT_SUCCEEDED);    
}

void OnTick() {
    modelBackend.OnTick();
}

void OnDeinit(const int reason) {
    delete dewa;
    delete modelBackend;
}