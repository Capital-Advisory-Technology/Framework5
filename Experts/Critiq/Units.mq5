// Main models
#include <Critiq/main/Risk.mqh>
#include <Critiq/main/Limits.mqh>
#include <Critiq/backend/ModelBackend.mqh>

// Strategy models
#include <Critiq/Models/Dewa.mqh>
#include <Critiq/Models/Risk/ATR.mqh>

// Main - Risk parameters
input double rpp = 1.0;
input double pos_ratio = 10.0;
input double rpp_reduce_per_loss = 0.01;

input double ps_be = 0.5;
input double ps_t1 = 0.5;
input double ps_t2 = 0.8;
input double ps_s1 = 0.5;
input double ps_s2 = 0.8;

// Main - Limits parameters
input int limits_intraday_from = 2;
input int limits_intraday_to = 22;

// Strategy - SL parameters
input int atr_period = 14;                                              
input double atr_multiplier = 1.5;

// Strategy - Signal parameters
input ENUM_PRICE_DERIVATIVE wad_price = Close; 
input int wad_sensitivity = 150;
input int wad_fastlength = 20;
input int wad_slowlength = 40;
input int wad_bblength = 20;
input double wad_bbstdev = 2.0;
input ENUM_YES_NO wad_smooth = Yes;

input int dewa_period = 30;                                             
input double dewa_volume = 0.7;
input ENUM_APPLIED_PRICE dewa_price = PRICE_CLOSE;

// Base objects
Risk *risk = new Risk;
Limits *limits = new Limits;
ModelBackend *modelBackend = new ModelBackend;

// Strategy objects
Atr *atr = new Atr;
Dewa *dewa = new Dewa;

int OnInit() {
    // SET RISK
    atr.InitParams(atr_period, atr_multiplier);
    risk.InitRisk(atr, rpp, rpp_reduce_per_loss, pos_ratio);
    
    modelBackend.setProfitSystem(ps_t1, ps_t2, ps_s1, ps_s2, ps_be);
    modelBackend.setRisk(risk);
    
    // SET SIGNAL MODEL
        dewa.Init(dewa_period, dewa_volume, dewa_price, wad_price, wad_sensitivity, 
              wad_fastlength, wad_slowlength, wad_bblength, wad_bbstdev, wad_smooth);     
                           
    modelBackend.setModel(dewa);

    // SET LIMITS
    limits.setIntraDay(limits_intraday_from, limits_intraday_to);
    modelBackend.setLimits(limits);
    
    return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {
    delete modelBackend;
}

void OnTick() {
    modelBackend.OnTick();
}

void OnTrade() {
    // modelBackend.OnTrade();
}

void OnTradeTransaction(const MqlTradeTransaction &trans, 
                        const MqlTradeRequest &request, 
                        const MqlTradeResult &result) {}

void OnTimer() {}

double OnTester() {return(0);}

int onTesterInit() {return(0);}

void OnTesterDeinit() {}

void OnTesterPass() {}