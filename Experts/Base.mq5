//+------------------------------------------------------------------+
//|                                                         Base.mq5 |
//|                                                           Critiq |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Critiq"
#property link      ""
#property version   "1.00"
#property tester_indicator "GeneralizedDoubleDEMA.ex5" 

#include <Critiq-Include/backend/Risk.mqh>
#include <Critiq-Include/main/PositionManager.mqh>
#include <Critiq-Include/Signals/Dewa.mqh>

#include <Trade\Trade.mqh>

int tickCount;
int tradeCount;

Dewa *dewa = new Dewa;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
    dewa.init(20, 0.8, PRICE_CLOSE);
    
    dewa.setPosRatio(10);
    dewa.setRisk(1);
    tickCount = 0;
    tradeCount = 0;
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) {
    Print("Total ticks: ", tickCount);
    Print("Total trades: ", tradeCount);
    delete positionManager;
}

void OnTick() {
   dewa.OnTick();
}
 
void OnTrade() { } 