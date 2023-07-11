// Main models
#include <Critiq/main/Risk.mqh>
#include <Critiq/main/Limits.mqh>
#include <Critiq/backend/ModelBackend.mqh>

// Strategy models
#include <Critiq/Models/Dewa.mqh>
#include <Critiq/Models/Risk/ATR.mqh>

// Main - Risk parameters
input group "Risk"
input double rpp = 1.0; // Risk per position
input double pos_ratio = 10.0; // TP/SL Position ratio
input double rpp_reduce_per_loss = 0.01;    // Risk Reduce per loss

// Main - ProfitSystem parameters
input group "ProfitSystem"
input double ps_be = 0.5;   // BreakEven ratio
input double ps_t1 = 0.5;   // Target 1 ratio
input double ps_t2 = 0.8;   // Target 2 ratio
input double ps_s1 = 0.5;   // StopLoss 1 ratio
input double ps_s2 = 0.8;   // StopLoss 2 ratio

// Main - Limits parameters
input group "Limits"
input int limits_intraday_from = 2;  // Intraday start at
input int limits_intraday_to = 22;   // Intraday end at

// Strategy - SL parameters
input group "StopLoss Model - ATR"
input int atr_period = 14;                                              
input double atr_multiplier = 1.5;

// Strategy - Signal parameters
input group "Signal Model - Waddah"
input ENUM_PRICE_DERIVATIVE wadPrice = Close; 
input int wadSensitivity = 150;
input int wadFLength = 20; 
input int wadSLength = 40;
input int wadBLength = 20;
input double wadBDev = 2.0;
input ENUM_YES_NO wadSmooth = Yes;

input group "Signal Model - Dema"
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
    modelBackend.setRisk(risk);
    
    // SET PROFIT SYSTEM
    modelBackend.setProfitSystem(ps_t1, ps_t2, ps_s1, ps_s2, ps_be);
    
    // SET MODEL
    dewa.Init(
        dewa_period, dewa_volume, dewa_price,
        wadPrice, wadSensitivity, wadFLength,
         wadSLength, wadBLength, wadBDev, wadSmooth
    );                            
    modelBackend.setModel(dewa);

    // SET LIMITS
    limits.setIntraDay(limits_intraday_from, limits_intraday_to);
    modelBackend.setLimits(limits);
    
    return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {
    delete atr;
    delete dewa;
    delete risk;
    delete limits;
    delete modelBackend;
}

void OnTick() {
    modelBackend.OnTick();
}

void OnTrade() {
}

void OnTradeTransaction(const MqlTradeTransaction &trans, 
                        const MqlTradeRequest &request, 
                        const MqlTradeResult &result) {}

void OnTimer() {}

double OnTester() {return(0);}

int onTesterInit() {return(0);}

void OnTesterDeinit() {}

void OnTesterPass() {}