#include <Critiq/backend/ModelBackendNew.mqh>
#include <Critiq/Models/Dewa.mqh>
#include <Critiq/Models/Risk/ATR.mqh>

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

void OnDeinit(const int reason)
{
    delete modelBackend;
}

void OnTick() {
    modelBackend.OnTick();
}