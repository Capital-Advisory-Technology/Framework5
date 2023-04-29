//+------------------------------------------------------------------+
//|                                                         Base.mq5 |
//|                                                           Critiq |
//+------------------------------------------------------------------+
#property copyright "Critiq"
#property link      ""
#property version   "1.00"

#property tester_indicator "GeneralizedDoubleDEMA.ex5" 
#property tester_indicator "AdaptiveATR.ex5"

#include <Trade\Trade.mqh>

#include <Critiq-Include/Models/FooModel.mqh>

// Model params.
input int period = 30;
input double volume = 0.7;
input ENUM_APPLIED_PRICE price = PRICE_CLOSE;

input int period_atr = 14;
input double multiplier_atr = 1.5;  

// Risk params.
input double rpp = 1.0;
input int posRatio = 10;

FooModel *fooModel = new FooModel;

int OnInit() {
    fooModel.init(period, volume, price); // Init model
    Print("HERE1");
    fooModel.initRisk(rpp, posRatio); // Init risk model
    // fooModel.risk.init_atr_model(period_atr, multiplier_atr);             // Init ATR model
    
    Print("HERE2");
    return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) { 
    Print("Deinit");
    delete fooModel; 
}

void OnTick() {
    Print("HERE4");
    fooModel.OnTick();
 }
 
void OnTrade() { } 