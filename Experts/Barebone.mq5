//+------------------------------------------------------------------+
//|                                                         Base.mq5 |
//|                                                           Critiq |
//+------------------------------------------------------------------+

#include <Trade\Trade.mqh>
#include <Critiq-Include/main/Risk.mqh>
#include <Critiq-Include/backend/PositionManager.mqh>
#include <Critiq-Include/Models/Dewa.mqh>

// Model params.
input int period = 30;
input double volume = 0.7;
input ENUM_APPLIED_PRICE price = PRICE_CLOSE;

// Risk params.
input double rpp = 1.0;
input int posRatio = 10;

input int period_atr = 14;
input double multiplier_atr = 1.5;  

// extern double breakeven = 0.5;
// extern double profit_zone = 0.5;
// extern double profit_zone_reward = 0.1;

Risk *risk;
PositionManager *positionManager;
Dewa *dewaModel;

int OnInit() {
    risk.initRisk(rpp, posRatio); // Init risk model
    risk.init_atr_model(period_atr, multiplier_atr);
    dewaModel.init(period, volume, price);
    return(INIT_SUCCEEDED);
}

void OnTick() {
    if (dewaModel.getSignal() == ORDER_TYPE_BUY) {
        if (!positionManager.isOrderOpen()) {
            risk.get_atr_model(ORDER_TYPE_BUY);
            double volume = risk.get_volume();
            double stoploss = risk.get_slPrice();
            double takeprofit = risk.get_tpPrice();
            positionManager.OrderOpen(ORDER_TYPE_BUY, volume, stoploss, takeprofit);
        }
    } else if (dewaModel.getSignal() == ORDER_TYPE_SELL) {
        if (!positionManager.isOrderOpen()) {
            risk.get_atr_model(ORDER_TYPE_SELL);
            double volume = risk.get_volume();
            double stoploss = risk.get_slPrice();
            double takeprofit = risk.get_tpPrice();
            positionManager.OrderOpen(ORDER_TYPE_SELL, volume, stoploss, takeprofit);
        }
    }
}

void OnDeinit(const int reason) { 
    Print("Deinit");
    
}


void OnTrade() { };