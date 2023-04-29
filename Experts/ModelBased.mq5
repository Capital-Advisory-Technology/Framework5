#include <Critiq-Include/backend/ModelBackend.mqh>
#include <Critiq-Include/Models/DewaModel.mqh>
#include <Critiq-Include/Models/ModelAdaptiveATR.mqh>

input double rpp = 1.0;
input int posRatio = 10;

input int period_atr = 14;
input double multiplier_atr = 1.5;

input int dewa_period = 30;
input double dewa_volume = 0.7;
input ENUM_APPLIED_PRICE dewa_price = PRICE_CLOSE;

Dewa *dewa = new Dewa;
ModelBackend *modelBackend = new ModelBackend;


int OnInit() {
    modelBackend.Init();
    modelBackend.risk.initRisk(rpp, posRatio); // Init risk model
    modelBackend.risk.init_atr_model(period_atr, multiplier_atr);

    dewa.Init(dewa_period, dewa_volume, dewa_price);
    modelBackend.InitModel(dewa);
    // modelBackend.InitModel('Dewa')
    // modelBackend.model.init(dewa_period, dewa_volume, dewa_price);
    return(INIT_SUCCEEDED);
}

void OnTick() {
    modelBackend.OnTick();
}

void OnDeinit(const int reason) {
    delete modelBackend;
}