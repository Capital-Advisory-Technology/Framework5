//+------------------------------------------------------------------+
//|                                                         Base.mq5 |
//|                                                           Critiq |
//+------------------------------------------------------------------+

#include <Trade\Trade.mqh>
#include <Critiq-Include/main/Risk.mqh>
#include <Critiq-Include/main/Limits.mqh>
#include <Critiq-Include/main/PositionManager.mqh>
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


input double limits_weekly_loss = 0.1;
input double limits_daily_loss = 0.05;
// extern double breakeven = 0.5;
// extern double profit_zone = 0.5;
// extern double profit_zone_reward = 0.1;

Dewa *dewaModel;

Risk *risk;
Limits *limits;
PositionManager *positionManager;

int OnInit() {
    risk.initRisk(rpp, posRatio); // Init risk model
    risk.init_atr_model(period_atr, multiplier_atr);
    // risk.init_sl_atr(period_atr, multiplier_atr);

    limits.InitDailyLoss(limits_daily_loss);
    limits.InitWeeklyLoss(limits_weekly_loss);

    dewaModel.init(period, volume, price);
    return(INIT_SUCCEEDED);
}

void OnTick() {
    if (!limits.getLimits()) {
        if (dewaModel.getSignal() == ORDER_TYPE_BUY) {
            if (!positionManager.isOrderOpen()) {
                risk.get_atr_model(ORDER_TYPE_BUY);
                positionManager.OrderOpen(
                    ORDER_TYPE_BUY,
                    risk.get_volume(),
                    risk.get_slPrice(),
                    risk.get_tpPrice()
                    );
            }
        } else if (dewaModel.getSignal() == ORDER_TYPE_SELL) {
            if (!positionManager.isOrderOpen()) {
                risk.get_atr_model(ORDER_TYPE_SELL);
                positionManager.OrderOpen(
                    ORDER_TYPE_SELL,
                    risk.get_volume(),
                    risk.get_slPrice(),
                    risk.get_tpPrice());
            }
        }
    }
}

void OnDeinit(const int reason) { 
    Print("Deinit");
    
}


void OnTrade() { };