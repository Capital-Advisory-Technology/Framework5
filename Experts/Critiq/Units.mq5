#include <Critiq/backend/ModelBackend.mqh>
#include <Critiq/Models/Dewa.mqh>
#include <Critiq/main/Risk.mqh>
#include <Critiq/Models/Risk/ATR.mqh>
#include <Critiq/main/Limits.mqh>

input double rpp = 1.0;
input double rpp_reduce_per_loss = 0.01;
input double pos_ratio = 10.0;

input int atr_period = 14;                                              
input double atr_multiplier = 1.5;

input int dewa_period = 30;                                             
input double dewa_volume = 0.7;
input ENUM_APPLIED_PRICE dewa_price = PRICE_CLOSE;

ModelBackend *modelBackend = new ModelBackend;
Limits *limits = new Limits;
Risk *risk = new Risk;
Dewa *dewa = new Dewa;
Atr *atr = new Atr;

int OnInit() {
    // SET RISK
    atr.InitParams(atr_period, atr_multiplier);
    risk.InitRisk(atr, rpp, rpp_reduce_per_loss, pos_ratio);
    modelBackend.setRisk(risk);
    
    // SET SIGNAL MODEL
    dewa.Init(dewa_period, dewa_volume, dewa_price);
    modelBackend.setModel(dewa);

    // SET LIMITS
    limits.setIntraDay(2, 22);
    modelBackend.setLimits(limits);
    
    return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {
    delete modelBackend;
}

void OnTick() {
    modelBackend.OnTick();
}

void OnTimer() {}

void OnTrade() {}

void OnTradeTransaction(const MqlTradeTransaction &trans, 
                        const MqlTradeRequest &request, 
                        const MqlTradeResult &result) {}

double OnTester() {return(0);}

int onTesterInit() {return(0);}

void OnTesterDeinit() {}

void OnTesterPass() {}